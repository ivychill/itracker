//
//  LYLocationInfo.h
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-9.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bmapkit.h"

@interface LYLocationInfo : NSObject
@property CLLocationCoordinate2D coordinate;
@property NSTimeInterval timeStamp;
@property NSString *PoiInfo;
@property NSString *CityName;


@end
