//
//  PT_CacheHoleData.m
//  Putt2Gether
//
//  Created by Devashis on 04/01/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_CacheHoleData.h"

static NSString *const User_Id = @"userId";
static NSString *const Gross_Score = @"gross";
static NSString *const Number_Of_Putts = @"putts";
static NSString *const Fairways = @"fairways";
static NSString *const Sand = @"sand";
static NSString *const Spot_Prize = @"spotprize";
static NSString *const Data = @"data";

@interface PT_CacheHoleData ()
{
    
    NSArray *arrPlayersForScoring;
    
}

@end

@implementation PT_CacheHoleData

- (instancetype)initWithScoreDataArray:(NSArray *)arrScore
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    arrPlayersForScoring = arrScore;
    return self;
}

- (void)saveDataForHoleNumber:(NSInteger)holeNumber
{
    __block NSMutableArray *arrScore = [NSMutableArray new];
    [arrPlayersForScoring enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PT_ScoringIndividualPlayerModel *model = obj;
        NSNumber *gross = [NSNumber numberWithInteger:model.grossScore];
        NSNumber *putts = [NSNumber numberWithInteger:model.numberOfPuts];
        
        NSNumber *sandval = [NSNumber numberWithInteger:[model.sand integerValue]];

        NSString *fairways = model.fairways;
        NSString *sand = [NSString stringWithFormat:@"%@",sandval];
        NSNumber *spotPrize = [NSNumber numberWithFloat:model.closestFeet];
        
        NSDictionary *dicScores = [NSDictionary dictionaryWithObjectsAndKeys:gross,Gross_Score,
                                   putts,Number_Of_Putts,
                                   fairways,Fairways,
                                   sand,Sand,
                                   spotPrize,Spot_Prize,
                                   nil];
        [arrScore addObject:dicScores];
        
        if (idx == [arrPlayersForScoring count] - 1)
        {
            NSString *holeStr = [NSString stringWithFormat:@"Hole_%li",(long)holeNumber];
            NSDictionary *data = [NSDictionary dictionaryWithObject:arrScore forKey:Data];
            [[MGUserDefaults sharedDefault] setData:data forHoleNumber:holeStr];
            
            //NSDictionary *returnDict = [[MGUserDefaults sharedDefault] getDataForHoleNumber:holeStr];
            //NSLog(@"%@",returnDict);
        }
    }];
    
}

- (void)setDataFromExistingValuesForHole:(NSInteger)holeNumber
{
    NSString *holeStr = [NSString stringWithFormat:@"Hole_%li",(long)holeNumber];
    NSDictionary *returnDict = [[MGUserDefaults sharedDefault] getDataForHoleNumber:holeStr];
    NSArray *arrData = returnDict[@"data"];
    
    NSLog(@"%lu",(unsigned long)[arrPlayersForScoring count]);
    /*
    if (holeNumber == 18 || [arrPlayersForScoring count] == 18) {
        
        PT_ScoringIndividualPlayerModel *model = arrPlayersForScoring[17];
        NSDictionary *dictAtIndex = arrData[17];
        
        model.grossScore = [dictAtIndex[Gross_Score] integerValue];
        model.numberOfPuts = [dictAtIndex[Number_Of_Putts] integerValue];
        model.fairways = dictAtIndex[Fairways];
        if (dictAtIndex[Sand]) {
            
            model.sand = dictAtIndex[Sand];
        }
        
        
        model.closestFeet = [dictAtIndex[Spot_Prize] floatValue];

        
        return;
    }else{
     */
    for (NSInteger counter = 0; counter < [arrData count]-1; counter++)
    {
        NSLog(@"%ld",(long)counter);
        
        PT_ScoringIndividualPlayerModel *model = arrPlayersForScoring[counter];
        NSDictionary *dictAtIndex = arrData[counter];
        
        model.grossScore = [dictAtIndex[Gross_Score] integerValue];
        model.numberOfPuts = [dictAtIndex[Number_Of_Putts] integerValue];
        model.fairways = dictAtIndex[Fairways];
        if (dictAtIndex[Sand]) {
            
            model.sand = dictAtIndex[Sand];
        }
        
        
        model.closestFeet = [dictAtIndex[Spot_Prize] floatValue];
        
        
    }
    //}
    
}

- (void)removeAllCachedHoleData
{
    for (NSInteger counter = 0; counter < 18; counter ++)
    {
        NSString *holeStr = [NSString stringWithFormat:@"Hole_%li",(long)counter];
        [[MGUserDefaults sharedDefault] removeObjectForKey:holeStr];
        
    }
}
@end
