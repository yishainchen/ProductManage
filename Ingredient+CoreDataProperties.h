//
//  Ingredient+CoreDataProperties.h
//  TeamFive
//
//  Created by yishain chen on 2015/10/6.
//  Copyright © 2015年 yishain. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Ingredient.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ingredient (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ingredientName;
@property (nullable, nonatomic, retain) NSNumber *ingredientPrice;
@property (nullable, nonatomic, retain) NSNumber *ingredientTime;
@property (nullable, nonatomic, retain) NSNumber *ingredientQuantity;

@end

NS_ASSUME_NONNULL_END
