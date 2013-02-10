//
//  LYSuggestionListViewController.h
//  Easyway
//
//  Created by Ye Sean on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYVCDelegate.h"

@interface LYSuggestionListViewController : UITableViewController

@property (nonatomic, copy)NSString		*searchText;
@property (nonatomic, copy)NSString		*selectedText;
@property (nonatomic, retain)NSMutableArray	*resultList;
@property (assign) id <LYVCDelegate> delegate;

- (void)updateData;
- (void)clearData;

@end
