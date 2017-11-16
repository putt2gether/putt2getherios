//
//  PT_PreviewEventSingletonModel.h
//  Putt2Gether
//
//  Created by Devashis on 07/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PT_SelectGolfCourseModel.h"

#import "PT_StrokePlayListItemModel.h"

#import "PT_TeeItemModel.h"

static NSString  *const singleScorerStatic = @"1";
static NSString  *const multiScorerStatic = @"2";

@interface PT_PreviewEventSingletonModel : NSObject

+ (PT_PreviewEventSingletonModel *)sharedPreviewEvent;

//Event Name
- (NSString *)getEventName;
- (void)setEventName:(NSString *)eventName;

//Golf Course
- (void)setGolfCourse:(PT_SelectGolfCourseModel *)golfCourse;
- (PT_SelectGolfCourseModel *)getGolfCourse;

//Number Of players
- (void)setNumberOfPlayers:(NSString *)noOfPlayers;
- (NSString *)getNumberOfPlayers;
- (void)setNumberOfPlayersFor4Plus:(NSArray *)players;
- (NSArray *)getNumberOfPlayersFor4Plus;
- (void)setEventSuggestionFriends:(NSArray *)arrFriends;
- (NSArray *)getEventSuggestionFriends;
- (void)setTeamA:(NSArray *)players;
- (NSArray *)getTeamA;
- (void)setTeamB:(NSArray *)players;
- (NSArray *)getTeamB;

- (void)setPlayerAddedThroughEmail:(NSArray *)arrFriends;
- (NSArray *)getPlayerAddedThroughEmail;

//Individual Or Team
- (void)setindividualOrTeam:(NSString *)individualOrTeam;
- (NSString *)getIndividualOrTeam;

//Format
- (void)setFormat:(PT_StrokePlayListItemModel *)format;
- (PT_StrokePlayListItemModel *)getFormat;

//Event Time
- (void)setEventTime:(NSString *)time;
- (NSString *)getEventTime;

//No Of Holes
- (void)setNumberOfHoles:(NSString *)holes;
- (NSString *)getNumberOfHoles;

- (void)setIs18HolesSelected:(BOOL)is18Selected;
- (BOOL)getis18HolesSelected;

- (void)setFrontOrBack9:(NSString *)type;
- (NSString *)getFrontOrBack9;

//Event Type
- (void)setEventType:(NSString *)type;
- (NSString *)getEventType;

//Public Or Private
- (void)setPublicOrPrivate:(NSString *)type;
- (NSString *)getPublicOrPrivate;

#pragma mark - Spot Prize

- (void)setIsSpotPrize:(BOOL)selected;

- (BOOL)getIsSpotPrize;

- (void)setSpotPrizeClosestToPinData:(NSString *)value;
- (NSString *)getSpotPrizeClosestToPinData;

//SPOT PRIZE CLOSEST TO PIN
- (void)setSpotPrizeClosestToPinData1:(NSString *)value;
- (NSString *)getSpotPrizeClosestToPinData1;
- (void)setSpotPrizeClosestToPinData2:(NSString *)value;
- (NSString *)getSpotPrizeClosestToPinData2;
- (void)setSpotPrizeClosestToPinData3:(NSString *)value;
- (NSString *)getSpotPrizeClosestToPinData3;
- (void)setSpotPrizeClosestToPinData4:(NSString *)value;
- (NSString *)getSpotPrizeClosestToPinData4;

- (void)setSpotPrizeLongDrive:(NSString *)value;
- (NSString *)getSpotPrizeLongDrive;

//SPOT PRIZE LONG DRIVE
- (void)setSpotPrizeLongDrive1:(NSString *)value;
- (NSString *)getSpotPrizeLongDrive1;
- (void)setSpotPrizeLongDrive2:(NSString *)value;
- (NSString *)getSpotPrizeLongDrive2;
- (void)setSpotPrizeLongDrive3:(NSString *)value;
- (NSString *)getSpotPrizeLongDrive3;
- (void)setSpotPrizeLongDrive4:(NSString *)value;
- (NSString *)getSpotPrizeLongDrive4;

- (void)setSpotPrizeStraightDrive:(NSString *)value;
- (NSString *)getSpotPrizeStraightDrive;

//SPOT PRIZE STRAIGHT DRIVE
- (void)setSpotPrizeStraightDrive1:(NSString *)value;
- (NSString *)getSpotPrizeStraightDrive1;
- (void)setSpotPrizeStraightDrive2:(NSString *)value;
- (NSString *)getSpotPrizeStraightDrive2;
- (void)setSpotPrizeStraightDrive3:(NSString *)value;
- (NSString *)getSpotPrizeStraightDrive3;
- (void)setSpotPrizeStraightDrive4:(NSString *)value;
- (NSString *)getSpotPrizeStraightDrive4;

#pragma mark Tee 

- (void)setTeeColorsForMen:(UIColor *)colorMen;

- (UIColor *)getTeeColorForMen;

- (void)setTeeColorsForWomen:(UIColor *)colorWomen;

- (UIColor *)getTeeColorForWomen;

- (void)setTeeColorsForJunior:(UIColor *)colorJunior;

- (UIColor *)getTeeColorForJunior;

- (void)setMenTeeModel:(PT_TeeItemModel *)model;

- (PT_TeeItemModel *)getMenTeeModel;

- (void)setWomenTeeModel:(PT_TeeItemModel *)model;

- (PT_TeeItemModel *)getWomenTeeModel;

- (void)setJuniorTeeModel:(PT_TeeItemModel *)model;

- (PT_TeeItemModel *)getJuniorTeeModel;

- (void)setDefaultValues;

- (void)setDefaultSpotPrize;

#pragma mark - Group For 4+ players

- (void)setGroups:(NSArray *)arrGrps;

- (NSArray *)getGroups;

#pragma mark - Scorer entry type

- (void)setScorerEntryType:(NSString *)type;

- (NSString *)getScorerEntryType;

- (void)setIsScorerTypeRequired:(BOOL)value;

- (BOOL)getIsScorerTypeRequired;

@end
