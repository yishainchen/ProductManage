//
//  IngreCategory.m
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import "IngreCategory.h"

@implementation IngreCategory

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.totalCategory = [[NSMutableArray alloc] initWithArray: @[ @{@"name": @"茶葉", @"unit" : @"公克"},
                                                                       @{@"name": @"飲料", @"unit" : @"毫升"},
                                                                       @{@"name": @"水果", @"unit" : @"公克"},
                                                                       @{@"name": @"果醬", @"unit" : @"毫升"},
                                                                       @{@"name": @"麵包", @"unit" : @"公克"} ]];
    }
    return self;
}

+ (NSString *)unitMap:(NSString *)category {
    return @{@"茶葉": @"公克", @"飲料": @"毫升", @"水果": @"公克", @"果醬": @"毫升", @"麵包": @"公克"}[category];
}
@end
