//
//  AppDelegate.m
//  Putt2Gether
//
//  Created by Devashis on 15/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "AppDelegate.h"

#import "PT_LoginViewController.h"

#import "PT_HomeViewController.h"

#import "PT_InviteViewController.h"

#import "PT_CreateViewController.h"

#import "PT_NotificationsViewController.h"

#import "PT_MoreViewController.h"

#import "UITabBarController+Designing.h"

#import "MGUserDefaults.h"
#import "PT_StartEventViewController.h"
#import "PT_StatsViewController.h"

#import "PT_CacheHoleData.h"

#import "PT_PlayerItemModel.h"

//FB SDK
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <UserNotifications/UserNotifications.h>

#import "PT_AppIntroViewController.h"


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@import Firebase;
@import FirebaseMessaging;
@import FirebaseInstanceID;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0


@interface AppDelegate ()<UIApplicationDelegate,UITabBarControllerDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate>


#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif
@end
#endif


@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

static NSString *TabHomeImage = @"stats";
static NSString *TabNotificationImage = @"notification";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Mark:-for Fcm integration
    [FIRApp configure];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    //Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [self initializeLocationServices];
#if (TARGET_OS_SIMULATOR)
    
    self.deviceToken = DemoDeviceToken;
    [[MGUserDefaults sharedDefault] setAccessToken:DemoDeviceToken];
    //self.latestLocation = [[CLLocation alloc] initWithLatitude:12.9716 longitude:77.5946];
    self.latestLocation = [[CLLocation alloc] initWithLatitude:19.049213 longitude:72.898833];
    
#endif
    
    PT_CacheHoleData *caheController = [PT_CacheHoleData new];
    [caheController removeAllCachedHoleData];
    
    //Reachability
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    NSLog(@"Internet status:%ld",(long)self.internetReachability.currentReachabilityStatus);
    
    //APNS
//    if([[[UIDevice currentDevice]systemVersion]floatValue]<10.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
//         {
//             if( !error )
//             {
//                 [[UIApplication sharedApplication] registerForRemoteNotifications];
//                 NSLog( @"Push registration success." );
//             }
//             else
//             {
//                 NSLog( @"Push registration FAILED" );
//                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
//                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
//             }
//         }];
//        
//
//        // For iOS 10 display notification (sent via APNS)
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        //            // For iOS 10 data message (sent via FCM)
//        [FIRMessaging messaging].remoteMessageDelegate = self;
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"Reload"];

    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        
        // For iOS 10 data message (sent via FCM)
        [FIRMessaging messaging].remoteMessageDelegate = self;
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.autoresizesSubviews = YES;
    
    //[self skipLoginForTest];
    
    if ([[MGUserDefaults sharedDefault] getSignUpOrLoginDone])
    {
        [self addTabBarAsRootViewController];
        
        
    }
    else
    {
    
    PT_AppIntroViewController *rVC = [[PT_AppIntroViewController alloc] initWithNibName:@"PT_AppIntroViewController" bundle:nil];
        self.window.rootViewController = rVC;
//        PT_LoginViewController *rVC = [[PT_LoginViewController alloc] initWithNibName:@"PT_LoginViewController" bundle:nil];
//        self.window.rootViewController = rVC;
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma FireBase Del

-(void)subscribeTotopic
{
    //[[FIRMessaging messaging] subscribeToTopic:@"topics"];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}
//Mark:-imtegrateing FireBase For push
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    NSString *customDataString = userInfo[@"custom"];
    
    NSDictionary *jsonData = nil;
    if (customDataString) {
        jsonData = [NSJSONSerialization JSONObjectWithData:[customDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableContainers error:nil]
        ;
        
        //[self addTabBarAsRootViewController];
        [self.tabBarController setSelectedIndex:3];
        // do something with job id
    }

    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// With "FirebaseAppDelegateProxyEnabled": NO
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:
//(void (^)(UIBackgroundFetchResult))completionHandler {
//    // Let FCM know about the message for analytics etc.
//    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
//    // handle your message.
//}

// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}



// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    //[self addTabBarAsRootViewController];
    [self.tabBarController setSelectedIndex:3];
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}
#endif
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", remoteMessage.appData);
    
    
   
}

#endif
// [END ios_10_data_message_handling]

//FB SDK Open URL scheme
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    //NSLog(@"Tab index = %u (%u)", (int)indexOfTab);
    if (indexOfTab == 2)
    {
        PT_CreateViewController *createVC = (PT_CreateViewController*)[self.tabBarController.viewControllers objectAtIndex:indexOfTab];
        createVC.isEditMode = NO;
        [createVC setBasicElements];
    }
    if (indexOfTab == 0)
    {
        self.isStatsSelected = YES;
        [self.tabBarController setSelectedIndex:0];
        PT_HomeViewController *homeVC = [self.tabBarController.viewControllers firstObject];
        [homeVC viewWillAppear:YES];
    }
    
    if ((indexOfTab == 0) || (indexOfTab == 1) || (indexOfTab == 2) || (indexOfTab == 4)) {
        
        
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"};
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,@"getuserdetail"] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
            
            if (!error)
            {
                if (responseData != nil)
                {
                    if ([responseData isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dicOutPut = responseData[@"output"];
                        
                        NSDictionary *dicInfo = dicOutPut[@"data"];
                        PT_PlayerItemModel *model = [PT_PlayerItemModel new];
                        model.playerId = [dicInfo[@"notifications_count"] integerValue];
                        
                      //  UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:3];
                        
                       
                        
                        if (model.playerId == 1) {
                            
                            
                           // [tabBarItem setImage:[UIImage imageNamed:@"notification"]];
                           // [tabBarItem setSelectedImage:[UIImage imageNamed:@"notification"]];
                            
                            
                        }else{
                            
                            
                           // [tabBarItem setImage:[UIImage imageNamed:@""]];
                        }
                       
                    }
                }
            }
        }];
    }

}


- (void)setFirstTAbIndexForChart
{
    
}

- (void)skipLoginForTest
{
    [[MGUserDefaults sharedDefault] setDisplayName:@"VISHAL TRI"];
    
    [[MGUserDefaults sharedDefault] setAccessToken:DemoDeviceToken];
    
    [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
    NSString *uId = @"3";
    [[MGUserDefaults sharedDefault] setUserId:[uId integerValue]];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    //FCM
    [self connectToFcm];
    
    //FB SDK
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    PT_CacheHoleData *caheController = [PT_CacheHoleData new];
    [caheController removeAllCachedHoleData];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBanner"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bannerPath"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBanner2"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bannerPath2"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BannerImgdata"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventIdOfBanner2"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventIdOfBanner"];

    
    
    
}

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    
    self.deviceToken = refreshedToken;
    [[MGUserDefaults sharedDefault] setDeviceToken:_deviceToken];
    
    
    //[[MGUserDefaults sharedDefault] setDeviceToken:_deviceToken forkey:DEVICE_TOKEN];
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    
    
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        
        //self.deviceToken = [[FIRInstanceID instanceID] token];
        // NSLog(@"%@",_deviceToken);
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            //[self subscribeTotopic];
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

- (void)addTabBarAsRootViewController
{
    //if (self.tabBarController == nil)
    {
         _tabBarController = [UITabBarController new];
    }
    
   
    PT_InviteViewController *invite = [PT_InviteViewController new];

    PT_HomeViewController *home = [PT_HomeViewController new];
    
    PT_CreateViewController *create = [PT_CreateViewController new];
    
    PT_NotificationsViewController *notifications = [PT_NotificationsViewController new];
    
    PT_MoreViewController *more = [PT_MoreViewController new];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:home,invite,create,notifications,more, nil];
    
    [self.tabBarController setViewControllers:viewControllers];
    
    
    [self.tabBarController setSelectedIndex:0];
    
     _tabBarController.tabBar.hidden = NO;
   
    [self changeRootViewController:self.tabBarController];
    

    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"Reload"];

    
    //[[NSNotificationCenter defaultCenter] postNotificationName:MGINVITATIONNOTIFICATION object:nil];
    
}



- (void)changeRootViewControllerToLogin
{
    PT_LoginViewController *loginVC = [[PT_LoginViewController alloc] initWithNibName:@"PT_LoginViewController" bundle:nil];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
    [self.window makeKeyAndVisible];
}
- (void)changeRootViewController:(id)rootViewController
{
    [self.window setRootViewController:rootViewController];
    [_tabBarController setDefaultTabDesign];
    self.tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
   // [application registerForRemoteNotifications];
}

//For interactive notification only
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
//{
//    //handle the actions
////    if ([identifier isEqualToString:@"declineAction"]){
////    }
////    else if ([identifier isEqualToString:@"answerAction"]){
////    }
//}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken
                                        type:FIRInstanceIDAPNSTokenTypeSandbox];
//    NSString  *token_string = [[[[deviceToken description]    stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                                stringByReplacingOccurrencesOfString:@">" withString:@""]
//                               stringByReplacingOccurrencesOfString: @" " withString: @""];
   // self.deviceToken = token_string;
    
    NSLog(@"Device Token:-%@",deviceToken);
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    // NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@",err);
}

#pragma mark - Location

- (void)initializeLocationServices
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    //_locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer; // 1 km
    [self.locationManager setDistanceFilter:1000];
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if (authStatus == kCLAuthorizationStatusNotDetermined){
        //[_locationManager requestWhenInUseAuthorization];
        //return
    }
    
    if (authStatus == kCLAuthorizationStatusDenied || authStatus == kCLAuthorizationStatusRestricted) {
        // show an alert
        //return
    }
    
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    }
    else
    {
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [_locationManager startUpdatingLocation];
        }
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error"
                               message:@"Failed to Get Your Location"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
     */
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //CLLocation *loc = [locations lastObject];
    
    //CLLocationDistance distance = [loc distanceFromLocation:_latestLocation];
    
    //NSLog(@"Locations: %f",distance/1000);
    _latestLocation = [locations lastObject];
    
    
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
}


/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    //self.internetReachability.currentReachabilityStatus = curReach.currentReachabilityStatus;
}


@end
