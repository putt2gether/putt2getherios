//
//  PT_NumOfHolesTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_NumOfHolesTableViewCell.h"

@implementation PT_NumOfHolesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)actionNumberOfHolesSelectedForCell:(UIButton *)sender
{
    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *whiteBGColor = [UIColor whiteColor];
    switch (sender.tag) {
        case 0:
        {
            self.nineButton.backgroundColor = blueBGColor;
            [self.nineButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            //self.oneButton.titleLabel.text = @"1";
            self.eighteenButton.backgroundColor = whiteBGColor;
            self.eighteenButton.layer.borderColor = blueBGColor.CGColor;
            self.eighteenButton.titleLabel.textColor = blueBGColor;
            self.parentController.isNumberOfHole18Selected = NO;
            [self.parentController refreshTableView];
            [self.parentController setNoOfHolesForPreviewEvent:@"9"];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultSpotPrize];
            [self.parentController setIs18HolesSelectedForPreviewEvent:NO];
            if (self.parentController.isFront9Selected == YES)
            {
                
            }
            else
            {
                
            }
        }
            break;
        case 1:
        {
            self.eighteenButton.backgroundColor = blueBGColor;
            [self.eighteenButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            //self.eighteenButton.titleLabel.text = @"2";
            self.nineButton.backgroundColor = whiteBGColor;
            self.nineButton.layer.borderColor = blueBGColor.CGColor;
            self.nineButton.titleLabel.textColor = blueBGColor;
            self.parentController.isNumberOfHole18Selected = YES;
            [self.parentController refreshTableView];
            [self.parentController setIs18HolesSelectedForPreviewEvent:YES];
            [self.parentController setNoOfHolesForPreviewEvent:@"18"];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultSpotPrize];

        }
            break;
        
    }
}


@end
