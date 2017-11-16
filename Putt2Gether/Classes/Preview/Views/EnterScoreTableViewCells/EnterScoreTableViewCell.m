//
//  EnterScoreTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 26/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "EnterScoreTableViewCell.h"

@interface EnterScoreTableViewCell ()
{
    IBOutlet UIView *putActionView;
    IBOutlet UIView *sandActionView;
    IBOutlet UIView *scoreActionView;
}

@end

@implementation EnterScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBordersForActionViews
{
    putActionView.layer.cornerRadius = 4.0;
    putActionView.layer.borderWidth = 1.0;
    putActionView.layer.borderColor = [[UIColor clearColor] CGColor];
    putActionView.layer.masksToBounds = YES;
    
    sandActionView.layer.cornerRadius = 4.0;
    sandActionView.layer.borderWidth = 1.0;
    sandActionView.layer.borderColor = [[UIColor clearColor] CGColor];
    sandActionView.layer.masksToBounds = YES;
    
    scoreActionView.layer.cornerRadius = 4.0;
    scoreActionView.layer.borderWidth = 1.0;
    scoreActionView.layer.borderColor = [[UIColor clearColor] CGColor];
    scoreActionView.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionIncreamentGross:(UIButton *)sender
{
    sender.tag = self.tag;
    [self.startVC actionIncrementGross:sender];
}

- (IBAction)actionDecreamentGross:(UIButton *)sender
{
    sender.tag = self.tag;
    [self.startVC actionDecreamentGross:sender];
}

- (IBAction)actionIncreamentPuts:(UIButton *)sender
{
    sender.tag = self.tag;
    [self.startVC actionIncreamentPutts:sender];
}

- (IBAction)actionDecreamentPuts:(UIButton *)sender
{
    sender.tag = self.tag;
    [self.startVC actionDecreamentPutts:sender];
}


- (IBAction)actionFairwaysLeft:(id)sender
{
    [self.startVC actionLeftBtn:sender];
}

- (IBAction)actionFairwaysRight:(id)sender
{
    [self.startVC actionRightBtn:sender];
}

- (IBAction)actionFairwaysCentre:(id)sender
{
    [self.startVC actionHitBtn:sender];
}

- (IBAction)actionSandIncreament:(id)sender
{
    [self.startVC actionNoBtn:sender];
}

- (IBAction)actionSandDecreament:(id)sender
{
    [self.startVC actionYesBtn:sender];
}
@end
