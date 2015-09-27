//
//  IngredientPickerCell.h
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerCell.h"

@interface IngredientPickerCell : UITableViewCell
@property (strong, nonatomic) NSString *category;

@property (weak, nonatomic) id <PickerCell> delegate;
@property (strong, nonatomic) IBOutlet UITextField *IngredientTextfield;
@property (strong, nonatomic) NSString *ingredientID;
@end
