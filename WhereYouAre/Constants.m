//
//  Constants.m
//  WhereYouAre
//
//  Created by chenfeng on 13-2-7.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import "Constants.h"

NSString * const endpointSvr = @"tcp://roadclouding.com:8007";
//NSString * const endpointMt = @"tcp://127.0.0.1:6007";
NSString * const endpointMt = @"inproc://lifecycle";
ZMQContext * zmqContextInproc;
NSString * const ZMQ_QUITTING_CMD = @"QT";
NSString * const ZMQ_RECONNECT_CMD = @"RC";

@implementation Constants

@end
