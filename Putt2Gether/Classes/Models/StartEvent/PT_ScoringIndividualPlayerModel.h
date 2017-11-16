//
//  PT_ScoringIndividualPlayerModel.h
//  Putt2Gether
//
//  Created by Devashis on 25/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_ScoringIndividualPlayerModel : NSObject

@property (assign, nonatomic) NSInteger playerId;

@property (strong, nonatomic) NSString *playerName;

@property (strong, nonatomic) NSString *shortName;

@property (assign, nonatomic) NSInteger handicap;

@property (assign, nonatomic) NSInteger grossScore;

@property (assign, nonatomic) NSInteger numberOfPuts;

@property (strong, nonatomic) NSString *fairways;

@property (strong, nonatomic) NSString *sand;

@property (assign, nonatomic) BOOL isSPotPrize;

@property (strong, nonatomic) NSString *spotPrizeType;

@property (assign, nonatomic) NSInteger spotPrizeValue;

@property (assign, nonatomic) NSInteger closestInch;

@property (assign, nonatomic) NSInteger closestFeet;

@property (assign, nonatomic) NSInteger holeLastPlayed;

@property (strong, nonatomic) NSString *playerColor;

@property(strong,nonatomic) NSMutableArray *arrplayedHole;

@end
