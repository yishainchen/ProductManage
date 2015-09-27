//
//  EliminatingTableViewController.h
//  TeamFive
//
//  Created by CHIH WEI HU on 20/9/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EliminatingTableViewController : UITableViewController
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *quantityField;
@property (strong, nonatomic) NSArray *handledOptions;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) PFObject *object;
@end
