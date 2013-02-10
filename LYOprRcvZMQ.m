//
//  LYOprRcvZMQ.m
//  RTTGUIDE
//
//  Created by Ye Sean on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import "RttGViewController.h"
#import "LYOprRcvZMQ.h"
#import "ZMQSocket.h"
#import "ZMQContext.h"
#import "Constants.h"

@implementation LYOprRcvZMQ


- (id) initWithDelegate:(NSObject <LYCommDelegate> *)delegate
{
    self = [super init];
    [self setDelegate: delegate];
    zmqContext = [[ZMQContext alloc] initWithIOThreads:1U];
    zmqSocket2Svr = [zmqContext socketWithType:ZMQ_DEALER];
    zmqSocket2Mt = [zmqContextInproc socketWithType:ZMQ_PAIR];

    BOOL didConnect = [zmqSocket2Mt connectToEndpoint:endpointMt];
    if (!didConnect)
    {
        NSLog(@"*** Fail to connect to main thread [%@].", zmqSocket2Mt);
        return self;
    }
    else
    {
        NSLog(@"*** Succeed to connect to main thread [%@].", zmqSocket2Mt);
    }
    
    return self;
}

- (void)main
{
    @autoreleasepool
    {
        /* Process tasks forever, multiplexing between |zmqSocket2Svr| and |zmqSocket2Mt|. */
        [self preparePoll];
        
        while (true) {
            [ZMQContext pollWithItems:items count:itemCount
                     timeoutAfterUsec:ZMQPollTimeoutNever];
            NSLog(@"poll return");
            if (items[POLL_SVR].revents & ZMQ_POLLIN) {
                NSData *reply = [[zmqSocket2Svr receiveDataWithFlags:0] copy];
                NSLog(@"reply [%@].", reply);
                if (reply != nil)
                {
                    [self.delegate performSelectorOnMainThread:@selector(OnReceivePacket:) withObject:(NSData*)reply waitUntilDone:0];
                }
            }
            
            if (items[POLL_MT].revents & ZMQ_POLLIN) {
                NSData *data = [zmqSocket2Mt receiveDataWithFlags:0];
                NSLog(@"request [%@].", data);
                if ([data length] == 2) {
                    NSString* cmd = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    if ([cmd isEqualToString:ZMQ_QUITTING_CMD])
                    {
                        NSLog(@"LYOprRcvZMQ quitting...");
                        break; //break the loop
                    }
                    else if ([cmd isEqualToString:ZMQ_RECONNECT_CMD])
                    {
                        NSLog(@"LYOprRcvZMQ connecting ...");
                        [self connect2Svr];
                        continue;
                    }
                }
                [zmqSocket2Svr sendData:data withFlags:0];
            }
        }
        
        [zmqContext closeSockets];
    }
}

- (void)preparePoll
{
    [zmqSocket2Svr getPollItem:&items[POLL_SVR] forEvents:ZMQ_POLLIN];
    [zmqSocket2Mt getPollItem:&items[POLL_MT] forEvents:ZMQ_POLLIN];
    itemCount = sizeof(items)/sizeof(*items);
}

- (void)connect2Svr
{
    NSLog(@"*** connect2Svr ***");
    if (zmqSocket2Svr)
    {
        [zmqSocket2Svr close];
    }
    
    zmqSocket2Svr = [zmqContext socketWithType:ZMQ_DEALER];
    BOOL didConnect = [zmqSocket2Svr connectToEndpoint:endpointSvr];
    if (!didConnect)
    {
        NSLog(@"*** Fail to connect to server [%@].", endpointSvr);
    }
    else
    {
        NSLog(@"*** Succeed to connect to server [%@].", endpointSvr);
        [self preparePoll];
    }
}

@end
