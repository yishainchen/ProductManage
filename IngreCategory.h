//
//  IngreCategory.h
//  TeamFive
//
//  Created by 陳逸仁 on 9/19/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngreCategory : NSObject
@property (strong, nonatomic) NSMutableArray *totalCategory;
+ (NSString *)unitMap:(NSString *)category;
@end
