//
//  PT_Front9Model.h
//  Putt2Gether
//
//  Created by Devashis on 06/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_Front9Model : NSObject

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *score;

@property(assign,nonatomic) NSInteger holeNumber;
@property(strong,nonatomic) NSString *aggScore;

@property(strong,nonatomic)NSString *holeScore;

@property(strong,nonatomic)NSString *colorhole;

@end
