//
//  LYViewController.m
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-4.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import "LYViewController.h"
#import "LYTopBarView.h"
#import <QuartzCore/QuartzCore.h>
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


@implementation LYViewController
@synthesize comm4AppSvr;

- (void)viewDidLoad
{
    //初始化网络监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:)name:kReachabilityChangedNotification object:nil];

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initMapView];
    [self initMapButton];
    
    [self initRunningDataset];
    
    [self initMainTopbar];
    [self initSearchBar];
    [self initModeIndicator];

    //设置搜索建议结果列表框
    [self initSuggestionListView];
    [self.view addSubview:self.suggestionListVC.view];
    
    isCurrent = FALSE;
    
//    // Create location manager object
//    locationManager = [[CLLocationManager alloc] init];
//    [locationManager setDelegate:self];
//    
//    // And we want it to be as accurate as possible
//    // regardless of how much time/power it takes
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    // Tell our manager to start looking for its location immediately
//    [locationManager startUpdatingLocation];
    
    //初始化网络
    self.internetReachable =[Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    
    // check if a pathway to a host exists
    self.hostReachable =[Reachability reachabilityWithHostName:@"www.roadclouding.com"];
    [self.hostReachable startNotifier];
    
    self.comm4AppSvr = [[LYComm4ZMQ alloc] initWithDelegate:self];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    NSLog(@"didUpdateLocations");
////    [self.mainMapView setCenterOfMapView:self.mainMapView.userLocation.coordinate];
//    CLLocation *location = [locations objectAtIndex:0];
//    [self.mainMapView setCenterOfMapView:location.coordinate];
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation");
//    // How many seconds ago was this new location created?
//    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
//    
//    // CLLocationManagers will return the last found location of the
//    // device first, you don't want that data in this case.
//    // If this location was made more than 3 minutes ago, ignore it.
//    if (t < -180) {
//        // This is cached data, you don't want it, keep looking
//        return;
//    }
//    
//    BMKMapPoint point;
//    point = BMKMapPointForCoordinate(newLocation.coordinate);
//    NSLog(@"point=%.6f, %.6f", point.x, point.y);
//    [self.mainMapView setCenterOfMapView:newLocation.coordinate];
//    [locationManager stopUpdatingLocation];
//}


- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        if (isCurrent == FALSE) {
            [self.mainMapView setCenterOfMapView:userLocation.location.coordinate];
            NSLog(@"didUpdateUserLocation, userLocation: %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
            isCurrent = TRUE;
        }
	}
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil)
		NSLog(@"locate failed: %@", [error localizedDescription]);
	else {
		NSLog(@"locate failed");
	}
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setTopBarView:nil];
    [self setZoomInBTN:nil];
    [self setZoomOutBTN:nil];
    [self setLocationBTN:nil];
    [self setMapTypeSEG:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark -
#pragma mark init UI
- (void) initRunningDataset
{
    self.locationType = 1;
    
    self.runningDataset  = [[LYMemDataSet alloc] init];
    UIDevice *thisDev = [UIDevice currentDevice];
    self.runningDataset.DevUUID =  thisDev.uniqueIdentifier;
    
    self.runningDataset.FriendLocation = nil;
    self.runningDataset.MeetingPointLocation = nil;
    self.runningDataset.TrackeeID = 0;
    self.runningDataset.TrackingWebSession = nil;
    
}

- (void) initMapView
{
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    self.mainMapView = [[LYMapView alloc]initWithFrame:mainScreenRect];
    [self.mapView  addSubview:self.mainMapView];
    [self.mainMapView setDelegate:self];
    //[self.mainMapView setUserInteractionEnabled:YES];
    [self.mainMapView setShowsUserLocation:YES];
    [self.mainMapView setCenterOfMapView:([self.mainMapView getCurLocation])];
    [self.mainMapView setZoomLevel:15];
    
    if (!(self.mapSearcher))
    {
        self.mapSearcher = [[BMKSearch alloc]init];
        [self.mapSearcher setDelegate:self];
    }
}

- (void) initMapButton
{
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    
    [self.zoomOutBTN setCenter:CGPointMake(40.0, mainScreenRect.size.height-180.0)];
    [self.zoomInBTN setCenter:CGPointMake(40.0, mainScreenRect.size.height-130.0)];
    [self.locationBTN setCenter:CGPointMake(280.0, mainScreenRect.size.height-180.0)];
    [self.mapTypeSEG setCenter:CGPointMake(260.0, mainScreenRect.size.height-46.0-80.0)];
    
    CGRect frame= self.mapTypeSEG.frame;
    [self.mapTypeSEG setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 38)];
    
}


- (void) initMainTopbar
{
    self.mainTopBarView = [[[NSBundle mainBundle] loadNibNamed:@"LYTopBarView" owner:self options:nil] lastObject];
    //[self.mainTopBarView = [UIView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,80.0)];
    //[self.mainTopBarView setFrame:CGRectMake(0.0,0.0,300.0,80.0)];
    
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    //CGRect mainScreenRect = [self.view frame];
    CGRect barScreenRect = [self.mainTopBarView frame];

    //[self.mainTopBarView setCenter:CGPointMake(160.0, 30.0)];
    [self.mainTopBarView setCenter:CGPointMake(160.0, mainScreenRect.size.height-barScreenRect.size.height/2.0-20.0)];

    [self.mainTopBarView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.mainTopBarView];
    //[[self view] addSubview:self.mainTopBarView];
    
    self.mainTopBarView.delegate = self;
    
    
    //设置圆角
    [self.mainTopBarView.layer setCornerRadius:16.0f];
    //self.mainTopBarView setBackgroundImgVW:<#(UIImageView *)#>
    //[self.mainTopBarView.backgroundImgVW.layer setCornerRadius:16.0f];

    
    //设置阴影
    self.mainTopBarView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.mainTopBarView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); // [水平偏移，垂直偏移]
    self.mainTopBarView.layer.shadowOpacity = 0.8f; // 0.0 ~ 1.0的值
    self.mainTopBarView.layer.shadowRadius = 10.0f; // 阴影发散的程度
}

- (void) showMainTopbar
{
    [self.mainTopBarView setHidden:NO];

}

- (void) hideMainTopbar
{
    [self.mainTopBarView setHidden:YES];
}



-(void) initSearchBar
{
    
    self.topSearchBar = [[[NSBundle mainBundle] loadNibNamed:@"LYSearchBar" owner:self options:nil] lastObject];
    [self.topSearchBar setCenter:CGPointMake(160.0, 20.0)];
    [self.topSearchBar setInputDelegate];
    [self.topSearchBar setDelegate:self];
    
    [[self view] addSubview:self.topSearchBar];
    
    //设置圆角
    //[mTrafficInfoBoard.layer setCornerRadius:12.0f];
    
    //设置阴影
    self.topSearchBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.topSearchBar.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); // [水平偏移，垂直偏移]
    self.topSearchBar.layer.shadowOpacity = 0.5f; // 0.0 ~ 1.0的值
    self.topSearchBar.layer.shadowRadius = 10.0f; // 阴影发散的程度
    
    //[self.topSearchBar setHidden:YES];
}

- (void) hideTopSearchBar
{
    [self.topSearchBar dismissKeyboard];
    [self.topSearchBar setHidden:YES];
    
    [self setSearchListHidden:YES];
    [self showMainTopbar];
}

- (void) showTopSearchBar
{
    [self.topSearchBar.uiInputTxtField setText:@""];
    [self.topSearchBar setHidden:NO];
    [self hideMainTopbar];
}

- (void) initSuggestionListView
{
    self.suggestionListVC = [[LYSuggestionListViewController alloc] initWithStyle:UITableViewStylePlain];
    self.suggestionListVC.delegate = self;
    [self.suggestionListVC.view setFrame:CGRectMake(5, 42, 0, 0)];
}

- (void)setSearchListHidden:(BOOL)hidden
{
    if (!hidden)
    {
        [self.suggestionListVC.view setHidden:NO];
    }
	NSInteger height = hidden ? 0 : 125; //180
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	//[mSuggestionListVC.view setFrame:CGRectMake(mSuggestionListVC.view.frame.origin.x, mSuggestionListVC.view.frame.origin.y, 210, height)];
    [self.suggestionListVC.view setFrame:CGRectMake(self.suggestionListVC.view.frame.origin.x, self.suggestionListVC.view.frame.origin.y, 310, height)];
	[UIView commitAnimations];
    
    
    if (hidden)
    {
        [self.suggestionListVC clearData];
        [self.suggestionListVC updateData];
        [self.suggestionListVC.view setHidden:YES];
    }
}


-(void) initModeIndicator
{
    self.modeIndicatorView = [[[NSBundle mainBundle] loadNibNamed:@"LYModeIndicatorVW" owner:self options:nil] lastObject];
    [[self view] addSubview:self.modeIndicatorView];
    
    CGRect mainScreenRect = [[UIScreen mainScreen] bounds];
    
    [self.modeIndicatorView.backgroundBoardVW setCenter:CGPointMake(160.0, mainScreenRect.size.height/2.0)];
    
    //设置圆角
    [self.modeIndicatorView.backgroundBoardVW.layer setCornerRadius:12.0f];
    
    //设置阴影
    self.modeIndicatorView.backgroundBoardVW.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.modeIndicatorView.backgroundBoardVW.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); // [水平偏移，垂直偏移]
    self.modeIndicatorView.backgroundBoardVW.layer.shadowOpacity = 0.5f; // 0.0 ~ 1.0的值
    self.modeIndicatorView.backgroundBoardVW.layer.shadowRadius = 10.0f; // 阴影发散的程度
    
    
    [self closeModeIndicator];
}


- (void) showModeIndicator:(NSString *)actinfo seconds:(NSInteger) seconds
{
    self.modeIndicatorView.activityDescLBL.text = actinfo;
    [self.modeIndicatorView setHidden:NO];
    [self.view bringSubviewToFront:self.modeIndicatorView];
    [self.modeIndicatorView.activityIndicator startAnimating];

    //[self.activityIndicatorView startAnimating];
    
    if (seconds > 0)
    {
        [self setShowModeIndicatorViewTimer:seconds];
    }
}

- (void) closeModeIndicator
{
    if (self.modeIndicatorTimer)
    {
        [self.modeIndicatorTimer invalidate];
        self.modeIndicatorTimer = nil;
    }
    //[self.activityIndicatorView stopAnimating];
    [self.modeIndicatorView.activityIndicator stopAnimating];
    [self.modeIndicatorView setHidden:YES];
}


#pragma mark -
#pragma mark Timer process

- (void) setShowModeIndicatorViewTimer:(NSInteger) seconds
{
    if (self.modeIndicatorTimer)
    {
        [self.modeIndicatorTimer invalidate];
        self.modeIndicatorTimer = nil;
    }
    self.modeIndicatorTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(didModeIndicatorTimeout) userInfo:nil repeats:NO];
}

- (void) didModeIndicatorTimeout
{
    //清除定时器的动作统一在Close中完成
    [self closeModeIndicator];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"操作失败，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alertView show];
}

//1秒后启动初始化工作，（目的是为了避免刚刚启动时当前位置、网络等不稳定的因素）
- (void) startFirstTimeInitDelayToDoTimer
{
    [self stopFirstTimeInitDelayToDoTimer];
    
    self.firstTimeInitDelayToDoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didFirstTimeInitDelayToDo) userInfo:nil repeats:NO];
}

- (void) stopFirstTimeInitDelayToDoTimer
{
    if (self.firstTimeInitDelayToDoTimer)
    {
        [self.firstTimeInitDelayToDoTimer invalidate];
        self.firstTimeInitDelayToDoTimer = nil;
    }
}

//- (void) didFirstTimeInitDelayToDo
//{
//    NSLog(@"Enter didFirstTimeInitDelayToDo");
//    if ([self isNetworkActive])
//    {
//        [self sendChechinInfo2TSS];
//    }
//}


#pragma mark -
#pragma mark UI Actions

- (IBAction)diLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (! [self detectNetworkReachableAndShowTips])
        {
            return;
        }
        
        //坐标转换
        CGPoint touchPoint = [sender locationInView:self.mainMapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mainMapView addUndefAnnotationWithTouchPoint:touchPoint];
        
        BOOL result = [self getGeoInfofromMAPSVR:touchMapCoordinate];
        if (result)
        {
            //等待动作指示以及串行超时处理
            [self showModeIndicator:@"正在获取坐标对应的地址信息，请稍候" seconds:10];
        }
    }
    
}


- (IBAction)diShowMenu:(id)sender
{
    if ( [self.mainTopBarView isHidden] )
    {
        [self showMainTopbar];
    }
    else
    {
        [self hideMainTopbar];
    }
}


- (void) diSendSMS4GetLocation:(id)sender
{
    NSLog(@"diSendSMS4GetLocation");
    
    //用于百度统计。发送短信被认为活跃用户。
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    [statTracker logEvent:@"1" eventLabel:[NSString stringWithFormat: @"发送短信"]];
    
    if ([self isNetworkReachable])
    {
        if ([self sendStartTracking2Server])
        {
            [self showModeIndicator:@"正在和服务器通信，请稍候" seconds:10];
            return;
        }
    }
    
    //如果网络不可用或者发送失败，则提示
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"网络不可达，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alertView show];
}

- (void) sendMeetingPoint
{
    CLLocationCoordinate2D meetingCoor = self.mainMapView.currentlySelectedAnnotation.coordinate;
    NSInteger meetinglocLat = meetingCoor.latitude * 1000000;
    NSInteger meetinglocLng = meetingCoor.longitude * 1000000;
    
    NSString *strAddr =  self.mainMapView.currentlySelectedAnnotation.addrString;
    NSString *meetringAddr = [[NSString alloc] initWithFormat:@"会合地点 %@", strAddr];
//    NSString *msgCnt = [[NSString alloc] initWithFormat:@"%@，请打开链接查看地图地点：http://dd.roadclouding.com/d/%d,%d",
//                        meetringAddr, meetinglocLng, meetinglocLat ];
    NSString *msgCnt = [[NSString alloc] initWithFormat:@"发自易寻位，共享一个地点 http://dd.roadclouding.com/dests?x=%d&y=%d", meetinglocLng, meetinglocLat ];
    
    [self.mainMapView removeAllUndefAnnotation];
    [self.mainMapView addAnnotation2Map:meetingCoor withType:MAPPOINTTYPE_MEETING addr:meetringAddr];
    
    [self sendSMS:msgCnt recipientList:nil];
}


- (void) diGetMeetLocation:(id)sender
{
//    [self hideMainTopbar];
//    [self.topSearchBar setHidden:NO];
    [self showTopSearchBar];
}

- (void) diShowHelpInfo:(id)sender
{

    LYHelpInfoViewController *helpView = [[LYHelpInfoViewController alloc] init];
    [self.navigationController pushViewController:helpView animated:YES];
}

- (IBAction)diBack2Location:(id)sender
{
    //self.locationType = self.locationType << 1;
    //self.locationType =  [self getNextLocationType:self.locationType];
    switch (self.locationType)
    {
        case 1:
        {
            [self.mainMapView setCenterOfMapView:self.mainMapView.userLocation.coordinate];
        };
            break;
        case 2:
        {
            if (self.mainMapView.friendPointAnn)
            {
                [self.mainMapView setCenterOfMapView:self.mainMapView.friendPointAnn.coordinate];
            }
        };
            break;
        case 4:
        {
            if (self.mainMapView.mettingPointAnn)
            {
                [self.mainMapView setCenterOfMapView:self.mainMapView.mettingPointAnn.coordinate];
            }
        };
            break;
        default:
            break;
    }
    
    //NSInteger NextlocType = [self getNextLocationType:self.locationType];
    self.locationType =  [self getNextLocationType:self.locationType];
    switch (self.locationType)
    {
        case 1:
        {
            //[self.locationBTN setTitle:@"ME" forState:UIControlStateNormal];
            UIImage *initImage = [UIImage imageNamed:@"LocMe.png"];            
            [self.locationBTN setImage:initImage forState:UIControlStateNormal];

        };
            break;
        case 2:
        {
            if (self.mainMapView.friendPointAnn)
            {
                //[self.locationBTN setTitle:@"Friend" forState:UIControlStateNormal];
                UIImage *initImage = [UIImage imageNamed:@"LocFriend.png"];
                [self.locationBTN setImage:initImage forState:UIControlStateNormal];
            }
        };
            break;
        case 4:
        {
            if (self.mainMapView.mettingPointAnn)
            {
                //[self.locationBTN setTitle:@"Meeting" forState:UIControlStateNormal];
                UIImage *initImage = [UIImage imageNamed:@"LocMeet.png"];
                [self.locationBTN setImage:initImage forState:UIControlStateNormal];
            }
        };
            break;
        default:
            break;
    }
    
    
}

- (NSInteger) getNextLocationType:(NSInteger) curLocType
{
    NSInteger nextType = 1;
    
    if (curLocType < 4)
    {
        nextType = curLocType << 1;
    }
    
    switch (nextType)
    {
        case 1:
        {
            
        };
            break;
        case 2:
        {
            if (self.mainMapView.friendPointAnn)
            {
                
            }
            else
            {
                nextType = [self getNextLocationType:nextType];
            }
        };
            break;
        case 4:
        {
            if (self.mainMapView.mettingPointAnn)
            {
                
            }
            else
            {
                nextType = [self getNextLocationType:nextType];
            }
        };
            break;
        default:
        {
            nextType = 1;
        }
            break;
    }
    
    return nextType;
    
}



- (IBAction)diMapTypeChanged:(id)sender
{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex)
    {
        case 0:
        {
            [self.mainMapView  setMapType:BMKMapTypeStandard];
        };
            break;
        case 1:
        {
            [self.mainMapView  setMapType:BMKMapTypeSatellite];
        };
            break;
        default:
            break;
    }
}

- (IBAction)diZoomOut:(id)sender
{
    [self.mainMapView zoomOut];
}

- (IBAction)diZoomIn:(id)sender
{
    [self.mainMapView zoomIn];
}



#pragma mark - View lifecycle

-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"开启主页面"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"退出主页面"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

#pragma mark -
#pragma mark SMS Functions


//内容，收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    
    if([MFMessageComposeViewController canSendText])
    {
        
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentModalViewController:controller animated:YES];
        
    }
    
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
    }
    else
    {
        if (result == MessageComposeResultSent)
        {
            NSLog(@"Message sent");
        }
        else
        {
            NSLog(@"Message failed");
        }
    }
}



#pragma mark -
#pragma mark Searchbar delegate

- (void)didAddrSearchWasPressed:(NSString*)inputStr
{
    NSString *strPOIName = inputStr;
    //[self.mapSearcher poiSearchInCity:@"深圳" withKey:strPOIName pageIndex:0];
    [self setSearchListHidden:YES];

    if (![self detectNetworkReachableAndShowTips])
    {
        return;
    }
    
    BOOL result = [self getPoiLocationInCityfromMAPSVR:@"深圳" poiName:strPOIName];
    if (!result)
    {
        
        //NSLog(@"Failure when get poi location from map server");
        //百度已经有提示了，所以不用重复提示
        //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:errorMsg
        //                                                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        //            [alertView show];
        return;
    }
    else
    {
        //[self hideTopSearchBar];
        //[self didHideAddrSearchBar:nil];
        
//        [self setRunningActivityTimer:10 activity:RTTEN_ACTIVITYTYPE_GETTINGGEO];
//        [self showModeIndicator:@"获取地理坐标信息" seconds:10];
        
    }
    
}
- (void)didAddrSearchInputWasChanged:(NSString*)inputStr
{
    if ([inputStr length] != 0)
    {
        if (![self isNetworkReachable])
        {
            return;
        }
        
//        if (![self detectNetworkReachableAndShowTips])
//        {
//            return;
//        }
        
        BOOL callresult = [self getPoinameSuggestionfromMAPSVR:inputStr];
        if (!callresult)
        {
            //NSLog(@"######Call sugession Error");
        }
        
        self.suggestionListVC.searchText = inputStr;
        [self.suggestionListVC updateData];
        [self setSearchListHidden:NO];
    }
    else
    {
        [self setSearchListHidden:YES];
    }
    
}

- (void)didAddrSearchBegin:(id)sender
{
    [self.suggestionListVC clearData];
    
//    if (runningDataset.searchHistoryArray.count > 0)
//    {
//        for (NSString *searchHisTxt in runningDataset.searchHistoryArray)
//        {
//            //NSLog(@"**********Input TXT=%@************", searchHisTxt);
//            [mSuggestionListVC.resultList addObject:searchHisTxt];
//        }
//        [suggestionListVC updateData];
//        [self setSearchListHidden:NO];
//    }
    
}


- (void)didResultlistSelected:(NSString *)poiName
{
	if (poiName)
    {
        [self didAddrSearchWasPressed:poiName];
        //[runningDataset saveSearchHistory:poiName];
	}
    [self setSearchListHidden:YES];
    [self.topSearchBar dismissKeyboard];

    //[self hideTopSearchBar];
    //[self didHideAddrSearchBar:nil];
}

- (void)didHideAddrSearchBar:(id)sender
{
    [self hideTopSearchBar];
}

- (void)didHideSuggestionList:(id)sender
{
    [self setSearchListHidden:YES];
}

#pragma mark -
#pragma mark Process Request to MAP Service

- (BOOL) getPoinameSuggestionfromMAPSVR:(NSString*)searchStr
{
    BOOL callresult = [self.mapSearcher suggestionSearch:searchStr];
    return callresult;
}

//获取POI描述信息对应的地理坐标
- (BOOL) getPoiLocationInCityfromMAPSVR:(NSString*)cityName poiName:(NSString*)poiName
{
    return [self.mapSearcher poiSearchInCity:cityName withKey:poiName pageIndex:0];
}

//获取地理坐标对应的POI描述信息
- (BOOL) getGeoInfofromMAPSVR:(CLLocationCoordinate2D)coordinate
{
    bool result = [self.mapSearcher reverseGeocode:coordinate];
    if (!result)
    {
        //NSLog(@"***设置导航点，获取当前地址错误***");
    }
    
    //[self showModeIndicator:@"正在获取位置信息" seconds:0];
    
    return result;
}

#pragma mark -
#pragma mark Baidu Delegate Event Process
- (void)onGetSuggestionResult:(BMKSuggestionResult*)result errorCode:(int)error
{
    if (error != BMKErrorOk)
    {
        //NSLog(@"######get sugession Error, errorcode:%d", error);
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"无法获得输入建议"
        //                                                          delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        //        [alertView show];
        return;
    }
    
    //poiSuggestionList = result.keyList;
    [self.suggestionListVC.resultList removeAllObjects];
    
    for (int i = 0; i < result.keyList.count; i++)
    {
        NSString *strPoiName = [result.keyList objectAtIndex:i];
        //NSLog(@"POISuggestion: %@", strPoiName);
        
        [self.suggestionListVC.resultList addObject:strPoiName];
        //[mSuggestionListVC updateData];
    }
    [self.suggestionListVC updateData];
}


//得到Poi的地理位置坐标信息
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    
	if (error == BMKErrorOk)
    {
		BMKPoiResult* result = (BMKPoiResult*) [poiResultList objectAtIndex:0];
        
        if (result.poiInfoList.count > 0)
        {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:0];
            
            BMKPoiInfo *firstPoi = [result.poiInfoList objectAtIndex:0];
            NSString *pointAddr = firstPoi.address;
            NSString *pointName = firstPoi.name;
            NSString *addrTxt = [[NSString alloc] initWithFormat:@"%@,%@", pointAddr, pointName ];
            
            [self.mainMapView removeAllUndefAnnotation];
            [self.mainMapView addAnnotation2Map:poi.pt withType:MAPPOINTTYPE_UNDEF addr:addrTxt];
            
            [self.mainMapView setCenterOfMapView:poi.pt];
        }
	}
    else
    {
        //NSLog(@"POI Search Fail, Error Code=%d", error);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"无法获取检索结果"
                                                          delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
    }
}


//获取地理位置的路名地址等POI信息
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{    
	if (error != BMKErrorOk)
    {
    	//NSLog(@"onGetDrivingRouteResult:error:%d", error);
        return;
    }
    
    [self closeModeIndicator];
    
    [self.mainMapView setUndefPOIAnnotationAddress:result];
}


#pragma mark -
#pragma mark Process View Delegate for Map

- (BMKAnnotationView *)mapView:(BMKMapView *)bmkmapview viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKUserLocation class]])
    {
        return nil;
    }
    
    if ([annotation isKindOfClass:[LYMapPointAnnotation class]])
    {
        LYMapPointAnnotation *pointAnnotation = (LYMapPointAnnotation*) annotation;
        __autoreleasing BMKPinAnnotationView* pinView;
        
        pinView.animatesDrop = NO;  
        pinView.opaque = YES;
        
        switch (pointAnnotation.pointType) {
            case MAPPOINTTYPE_FRIEND:
            {
                pinView = (BMKPinAnnotationView *) [self.mainMapView dequeueReusableAnnotationViewWithIdentifier:@"FRIENDPOINTANNOIDENTI"];
                if (!pinView)
                {
                    BMKPinAnnotationView* customPinView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"FRIENDPOINTANNOIDENTI"];
                    pinView = customPinView;
                    
                    pinView.pinColor = BMKPinAnnotationColorGreen;
                    //UIImage *anoImage = [UIImage imageNamed:@"StartPointV1.png"];
                    //UIImage *anoImage = [UIImage imageNamed:@"mapapi.bundle/images/icon_nav_start.png"];
                    //pinView.image = anoImage;
                    CGPoint offsetPoin = {0.0,-10.0};
                    pinView.centerOffset = offsetPoin;
                    
                }
                else
                {
                    pinView.annotation = annotation;
                }
                
                
            }
                break;
                
            case MAPPOINTTYPE_MEETING:
            {
                pinView = (BMKPinAnnotationView *) [self.mainMapView dequeueReusableAnnotationViewWithIdentifier:@"MEETINGPOINTANNOIDENTI"];
                if (!pinView)
                {
                    BMKPinAnnotationView* customPinView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MEETINGPOINTANNOIDENTI"];
                    pinView = customPinView;
                    
                    pinView.pinColor = BMKPinAnnotationColorPurple;
                    //UIImage *anoImage = [UIImage imageNamed:@"EndPointV1.png"];
                    //UIImage *anoImage = [UIImage imageNamed:@"mapapi.bundle/images/icon_nav_end.png"];
                    //pinView.image = anoImage;
                    CGPoint offsetPoin = {0.0,-10.0};
                    pinView.centerOffset = offsetPoin;
                    
                }
                else
                {
                    pinView.annotation = annotation;
                }
                //self.mainMapView.mettingPointAnn = pointAnnotation;
            }
                break;
                
                
            case MAPPOINTTYPE_UNDEF:
            {
                
                pinView = (BMKPinAnnotationView *) [self.mainMapView dequeueReusableAnnotationViewWithIdentifier:@"UNDEFANNOIDENTI"];
                if (!pinView)
                {
                    BMKPinAnnotationView* customPinView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UNDEFANNOIDENTI"];
                    pinView = customPinView;
                    
                    pinView.pinColor = BMKPinAnnotationColorRed;
                    pinView.canShowCallout = YES;  //运行点击弹出标签
                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    [rightButton addTarget:self
                                    action:@selector(sendMeetingPoint)  //点击右边的按钮之后，显示设置导航点的页面
                          forControlEvents:UIControlEventTouchUpInside];
                    pinView.rightCalloutAccessoryView = rightButton;
                    
                }
                else
                {
                    pinView.annotation = annotation;
                }
                
                [pinView setSelected:YES];
                self.mainMapView.currentlySelectedAnnotation = pointAnnotation;
                //self.mainMapView.mettingPointAnn = pointAnnotation;
            }
                break;
                
                
            default:
            {
                pinView.pinColor = BMKPinAnnotationColorRed;
                //                pinView.canShowCallout = YES;  //运行点击弹出标签
                //                if ((pointAnnotation.pointType != MAPPOINTTYPE_START) && (pointAnnotation.pointType != MAPPOINTTYPE_END))
                //                {
                //                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                //                    [rightButton addTarget:self
                //                                    action:@selector(showSettingRoutPointView:)  //点击右边的按钮之后，显示设置导航点的页面
                //                          forControlEvents:UIControlEventTouchUpInside];
                //                    pinView.rightCalloutAccessoryView = rightButton;
                //                    [pinView setSelected:YES];
                //                    mMapView.currentlySelectedAnnotation = pointAnnotation;
                //                }
            }
                break;
        }
        
        //pCurrentlyAnnotation = annotation;
        return pinView;
    }
    
    return nil;  
}



#pragma mark -
#pragma mark Communication Functions

- (BOOL) isNetworkActive
{
    BOOL isNetworkReachable = NO;
    Reachability *r = [Reachability reachabilityForInternetConnection];
    
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            NSLog(@"############# Network is not available #######");
            break;
        case ReachableViaWWAN:
            // 使用3G网络
        {
            NSLog(@"############# 3G is availabe #######");
            isNetworkReachable = YES;
        }
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
        {
            NSLog(@"############# WiFi is available #######");
            isNetworkReachable = YES;
        }
            break;
    }
    return isNetworkReachable;
}

- (BOOL) isNetworkReachable
{
    BOOL isNetworkReachable = NO;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.roadclouding.com"];
    
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            NSLog(@"############# Host is not reachable #######");
            break;
        case ReachableViaWWAN:
            // 使用3G网络
        {
            NSLog(@"############# Host is reachable via 3G #######");
            isNetworkReachable = YES;
        }
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
        {
            NSLog(@"############# Host is reachable via WiFi #######");
            isNetworkReachable = YES;
        }
            break;
    }
    return isNetworkReachable;
}

- (BOOL) detectNetworkReachableAndShowTips
{
    
    BOOL isReachable = [self isNetworkReachable];
    if (!isReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"当前网络无法连接到互联网\n请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
    }
    return isReachable;
}


-(void)checkNetworkStatus:(NSNotification*)notice
{
    // called after network status changes
    NetworkStatus internetStatus =[self.internetReachable currentReachabilityStatus];
    switch(internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive =NO;
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive =YES;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive =YES;
            break;
        }
    }
    
    NetworkStatus hostStatus = [self.hostReachable currentReachabilityStatus];
    switch(hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive =NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive =YES;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive =YES;
            break;
        }
    }
    
    //uncommented by chenfeng 2013-02-04
    if (self.hostActive && self.internetActive)
    {
        //send something to server to keep ZMQ alive;
        NSLog(@"network recover or handover");
        [self.comm4AppSvr sendCmdConnect];
        [self sendChechinInfo2TSS];
    }
}

- (void) OnReceivePacket:(NSData*) rcvdata
{
    NSLog(@"*********RECEIVED DATA******************");
    if (rcvdata == nil)
    {
        NSLog(@"invalid data");
        return;
    }
    
    TrackEvent *recvPackage = [TrackEvent parseFromData:rcvdata];
    if (recvPackage == nil)
    {
        NSLog(@"Error when parse receive app server package data");
        return;
    }
    

    NSLog(@"receive Type=%d", recvPackage.type);
    
    switch (recvPackage.type)
    {
        case TrackEvent_EventTypeStartTrackingRep:
        {
            [self diGotTrackID:recvPackage];
        }
            break;
            
        case TrackEvent_EventTypeFwdLocReq:
        {
            [self diGotTrackeeLocation:recvPackage];
        }
            break;
            
        default:
            break;
    }
    
    
}


- (void) diGotTrackID:(TrackEvent *) resTrackEvent
{
    if ([resTrackEvent hasId])
    {
        [self closeModeIndicator];
        
        NSLog(@"receive ID=%u", resTrackEvent.id);
        self.runningDataset.TrackeeID = resTrackEvent.id;
        self.runningDataset.TrackingWebSession
            = [[NSString alloc] initWithFormat:@"http://dd.roadclouding.com/t/%u", resTrackEvent.id];
        
        NSString *strMsg = [[NSString alloc] initWithFormat:@"发自易寻位，点击 %@ 知道你在哪",self.runningDataset.TrackingWebSession];
        [self sendSMS:strMsg recipientList:nil];

    }
    
//    if (self.runningDataset.TrackingWebSession)
//    {
//        NSString *strMsg = [[NSString alloc] initWithFormat:@"发自易寻位，点击 %@ 知道你在哪",self.runningDataset.TrackingWebSession];
//        [self sendSMS:strMsg recipientList:nil];
//    }

}

- (void) diGotTrackeeLocation:(TrackEvent *) resTrackEvent
{
    if ([resTrackEvent hasId])
    {
        NSLog(@"receive ID=%d", resTrackEvent.id);
//        NSLog(@"self.runningDataset.TrackeeID=%d", self.runningDataset.TrackeeID);
//        NSLog(@"resTrackEvent.id=%d", resTrackEvent.id);
//        if (self.runningDataset.TrackeeID == resTrackEvent.id)
//        {
            CLLocationCoordinate2D trackeeLoc;

            if ([resTrackEvent hasTrackeeX])
            {
                NSLog(@"receive trakee X=%@", resTrackEvent.trackeeX);
                trackeeLoc.longitude = [resTrackEvent.trackeeX doubleValue];
            }
            
            if ([resTrackEvent hasTrackeeY])
            {
                NSLog(@"receive trakee Y=%@", resTrackEvent.trackeeY);
                trackeeLoc.latitude = [resTrackEvent.trackeeY doubleValue];
            }
            
            if (!self.runningDataset.FriendLocation)
            {
                self.runningDataset.FriendLocation = [[LYLocationInfo alloc] init];
            }
            
            self.runningDataset.FriendLocation.coordinate = trackeeLoc;
            if ([resTrackEvent hasTrackeeDesc])
            {
                self.runningDataset.FriendLocation.PoiInfo = resTrackEvent.trackeeDesc;
            }
            
            [self.mainMapView addAnnotation2Map:trackeeLoc withType:MAPPOINTTYPE_FRIEND addr:resTrackEvent.trackeeDesc];
            [self.mainMapView setCenterOfMapView:trackeeLoc];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message: @ "获取对方地址成功" delegate:nil cancelButtonTitle: @ "确定" otherButtonTitles: nil, nil];
            [alertView show];
//        }
    }
}

- (bool) sendStartTracking2Server
{
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = dev.uniqueIdentifier;
    
    TrackEvent_Builder *trackmsgBuilder = [[TrackEvent_Builder alloc] init];
    
    [trackmsgBuilder setType:TrackEvent_EventTypeStartTrackingReq];
    [trackmsgBuilder setSndId:deviceUuid];

    [trackmsgBuilder setTracker:deviceUuid];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *strTrakee = [[NSString alloc] initWithFormat:@"Trackee%d-%d", (int)timeStamp,  arc4random()];
    NSLog(@"trackee ID=%@", strTrakee);
    [trackmsgBuilder setTrackee:strTrakee];
    
    
    TrackEvent * startTrackMsg = [trackmsgBuilder build];
    
    if (!startTrackMsg)
    {
        NSLog(@"build starting track message false");
        return false;
    }
    
    NSData *const request = [startTrackMsg data];
    
    NSLog(@"------------Sending Request------------");
    
    [self.comm4AppSvr sendData:request withFlags:0];
    return true;
}


- (bool) sendChechinInfo2TSS
{
    NSLog(@"sendChechinInfo2TSS");
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = dev.uniqueIdentifier;
    //NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    //NSString *deviceOSType = dev.systemName;
        
    LYCheckin_Builder *chechinBuilder = [[LYCheckin_Builder alloc] init];
    [chechinBuilder setDeviceModel:deviceModel];
    [chechinBuilder setOsType:LYOsTypeLyIos];
    [chechinBuilder setOsVersion:deviceSystemVersion];
    [chechinBuilder setLyMajorRelease:1];
    [chechinBuilder setLyMinorRelease:0];
    
    
    LYCheckin * chechinRptMsg = [chechinBuilder build];
    
    TrackEvent_Builder *trackmsgBuilder = [[TrackEvent_Builder alloc] init];
    
    [trackmsgBuilder setType:TrackEvent_EventTypeLyCheckIn];
    [trackmsgBuilder setSndId:deviceUuid];
    
    [trackmsgBuilder setCheckin:chechinRptMsg];
    
    TrackEvent * checkinTrackMsg = [trackmsgBuilder build];
    
    if (!checkinTrackMsg)
    {
        NSLog(@"build checkin message  false");
        return false;
    }
    
    
    NSData *const request = [checkinTrackMsg data];
    
    NSLog(@"------------Sending Request------------");
    
    //commented out by chenfeng 2013-02-04
//    //重试一次连接
//    if (!self.comm4AppSvr)
//    {
//        if (![self tryConnection])
//        {
//            return false;
//        }
//    }
    
    [self.comm4AppSvr sendData:request withFlags:0];
    return true;
}

@end
