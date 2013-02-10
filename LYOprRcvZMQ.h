//
//  LYOprRcvZMQ.h
//  RTTGUIDE
//
//  Created by Ye Sean on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tss.pb.h"
#import "ZMQSocket.h"
#import "ZMQContext.h"
#import "LYCommDelegate.h"

@interface LYOprRcvZMQ : NSOperation
{
    ZMQContext *zmqContext;
    ZMQSocket *zmqSocket2Svr;   //与tracker_svr连接
    ZMQSocket *zmqSocket2Mt;    //与主线程连接
    zmq_pollitem_t items[2];
    size_t itemCount;
    enum {POLL_SVR, POLL_MT};
}

@property (nonatomic, strong) ZMQContext* zmqTSSContx;
@property (nonatomic, strong) ZMQSocket* zmqTSSSocket;

//接收到数据后回调的Delegate
@property (nonatomic, assign) NSObject <LYCommDelegate> *delegate;

- (id)initWithDelegate:(NSObject <LYCommDelegate> *)delegate;
- (void)connect2Svr;

@end
