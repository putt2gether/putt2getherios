//
//  PT_420Formatmodel.h
//  Putt2Gether
//
//  Created by Nivesh on 01/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_420Formatmodel : NSObject

@property (assign, nonatomic) NSInteger hole_number;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *score;

@property (strong, nonatomic) NSMutableArray *arrFirst;
@property (strong, nonatomic) NSMutableArray *arrFirstColor;

@property(strong,nonatomic) NSMutableArray *arrFirstCount,*arrSecondCount;

@property (strong, nonatomic) NSMutableArray *arrSecond,*arrSecondColor;

@property(assign,nonatomic) NSInteger secondArrayCount;


@end
