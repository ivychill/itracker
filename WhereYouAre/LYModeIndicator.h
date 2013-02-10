//
//  LYModeIndicator.h
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-16.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYModeIndicator : UIView
@property (strong, nonatomic) IBOutlet UILabel *activityDescLBL;
@property (strong, nonatomic) IBOutlet UIView *backgroundBoardVW;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
