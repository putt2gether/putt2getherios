//
//  PT_ViewRequestsModel.h
//  Putt2Gether
//
//  Created by Devashis on 05/11/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_ViewRequestsModel : NSObject

@property (assign, nonatomic) NSInteger eventId;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *eventStartTime;
@property (strong, nonatomic) NSString *isAccepted;
@property (strong, nonatomic) NSString *isStarted;
@property (assign, nonatomic) NSInteger handicap;
@property (assign, nonatomic) NSInteger playerId;
@property (strong, nonatomic) NSString *playerName;
@property (strong, nonatomic) NSString *isEventStarted;
@property (strong, nonatomic) NSString *photo_url;

@end
