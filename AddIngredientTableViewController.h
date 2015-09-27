//
//  AddIngredientTableViewController.h
//  TeamFive
//
//  Created by yishain on 9/19/15.
//  Copyright (c) 2015 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddIngredientTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIPickerView *classPicker;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UITextField *foodNameTxt;
//@property (weak, nonatomic) IBOutlet UITextField *classTxt;
@property (weak, nonatomic) IBOutlet UITextField *quantityTxt;
@property (weak, nonatomic) IBOutlet UITextField *unitTxt;
@property (weak, nonatomic) IBOutlet UITextField *priceTxt;
@property (weak, nonatomic) IBOutlet UITextField *timeTxt;

@end
