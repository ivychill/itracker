//
//  LYComm4ZMQ.h
//  Easyway
//
//  Created by Ye Sean on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCommDelegate.h"
#import "ZMQSocket.h"
#import "LYOprRcvZMQ.h"

@class ZMQContext;
@class ZMQSocket;


@interface LYComm4ZMQ : NSObject
{
    //用于与ZMQ子线程间通讯
    ZMQSocket *zmqSocket;
    NSOperationQueue *rttThreadQue;
    LYOprRcvZMQ *pRcvThread;
}

//- (id) initWithEndpoint:(NSString*) endpoint delegate:(NSObject <LYCommDelegate> *) delegate;

- (id)initWithDelegate:(NSObject <LYCommDelegate> *)delegate;
- (BOOL)sendCmdConnect;
- (BOOL)sendData:(NSData *)messageData withFlags:(ZMQMessageSendFlags)flags;

@end
