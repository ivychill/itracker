//
//  LYViewController.h
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-4.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "bmapkit.h"
#import "LYVCDelegate.h"
#import "LYCommDelegate.h"


@class LYTopBarView;
@class Reachability;
@class LYMapView;
@class LYSearchBarView;
@class LYSuggestionListViewController;
@class LYComm4ZMQ;
@class LYMemDataSet;
@class LYModeIndicator;
@class TrackEvent;

@interface LYViewController : UIViewController <MFMessageComposeViewControllerDelegate, LYVCDelegate, BMKMapViewDelegate, BMKSearchDelegate, LYCommDelegate, CLLocationManagerDelegate>
{
//    CLLocationManager *locationManager;
    BOOL isCurrent;
}

@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIView *topBarView;
- (IBAction)diShowMenu:(id)sender;
- (IBAction)diZoomIn:(id)sender;
- (IBAction)diBack2Location:(id)sender;
- (IBAction)diMapTypeChanged:(id)sender;
- (IBAction)diZoomOut:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *zoomInBTN;
@property (strong, nonatomic) IBOutlet UIButton *zoomOutBTN;
@property (strong, nonatomic) IBOutlet UIButton *locationBTN;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSEG;


@property (strong, nonatomic) BMKSearch  *mapSearcher;

@property LYComm4ZMQ *comm4AppSvr;
@property LYMemDataSet *runningDataset;

@property LYTopBarView *mainTopBarView;
@property LYMapView *mainMapView;
@property LYSearchBarView *topSearchBar;
@property LYSuggestionListViewController *suggestionListVC;
@property LYModeIndicator *modeIndicatorView;
//@property UIActivityIndicatorView *activityIndicatorView;

@property NSTimer *modeIndicatorTimer;
@property NSTimer *firstTimeInitDelayToDoTimer;


@property Reachability *internetReachable;
@property BOOL internetActive;
@property Reachability *hostReachable;
@property BOOL hostActive;
@property NSInteger locationType;


@property UIButton *uiBTNSendSMS4GetLocation;
@property UIButton *uiBTN2GetMeetLocation;
@property UIButton *uiBTNGetHelpInfo;

- (IBAction)diLongPress:(UILongPressGestureRecognizer *)sender;

//Add these function description for Unit Test
- (void) initRunningDataset;
- (void) initMapView;
- (void) initMainTopbar;
- (void) showMainTopbar;
- (void) hideMainTopbar;
- (void) initSearchBar;
- (void) hideTopSearchBar;
- (void) showTopSearchBar;
- (void) initSuggestionListView;
- (void) setSearchListHidden:(BOOL)hidden;
- (void) initMapButton;


- (void) diSendSMS4GetLocation:(id)sender;
- (void) diGetMeetLocation:(id)sender;
- (void) sendMeetingPoint;
- (void) diShowHelpInfo:(id)sender;

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
- (void)didAddrSearchWasPressed:(NSString*)inputStr;
- (void)didAddrSearchInputWasChanged:(NSString*)inputStr;

- (void) initModeIndicator;
- (void) showModeIndicator:(NSString *)actinfo seconds:(NSInteger) seconds;
- (void) closeModeIndicator;

- (void) setShowModeIndicatorViewTimer:(NSInteger) seconds;
- (void) didModeIndicatorTimeout;
- (void) startFirstTimeInitDelayToDoTimer;
- (void) stopFirstTimeInitDelayToDoTimer;

- (NSInteger) getNextLocationType:(NSInteger) curLocType;

- (BOOL) getPoinameSuggestionfromMAPSVR:(NSString*)searchStr;
- (BOOL) getPoiLocationInCityfromMAPSVR:(NSString*)cityName poiName:(NSString*)poiName;
- (BOOL) getGeoInfofromMAPSVR:(CLLocationCoordinate2D)coordinate;

- (void)onGetSuggestionResult:(BMKSuggestionResult*)result errorCode:(int)error;
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error;
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error;

- (BOOL) isNetworkActive;
- (BOOL) isNetworkReachable;
- (BOOL) detectNetworkReachableAndShowTips;
- (void) checkNetworkStatus:(NSNotification*)notice;
- (void) OnReceivePacket:(NSData*) rcvdata;
- (void) diGotTrackID:(TrackEvent *) resTrackEvent;
- (void) diGotTrackeeLocation:(TrackEvent *) resTrackEvent;
- (bool) sendStartTracking2Server;
- (bool) sendChechinInfo2TSS;

@end
