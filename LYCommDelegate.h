//
//  LYCommDelegate.h
//  RTTGUIDE
//
//  Created by Ye Sean on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LYCommDelegate <NSObject>
- (void) OnReceivePacket:(NSData*) rcvdata;
@end
