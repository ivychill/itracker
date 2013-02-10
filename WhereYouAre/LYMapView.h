//
//  LYMapView.h
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-6.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import "BMKMapView.h"
#import "BMapKit.h"
#import "LYMapPointAnnotation.h"

@interface LYMapView : BMKMapView


@property LYMapPointAnnotation *friendPointAnn;
@property LYMapPointAnnotation *mettingPointAnn;
@property LYMapPointAnnotation *undefinePointAnn;


@property LYMapPointAnnotation *currentlySelectedAnnotation;  //当前选择的点；由外部selected的回调函数设置
@property LYMapPointAnnotation *waitingPOIResultAnnotation;  //当前等待返回POI结果的点；由外部设置


- (void) setCenterOfMapView:(CLLocationCoordinate2D)coordinate;
- (LYMapPointAnnotation*) addAnnotation2Map:(CLLocationCoordinate2D)coordinate withType:(enum LYEN_MAPPOINTTYPE)annoType addr:(NSString*)addrTxt;
- (CLLocationCoordinate2D)addUndefAnnotationWithTouchPoint:(CGPoint) touchPoint;
-(void) setUndefPOIAnnotationAddress:(BMKAddrInfo*)addrinfo;

- (void) removeAllUndefAnnotation;

- (CLLocationCoordinate2D) getCurLocation;
- (BOOL) checkIfLocOutofRange;

@end
