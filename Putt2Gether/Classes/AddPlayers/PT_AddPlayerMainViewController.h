//
//  PT_AddPlayerMainViewController.h
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"
#import "PT_InviteViewController.h"

#import "PT_PlayerItemModel.h"
#import "PT_AddPlayerIntermediateViewController.h"

typedef NS_ENUM(NSInteger, TeamType)
{
    TeamType_A,
    TeamType_B
};

@interface PT_AddPlayerMainViewController : UIViewController

@property (strong, nonatomic) PT_CreateViewController *createVC;

@property (assign, nonatomic) TeamType selectedTeamType;

@property (strong, nonatomic) PT_AddPlayerIntermediateViewController *intermediatePlayerVC;


- (instancetype)initWithDelegate:(PT_CreateViewController *)parent;

- (void)setDataForTeamWithArray:(NSArray *)playerList;
- (void)removeDataForTeamWithArray:(PT_PlayerItemModel *)playerModel;

- (IBAction)actionBack;

- (NSArray *)getTeamPlayersArray;


@property(assign,nonatomic) BOOL isAddingThroughEmail;

@end
