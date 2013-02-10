//
//  LYClassMapViewTests.m
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-6.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import "LYClassMapViewTests.h"

@implementation LYClassMapViewTests
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    self.mapView = [[LYMapView alloc]initWithFrame:mainScreenRect];
    //[self.mainMapView setDelegate:self];
    
    STAssertNotNil(self.mapView, @"Main View Controller Init fall");

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void) testOutofRange
{
    STAssertTrue([self.mapView checkIfLocOutofRange], @"detect out fo range Fall");
}


- (void) testSetCenterofMapView
{
    //STAssertNotNil(, @"mainTopBarView Init fall");
    CLLocationCoordinate2D myCordinate;
    myCordinate.latitude = 22.33;
    myCordinate.longitude = 113.232323;    
    
    STAssertNoThrow([self.mapView setCenterOfMapView:myCordinate], @"Test case SetCenterofMapView fall");

}

- (void) testaddAnnotation2Map
{
    //STAssertNotNil(, @"mainTopBarView Init fall");
    CLLocationCoordinate2D myCordinate;
    myCordinate.latitude = 22.33;
    myCordinate.longitude = 113.232323;
    
    STAssertNoThrow([self.mapView  addAnnotation2Map:myCordinate withType:MAPPOINTTYPE_UNDEF addr:nil], @"Test case addAnnotation2Map fall");
    
}

- (void) testaddUndefAnnotationWithTouchPoint
{
    STAssertNoThrow([self.mapView  addUndefAnnotationWithTouchPoint:(CGPointMake(160, 160)) ], @"Test case addUndefAnnotationWithTouchPoint fall");
}

- (void) testRemoveAllUndefAnnotation
{

    STAssertNoThrow([self.mapView  removeAllUndefAnnotation], @"Test case RemoveAllUndefAnnotation fall");
}

- (void) testgetCurLocation
{
    CLLocationCoordinate2D retCordinate = [self.mapView  getCurLocation];
    
    STAssertTrue( ((retCordinate.latitude >= 0.0) && (retCordinate.longitude >= 0.0)), @"Test case TestgetCurLocation fall");
}


@end
