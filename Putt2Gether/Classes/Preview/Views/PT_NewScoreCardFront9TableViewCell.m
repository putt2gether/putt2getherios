//
//  PT_NewScoreCardFront9TableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 21/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_NewScoreCardFront9TableViewCell.h"

@implementation PT_NewScoreCardFront9TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDefaultBodering
{
    _c1.layer.borderWidth = 0.6;
    _c1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c2.layer.borderWidth = 0.6;
    _c2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c3.layer.borderWidth = 0.6;
    _c3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c4.layer.borderWidth = 0.6;
    _c4.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c5.layer.borderWidth = 0.6;
    _c5.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c6.layer.borderWidth = 0.6;
    _c6.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c7.layer.borderWidth = 0.6;
    _c7.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c8.layer.borderWidth = 0.6;
    _c8.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c9.layer.borderWidth = 0.6;
    _c9.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _l1.layer.borderWidth = 0.6;
    _l1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _l2.layer.borderWidth = 0.6;
    _l2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setCBGColor
{
    _ct1.textColor = [UIColor whiteColor];
    _ct2.textColor = [UIColor whiteColor];
    _ct3.textColor = [UIColor whiteColor];
    _ct4.textColor = [UIColor whiteColor];
    _ct5.textColor = [UIColor whiteColor];
    _ct6.textColor = [UIColor whiteColor];
    _ct7.textColor = [UIColor whiteColor];
    _ct8.textColor = [UIColor whiteColor];
    _ct9.textColor = [UIColor whiteColor];
}


@end
