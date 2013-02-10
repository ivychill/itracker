//
//  WhereYouAreTests.m
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-7.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import "WhereYouAreTests.h"
#import "LYMapView.h"
#import "Reachability.h"
#import "bmapkit.h"
#import "LYMapView.h"
#import "LYHelpInfoViewController.h"
#import "LYSearchBarView.h"
#import "LYSuggestionListViewController.h"
#import "BaiduMobStat.h"
#import "LYComm4ZMQ.h"
#import "Trackevent.pb.h"
#import "LYMemDataSet.h"
#import "LYLocationInfo.h"
#import "LYModeIndicator.h"

@implementation WhereYouAreTests
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.mMainVC = [[LYViewController alloc] initWithNibName:@"LYViewController" bundle:nil];
    //LYViewController *mmt =
    
    STAssertNotNil(self.mMainVC, @"Main View Controller Init fall");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testMainVC
{
    //STFail(@"Unit tests are not implemented yet in WhereYouAreTests");
    STAssertNotNil(self.mMainVC, @"MapView Init fall");
}


- (void) testinitRunningDataset
{
    STAssertNoThrow([self.mMainVC initRunningDataset], @"testinitRunningDataset fall");
}

- (void) testinitMapView
{
    STAssertNoThrow([self.mMainVC initMapView], @"testinitMapView fall");
}

- (void) testInitMainTopbar
{
    [self.mMainVC initMainTopbar];
    STAssertNotNil(self.mMainVC.mainTopBarView, @"mainTopBarView Init fall");
}

- (void) testShowMainTopbar
{
    STAssertNoThrow([self.mMainVC showMainTopbar], @"testcase  fall");
}

- (void) testHideMainTopbar
{
    STAssertNoThrow([self.mMainVC hideMainTopbar], @"testcase  fall");
}

- (void) testinitSearchBar
{
    STAssertNoThrow([self.mMainVC initSearchBar], @"testcase  fall");
}

- (void) testShowSearchBar
{
    STAssertNoThrow([self.mMainVC showTopSearchBar], @"testcase  fall");
}

- (void) testinitSuggestionListView
{
    STAssertNoThrow([self.mMainVC initSuggestionListView], @"initSuggestionListView  fall");
}



- (void) testsetSearchListHidden
{
    STAssertNoThrow([self.mMainVC setSearchListHidden:YES], @"setSearchListHidden:YES  fall");
    STAssertNoThrow([self.mMainVC setSearchListHidden:NO], @"setSearchListHidden:NO  fall");

}


- (void) testinitMapButton
{
    STAssertNoThrow([self.mMainVC initMapButton], @"initMapButton  fall");
}


- (void) testdiSendSMS4GetLocation
{
    STAssertNoThrow([self.mMainVC diSendSMS4GetLocation:nil], @"diSendSMS4GetLocation  fall");
}


- (void) testdiGetMeetLocation
{
    STAssertNoThrow([self.mMainVC diGetMeetLocation:nil], @"diGetMeetLocation  fall");
}


- (void) testsendMeetingPoint
{
    STAssertNoThrow([self.mMainVC sendMeetingPoint], @"sendMeetingPoint  fall");
}


- (void) testdiShowHelpInfo
{
    STAssertNoThrow([self.mMainVC diShowHelpInfo:nil], @"diShowHelpInfo  fall");
}


- (void) testdidAddrSearchWasPressed
{
    STAssertNoThrow([self.mMainVC didAddrSearchWasPressed:@"test"], @"didAddrSearchWasPressed  fall");
    STAssertNoThrow([self.mMainVC didAddrSearchWasPressed:nil], @"didAddrSearchWasPressed:nil  fall");

}

- (void) testdidAddrSearchInputWasChanged
{
    STAssertNoThrow([self.mMainVC didAddrSearchInputWasChanged:@"test"], @"didAddrSearchInputWasChanged  fall");
}

- (void) testinitModeIndicator
{
    STAssertNoThrow([self.mMainVC initModeIndicator], @"initModeIndicator  fall");
}

- (void) testshowModeIndicator
{
    STAssertNoThrow([self.mMainVC showModeIndicator:@"Test" seconds:10], @"showModeIndicator  fall");
    STAssertNotNil(self.mMainVC.modeIndicatorTimer, @"showModeIndicator  fall");
}

- (void) testcloseModeIndicator
{
    STAssertNoThrow([self.mMainVC closeModeIndicator], @"closeModeIndicator  fall");
}

- (void) testsetShowModeIndicatorViewTimer
{
    STAssertNoThrow([self.mMainVC setShowModeIndicatorViewTimer:10], @"setShowModeIndicatorViewTimer  fall");
    STAssertNotNil(self.mMainVC.modeIndicatorTimer, @"setShowModeIndicatorViewTimer  fall");
}

- (void) testdidModeIndicatorTimeout
{
    STAssertNoThrow([self.mMainVC didModeIndicatorTimeout], @"didModeIndicatorTimeout  fall");
}

- (void) testsetFirstTimeInitDelayToDoTimer
{
    STAssertNoThrow([self.mMainVC startFirstTimeInitDelayToDoTimer], @"setFirstTimeInitDelayToDoTimer  fall");
    STAssertNotNil(self.mMainVC.firstTimeInitDelayToDoTimer, @"setShowModeIndicatorViewTimer  fall");
}

- (void) teststopFirstTimeInitDelayToDoTimer
{
    STAssertNoThrow([self.mMainVC stopFirstTimeInitDelayToDoTimer], @"stopFirstTimeInitDelayToDoTimer  fall");
}


- (void) testdiLongPress
{
    //UILongPressGestureRecognizer *sender = [[UILongPressGestureRecognizer alloc] init];
    STAssertNoThrow([self.mMainVC diLongPress:nil], @"diLongPress  fall");
}


- (void) testdiShowMenu
{
    STAssertNoThrow([self.mMainVC diShowMenu:nil], @"  fall");
}

- (void) testdiBack2Location
{
    STAssertNoThrow([self.mMainVC diBack2Location:nil], @"  fall");
}

- (void) testgetNextLocationTypeExp
{
    STAssertNoThrow([self.mMainVC getNextLocationType:-1], @"testgetNextLocationType -1 fall");
    STAssertNoThrow([self.mMainVC getNextLocationType:0], @"testgetNextLocationType  0 fall");
    STAssertNoThrow([self.mMainVC getNextLocationType:999], @"testgetNextLocationType 999 fall");
    
    NSInteger retValue =  [self.mMainVC getNextLocationType:1];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 1 whith Default fall");
    
     retValue =  [self.mMainVC getNextLocationType:2];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 2 whith Default fall");

     retValue =  [self.mMainVC getNextLocationType:4];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 4 whith Default fall");

    retValue =  [self.mMainVC getNextLocationType:3];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 3 whith Default fall");
    
    retValue =  [self.mMainVC getNextLocationType:100];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 100 whith Default fall");

    retValue =  [self.mMainVC getNextLocationType:-1];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType -1 whith Default fall");

}

- (void) testgetNextLocationTypeOnlyMe
{
    
    NSInteger retValue =  [self.mMainVC getNextLocationType:1];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 1 whith Default fall");
    
    retValue =  [self.mMainVC getNextLocationType:2];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 2 whith Default fall");
    
    retValue =  [self.mMainVC getNextLocationType:4];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 4 whith Default fall");
    
}


- (void) testgetNextLocationTypeWithMEandFriend
{
    [self.mMainVC initMapView];
    CLLocationCoordinate2D myCordinate;
    myCordinate.latitude = 22.33;
    myCordinate.longitude = 113.232323;

    [self.mMainVC.mainMapView addAnnotation2Map:myCordinate withType:MAPPOINTTYPE_FRIEND addr:@"test"];
    
    NSInteger retValue =  [self.mMainVC getNextLocationType:1];
    STAssertEquals(retValue, 2,  @"testgetNextLocationType 1 whith Default fall");

     retValue =  [self.mMainVC getNextLocationType:2];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 2 whith Default fall");

    retValue =  [self.mMainVC getNextLocationType:4];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 4 whith Default fall");

}

- (void) testgetNextLocationTypeWithMEandMeeting
{
    [self.mMainVC initMapView];
    CLLocationCoordinate2D myCordinate;
    myCordinate.latitude = 22.33;
    myCordinate.longitude = 113.232323;
    
    [self.mMainVC.mainMapView addAnnotation2Map:myCordinate withType:MAPPOINTTYPE_MEETING addr:@"test"];
    
    NSInteger retValue =  [self.mMainVC getNextLocationType:1];
    STAssertEquals(retValue, 4,  @"testgetNextLocationType 1 whith Default fall");
    
    retValue =  [self.mMainVC getNextLocationType:2];
    STAssertEquals(retValue, 4,  @"testgetNextLocationType 2 whith Default fall");
    
    retValue =  [self.mMainVC getNextLocationType:4];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 4 whith Default fall");
    
}


- (void) testgetNextLocationTypeWithMEandMeetingandFriend
{
    [self.mMainVC initMapView];
    CLLocationCoordinate2D myCordinate;
    myCordinate.latitude = 22.33;
    myCordinate.longitude = 113.232323;
    
    [self.mMainVC.mainMapView addAnnotation2Map:myCordinate withType:MAPPOINTTYPE_MEETING addr:@"test"];
    [self.mMainVC.mainMapView addAnnotation2Map:myCordinate withType:MAPPOINTTYPE_FRIEND addr:@"test"];

    
    NSInteger retValue =  [self.mMainVC getNextLocationType:1];
    STAssertEquals(retValue, 2,  @"testgetNextLocationType 1 whith Default fall");
    
    retValue =  [self.mMainVC getNextLocationType:2];
    STAssertEquals(retValue, 4,  @"testgetNextLocationType 2 whith Default fall");
    
    retValue =  [self.mMainVC getNextLocationType:4];
    STAssertEquals(retValue, 1,  @"testgetNextLocationType 4 whith Default fall");
    
}


- (void) testdiMapTypeChanged
{
    STAssertNoThrow([self.mMainVC diMapTypeChanged:nil], @"diMapTypeChanged  fall");
}


- (void) testdiZoomOut
{
    STAssertNoThrow([self.mMainVC diZoomOut:nil], @"diZoomOut  fall");
}

- (void) testdiZoomIn
{
    STAssertNoThrow([self.mMainVC diZoomIn:nil], @"diZoomIn  fall");
}

- (void) testsendSMS
{
    STAssertNoThrow([self.mMainVC sendSMS:@"Test" recipientList:nil], @"sendSMS  fall");
}


- (void) testmessageComposeViewController
{
    STAssertNoThrow([self.mMainVC messageComposeViewController:nil didFinishWithResult:MessageComposeResultSent], @"messageComposeViewController  fall");
}


- (void) testgetPoinameSuggestionfromMAPSVR
{
    [self.mMainVC initMapView];
    STAssertNoThrow([self.mMainVC getPoinameSuggestionfromMAPSVR:@"test"], @"getPoinameSuggestionfromMAPSVR  fall");
}

- (void) testgetPoiLocationInCityfromMAPSVR
{
    [self.mMainVC initMapView];
    STAssertNoThrow([self.mMainVC getPoiLocationInCityfromMAPSVR:@"Shenzhen" poiName:@"wenxin 2 rd"], @"getPoiLocationInCityfromMAPSVR  fall");
}

- (void) testgetGeoInfofromMAPSVR
{
    [self.mMainVC initMapView];
    CLLocationCoordinate2D myCordinate;
    myCordinate.latitude = 22.33;
    myCordinate.longitude = 113.232323;

    STAssertNoThrow([self.mMainVC getGeoInfofromMAPSVR:myCordinate], @"getGeoInfofromMAPSVR  fall");
}

- (void) testonGetSuggestionResult
{
    STAssertNoThrow([self.mMainVC onGetSuggestionResult:nil errorCode:0], @"onGetSuggestionResult  fall");
}

- (void) testisNetworkActive
{
    STAssertTrue([self.mMainVC isNetworkActive], @"isNetworkActive  fall");
}

- (void) testisNetworkReachable
{
    STAssertTrue([self.mMainVC isNetworkReachable], @"isNetworkReachable  fall");
}
- (void) testdetectNetworkReachableAndShowTips
{
    STAssertTrue([self.mMainVC detectNetworkReachableAndShowTips], @"detectNetworkReachableAndShowTips  fall");
}

- (void) testcheckNetworkStatus
{
    STAssertNoThrow([self.mMainVC checkNetworkStatus:nil], @"checkNetworkStatus  fall");
}

- (void) testOnReceivePacket
{
    STAssertNoThrow([self.mMainVC OnReceivePacket:nil], @"OnRceivePacket  fall");
}

- (void) testdiGotTrackID
{
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = dev.uniqueIdentifier;
    
    TrackEvent_Builder *trackmsgBuilder = [[TrackEvent_Builder alloc] init];
    
    [trackmsgBuilder setType:TrackEvent_EventTypeStartTrackingRep];
    [trackmsgBuilder setSndId:deviceUuid];
    
    [trackmsgBuilder setTracker:deviceUuid];
    NSString *strTrakee = @"TESTTrakeeID";
    NSLog(@"trackee ID=%@", strTrakee);
    [trackmsgBuilder setTrackee:strTrakee];
    
    [trackmsgBuilder setId:123456];
    
    
    TrackEvent * testTrackMsg = [trackmsgBuilder build];
    
    
    [self.mMainVC initRunningDataset];
    self.mMainVC.runningDataset.TrackeeID  = 123456;


    STAssertNoThrow([self.mMainVC diGotTrackID:testTrackMsg], @"diGotTrackID  fall");

}
- (void) testdiGotTrackeeLocation
{
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = dev.uniqueIdentifier;
    
    TrackEvent_Builder *trackmsgBuilder = [[TrackEvent_Builder alloc] init];
    
    [trackmsgBuilder setType:TrackEvent_EventTypeFwdLocReq];
    [trackmsgBuilder setSndId:deviceUuid];
    
    [trackmsgBuilder setTracker:deviceUuid];
    NSString *strTrakee = @"TESTTrakeeID";
    NSLog(@"trackee ID=%@", strTrakee);
    [trackmsgBuilder setTrackee:strTrakee];
    
    [trackmsgBuilder setId:123456];
    [trackmsgBuilder setTrackeeX:@"122.30"];
    [trackmsgBuilder setTrackeeY:@"22.30"];

    TrackEvent * testTrackMsg = [trackmsgBuilder build];
    
    
    
    [self.mMainVC initRunningDataset];
    self.mMainVC.runningDataset.TrackeeID  = 123456;
        
    STAssertNoThrow([self.mMainVC diGotTrackeeLocation:testTrackMsg], @"diGotTrackeeLocation  fall");
    STAssertEqualsWithAccuracy(self.mMainVC.runningDataset.FriendLocation.coordinate.longitude,  122.30, 0.1, @"diGotTrackeeLocation  fall");
    STAssertEqualsWithAccuracy(self.mMainVC.runningDataset.FriendLocation.coordinate.latitude,  22.30, 0.1, @"diGotTrackeeLocation  fall");
}

//- (void) test
//{
//    STAssertNoThrow([self.mMainVC ], @"  fall");
//}




@end
