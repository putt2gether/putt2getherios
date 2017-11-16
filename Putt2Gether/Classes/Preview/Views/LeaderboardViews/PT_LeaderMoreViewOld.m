//
//  PT_LeaderMoreView.m
//  Putt2Gether
//
//  Created by Bunny on 9/13/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_LeaderMoreView.h"

#import "PT_ScoreCardViewController.h"

@interface PT_LeaderMoreView ()

@property (weak, nonatomic) IBOutlet UIButton *scorecardBtn;
@property (weak, nonatomic) IBOutlet UIButton *delegateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endroundBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation PT_LeaderMoreView



-(IBAction)actioncloseBtn:(id)sender{
    
    
    
    [self hideview];
    
}
-(void)hideview
{
    [self setHidden:YES];
    [_backgroundView removeFromSuperview];
}
- (IBAction)actionScorecardBtn
{
    [self.delegate didSelectScoreBoard];
}

- (IBAction)actionDelegateBtn
{
    [self.delegate didSelectDelegate];
}

- (IBAction)actionEndRound
{
    [self.delegate didSelectEndRound];
}

- (IBAction)actionShare
{
    [self.delegate didSelectShare];
}

@end
