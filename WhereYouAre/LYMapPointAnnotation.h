//
//  LYMapPointAnnotation.h
//  Easyway
//
//  Created by Ye Sean on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BMKPointAnnotation.h"
@class BMKAddrInfo;


enum LYEN_MAPPOINTTYPE
{
    MAPPOINTTYPE_UNDEF = 1 << 0,
    MAPPOINTTYPE_FRIEND = 1 << 1,
    MAPPOINTTYPE_MEETING = 1 << 2,
    MAPPOINTTYPE_MY = 1 << 3,
    MAPPOINTTYPE_CENTER = 1 << 4,
} ;


@interface LYMapPointAnnotation : BMKPointAnnotation

@property BMKAddrInfo *addrInfo;
@property NSString  *addrString;
@property enum LYEN_MAPPOINTTYPE pointType;

@end
