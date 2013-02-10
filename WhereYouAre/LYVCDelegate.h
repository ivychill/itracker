//
//  LYVCDelegate.h
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-9.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LYVCDelegate <NSObject>

- (void)diSendSMS4GetLocation:(id)sender;
- (void)diGetMeetLocation:(id)sender;
- (void)diShowHelpInfo:(id)sender;

- (void)didAddrSearchWasPressed:(NSString*)inputStr;
- (void)didAddrSearchInputWasChanged:(NSString*)inputStr;
- (void)didAddrSearchBegin:(id)sender;
- (void)didHideAddrSearchBar:(id)sender;
- (void)didHideSuggestionList:(id)sender;


- (void)didResultlistSelected:(NSString *)poiName;

@end
