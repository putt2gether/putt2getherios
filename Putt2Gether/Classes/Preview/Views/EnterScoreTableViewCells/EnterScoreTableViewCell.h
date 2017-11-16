//
//  EnterScoreTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 26/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_StartEventViewController.h"

@interface EnterScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) PT_StartEventViewController *startVC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFairwaysViewHeight;

@property (weak, nonatomic) IBOutlet UIView *spotPrizeView;

@property (weak, nonatomic) IBOutlet UIView *fairwaysView,*puttView,*sandView;

@property (weak, nonatomic) IBOutlet UIView *underlineView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *bgActionButton;

@property (weak, nonatomic) IBOutlet UILabel *grossValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *puttsValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *sandValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *handicap;

@property (weak, nonatomic) IBOutlet UIImageView *fairwaysLeftImage;

@property (weak, nonatomic) IBOutlet UIImageView *fairwaysRightImage;

@property (weak, nonatomic) IBOutlet UIImageView *fairwaysCentreImage;

@property (weak, nonatomic) IBOutlet UITextField *textFeet;

@property (weak, nonatomic) IBOutlet UILabel *feetLabel;

@property (weak, nonatomic) IBOutlet UILabel *spotPrizeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerViewHeight;


//Mark:-for showing closetFeet Value of other Players

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPuttViewHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSandViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *hitBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *increamentPuttsButton;
@property (weak, nonatomic) IBOutlet UIButton *decreamentPuttsButton;
@property (weak, nonatomic) IBOutlet UIButton *decreamentGrossButton;
@property (weak, nonatomic) IBOutlet UIButton *incre1Btn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;

- (void)setBordersForActionViews;

@end
