//
//  AddByQRcode.h
//  TeamFive
//
//  Created by yishain chen on 2015/10/10.
//  Copyright © 2015年 yishain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddByQRcode : UIViewController

@property (weak, nonatomic) IBOutlet UIView *PreviewView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startBarItem;

@property (nonatomic) BOOL  isReading;


@end
