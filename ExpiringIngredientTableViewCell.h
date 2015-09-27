//
//  ExpiringIngredientTableViewCell.h
//  TeamFive
//
//  Created by CHIH WEI HU on 19/9/15.
//  Copyright © 2015 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <M13ProgressSuite/M13ProgressViewBar.h>

@interface ExpiringIngredientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiringTime;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet M13ProgressViewBar *progressBar;


@end
