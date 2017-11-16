//
//  PT_SpecialFormatLeaderboardModel.h
//  Putt2Gether
//
//  Created by Devashis on 06/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_SpecialFormatLeaderboardModel : NSObject

@property (strong, nonatomic) NSString *hole_number;
@property (strong, nonatomic) NSString *colorWinner;
@property (strong, nonatomic) NSMutableArray *arrBackto9Score;
@property (strong, nonatomic) NSMutableArray *arrScoreValue;

@end
