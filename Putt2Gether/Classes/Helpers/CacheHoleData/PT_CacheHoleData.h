//
//  PT_CacheHoleData.h
//  Putt2Gether
//
//  Created by Devashis on 04/01/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_CacheHoleData : NSObject

- (instancetype)initWithScoreDataArray:(NSArray *)arrScore;

- (void)saveDataForHoleNumber:(NSInteger)holeNumber;

- (void)setDataFromExistingValuesForHole:(NSInteger)holeNumber;

- (void)removeAllCachedHoleData;

@end
