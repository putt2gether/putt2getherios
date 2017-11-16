//
//  PT_SelectHolesTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_SelectHolesTableViewCell.h"

@implementation PT_SelectHolesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)actionHoleTypeSelectedForCell:(UIButton *)sender
{
    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *whiteBGColor = [UIColor whiteColor];
    switch (sender.tag) {
        case 0:
        {
            self.parentViewController.isFront9Selected = YES;
            self.front9Button.backgroundColor = blueBGColor;
            [self.front9Button setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.back9Button.backgroundColor = whiteBGColor;
            self.back9Button.layer.borderColor = blueBGColor.CGColor;
            self.back9Button.titleLabel.textColor = blueBGColor;
            [self.parentViewController setFRontOrBack9ForPreviewEvent:FRONT9];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultSpotPrize];
            [self.parentViewController refreshTableView];

        }
            break;
        case 1:
        {
            self.parentViewController.isFront9Selected = NO;
            self.back9Button.backgroundColor = blueBGColor;
            [self.back9Button setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.front9Button.backgroundColor = whiteBGColor;
            self.front9Button.layer.borderColor = blueBGColor.CGColor;
            self.front9Button.titleLabel.textColor = blueBGColor;
            [self.parentViewController setFRontOrBack9ForPreviewEvent:BACK9];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultSpotPrize];
            [self.parentViewController refreshTableView];


        }
            break;
            
    }
}

@end
