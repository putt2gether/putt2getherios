//
//  PT_CreatedEventModel.h
//  Putt2Gether
//
//  Created by Devashis on 02/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_CreatedEventModel : NSObject

@property (assign, nonatomic) NSInteger eventId;
@property (assign, nonatomic) NSInteger adminId;
@property (strong, nonatomic) NSArray *closestPin;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *eventstartDateTime;
@property (strong, nonatomic) NSString *formatName;
@property (strong, nonatomic) NSString *formatId;
@property (assign, nonatomic) NSInteger golfCourseId;
@property (strong, nonatomic) NSString *golfCourseName;
@property (strong, nonatomic) NSString *holes;
@property (assign, nonatomic) BOOL isAdmin;
@property (strong, nonatomic) NSString *isIndividual;
@property (assign, nonatomic) BOOL isSpot;
@property (strong, nonatomic) NSArray *longDrive;
@property (strong, nonatomic) NSString *numberOfPlayers;
@property (strong, nonatomic) NSArray *straightDrive;
@property (strong, nonatomic) NSDictionary *teeId;
@property (assign, nonatomic) NSInteger totalHoleNumber;
@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *isEventStarted;
@property (strong, nonatomic) NSString *is_accepted;
@property (assign, nonatomic) BOOL isSingleScreen;
@property (strong, nonatomic) NSString *back9;
@property (assign, nonatomic) NSInteger scorerId;

@property(assign,nonatomic) NSInteger isStarted;

@property(strong,nonatomic) NSString *playersInGame;


@property (assign, nonatomic) BOOL isBannerSaved;


@end
