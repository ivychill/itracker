//
//  LYComm4ZMQ.m
//  Easyway
//
//  Created by Ye Sean on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LYComm4ZMQ.h"
#import "ZMQSocket.h"
#import "ZMQContext.h"
#import "LYOprRcvZMQ.h"
#import "Constants.h"

@implementation LYComm4ZMQ


//初始化：endpoint: 连接的端点；delegate:实现OnReceivePacket方法的类实例
- (id)initWithDelegate:(NSObject <LYCommDelegate> *)delegate
{
    //初始化和启动通信模块
    zmqContextInproc = [[ZMQContext alloc] initWithIOThreads:1U];
    zmqSocket = [zmqContextInproc socketWithType:ZMQ_PAIR];
    BOOL didBind;
    didBind = [zmqSocket bindToEndpoint:endpointMt];
    if (!didBind)
    {
        NSLog(@"*** Fail to bind to main thread [%@].", endpointMt);
        return self;
    }
    else
    {
        NSLog(@"*** Succeed to bind to main thread [%@].", endpointMt);
    }
    
    pRcvThread = [[LYOprRcvZMQ alloc] initWithDelegate:delegate];
    rttThreadQue = [[NSOperationQueue alloc] init];
    [rttThreadQue addOperation:pRcvThread];
    
    return self;
}

- (BOOL)sendCmdConnect
{
    NSData* data=[ZMQ_RECONNECT_CMD dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"sendCmdConnect [%@].", data);
    return [zmqSocket sendData:data withFlags:0];
}

//发送，直接调用ZMQ的发送函数
- (BOOL)sendData:(NSData *)messageData withFlags:(ZMQMessageSendFlags)flags
{
    NSLog(@"sendData [%@].", messageData);
    return [zmqSocket sendData:messageData withFlags:0];
}

@end
