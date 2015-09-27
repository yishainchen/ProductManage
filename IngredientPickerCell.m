//
//  IngredientPickerCell.m
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import "IngredientPickerCell.h"
#import "Parse/Parse.h"

@interface IngredientPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) NSMutableArray *ingredientOptions;
@property (strong, nonatomic) NSMutableArray *pickerOptions;
@property (strong, nonatomic) UIPickerView *picker;
@end

@implementation IngredientPickerCell

- (void)awakeFromNib {
    self.IngredientTextfield.inputView = self.picker;
    self.ingredientOptions = [[NSMutableArray alloc] init];
}

#pragma mark - setter & getter

//@synthesize pickerOptions = _pickerOptions;
- (NSMutableArray *)pickerOptions
{
    if (!_pickerOptions) {
        _pickerOptions = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Ingredient"];
        
        if (self.category) {
            [query whereKey:@"category" equalTo: self.category];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    // The find succeeded.
                    for (PFObject *object in objects) {
                        [_ingredientOptions addObject: @{@"name" : object[@"name"],
                                                         @"id" : object.objectId } ];
                    }
                    
                    if (objects.count > 0) {
                        for (NSDictionary *ingredient in self.ingredientOptions) {
                            [_pickerOptions addObject: ingredient[@"name"]];
                        }
                    }else{
                        [_pickerOptions addObject:@"無"];
                    }
                    
                    [self.picker reloadAllComponents];
                    
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }else{
            
        }
    }
    
    return _pickerOptions;
}

- (UIPickerView *)picker
{
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 120)];
        _picker.delegate = self;
        _picker.dataSource = self;
    }
    return _picker;
}

#pragma mark - picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerOptions[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.IngredientTextfield.text = self.pickerOptions[row];
    self.ingredientID = self.ingredientOptions[row][@"id"];
    [self.IngredientTextfield resignFirstResponder];

    [self.delegate update:@"ingredient" By:self AtRow:row];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
