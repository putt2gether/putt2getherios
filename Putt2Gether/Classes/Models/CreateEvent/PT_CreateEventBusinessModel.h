//
//  PT_CreateEventBusinessModel.h
//  Putt2Gether
//
//  Created by Devashis on 29/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_CreateEventBusinessModel : NSObject

- (NSString *)getNumberOfPlayers;

- (NSString *)getEventDate;

- (NSString *)getEventTime;

- (NSString *)getSelectHole;

- (NSString *)getIsEventTeam;

- (NSString *)getTeamNumber;

- (NSString *)getEventIsSpot;

- (NSDictionary *)getCLosestToPin;

- (NSDictionary *)getLongDrive;

- (NSDictionary *)getStraightDrive;

- (NSMutableArray *)getTeam;

- (NSArray *)getEventTee;

- (NSArray *)getSuggestionFriendList;

- (NSString *)getPublicOrPrivate;

- (NSString *)getIIndividualOrTeam;

- (NSArray *)getGroups;

-(NSArray *)getAddedThroughEmailList;


@end
