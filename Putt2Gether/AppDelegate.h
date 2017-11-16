//
//  AppDelegate.h
//  Putt2Gether
//
//  Created by Devashis on 15/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "Reachability.h"

#import <UserNotifications/UserNotifications.h>



static NSString *const DemoDeviceToken = @"740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad";

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarController;

//Device Token APNS
@property (strong, nonatomic) NSString *deviceToken;

//Location Manager
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation* latestLocation;

@property (assign) BOOL isStatsSelected;

//Reachability
@property (nonatomic) Reachability *internetReachability;

- (void)addTabBarAsRootViewController;

- (void)changeRootViewControllerToLogin;



@end

