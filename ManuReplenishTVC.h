//
//  ManuReplenishTVC.h
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngreCategoryPickerCell.h"
#import "IngredientPickerCell.h"

@interface ManuReplenishTVC : UITableViewController
@property (strong, nonatomic) NSString *categorySelected;
@property (strong, nonatomic) NSString *ingredientSelected;
@property (strong, nonatomic) NSString *ingredientSelectedID;

@property (strong, nonatomic) IBOutlet IngreCategoryPickerCell *categoryCell;
@property (weak, nonatomic) IBOutlet IngredientPickerCell *ingredientCell;
@end
