//
//  LYTopBarView.m
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-4.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import "LYTopBarView.h"

@implementation LYTopBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)diSendSMS:(id)sender
{
    [self.delegate diSendSMS4GetLocation:sender];
}

- (IBAction)diSetMeetingPoint:(id)sender
{
    [self.delegate diGetMeetLocation:sender];
}

- (IBAction)diShowHelpInfo:(id)sender
{
    [self.delegate diShowHelpInfo:sender];
}
@end
