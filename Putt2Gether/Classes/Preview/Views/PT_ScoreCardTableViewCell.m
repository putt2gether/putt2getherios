//
//  PT_ScoreCardTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 13/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ScoreCardTableViewCell.h"

@interface PT_ScoreCardTableViewCell ()<UITextFieldDelegate>

{
    
}

@end

@implementation PT_ScoreCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDefaultBodering
{
    _c1.layer.borderWidth = 0.8;
    _c1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c2.layer.borderWidth = 0.8;
    _c2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c3.layer.borderWidth = 0.8;
    _c3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c4.layer.borderWidth = 0.8;
    _c4.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c5.layer.borderWidth = 0.8;
    _c5.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c6.layer.borderWidth = 0.8;
    _c6.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c7.layer.borderWidth = 0.8;
    _c7.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c8.layer.borderWidth = 0.8;
    _c8.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _c9.layer.borderWidth = 0.8;
    _c9.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _l1.layer.borderWidth = 0.8;
    _l1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _l2.layer.borderWidth = 0.8;
    _l2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setCBGColor
{
   /* _c1.backgroundColor = [UIColor colorWithRed:(7/255.0f) green:(65/255.0f) blue:(148/255.0f) alpha:1.0];
    _c2.backgroundColor = [UIColor colorWithRed:(111/255.0f) green:(163/255.0f) blue:(210/255.0f) alpha:1.0];
    _c3.backgroundColor = [UIColor colorWithRed:(7/255.0f) green:(65/255.0f) blue:(148/255.0f) alpha:1.0];
    _c4.backgroundColor = [UIColor colorWithRed:(128/255.0f) green:(129/255.0f) blue:(129/255.0f) alpha:1.0];
    _c5.backgroundColor = [UIColor colorWithRed:(111/255.0f) green:(163/255.0f) blue:(210/255.0f) alpha:1.0];
    _c6.backgroundColor = [UIColor colorWithRed:(128/255.0f) green:(129/255.0f) blue:(129/255.0f) alpha:1.0];
    _c7.backgroundColor = [UIColor blackColor];
    _c8.backgroundColor = [UIColor colorWithRed:(7/255.0f) green:(65/255.0f) blue:(148/255.0f) alpha:1.0];
    _c9.backgroundColor = [UIColor colorWithRed:(237/255.0f) green:(153/255.0f) blue:(52/255.0f) alpha:1.0];
    */
    
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
