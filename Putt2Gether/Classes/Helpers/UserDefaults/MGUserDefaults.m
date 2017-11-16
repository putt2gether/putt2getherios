//
//  MGUserDefaults.m
//  MyGrid
//
//  Created by Devashis on 18/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGUserDefaults.h"

@interface MGUserDefaults ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;


@end


@implementation MGUserDefaults


+ (MGUserDefaults *)sharedDefault {
    static MGUserDefaults *_sharedDefault = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDefault = [[self alloc] init];
    });
    
    return _sharedDefault;
}

- (NSUserDefaults *)getDefaults
{
    if (_userDefaults == nil)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

#pragma mark - SIGN UP/LOGIN DONE
- (void)setSignUpOrLoginDone:(BOOL)done
{
    [[self getDefaults] setBool:done forKey:SIGNUP_LOGIN_DONE];
}

- (BOOL)getSignUpOrLoginDone
{
    return ([[self getDefaults] boolForKey:SIGNUP_LOGIN_DONE]);
    
}

#pragma mark - UserImage
- (void)setUserImage:(NSData *)imageData
{
    [[self getDefaults] setObject:imageData forKey:USER_IMAGE];
}

- (NSData *)getUserImage
{
    NSData *imageData = [[self getDefaults] objectForKey:USER_IMAGE];
    return imageData;
}

#pragma mark USERID
- (void)setUserId:(NSInteger)userId
{
    [[self getDefaults] setInteger:userId forKey:USER_ID];
}

- (NSInteger)getUserId
{
    NSInteger userId = [[self getDefaults] integerForKey:USER_ID];
    return userId;
}

#pragma mark EMAILID
- (void)setEmailId:(NSString *)email
{
    [[self getDefaults] setObject:email forKey:EMAIL_ID];
}

- (NSString *)getEmailId
{
    NSString *emailId = [[self getDefaults] objectForKey:EMAIL_ID];
    return emailId;
}

#pragma mark -Full Name
- (void)setFUllName:(NSString *)email
{
    [[self getDefaults] setObject:email forKey:FULL_NAME];
}

- (NSString *)getFullName
{
    NSString *fullName = [[self getDefaults] objectForKey:FULL_NAME];
    return fullName;
}

#pragma mark - Display Name
- (void)setDisplayName:(NSString *)displayName
{
    [[self getDefaults] setObject:displayName forKey:DISPLAY_NAME];
}

- (NSString *)getDisplayName
{
    NSString *displayName = [[self getDefaults] objectForKey:DISPLAY_NAME];
    return displayName;
}

#pragma mark - Password
- (void)setPassword:(NSString *)password
{
    [[self getDefaults] setObject:password forKey:PASSWORD];
}

- (NSString *)getPassword
{
    return [[self getDefaults] objectForKey:PASSWORD];
}

#pragma mark - ACCESS TOKEN
- (void)setAccessToken:(NSString *)token
{
    [[self getDefaults] setObject:token forKey:ACCESS_TOKEN];
}

- (NSString *)getAccessToken
{
    NSString *token = [[self getDefaults] objectForKey:ACCESS_TOKEN];
    return token;
}
#pragma mark - Handicap
- (void)setHandicap:(NSString *)handicap
{
    [[self getDefaults] setObject:handicap forKey:HANDICAP];
}

- (NSString *)getHandicap
{
    return ([[self getDefaults] objectForKey:HANDICAP]);
}
#pragma mark - Hole Data Cache

- (void)setData:(NSDictionary*)data forHoleNumber:(NSString *)holeNumber
{
    
    [[self getDefaults] setObject:data forKey:holeNumber];
}

- (NSDictionary *)getDataForHoleNumber:(NSString *)holeNumber
{
    return [[self getDefaults] objectForKey:holeNumber];
}

#pragma mark DeviceToken
- (void)setDeviceToken:(NSString *)token
{
    [[self getDefaults] setObject:token forKey:FCM_TOKEN];
}

- (NSString *)getDeviceToken
{
    NSString *deviceToken = [[self getDefaults] objectForKey:FCM_TOKEN];
    return deviceToken;
}

- (BOOL)isvaluePresentForKey:(NSString *)key
{
    //NSLog(@"%@",[[[self getDefaults] dictionaryRepresentation] allKeys]);
    if([[[[self getDefaults] dictionaryRepresentation] allKeys] containsObject:key]){
        
       return YES;
    }
    else
    {
        return NO;
    }
}

- (void)removeObjectForKey:(NSString *)key
{
    if([[[[self getDefaults] dictionaryRepresentation] allKeys] containsObject:key]){
        
        [[self getDefaults] removeObjectForKey:key];
    }
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

- (void)synchronize
{
    [[self getDefaults] synchronize];
}

#pragma mark - BannerImage
- (void)setBannerImage:(NSData *)imageData
{
    [[self getDefaults] setObject:imageData forKey:BANNER_IMAGE];
}

- (NSData *)getBannerImage
{
    NSData *imageData = [[self getDefaults] objectForKey:BANNER_IMAGE];
    return imageData;
}


@end
