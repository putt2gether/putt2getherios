//
//  PT_SuggestionsView.h
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_AddPlayerOptionsViewController.h"

@interface PT_SuggestionsView : UIView

@property (strong, nonatomic) PT_AddPlayerOptionsViewController *parentVC;

@property (strong, nonatomic) NSMutableArray *arrInviteGroup;

@property (strong, nonatomic) NSMutableArray *arrNumberOfPlayers4Plus;

@property(strong,nonatomic) IBOutlet UITextField *searchText;



- (void)setUpWithAddedGroup:(NSMutableArray *)added andInviteGroup:(NSMutableArray *)invite;

- (void)rearrangeContentsInPlayersList:(PT_PlayerItemModel *)model;

- (void)refreshTable;

@end
