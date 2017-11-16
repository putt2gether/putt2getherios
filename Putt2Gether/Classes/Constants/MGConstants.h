//
//  MGConstants.h
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


extern int const iPhone4Height;

extern int const iPhone5Height;

extern int const iPhone6Height;

extern int const iPhone6sHeight;

extern int const TeeDefaultIconSize;

extern NSString *const MGCONTACTS;

extern NSString *const MGGROJI;

extern NSString *const MGCHAT;

extern NSString *const MGNOTIFICATIONS;

extern NSString *const MGPROFILE;

extern NSString *const INDIVIDUAL;

extern NSString *const TEAM;

extern NSString *const PLAYERPRESENTINTEAMA;

extern NSString *const PLAYERPRESENTINTEAMB;

extern NSString *const PUBLIC;
extern NSString *const PRIVATE;

extern NSString *const FRONT9;
extern NSString *const BACK9;

extern NSString *const ACCEPTED;
extern NSString *const ACCEPT;

extern NSString *const LEFT;
extern NSString *const RIGHT;
extern NSString *const HIT;

//Preview event
extern NSString *const HOLE1;
extern NSString *const HOLE2;
extern NSString *const HOLE3;
extern NSString *const HOLE4;

extern NSString *const LeftRedArrowImage;
extern NSString *const RightBlueArrowImage;

typedef NS_ENUM(NSInteger,TabBarTpye)
{
    TabBarTpye_Home,
    TabBarTpye_Invite,
    TabBarTpye_Create,
    TabBarTpye_Notifications,
    TabBarTpye_More
};

typedef NS_ENUM(NSInteger, SpotPrizeType)
{
    SpotPrizeType_ClosestToPin1,
    SpotPrizeType_ClosestToPin2,
    SpotPrizeType_ClosestToPin3,
    SpotPrizeType_ClosestToPin4,
    SpotPrizeType_LongDrive1,
    SpotPrizeType_LongDrive2,
    SpotPrizeType_LongDrive3,
    SpotPrizeType_LongDrive4,
    SpotPrizeType_StraightDrive1,
    SpotPrizeType_StraightDrive2,
    SpotPrizeType_StraightDrive3,
    SpotPrizeType_StraightDrive4
};

typedef NS_ENUM(NSInteger,ButtonOptionType)
{
    ButtonOptionType_New,
    ButtonOptionType_Existing
};

typedef NS_ENUM(NSInteger, CreateEventCellType)
{
    CreateEventCellType_GolfCource,
    CreateEventCellType_EventName,
    CreateEventCellType_NumOfPlayers,
    CreateEventCellType_SelectFormat,
    CreateEventCellType_SelectTee,
    CreateEventCellType_EventTime,
    CreateEventCellType_NoOfHoles,
    CreateEventCellType_EventType,
    CreateEventCellType_SelectHoles,
    CreateEventCellType_SpotPrize,
    CreateEventCellType_ScoreScreen
};

typedef NS_ENUM(NSInteger, PreviewEventCellType)
{
    PreviewEventCellType_GolfCource,
    PreviewEventCellType_EventName,
    PreviewEventCellType_NumOfPlayers,
    PreviewEventCellType_TeamIndividual,
    PreviewEventCellType_SelectFormat,
    PreviewEventCellType_SelectTee,
    PreviewEventCellType_EventTime,
    PreviewEventCellType_NoOfHoles,
    PreviewEventCellType_EventType,
    PreviewEventCellType_SelectHoles,
    PreviewEventCellType_SpotPrize,
    PreviewEventCellType_Scorer
};

typedef NS_ENUM(NSInteger,TeeOptionType)
{
    TeeOptionType_Men,
    TeeOptionType_Women,
    TeeOptionType_Junior
};

typedef NS_ENUM(NSInteger, NumberOfPlayers)
{
    NumberOfPlayers_1 = 1,
    NumberOfPlayers_2,
    NumberOfPlayers_3,
    NumberOfPlayers_4,
    NumberOfPlayers_MoreThan4
};

typedef NS_ENUM(NSInteger, InviteType)
{
    InviteType_Edit,
    InviteType_Detail
};

typedef NS_ENUM(NSInteger, GroupType)
{
    GroupType_Members,
    GroupType_CreateGroup
};

