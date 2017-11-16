//
//  PT_SpotPrizeTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 23/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"

@interface PT_SpotPrizeTableViewCell : UITableViewCell

@property (strong, nonatomic) PT_CreateViewController *parentController;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIView *spotPrizeView;

//Spot Prizes

//Closest to pin
@property (weak, nonatomic) IBOutlet UIButton *closestToPinButton1;
@property (weak, nonatomic) IBOutlet UIButton *closestToPinButton2;
@property (weak, nonatomic) IBOutlet UIButton *closestToPinButton3;
@property (weak, nonatomic) IBOutlet UIButton *closestToPinButton4;

//Long drive
@property (weak, nonatomic) IBOutlet UIButton *longDriveButton1;
@property (weak, nonatomic) IBOutlet UIButton *longDriveButton2;
@property (weak, nonatomic) IBOutlet UIButton *longDriveButton3;
@property (weak, nonatomic) IBOutlet UIButton *longDriveButton4;

//Straight drive
@property (weak, nonatomic) IBOutlet UIButton *straightDriveButton1;
@property (weak, nonatomic) IBOutlet UIButton *straightDriveButton2;
@property (weak, nonatomic) IBOutlet UIButton *straightDriveButton3;
@property (weak, nonatomic) IBOutlet UIButton *straightDriveButton4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSpotPrizeViewHeight;

//Spot PrizeView
@property (weak, nonatomic) IBOutlet UIView *lineSptPrize1;
@property (weak, nonatomic) IBOutlet UIView *lineSptPrize2;
@property (weak, nonatomic) IBOutlet UIView *lineSptPrize3;

@property (weak, nonatomic) IBOutlet UILabel *closestToPinLabel;
@property (weak, nonatomic) IBOutlet UILabel *longDriveLabel;
@property (weak, nonatomic) IBOutlet UILabel *straightDriveLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectHoleLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *viewClosestToPin;
@property (weak, nonatomic) IBOutlet UIView *viewLongDrive;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLongDriveY;
@property (weak, nonatomic) IBOutlet UIView *viewStraightDrive;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStraightDriveY;

//@property (weak, nonatomic) IBOutlet UILabel *selectHoleLabrl;

@property (assign, nonatomic) BOOL isEditMode;

- (void)showSpotOptionsForNumberOfHoles:(NSInteger)numberOfHoles;
- (void)setLine2Visible;
- (void)setLine3Visible;

- (void)hideClosestToPin;
- (void)hideLongDrive;
- (void)hideStraightDrive;

@end
