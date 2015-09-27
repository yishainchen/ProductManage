//
//  AddHandledIngredientTableViewController.m
//  TeamFive
//
//  Created by yishain on 9/19/15.
//  Copyright (c) 2015 yishain. All rights reserved.
//

#import "AddHandledIngredientTableViewController.h"
#import <Parse/Parse.h>
@interface AddHandledIngredientTableViewController ()
{
    NSArray *addHandlesfoodArr;
    NSMutableArray *allHandlesfoodArr;
    NSString *handledfoodsStr;
    NSString *handledQuantityStr;
    NSString *handledTimestr;
    NSString *Unit;
    NSString *objectedID;
}

@end

@implementation AddHandledIngredientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.31 green:0.82 blue:0.76 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0];
    Unit = self.handledUnitStr;
    objectedID = self.handledObjectedID;
    addHandlesfoodArr = [[NSArray alloc] init];
    allHandlesfoodArr = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (IBAction)addHandledFoodItems:(id)sender {
    
    handledfoodsStr = self.handledFoods.text;
    handledQuantityStr = self.handledQuantity.text;
    handledTimestr = self.handledTime.text;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *foodQuantity = [f numberFromString:handledQuantityStr];
    NSNumber *foodShelfLife = [f numberFromString:handledTimestr];
    
    NSLog(@"%@ %@ %@ %@",handledTimestr,foodQuantity,foodShelfLife,objectedID);
    if (handledTimestr == nil || foodShelfLife ==nil || foodQuantity == nil || objectedID == nil) {
        return;
    }
    
    PFObject *handledIngredient = [PFObject objectWithClassName:@"HandledIngredient"];
    handledIngredient[@"name"] = handledfoodsStr;
    handledIngredient[@"shelfLife"] = foodShelfLife;
    handledIngredient[@"quantity"] = foodQuantity;
    NSLog(@"ID = %@",objectedID);
    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"Ingredient" objectId:objectedID];
    handledIngredient[@"ingredient"] = pointer;
    [handledIngredient saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
    
    UIAlertController * alert=  [UIAlertController
                                 alertControllerWithTitle:@"新增資料成功"
                                 message:@"已新增一筆加工食材資料"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action) {
        
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
