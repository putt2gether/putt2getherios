//
//  PT_AddPlayerIntermediateViewController.h
//  Putt2Gether
//
//  Created by Devashis on 29/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_PlayerItemModel.h"

@interface PT_AddPlayerIntermediateViewController : UIViewController

- (instancetype)initWithNumberOfPlayers:(NSInteger)numOfPlayers;

- (void)setSelectedPlayer:(PT_PlayerItemModel *)model;

- (void)setEmailSelectedPlayer:(PT_PlayerItemModel *)model;

@property(assign,nonatomic) BOOL isAddingThroughEmail;

- (NSArray *)getPlayersArray;

@end
