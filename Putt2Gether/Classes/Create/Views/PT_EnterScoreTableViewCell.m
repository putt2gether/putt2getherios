//
//  PT_EnterScoreTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 13/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_EnterScoreTableViewCell.h"


@implementation PT_EnterScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionSelectScorerType:(UIButton *)sender
{
    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *whiteBGColor = [UIColor whiteColor];
    switch (sender.tag) {
        case 0:
        {
            self.singleButton.backgroundColor = blueBGColor;
            [self.singleButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.multiButton.backgroundColor = whiteBGColor;
            self.multiButton.layer.borderColor = blueBGColor.CGColor;
            self.multiButton.titleLabel.textColor = blueBGColor;
            [self.parentController setScorerTypeForPreviewEvent:singleScorerStatic];
            
        }
            break;
            
        case 1:
        {
            
            self.multiButton.backgroundColor = blueBGColor;
            [self.multiButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.singleButton.backgroundColor = whiteBGColor;
            self.singleButton.layer.borderColor = blueBGColor.CGColor;
            self.singleButton.titleLabel.textColor = blueBGColor;
            //[self.parentController refreshTableView];
            [self.parentController setScorerTypeForPreviewEvent:multiScorerStatic];
            
            
        }
            break;
    }

}
@end
