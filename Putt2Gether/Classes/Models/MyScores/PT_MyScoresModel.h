//
//  PT_MyScoresModel.h
//  Putt2Gether
//
//  Created by Devashis on 13/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_MyScoresModel : NSObject

@property (assign, nonatomic) NSInteger eventId;
@property (assign, nonatomic) NSInteger formatId;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *golfCourseName;
@property (strong, nonatomic) NSString *formatName;
@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSString *numberOfPlayers;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *currentPosition;
@property (strong, nonatomic) NSString *currentRanking;
@property (assign, nonatomic) NSInteger eagle;
@property (assign, nonatomic) NSInteger grossScore;
@property (assign, nonatomic) NSInteger birdie;
@property (assign, nonatomic) NSInteger par;

@property(assign,nonatomic)NSInteger numberOfPlayerAccepted;


@end
