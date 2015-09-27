//
//  SearchTableViewController.m
//  TeamFive
//
//  Created by yishain on 9/19/15.
//  Copyright (c) 2015 yishain. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ExpiringIngredientTableViewCell.h"
#import <Parse/Parse.h>
#import "IngreCategory.h"
#import "MBProgressHUD.h"
#import "EliminatingTableViewController.h"
#import "ManuReplenishTVC.h"
#import "ExpiringIngredientTableViewCell.h"

@interface SearchTableViewController ()
@property (strong, nonatomic) NSArray *ingredients;
@property (strong, nonatomic) NSMutableArray *safeIngredients;
@property (strong, nonatomic) NSMutableArray *riskIngredients;
@end
NSString static *cellIdentifier = @"ExpiringCell";

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.31 green:0.82 blue:0.76 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0];
    self.safeIngredients = [[NSMutableArray alloc] init];
    self.riskIngredients = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"RawIngredient"];
    [query includeKey:@"ingredient"];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *object in objects) {
            
            // 如果保存期限小於 2 天，加進建議進貨清單
            if ( [self calculateRemainLifeFrom:object.createdAt ShelfLife:[object[@"ingredient"][@"shelfLife"] integerValue]] > 24*2 ) {
                [self.safeIngredients addObject: object];
            
            }else {
                
                [self.riskIngredients addObject: object];
            }
        }
        
        NSLog(@"safe: %ld", self.safeIngredients.count);
        NSLog(@"risk: %ld", self.riskIngredients.count);
        
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ExpiringIngredientCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDetailVC:) name:@"replenishButPress" object:nil];
}

- (void)toDetailVC:(NSNotification *)notificaiton {
    
    NSDictionary *info = [notificaiton userInfo];
    
    ExpiringIngredientTableViewCell *senderCell = info [@"id"];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:senderCell];
    
    ManuReplenishTVC *replenishVC = (ManuReplenishTVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"replenishDetailVC"];
    __unused UIView *view = replenishVC.view;
    
    if (indexPath.section == 0) {
        PFObject *rawIngredient = self.riskIngredients[indexPath.row];
        replenishVC.categorySelected = rawIngredient[@"category"];
        replenishVC.categoryCell.CategoryTextfield.text = rawIngredient[@"category"];
        
        PFObject *ingredient = rawIngredient[@"ingredient"];
        replenishVC.ingredientSelectedID = ingredient.objectId;
        // NSLog(@"%@", replenishVC.ingredientSelectedID);
    }else {
        PFObject *rawIngredient = self.safeIngredients[indexPath.row];
        replenishVC.categorySelected = rawIngredient[@"category"];
        replenishVC.categoryCell.CategoryTextfield.text = rawIngredient[@"category"];
        
        PFObject *ingredient = rawIngredient[@"ingredient"];
        replenishVC.ingredientSelectedID = ingredient.objectId;
        // NSLog(@"%@", replenishVC.ingredientSelectedID);
    }
    
    replenishVC.ingredientSelected = senderCell.nameLabel.text;
    replenishVC.ingredientCell.IngredientTextfield.text = senderCell.nameLabel.text;
    [self.navigationController pushViewController:replenishVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self.tableView reloadData];
}
- (NSInteger)calculateRemainLifeFrom:(NSDate *)createdDate ShelfLife:(NSInteger)shelfLife{
    
    NSInteger interval = [[NSDate date] timeIntervalSinceDate:createdDate] / 3600;
    NSInteger remainedLife = shelfLife - interval;
    return remainedLife;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [self.riskIngredients count];
//        return 0;
    } else if (section == 1) {
        return [self.safeIngredients count];
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ExpiringIngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        PFObject *rawIngredient = self.riskIngredients[indexPath.row];
        cell.nameLabel.text = rawIngredient[@"name"];
        PFObject *ingredient = rawIngredient[@"ingredient"];
        cell.quantity.text = [NSString stringWithFormat:@"庫存：%@ %@", [rawIngredient[@"quantity"] stringValue], [IngreCategory unitMap:ingredient[@"category"]]];
        NSInteger interval = [[NSDate date] timeIntervalSinceDate:rawIngredient.createdAt] / 3600;
        NSInteger shelfLife = [ingredient[@"shelfLife"] integerValue];
        NSInteger remainedLife = shelfLife - interval;
        CGFloat ratio = (float)remainedLife / (float)shelfLife;
        [cell.progressBar setProgress:ratio animated:YES];
        UIColor *progressColor;
        if (ratio > 0.5) {
            progressColor = [UIColor colorWithRed:0.53 green:0.99 blue:0 alpha:1];
        } else if (ratio > 0.3) {
            progressColor = [UIColor colorWithRed:0.95 green:0.83 blue:0.27 alpha:1];
        } else {
            progressColor = [UIColor redColor];
        }
        [cell.progressBar setPrimaryColor:progressColor];
        cell.expiringTime.text = [NSString stringWithFormat:@"剩餘時間： %li 小時", (long)remainedLife];
        return cell;
    }
    if (indexPath.section == 1) {
        ExpiringIngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        PFObject *rawIngredient = self.safeIngredients[indexPath.row];
        cell.nameLabel.text = rawIngredient[@"name"];
        PFObject *ingredient = rawIngredient[@"ingredient"];
        cell.quantity.text = [NSString stringWithFormat:@"庫存：%@ %@", [rawIngredient[@"quantity"] stringValue], [IngreCategory unitMap:ingredient[@"category"]]];
        NSInteger interval = [[NSDate date] timeIntervalSinceDate:rawIngredient.createdAt] / 3600;
        NSInteger shelfLife = [ingredient[@"shelfLife"] integerValue];
        NSInteger remainedLife = shelfLife - interval;
        CGFloat ratio = (float)remainedLife / (float)shelfLife;
        [cell.progressBar setProgress:ratio animated:YES];
        UIColor *progressColor;
        if (ratio > 0.5) {
            progressColor = [UIColor colorWithRed:0.53 green:0.99 blue:0 alpha:1];
        } else if (ratio > 0.3) {
            progressColor = [UIColor colorWithRed:0.95 green:0.83 blue:0.27 alpha:1];
        } else {
            progressColor = [UIColor redColor];
        }
        [cell.progressBar setPrimaryColor:progressColor];
        cell.expiringTime.text = [NSString stringWithFormat:@"剩餘時間： %li 小時", (long)remainedLife];
        return cell;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111.;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"建議進貨清單";
            break;
            
        case 1:
            return @"庫存清單";
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    if (section != 3) {   //section 3 is just a image
        
        // Text Color & Background color
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.textColor = [UIColor orangeColor];
        
        header.contentView.backgroundColor = [UIColor colorWithRed:25/255 green:28/255 blue:43/255 alpha:0.8];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *sender = indexPath.section == 0 ? _riskIngredients : _safeIngredients;
    [self performSegueWithIdentifier:@"eliminatingSegue" sender:sender[indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"eliminatingSegue"]) {
        EliminatingTableViewController *eliminatingVC = segue.destinationViewController;
        eliminatingVC.object = sender;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
