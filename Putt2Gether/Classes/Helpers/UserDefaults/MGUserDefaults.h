//
//  MGUserDefaults.h
//  MyGrid
//
//  Created by Devashis on 18/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

//Sign Up or Sign In
static NSString *const SIGNUP_LOGIN_DONE = @"signUpOrLogin";
static NSString *const USER_ID = @"user_id";
static NSString *const EMAIL_ID = @"email_id";
static NSString *const FULL_NAME = @"full_name";
static NSString *const DISPLAY_NAME = @"display_name";
static NSString *const ACCESS_TOKEN = @"access_token";
static NSString *const USER_IMAGE = @"UserImage";
static NSString *const PASSWORD = @"Password";
static NSString *const HANDICAP = @"Handicap";
static NSString *const BANNER_IMAGE = @"BannerImage";


//Mark:-for FCm
static NSString *const FCM_TOKEN = @"device_token";




@interface MGUserDefaults : NSObject

+ (MGUserDefaults *)sharedDefault;

- (void)setSignUpOrLoginDone:(BOOL)done;
- (BOOL)getSignUpOrLoginDone;
- (void)setUserId:(NSInteger)userId;
- (NSInteger)getUserId;
- (void)setEmailId:(NSString *)email;
- (NSString *)getEmailId;
- (void)setFUllName:(NSString *)email;
- (NSString *)getFullName;
- (void)setDisplayName:(NSString *)displayName;
- (NSString *)getDisplayName;
- (void)setAccessToken:(NSString *)token;

- (NSString *)getAccessToken;

//mark:-for FCM registration token
- (void)setDeviceToken:(NSString *)token;

- (NSString *)getDeviceToken;

#pragma mark - UserImage
- (void)setUserImage:(NSData *)imageData;

- (NSData *)getUserImage;

#pragma mark - BannerImage
- (void)setBannerImage:(NSData *)imageData;

- (NSData *)getBannerImage;


#pragma mark - Password
- (void)setPassword:(NSString *)password;

- (NSString *)getPassword;

#pragma mark - Handicap
- (void)setHandicap:(NSString *)handicap;
- (NSString *)getHandicap;

#pragma mark - Hole Data Cache

- (void)setData:(NSDictionary*)data forHoleNumber:(NSString *)holeNumber;

- (NSDictionary *)getDataForHoleNumber:(NSString *)holeNumber;

- (BOOL)isvaluePresentForKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)resetDefaults;

- (void)synchronize;

@end
