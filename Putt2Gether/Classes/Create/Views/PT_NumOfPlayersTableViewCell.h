//
//  PT_NumOfPlayersTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"

@interface PT_NumOfPlayersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;

@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (weak, nonatomic) IBOutlet UIButton *fourButton;

//Lower Half
@property (weak, nonatomic) IBOutlet UIView *lowerHalfView;

@property (weak,nonatomic) IBOutlet UIButton *yesButton;

@property (weak, nonatomic) IBOutlet UIButton *noButton;

@property (strong, nonatomic) PT_CreateViewController *parentController;

@property (assign, nonatomic) BOOL isOneSelected;

- (void)actionNumberOfPlayersSelectedForCell:(UIButton *)sender;

//Yes No Button Event
- (void)actionTeamSelectedForCell:(UIButton *)sender;

@end
