//
//  Constants.h
//  WhereYouAre
//
//  Created by chenfeng on 13-2-7.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMQContext.h"

extern NSString * const endpointSvr;
extern NSString * const endpointMt;
extern ZMQContext * zmqContextInproc;
extern NSString * const ZMQ_QUITTING_CMD;
extern NSString * const ZMQ_RECONNECT_CMD;

@interface Constants : NSObject

@end
