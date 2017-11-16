//
//  PT_GolfCourceTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_GolfCourceTableViewCell.h"

@interface PT_GolfCourceTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonWidth;

@end

@implementation PT_GolfCourceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSychronizationValueforButton
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    switch (screenHeight) {
        case 480 :
        {
            
            
        }
            break;
            
        case 568:
        {
            self.constraintButtonWidth.constant = 148;
        }
            break;
            
        case 667:
        {
            
        }
            break;
            
        case 736:
        {
            //self.loginBoxHeight.constant = 220;
        }
            break;
            
    }

}

@end
