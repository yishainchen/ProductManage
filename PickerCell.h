//
//  PickerCell.h
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IngreCategoryPickerCell;
@protocol PickerCell <NSObject>

@required
- (void)update:(NSString *)target By:(UITableViewCell *)cell AtRow:(NSInteger)row;


@end
