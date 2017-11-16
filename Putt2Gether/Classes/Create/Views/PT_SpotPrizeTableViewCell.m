//
//  PT_SpotPrizeTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 23/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_SpotPrizeTableViewCell.h"

@interface PT_SpotPrizeTableViewCell ()
{
    BOOL isCLosestToPinHidden;
    BOOL isLongDriveHidden;
}

@property (weak, nonatomic) IBOutlet UIView *lineSeparatorSpotPrize;

@end

@implementation PT_SpotPrizeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionSpotPrizes:(UIButton *)sender
{
    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *whiteBGColor = [UIColor whiteColor];
    
    switch (sender.tag) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noButton.backgroundColor = blueBGColor;
                [self.noButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
                self.yesButton.backgroundColor = whiteBGColor;
                self.yesButton.layer.borderColor = blueBGColor.CGColor;
                self.yesButton.titleLabel.textColor = blueBGColor;
                self.parentController.isSpotPrizeSelected = NO;
                //[self.parentController refreshTableView];
                self.lineView.hidden = NO;
                self.spotPrizeView.hidden = YES;
                [self.parentController setIsSpotPrizeForPreviewEvent:NO];
            });
            
        }
            break;
            
        case 1:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.yesButton.backgroundColor = blueBGColor;
                [self.yesButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
                self.noButton.backgroundColor = whiteBGColor;
                self.noButton.layer.borderColor = blueBGColor.CGColor;
                self.noButton.titleLabel.textColor = blueBGColor;
                self.parentController.isSpotPrizeSelected = YES;
                //[self.parentController refreshTableView];
                self.spotPrizeView.hidden = NO;
                self.lineView.hidden = YES;
                [self.parentController setIsSpotPrizeForPreviewEvent:YES];
                //self.spotPrizeView.backgroundColor = [UIColor colorWithRed:(228/255.0f) green:(232/255.0f) blue:(239/255.0f) alpha:1.0];
            });
            

        }
            break;
    }
}

- (void)showSpotOptionsForNumberOfHoles:(NSInteger)numberOfHoles
{
    if (numberOfHoles == 18)
    {
        _closestToPinButton1.hidden = NO;
        _closestToPinButton2.hidden = NO;
        _closestToPinButton3.hidden = NO;
        _closestToPinButton4.hidden = NO;
        _longDriveButton1.hidden = NO;
        _longDriveButton2.hidden = NO;
        _longDriveButton3.hidden = NO;
        _longDriveButton4.hidden = NO;
        _straightDriveButton1.hidden = NO;
        _straightDriveButton2.hidden = NO;
        _straightDriveButton3.hidden = NO;
        _straightDriveButton4.hidden = NO;
    }
    else
    {
        _closestToPinButton1.hidden = YES;
        _closestToPinButton2.hidden = YES;
        _closestToPinButton3.hidden = NO;
        _closestToPinButton4.hidden = NO;
        _longDriveButton1.hidden = YES;
        _longDriveButton2.hidden = YES;
        _longDriveButton3.hidden = NO;
        _longDriveButton4.hidden = NO;
        _straightDriveButton1.hidden = YES;
        _straightDriveButton2.hidden = YES;
        _straightDriveButton3.hidden = NO;
        _straightDriveButton4.hidden = NO;
    }
}

- (void)hideClosestToPin
{
    //_constraintLongDriveY.constant = _constraintLongDriveY.constant - 10;
    //self.lineSptPrize2.hidden = YES;
    _viewClosestToPin.hidden = YES;
    _constraintLongDriveY.constant = _constraintLongDriveY.constant - 35;
    
    if (_isEditMode == YES)
    {
        
    }
    else
    {
       _constraintSpotPrizeViewHeight.constant = _constraintSpotPrizeViewHeight.constant - 35;
    }
   
        
    isCLosestToPinHidden = YES;
}

- (void)hideLongDrive
{
    
    _viewLongDrive.hidden = YES;
    
    if (isCLosestToPinHidden == YES)
    {
        _lineSptPrize2.hidden = YES;
        _constraintStraightDriveY.constant = _constraintStraightDriveY.constant - 20;
    }
    else{
        _lineSptPrize2.hidden = NO;
        _constraintStraightDriveY.constant = _constraintStraightDriveY.constant - 20;
    }
    _constraintStraightDriveY.constant = _constraintStraightDriveY.constant - 25;
    
    if (_isEditMode == YES)
    {
        
    }
    else
    {
        _constraintSpotPrizeViewHeight.constant = _constraintSpotPrizeViewHeight.constant - 35;
    }
    
    
    isLongDriveHidden = YES;
}

- (void)hideStraightDrive
{
    _viewStraightDrive.hidden = YES;
    _lineSptPrize3.hidden = YES;
    if (isLongDriveHidden == NO)
    {
        _lineSptPrize3.hidden = YES;
        _lineSptPrize2.hidden = YES;
    }
    if (isCLosestToPinHidden == YES && isLongDriveHidden == YES)
    {
        
    }
    if (_isEditMode == YES)
    {
        
    }
    else
    {
        _constraintSpotPrizeViewHeight.constant = _constraintSpotPrizeViewHeight.constant - 35;
    }
    
   
}

- (void)setLine2Visible
{
    _lineSptPrize2.hidden = NO;
}
- (void)setLine3Visible
{
    _lineSptPrize3.hidden = NO;
}

@end
