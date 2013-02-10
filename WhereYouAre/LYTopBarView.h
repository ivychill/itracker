//
//  LYTopBarView.h
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-4.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYVCDelegate.h"

@interface LYTopBarView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImgVW;

@property id <LYVCDelegate> delegate;
- (IBAction)diSendSMS:(id)sender;
- (IBAction)diSetMeetingPoint:(id)sender;
- (IBAction)diShowHelpInfo:(id)sender;

@end
