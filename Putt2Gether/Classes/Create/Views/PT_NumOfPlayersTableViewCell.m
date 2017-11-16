//
//  PT_NumOfPlayersTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_NumOfPlayersTableViewCell.h"

@implementation PT_NumOfPlayersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)actionNumberOfPlayersSelectedForCell:(UIButton *)sender
{
    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *whiteBGColor = [UIColor whiteColor];
    
    switch (sender.tag) {
        case 0:
        {
            self.oneButton.backgroundColor = blueBGColor;
            [self.oneButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.oneButton.titleLabel.text = @"1";
            self.twoButton.backgroundColor = whiteBGColor;
            self.twoButton.layer.borderColor = blueBGColor.CGColor;
            self.twoButton.titleLabel.textColor = blueBGColor;
            self.threeButton.backgroundColor = whiteBGColor;
            self.threeButton.layer.borderColor = blueBGColor.CGColor;
            self.threeButton.titleLabel.textColor = blueBGColor;
            self.fourButton.backgroundColor = whiteBGColor;
            self.fourButton.layer.borderColor = blueBGColor.CGColor;
            self.fourButton.titleLabel.textColor = blueBGColor;
            self.plusButton.backgroundColor = whiteBGColor;
            self.plusButton.layer.borderColor = blueBGColor.CGColor;
            [self.plusButton setTitleColor:blueBGColor forState:UIControlStateNormal];
            self.plusButton.titleLabel.text = @"+";
            self.lowerHalfView.hidden = YES;self.parentController.isNumOfPlayersCellLowerHalfVisible = NO;
            self.parentController.isTeamGame = NO;
            self.isOneSelected = YES;
            [self.parentController setIndividualOrTeamForPreviewEvent:INDIVIDUAL];
            [self.parentController setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_1];
    
            [self.parentController setIsScorerTypeForPreviewEvent:YES];
    
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:nil];
            [self.parentController refreshTableView];
        }
            break;
        case 1:
        {
            self.twoButton.backgroundColor = blueBGColor;
            [self.twoButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.twoButton.titleLabel.text = @"2";
            self.oneButton.backgroundColor = whiteBGColor;
            self.oneButton.layer.borderColor = blueBGColor.CGColor;
            self.oneButton.titleLabel.textColor = blueBGColor;
            self.threeButton.backgroundColor = whiteBGColor;
            self.threeButton.layer.borderColor = blueBGColor.CGColor;
            self.threeButton.titleLabel.textColor = blueBGColor;
            self.fourButton.backgroundColor = whiteBGColor;
            self.fourButton.layer.borderColor = blueBGColor.CGColor;
            self.fourButton.titleLabel.textColor = blueBGColor;
            self.plusButton.backgroundColor = whiteBGColor;
            self.plusButton.layer.borderColor = blueBGColor.CGColor;
            [self.plusButton setTitleColor:blueBGColor forState:UIControlStateNormal];
            self.plusButton.titleLabel.text = @"+";
            self.lowerHalfView.hidden = YES;
            self.parentController.isNumOfPlayersCellLowerHalfVisible = NO;
            self.parentController.isTeamGame = NO;
            [self.parentController setIndividualOrTeamForPreviewEvent:INDIVIDUAL];
            [self.parentController setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_2];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:nil];
            [self.parentController setIsScorerTypeForPreviewEvent:YES];
            [self.parentController refreshTableView];
        }
            break;
        case 2:
        {
            self.threeButton.backgroundColor = blueBGColor;
            [self.threeButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.threeButton.titleLabel.text = @"3";
            self.twoButton.backgroundColor = whiteBGColor;
            self.twoButton.layer.borderColor = blueBGColor.CGColor;
            self.twoButton.titleLabel.textColor = blueBGColor;
            self.oneButton.backgroundColor = whiteBGColor;
            self.oneButton.layer.borderColor = blueBGColor.CGColor;
            self.oneButton.titleLabel.textColor = blueBGColor;
            self.fourButton.backgroundColor = whiteBGColor;
            self.fourButton.layer.borderColor = blueBGColor.CGColor;
            self.fourButton.titleLabel.textColor = blueBGColor;
            self.plusButton.backgroundColor = whiteBGColor;
            self.plusButton.layer.borderColor = blueBGColor.CGColor;
            [self.plusButton setTitleColor:blueBGColor forState:UIControlStateNormal];
            self.plusButton.titleLabel.text = @"+";
            self.lowerHalfView.hidden = YES;
            self.parentController.isNumOfPlayersCellLowerHalfVisible = NO;
            self.parentController.isTeamGame = NO;
            [self.parentController setIndividualOrTeamForPreviewEvent:INDIVIDUAL];
            [self.parentController setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_3];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:nil];
            [self.parentController setIsScorerTypeForPreviewEvent:YES];
            [self.parentController refreshTableView];
        }
            break;
        case 3:
        {
            self.fourButton.backgroundColor = blueBGColor;
            [self.fourButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.fourButton.titleLabel.text = @"4";
            self.twoButton.backgroundColor = whiteBGColor;
            self.twoButton.layer.borderColor = blueBGColor.CGColor;
            self.twoButton.titleLabel.textColor = blueBGColor;
            self.threeButton.backgroundColor = whiteBGColor;
            self.threeButton.layer.borderColor = blueBGColor.CGColor;
            self.threeButton.titleLabel.textColor = blueBGColor;
            self.oneButton.backgroundColor = whiteBGColor;
            self.oneButton.layer.borderColor = blueBGColor.CGColor;
            self.oneButton.titleLabel.textColor = blueBGColor;
            self.plusButton.backgroundColor = whiteBGColor;
            self.plusButton.layer.borderColor = blueBGColor.CGColor;
            [self.plusButton setTitleColor:blueBGColor forState:UIControlStateNormal];
            self.plusButton.titleLabel.text = @"+";
            self.parentController.isNumOfPlayersCellLowerHalfVisible = YES;
            self.parentController.isTeamGame = YES;
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setindividualOrTeam:TEAM];  //Added

//            [self.parentController setIndividualOrTeamForPreviewEvent:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam]];
            [self.parentController setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_4];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:nil];
            [self.parentController setIsScorerTypeForPreviewEvent:YES];
            [self.parentController refreshTableView];
        }
            break;
        case 4:
        {
            self.plusButton.backgroundColor = blueBGColor;
            [self.plusButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.plusButton.titleLabel.text = @"+";
            self.fourButton.backgroundColor = whiteBGColor;
            self.fourButton.layer.borderColor = blueBGColor.CGColor;
            [self.fourButton setTitleColor:blueBGColor forState:UIControlStateNormal];
            self.fourButton.titleLabel.text = @"4";
            self.twoButton.backgroundColor = whiteBGColor;
            self.twoButton.layer.borderColor = blueBGColor.CGColor;
            self.twoButton.titleLabel.textColor = blueBGColor;
            self.threeButton.backgroundColor = whiteBGColor;
            self.threeButton.layer.borderColor = blueBGColor.CGColor;
            self.threeButton.titleLabel.textColor = blueBGColor;
            self.oneButton.backgroundColor = whiteBGColor;
            self.oneButton.layer.borderColor = blueBGColor.CGColor;
            self.oneButton.titleLabel.textColor = blueBGColor;
            self.parentController.isNumOfPlayersCellLowerHalfVisible = NO;
            self.parentController.isTeamGame = NO;
[[PT_PreviewEventSingletonModel sharedPreviewEvent] setindividualOrTeam:nil];
            [self.parentController setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_MoreThan4];
            self.parentController.isSpotPrizeSelected = NO;
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:nil];
            [self.parentController setIsScorerTypeForPreviewEvent:NO];
            [self.parentController refreshTableView];
        }
            break;
    }
}

- (void)actionTeamSelectedForCell:(UIButton *)sender
{
    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *whiteBGColor = [UIColor whiteColor];
    
    switch (sender.tag) {
        case 0:
        {
            self.yesButton.backgroundColor = blueBGColor;
            [self.yesButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            
            self.noButton.backgroundColor = whiteBGColor;
            self.noButton.layer.borderColor = blueBGColor.CGColor;
            self.noButton.titleLabel.textColor = blueBGColor;
            self.parentController.isTeamGame = YES;
            [self.parentController setIndividualOrTeamForPreviewEvent:TEAM];

        }
            break;
            
        case 1:
        {
            self.noButton.backgroundColor = blueBGColor;
            [self.noButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            
            self.yesButton.backgroundColor = whiteBGColor;
            self.yesButton.layer.borderColor = blueBGColor.CGColor;
            self.yesButton.titleLabel.textColor = blueBGColor;
            self.parentController.isTeamGame = NO;
            [self.parentController setIndividualOrTeamForPreviewEvent:INDIVIDUAL];
        }
            break;
    }
}


@end
