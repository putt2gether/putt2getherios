//
//  PT_PreviewEventSingletonModel.m
//  Putt2Gether
//
//  Created by Devashis on 07/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//


@interface PT_PreviewEventSingletonModel ()
{
    NSString *_eventName;
    PT_SelectGolfCourseModel *_golfCourseModel;
    NSString *_numberOfPlayers;
    NSString *_individualOrTeam;
    PT_StrokePlayListItemModel *_format;
    NSString *_eventTime;
    NSString *_numberOfHoles;
    NSString *_eventType;
    BOOL _is18HolesSelected;
    NSString *_frontOrBack9;
    NSString *_publicOrPrivate;
    BOOL _isSpotPrize;
    UIColor *_menTeeColor;
    UIColor *_womenTeeColor;
    UIColor *_juniorTeeColor;
    //Spot Prize
    NSString *_spotPrizeClosestToPin;
    NSString *_spotPrizeLongDrive;
    NSString *_spotPrizeStraightDrive;
    PT_SpotPrizeModel *spotPrizeModel;
    
    NSArray *_arrPlayers4Plus;
    NSArray *_arrSuggestionFriends;
    NSArray *_arrAddedThroughEmail;

    NSArray *_arrTeamA;
    NSArray *_arrTeamB;
    PT_TeeItemModel *_menTeeModel;
    PT_TeeItemModel *_womenTeeModel;
    PT_TeeItemModel *_juniorTeeModel;
    NSString *_scorerEntryType;
    BOOL _isScorerEntryRequired;
    
    NSArray *arrGroups;
}


@end

#import "PT_PreviewEventSingletonModel.h"

@implementation PT_PreviewEventSingletonModel

+ (PT_PreviewEventSingletonModel *)sharedPreviewEvent {
    static PT_PreviewEventSingletonModel *_sharedPreviewEvent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPreviewEvent = [[PT_PreviewEventSingletonModel alloc] init];
    });
    
    return _sharedPreviewEvent;
}

#pragma mark - Event Name
- (void)setEventName:(NSString *)eventName
{
    _eventName = eventName;
}

- (NSString *)getEventName
{
    return _eventName;
}

#pragma mark - Golf Course

- (void)setGolfCourse:(PT_SelectGolfCourseModel *)golfCourse
{
    _golfCourseModel = golfCourse;
}

- (PT_SelectGolfCourseModel *)getGolfCourse
{
    return _golfCourseModel;
}

#pragma mark - Number Of Players

- (void)setNumberOfPlayers:(NSString *)noOfPlayers
{
    _numberOfPlayers = noOfPlayers;
}
- (NSString *)getNumberOfPlayers
{
    return _numberOfPlayers;
}

- (void)setNumberOfPlayersFor4Plus:(NSArray *)players
{
    _arrPlayers4Plus = nil;
    _arrPlayers4Plus = players;
}

- (NSArray *)getNumberOfPlayersFor4Plus
{
    return _arrPlayers4Plus;
}

- (void)setEventSuggestionFriends:(NSArray *)arrFriends
{
    _arrSuggestionFriends = arrFriends;
}

- (NSArray *)getEventSuggestionFriends
{
    return _arrSuggestionFriends;
}

- (void)setPlayerAddedThroughEmail:(NSArray *)arrFriends{
    
    _arrAddedThroughEmail = arrFriends;

}

-(NSArray *)getPlayerAddedThroughEmail
{
    return _arrAddedThroughEmail;
}


- (void)setTeamA:(NSArray *)players
{
    _arrTeamA = players;
}
- (NSArray *)getTeamA
{
    return _arrTeamA;
}
- (void)setTeamB:(NSArray *)players
{
    _arrTeamB = players;
}
- (NSArray *)getTeamB
{
    return _arrTeamB;
}

#pragma mark - Individual Or Team
- (void)setindividualOrTeam:(NSString *)individualOrTeam
{
    _individualOrTeam = individualOrTeam;
}
- (NSString *)getIndividualOrTeam
{
    return _individualOrTeam;
}

#pragma mark - Format
- (void)setFormat:(PT_StrokePlayListItemModel *)format
{
    _format = format;
}
- (PT_StrokePlayListItemModel *)getFormat
{
    return _format;
}

#pragma Event Time
- (void)setEventTime:(NSString *)time
{
    _eventTime = time;
}
- (NSString *)getEventTime
{
    return _eventTime;
}

#pragma mark - Number Of Holes
- (void)setNumberOfHoles:(NSString *)holes
{
    _numberOfHoles = holes;
}
- (NSString *)getNumberOfHoles
{
    return _numberOfHoles;
}

- (void)setIs18HolesSelected:(BOOL)is18Selected
{
    _is18HolesSelected = is18Selected;
}

- (BOOL)getis18HolesSelected
{
    return _is18HolesSelected;
}

- (void)setFrontOrBack9:(NSString *)type
{
    _frontOrBack9 = type;
}
- (NSString *)getFrontOrBack9
{
    return _frontOrBack9;
}

#pragma mark - Event Type
- (void)setEventType:(NSString *)type
{
    _eventType = type;
}
- (NSString *)getEventType
{
    return _eventType;
}



#pragma mark - Public or Private

- (void)setPublicOrPrivate:(NSString *)type
{
    _publicOrPrivate = type;
}

- (NSString *)getPublicOrPrivate
{
    return _publicOrPrivate;
}

#pragma mark - Spot Prize

- (void)setIsSpotPrize:(BOOL)selected
{
    _isSpotPrize = selected;
}

- (BOOL)getIsSpotPrize
{
    return _isSpotPrize;
}

- (void)setSpotPrizeClosestToPinData:(NSString *)value
{
    _spotPrizeClosestToPin = value;
    
}

- (NSString *)getSpotPrizeClosestToPinData
{
    return _spotPrizeClosestToPin;
}
//CLOSEST TO PIN 1
- (void)setSpotPrizeClosestToPinData1:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.closestToPin1 = value;
}
- (NSString *)getSpotPrizeClosestToPinData1
{
    return spotPrizeModel.closestToPin1;
}
//CLOSEST TO PIN 2
- (void)setSpotPrizeClosestToPinData2:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.closestToPin2 = value;
}
- (NSString *)getSpotPrizeClosestToPinData2
{
    return spotPrizeModel.closestToPin2;
}
//CLOSEST TO PIN 3
- (void)setSpotPrizeClosestToPinData3:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.closestToPin3 = value;
}
- (NSString *)getSpotPrizeClosestToPinData3
{
    return spotPrizeModel.closestToPin3;
}
//CLOSEST TO PIN 4
- (void)setSpotPrizeClosestToPinData4:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.closestToPin4 = value;
}
- (NSString *)getSpotPrizeClosestToPinData4
{
    return spotPrizeModel.closestToPin4;
}


- (void)setSpotPrizeLongDrive:(NSString *)value
{
    _spotPrizeLongDrive = value;
    
}
- (NSString *)getSpotPrizeLongDrive
{
    return _spotPrizeLongDrive;
}
//LONG DRIVE 1
- (void)setSpotPrizeLongDrive1:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.longDrive1 = value;
}
- (NSString *)getSpotPrizeLongDrive1
{
    return spotPrizeModel.longDrive1;
}
//LONG DRIVE 2
- (void)setSpotPrizeLongDrive2:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.longDrive2 = value;
}
- (NSString *)getSpotPrizeLongDrive2
{
    return spotPrizeModel.longDrive2;
}
//LONG DRIVE 3
- (void)setSpotPrizeLongDrive3:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.longDrive3 = value;
}
- (NSString *)getSpotPrizeLongDrive3
{
    return spotPrizeModel.longDrive3;
}
//LONG DRIVE 4
- (void)setSpotPrizeLongDrive4:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.longDrive4 = value;
}
- (NSString *)getSpotPrizeLongDrive4
{
    return spotPrizeModel.longDrive4;
}


- (void)setSpotPrizeStraightDrive:(NSString *)value
{
    _spotPrizeStraightDrive = value;
}
- (NSString *)getSpotPrizeStraightDrive
{
    return _spotPrizeStraightDrive;
}

//STRAIGHT DRIVE 1
- (void)setSpotPrizeStraightDrive1:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.straightDrive1 = value;
}
- (NSString *)getSpotPrizeStraightDrive1
{
    return spotPrizeModel.straightDrive1;
}
//STRAIGHT DRIVE 2
- (void)setSpotPrizeStraightDrive2:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.straightDrive2 = value;
}
- (NSString *)getSpotPrizeStraightDrive2
{
    return spotPrizeModel.straightDrive2;
}
//STRAIGHT DRIVE 3
- (void)setSpotPrizeStraightDrive3:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.straightDrive3 = value;
}
- (NSString *)getSpotPrizeStraightDrive3
{
    return spotPrizeModel.straightDrive3;
}
//STRAIGHT DRIVE 4
- (void)setSpotPrizeStraightDrive4:(NSString *)value
{
    if (spotPrizeModel == nil)
    {
        spotPrizeModel = [PT_SpotPrizeModel new];
    }
    spotPrizeModel.straightDrive4 = value;
}
- (NSString *)getSpotPrizeStraightDrive4
{
    return spotPrizeModel.straightDrive4;
}

#pragma mark - Tees

- (void)setTeeColorsForMen:(UIColor *)colorMen
{
    if (colorMen)
    {
        _menTeeColor = colorMen;
    }
}

- (UIColor *)getTeeColorForMen
{
    return _menTeeColor;
}


- (void)setTeeColorsForWomen:(UIColor *)colorWomen
{
    if (colorWomen)
    {
        _womenTeeColor = colorWomen;
    }
}

- (UIColor *)getTeeColorForWomen
{
    return _womenTeeColor;
}

- (void)setTeeColorsForJunior:(UIColor *)colorJunior
{
    if (colorJunior)
    {
        _juniorTeeColor = colorJunior;
    }
}

- (UIColor *)getTeeColorForJunior
{
    return _juniorTeeColor;
}

- (void)setMenTeeModel:(PT_TeeItemModel *)model
{
    _menTeeModel = model;
}

- (PT_TeeItemModel *)getMenTeeModel
{
    return _menTeeModel;
}

- (void)setWomenTeeModel:(PT_TeeItemModel *)model
{
    _womenTeeModel = model;
}
- (PT_TeeItemModel *)getWomenTeeModel
{
    return _womenTeeModel;
}

- (void)setJuniorTeeModel:(PT_TeeItemModel *)model
{
    _juniorTeeModel = model;
}
- (PT_TeeItemModel *)getJuniorTeeModel
{
    return _juniorTeeModel;
}

#pragma mark - Scorer entry type

- (void)setScorerEntryType:(NSString *)type
{
    _scorerEntryType = type;
}

- (NSString *)getScorerEntryType
{
    return _scorerEntryType;
}

- (void)setIsScorerTypeRequired:(BOOL)value
{
    _isScorerEntryRequired = value;
}

- (BOOL)getIsScorerTypeRequired
{
    return _isScorerEntryRequired;
}

#pragma mark - Group For 4+ players

- (void)setGroups:(NSArray *)arrGrps
{
    arrGroups = arrGrps;
}

- (NSArray *)getGroups
{
    return arrGroups;
}

#pragma mark - Default Values

- (void)setDefaultValues
{
    _eventName = nil;
    _golfCourseModel = nil;
    _numberOfPlayers = nil;
    _individualOrTeam = nil;
    _format = nil;
    _eventTime = nil;
    _numberOfHoles = nil;
    _eventType = nil;
    _is18HolesSelected = NO;
    _frontOrBack9 = nil;
    _publicOrPrivate = nil;
    _isSpotPrize = NO;
    _menTeeColor = nil;
    _womenTeeColor = nil;
    _juniorTeeColor = nil;
    _spotPrizeClosestToPin = nil;
    _spotPrizeLongDrive = nil;
    _spotPrizeStraightDrive = nil;
    _arrPlayers4Plus = nil;
    _arrSuggestionFriends = nil;
    _arrTeamA = nil;
    _arrTeamB = nil;
    arrGroups = nil;
}

- (void)setDefaultSpotPrize
{
    [self setSpotPrizeClosestToPinData1:nil];
    [self setSpotPrizeClosestToPinData2:nil];
    [self setSpotPrizeClosestToPinData3:nil];
    [self setSpotPrizeClosestToPinData4:nil];
    
    [self setSpotPrizeLongDrive1:nil];
    [self setSpotPrizeLongDrive2:nil];
    [self setSpotPrizeLongDrive3:nil];
    [self setSpotPrizeLongDrive4:nil];
    
    [self setSpotPrizeStraightDrive1:nil];
    [self setSpotPrizeStraightDrive2:nil];
    [self setSpotPrizeStraightDrive3:nil];
    [self setSpotPrizeStraightDrive4:nil];
}
@end
