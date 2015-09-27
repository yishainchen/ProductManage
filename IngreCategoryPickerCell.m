//
//  IngreCategoryPickerCell.m
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import "IngreCategoryPickerCell.h"
#import "IngreCategory.h"

@interface IngreCategoryPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IngreCategory *ingreCategory;
@property (strong, nonatomic) NSMutableArray *pickerOptions;
@property (strong, nonatomic) UIPickerView *picker;
@end

@implementation IngreCategoryPickerCell

- (void)awakeFromNib {
    self.CategoryTextfield.inputView = self.picker;
}

#pragma mark - setter & getter

- (IngreCategory *)ingreCategory
{
    if (!_ingreCategory) {
        _ingreCategory = [[IngreCategory alloc] init];
    }
    return _ingreCategory;
}

- (NSMutableArray *)pickerOptions
{
    if (!_pickerOptions) {
        _pickerOptions = self.ingreCategory.totalCategory;
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
    return self.pickerOptions[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.CategoryTextfield.text = self.pickerOptions[row][@"name"];
    [self.CategoryTextfield resignFirstResponder];
    
    [self.delegate update:@"category" By:self AtRow:row];
}

#pragma mark - cell delegate

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
