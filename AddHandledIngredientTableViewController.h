//
//  AddHandledIngredientTableViewController.h
//  TeamFive
//
//  Created by yishain on 9/19/15.
//  Copyright (c) 2015 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddHandledIngredientTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *handledFoods;
@property (weak, nonatomic) IBOutlet UITextField *handledQuantity;
@property (weak, nonatomic) IBOutlet UITextField *handledTime;
@property NSString *handledUnitStr;
@property NSString *handledObjectedID;
@end
