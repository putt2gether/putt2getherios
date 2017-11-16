//
//  PT_AddPlayerOptionsViewController.h
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_AddPlayerMainViewController.h"

#import "PT_AddPlayerIntermediateViewController.h"

@interface PT_AddPlayerOptionsViewController : UIViewController

@property (strong, nonatomic) PT_AddPlayerMainViewController *previousVC;

@property (strong, nonatomic) PT_AddPlayerIntermediateViewController *intermediatePlayerVC;

@property (assign, nonatomic) NumberOfPlayers numberOfPlayers;

@property (assign, nonatomic) BOOL isIntermediateAddPlayer;

@property(weak,nonatomic) IBOutlet NSLayoutConstraint *groupWidthConstraint;

- (void)actionSuggestionPlayers:(NSArray *)players;
- (void)actionRemoveSuggestionPlayer:(PT_PlayerItemModel *)model;

@property(assign,nonatomic) NSInteger TeamNum;

@property(weak,nonatomic) IBOutlet UIView *addParticipantFooterView;

@property(assign,nonatomic) BOOL isComingFromAddParticipant;

- (instancetype)initWithEventModel:(PT_CreatedEventModel *)model;

@property (weak, nonatomic) IBOutlet UIView *loaderView,*loaderInsideView;



@end
