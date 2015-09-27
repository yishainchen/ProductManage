//
//  IngreCategoryPickerCell.h
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerCell.h"

@interface IngreCategoryPickerCell : UITableViewCell
@property (weak, nonatomic) id <PickerCell> delegate;

@property (strong, nonatomic) IBOutlet UITextField *CategoryTextfield;
@end
