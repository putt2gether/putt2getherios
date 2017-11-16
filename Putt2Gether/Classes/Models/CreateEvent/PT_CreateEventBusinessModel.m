//
//  PT_CreateEventBusinessModel.m
//  Putt2Gether
//
//  Created by Devashis on 29/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_CreateEventBusinessModel.h"

#import "PT_PlayerItemModel.h"

#import "PT_GroupItemModel.h"

@implementation PT_CreateEventBusinessModel

- (NSString *)getNumberOfPlayers
{
    NSString *numberOfPlayers = nil;
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
    {
        NSArray *arrPlayers = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayersFor4Plus];
        if (arrPlayers != nil) {
            numberOfPlayers = @"4+";//[NSString stringWithFormat:@"%li",[arrPlayers count]];
            
            
        }
        else
        {
            NSArray *arrGrps = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getGroups];
            if (arrGrps != nil) {
                
                numberOfPlayers = @"4+";
            }else{

                numberOfPlayers = @"0";
            }
        }
    }
    else
    {
        numberOfPlayers = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers];
    }
    return numberOfPlayers;
}

- (NSString *)getEventDate
{
    NSString *eventDateTime = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy - HH:mm"];
    NSDate *date = [formatter dateFromString:eventDateTime];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateSelected = [formatter stringFromDate:date];
    return dateSelected;
}

- (NSString *)getEventTime
{
    NSString *eventDateTime = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy - HH:mm"];
    NSDate *date = [formatter dateFromString:eventDateTime];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeSelected = [formatter stringFromDate:date];
    return timeSelected;
}

- (NSString *)getSelectHole
{
    NSString *selectHole = nil;
    if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getis18HolesSelected] == YES)
    {
        selectHole = @"1";
    }else if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getFrontOrBack9] isEqualToString:FRONT9])
    {
        selectHole = @"1";
    }
    else
    {
        selectHole = @"10";
    }
    
    return selectHole;
}

- (NSString *)getIsEventTeam
{
    NSString *isEventTeam = nil;
    
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM])
    {
        isEventTeam = @"0";
    }
    else
    {
        isEventTeam = @"1";
    }
    return isEventTeam;
}

- (NSString *)getIIndividualOrTeam
{
    NSString *isEventTeam = nil;
    
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM])
    {
        isEventTeam = @"1";
    }
    else
    {
        isEventTeam = @"0";
    }
    return isEventTeam;
}

- (NSString *)getTeamNumber
{
    NSString *isEventTeam = nil;
    
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM])
    {
        isEventTeam = @"4";
    }
    else
    {
        isEventTeam = @"0";
    }
    return isEventTeam;
}

- (NSString *)getEventIsSpot
{
    NSString *spot = nil;
    if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsSpotPrize] == YES)
    {
        spot = @"1";
    }
    else
    {
        spot = @"0";
    }
    
    return spot;
}

- (NSDictionary *)getCLosestToPin
{
    NSString *closestToPin = nil;
    
    if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsSpotPrize] == YES)
    {
        closestToPin = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData];
    }
    else
    {
        closestToPin = @"0";
    }
    
    NSDictionary *dicClosestToPinReturn;
    NSMutableDictionary *dicClosestToPin = [NSMutableDictionary new];
    NSInteger count = 0;
    BOOL isClosestPinAvailable = NO;
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData1] length] > 0)
    {
        count++;
        [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData1] forKey:HOLE1];
        isClosestPinAvailable = YES;
    }
  if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData2] length] > 0)
    {
        count++;
        if (count == 1)
        {
            //NSDictionary *dic =
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData2] forKey:HOLE1];
        }
        else{
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData2] forKey:HOLE2];
        }
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData3] length] > 0)
    {
        count++;
        if (count == 1)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData3] forKey:HOLE1];
        }
        else if (count == 2){
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData3] forKey:HOLE2];
        }
        else
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData3] forKey:HOLE3];
        }
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData4] length] > 0)
    {
        count++;
        if (count == 1)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData4] forKey:HOLE1];
        }
        else if (count == 2){
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData4] forKey:HOLE2];
        }
        else if (count == 3)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData4] forKey:HOLE3];
        }
        else
        {
           [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData4] forKey:HOLE4];
        }
        isClosestPinAvailable = YES;
        
    }
    /*if (isClosestPinAvailable == YES)
    {
        [dicClosestToPinReturn setObject:dicClosestToPin forKey:@"closest_pin"];
    }
    else{
        [dicClosestToPinReturn setObject:@"0" forKey:@"closest_pin"];
    }*/
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Hole_1",@"2",@"Hole_2", nil];
    if (count == 1)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1, nil];
    }
    else if (count == 2)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2, nil];
    }
    else if (count == 3)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2,dicClosestToPin[HOLE3],HOLE3, nil];
    }
    else if (count == 4)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2,dicClosestToPin[HOLE3],HOLE3,dicClosestToPin[HOLE4],HOLE4, nil];
    }
    if (isClosestPinAvailable == YES)
    {
        dicClosestToPinReturn = dic;//[NSDictionary dictionaryWithObjectsAndKeys:dic,@"closest_pin", nil];
    }
    else{
        dicClosestToPinReturn = [[NSDictionary alloc] init];
    }
    
    //return closestToPin;
    return dicClosestToPinReturn;
}

- (NSDictionary *)getStraightDrive
{
    NSString *straightDrive = nil;
    
    if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsSpotPrize] == YES)
    {
        straightDrive = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive];
    }
    else
    {
        straightDrive = @"0";
    }
    
    /////////////////////////////////////////////////////////////////////
    NSDictionary *dicClosestToPinReturn;
    NSMutableDictionary *dicClosestToPin = [NSMutableDictionary new];
    NSInteger count = 0;
    BOOL isClosestPinAvailable = NO;
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive1] length] > 0)
    {
        count++;
        [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive1] forKey:HOLE1];
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive2] length] > 0)
    {
        count++;
        if (count == 1)
        {
            //NSDictionary *dic =
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive2] forKey:HOLE1];
        }
        else{
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive2] forKey:HOLE2];
        }
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive3] length] > 0)
    {
        count++;
        if (count == 1)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive3] forKey:HOLE1];
        }
        else if (count == 2){
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive3] forKey:HOLE2];
        }
        else
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive3] forKey:HOLE3];
        }
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive4] length] > 0)
    {
        count++;
        if (count == 1)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive4] forKey:HOLE1];
        }
        else if (count == 2){
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive4] forKey:HOLE2];
        }
        else if (count == 3)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive4] forKey:HOLE3];
        }
        else
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeStraightDrive4] forKey:HOLE4];
        }
        isClosestPinAvailable = YES;
        
    }
    /*if (isClosestPinAvailable == YES)
     {
     [dicClosestToPinReturn setObject:dicClosestToPin forKey:@"closest_pin"];
     }
     else{
     [dicClosestToPinReturn setObject:@"0" forKey:@"closest_pin"];
     }*/
    NSDictionary *dic;
    if (count == 1)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1, nil];
    }
    else if (count == 2)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2, nil];
    }
    else if (count == 3)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2,dicClosestToPin[HOLE3],HOLE3, nil];
    }
    else if (count == 4)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2,dicClosestToPin[HOLE3],HOLE3,dicClosestToPin[HOLE4],HOLE4, nil];
    }
    if (isClosestPinAvailable == YES)
    {
        //dicClosestToPinReturn = [NSDictionary dictionaryWithObjectsAndKeys:dic,@"long_drive", nil];
        dicClosestToPinReturn = dic;
    }
    else{
        dicClosestToPinReturn = [[NSDictionary alloc] init];
    }
    /////////////////////////////////////////////////////////////////////
    
    //return straightDrive;
    return dicClosestToPinReturn;
}

- (NSDictionary *)getLongDrive
{
    NSString *longDrive = nil;
    
    if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsSpotPrize] == YES)
    {
        longDrive = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive];
    }
    else
    {
        longDrive = @"0";
    }
    /////////////////////////////////////////////////////////////////////
    NSDictionary *dicClosestToPinReturn;
    NSMutableDictionary *dicClosestToPin = [NSMutableDictionary new];
    NSInteger count = 0;
    BOOL isClosestPinAvailable = NO;
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive1] length] > 0)
    {
        count++;
        [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive1] forKey:HOLE1];
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive2] length] > 0)
    {
        count++;
        if (count == 1)
        {
            //NSDictionary *dic =
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive2] forKey:HOLE1];
        }
        else{
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive2] forKey:HOLE2];
        }
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive3] length] > 0)
    {
        count++;
        if (count == 1)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive3] forKey:HOLE1];
        }
        else if (count == 2){
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive3] forKey:HOLE2];
        }
        else
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive3] forKey:HOLE3];
        }
        isClosestPinAvailable = YES;
    }
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive4] length] > 0)
    {
        count++;
        if (count == 1)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive4] forKey:HOLE1];
        }
        else if (count == 2){
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive4] forKey:HOLE2];
        }
        else if (count == 3)
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive4] forKey:HOLE3];
        }
        else
        {
            [dicClosestToPin setObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeLongDrive4] forKey:HOLE4];
        }
        isClosestPinAvailable = YES;
        
    }
    /*if (isClosestPinAvailable == YES)
     {
     [dicClosestToPinReturn setObject:dicClosestToPin forKey:@"closest_pin"];
     }
     else{
     [dicClosestToPinReturn setObject:@"0" forKey:@"closest_pin"];
     }*/
    NSDictionary *dic;
    if (count == 1)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1, nil];
    }
    else if (count == 2)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2, nil];
    }
    else if (count == 3)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2,dicClosestToPin[HOLE3],HOLE3, nil];
    }
    else if (count == 4)
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:dicClosestToPin[HOLE1],HOLE1,dicClosestToPin[HOLE2],HOLE2,dicClosestToPin[HOLE3],HOLE3,dicClosestToPin[HOLE4],HOLE4, nil];
    }
    if (isClosestPinAvailable == YES)
    {
        //dicClosestToPinReturn = [NSDictionary dictionaryWithObjectsAndKeys:dic,@"long_drive", nil];
        dicClosestToPinReturn = dic;
    }
    else{
        dicClosestToPinReturn = [[NSDictionary alloc] init];
    }
    /////////////////////////////////////////////////////////////////////
    //return longDrive;
    return dicClosestToPinReturn;
}

- (NSMutableArray *)getTeam
{
    NSMutableArray *listToReturn = [NSMutableArray new];
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM])
    {
        
        //Team A
        NSMutableDictionary *dicTeamA = [NSMutableDictionary new];
        [dicTeamA setObject:@"Team A" forKey:@"team_name_1"];
        [dicTeamA setObject:@"2" forKey:@"event_friend_num"];
        NSMutableArray *arrTeamA = [NSMutableArray new];
        
        //Team B
        NSMutableDictionary *dicTeamB = [NSMutableDictionary new];
        [dicTeamB setObject:@"Team B" forKey:@"team_name_2"];
        [dicTeamB setObject:@"2" forKey:@"event_friend_num"];
        NSMutableArray *arrTeamB = [NSMutableArray new];
        
        NSArray *arrA = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getTeamA];
        NSArray *arrB = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getTeamB];
        
        NSMutableDictionary *playerA = [NSMutableDictionary new];
        int countA = 0;
        int countB = 0;
        NSMutableDictionary *playerB = [NSMutableDictionary new];
        
        for (NSInteger counter = 0; counter < [arrA count]; counter++)
        {
            if (countA < 2)
            {
                NSString *strFrndKey = [NSString stringWithFormat:@"friend_id_%li",counter+1];
                PT_PlayerItemModel *playerModel = arrA[counter];
                NSString *playerId = [NSString stringWithFormat:@"%li",playerModel.playerId];
                if (playerModel.playerId == 0)
                {
                    
                }
                else
                {
                    [playerA setObject:playerId forKey:strFrndKey];
                    countA++;
                }
                
                
            }
        }
        [arrTeamA addObject:playerA];
        for (NSInteger counterB = 0; counterB < [arrB count]; counterB++)
        {
            if (countB <= 2)
            {
                NSString *strFrndKey = [NSString stringWithFormat:@"friend_id_%li",counterB+1];
                PT_PlayerItemModel *playerModel = arrB[counterB];
                NSString *playerId = [NSString stringWithFormat:@"%li",(long)playerModel.playerId];
                if (playerModel.playerId == 0)
                {
                    
                }
                else
                {
                    [playerB setObject:playerId forKey:strFrndKey];
                    countB++;
                }
                

            }
        }
        [arrTeamB addObject:playerB];
        
        [dicTeamA setObject:arrTeamA forKey:@"event_friend_list"];
        [dicTeamB setObject:arrTeamB forKey:@"event_friend_list"];
        
        [listToReturn addObject:dicTeamA];
        [listToReturn addObject:dicTeamB];
        
        
    }
    else{
        
    }
    return listToReturn;
    
}

- (NSArray *)getSuggestionFriendList
{
    NSArray *arrList;
    NSMutableArray *listToReturn = [NSMutableArray new];
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
    {
        NSArray *arrList = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayersFor4Plus];
        
        if ([arrList count] > 0) {
        for (NSInteger counter = 0; counter <= [arrList count]-1; counter++)
        {
            PT_PlayerItemModel *model = arrList[counter];
            NSString *friendId = [NSString stringWithFormat:@"%li",(long)model.playerId];
            NSDictionary *dicFriend = [NSDictionary dictionaryWithObjectsAndKeys:friendId,@"friend_id", nil];
            [listToReturn addObject:dicFriend];
        }
        }
    }
    else
    {
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventSuggestionFriends] count] > 0)
        {
            arrList = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventSuggestionFriends];
            for (NSInteger counter = 0; counter <= [arrList count]-1; counter++)
            {
                PT_PlayerItemModel *model = arrList[counter];
                NSString *friendId = [NSString stringWithFormat:@"%li",(long)model.playerId];
                NSDictionary *dicFriend = [NSDictionary dictionaryWithObjectsAndKeys:friendId,@"friend_id", nil];
                [listToReturn addObject:dicFriend];
            }
        }
    }
    
    return listToReturn;
}

-(NSArray *)getAddedThroughEmailList
{
    NSArray *arrList;
    NSMutableArray *listToReturn = [NSMutableArray new];
    
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getPlayerAddedThroughEmail] count] > 0)
    {
        arrList = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getPlayerAddedThroughEmail];
        for (NSInteger counter = 0; counter <= [arrList count]-1; counter++)
        {
            
            
            PT_PlayerItemModel *model = arrList[counter];
            
            if (model.playerId > 0|| model.teamNum == 0) {
                
            }else
            {
            NSString *friendname = [NSString stringWithFormat:@"%@",model.playerName];
            NSString*handicap = [NSString stringWithFormat:@"%li",(long)model.counts];
            NSString *email = [NSString stringWithFormat:@"%@",model.email];
            NSString*teamNum = [NSString stringWithFormat:@"%li",(long)model.teamNum];
            NSDictionary *dicFriend = [NSDictionary dictionaryWithObjectsAndKeys:friendname,@"name",handicap,@"handicap",email,@"email",teamNum,@"team_number", nil];
            [listToReturn addObject:dicFriend];
            }
        }
    }
    return listToReturn;
    
}

- (NSArray *)getEventTee
{
    NSMutableArray *listToReturn = [NSMutableArray new];
    PT_TeeItemModel *menTeeModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getMenTeeModel];
    PT_TeeItemModel *womenTeeModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getWomenTeeModel];
    PT_TeeItemModel *juniorTeeModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getJuniorTeeModel];
    NSString *menTeeId = [NSString stringWithFormat:@"%li",(long)menTeeModel.teeId];
    NSString *womenTeeId = [NSString stringWithFormat:@"%li",(long)womenTeeModel.teeId];
    NSString *juniorTeeId = [NSString stringWithFormat:@"%li",(long)juniorTeeModel.teeId];
    NSDictionary *dicMenTee = [NSDictionary dictionaryWithObjectsAndKeys:menTeeId,@"men", nil];
    NSDictionary *dicWomenTee = [NSDictionary dictionaryWithObjectsAndKeys:womenTeeId,@"ladies", nil];
    NSDictionary *dicJuniorTee = [NSDictionary dictionaryWithObjectsAndKeys:juniorTeeId,@"junior", nil];
    [listToReturn addObject:dicMenTee];
    [listToReturn addObject:dicWomenTee];
    [listToReturn addObject:dicJuniorTee];
    return listToReturn;
}

- (NSString *)getPublicOrPrivate
{
    NSString *eventType = nil;
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventType] isEqualToString:PUBLIC])
    {
        eventType = @"1";
    }
    else
    {
        eventType = @"0";
    }
    return eventType;
}

- (NSArray *)getGroups
{
    NSMutableArray *arrToReturn = [NSMutableArray new];
    NSArray *arrGrps = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getGroups];
    for (NSInteger count = 0; count < [arrGrps count]; count++)
    {
        PT_GroupItemModel *model = arrGrps[count];
        NSString *grpId = [NSString stringWithFormat:@"%li",(long)model.groupId];
        NSDictionary *dicGroup = [NSDictionary dictionaryWithObject:grpId forKey:@"group"];
        
        [arrToReturn addObject:dicGroup];
    }
    
    return arrToReturn;
}

@end
