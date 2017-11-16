//
//  PT_InvitationItemModel.h
//  Putt2Gether
//
//  Created by Devashis on 01/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_InvitationItemModel : NSObject

@property (strong, nonatomic) NSString *addPlayerType;
@property (strong, nonatomic) NSString *admin;
@property (assign, nonatomic) NSInteger adminId;
@property (strong, nonatomic) NSString *createdDate;
@property (assign, nonatomic) NSInteger eventDisplaynumber;
@property (assign, nonatomic) NSInteger eventId;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *eventStartTime;
@property (assign, nonatomic) NSInteger formatId;
@property (strong, nonatomic) NSString *formatName;
@property (assign, nonatomic) NSInteger golfCourseid;
@property (strong, nonatomic) NSString *golfCourseName;
@property (strong, nonatomic) NSString *isAccepted;
@property (strong, nonatomic) NSString *isEdit;
@property (strong, nonatomic) NSString *isStarted;
@property (assign, nonatomic) NSInteger isSubmitScore;
@property (strong, nonatomic) NSString *location;
@property (assign, nonatomic) NSInteger playerId;
@property (assign, nonatomic) NSInteger readsatus;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *isEventStarted;

@property(strong,nonatomic) NSString *bannerImg;
@property(strong,nonatomic) NSString *bannerHref;

@end
