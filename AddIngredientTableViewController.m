//
//  AddIngredientTableViewController.m
//  TeamFive
//
//  Created by yishain on 9/19/15.
//  Copyright (c) 2015 yishain. All rights reserved.
//

#import "AddIngredientTableViewController.h"
#import "AddHandledIngredientTableViewController.h"
#import <Parse/Parse.h>
#import "IngreCategory.h"

@interface AddIngredientTableViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *classPick;
    NSMutableArray *unitPick;
    NSArray *addIngredientsArr;
    NSMutableArray *allIngredientsArr;
    NSString *foodNameStr;
    NSString *classStr;
    NSString *quantityStr;
    NSString *unitStr;
    NSString *priceStr;
    NSString *timeStr;
    NSString *objectedID;
}
@property (nonatomic, retain) UIPickerView *Picker;
@end

@implementation AddIngredientTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.31 green:0.82 blue:0.76 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0];
    self.classPicker.delegate = self;
    self.classPicker.dataSource = self;
    classStr = @"茶葉";
    classPick = [[NSMutableArray alloc] initWithObjects:@"茶葉",@"飲料",@"水果",@"果醬",@"麵包", nil];
    unitPick = [[NSMutableArray alloc] initWithObjects:@"g",@"ml",@"g",@"ml",@"g", nil];
 
    addIngredientsArr = [[NSArray alloc] init];
    allIngredientsArr = [[NSMutableArray alloc] init];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    return 7;
}


- (IBAction)addItems:(id)sender {

    foodNameStr = self.foodNameTxt.text;
    quantityStr = self.quantityTxt.text;
    unitStr = self.unitLabel.text;
    priceStr = self.priceTxt.text;
    timeStr = self.timeTxt.text;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *FoodTime = [f numberFromString:timeStr];
    NSNumber *FoodPrice = [f numberFromString:priceStr];
    NSNumber *FoodQuantity = [f numberFromString:quantityStr];

    if (foodNameStr == nil || FoodPrice ==nil || FoodTime ==nil ||FoodQuantity == nil ) {
        return;
    }

    PFObject *ingredient = [PFObject objectWithClassName:@"Ingredient"];
    ingredient[@"name"] = foodNameStr;
    ingredient[@"shelfLife"] = FoodTime;
    ingredient[@"price"] = FoodPrice;
    ingredient[@"category"] = classStr;
    ingredient[@"quantity"] = FoodQuantity;
    [ingredient saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Ingredient"];
    [query whereKey:@"name" equalTo:foodNameStr];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
          
            for (PFObject *object in objects) {
                
                objectedID = object.objectId;
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    UIAlertController * alert=  [UIAlertController
                                 alertControllerWithTitle:@"新增資料成功"
                                 message:@"已新增一筆食材資料"
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    //第一組選項由0開始
    switch (component) {
        case 0:
            return [classPick count];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [classPick objectAtIndex:row];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行）
        default:
            return @"Error";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            NSLog(@"class = %@",[classPick objectAtIndex:row]);
            classStr = [classPick objectAtIndex:row];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行）
        default:
            break;
    }
    self.unitLabel.text = [NSString stringWithFormat:@"%@", [unitPick objectAtIndex:row]];
    unitStr = self.unitLabel.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddHandledIngredientTableViewController *handledVC = segue.destinationViewController;
    handledVC.handledUnitStr = unitStr;
    handledVC.handledObjectedID = objectedID;
}

@end
