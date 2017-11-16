//
//  PT_DelegateModel.h
//  Putt2Gether
//
//  Created by Nivesh on 23/02/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_DelegateModel : NSObject

@property(assign,nonatomic) NSInteger eventId;

@property(strong,nonatomic) NSString *handicapValue;

@property(assign,nonatomic) NSInteger playerId;


@property(strong,nonatomic) NSString *playerName;


@property(assign,nonatomic) NSInteger scorerCount;

@property(strong,nonatomic) NSString *scorerName;

@property(assign,nonatomic) NSInteger scorerId;

@property (assign, nonatomic) BOOL isDelegated;

@property (assign, nonatomic) NSInteger delegatedToId;

@property (strong, nonatomic) NSString *delegatedToName;


@end
