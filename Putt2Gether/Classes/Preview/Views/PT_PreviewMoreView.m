//
//  PT_PreviewMoreView.m
//  Putt2Gether
//
//  Created by Devashis on 07/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_PreviewMoreView.h"

@interface PT_PreviewMoreView ()

@property (weak, nonatomic) IBOutlet UIButton *viewParticipantsButton;
@property (weak, nonatomic) IBOutlet UIButton *viewRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *editEventButton;
@property (weak, nonatomic) IBOutlet UIButton *selectScorerButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *viewParticipantsButtonNonAdmin;

@property (weak, nonatomic) IBOutlet UIView *upperHalfView;
@property (weak, nonatomic) IBOutlet UIView *lowerHalfView;
@property (weak, nonatomic) IBOutlet UIView *nonAdminView;

@end

@implementation PT_PreviewMoreView

- (void)setDefaultUIProperties:(BOOL)isAdmin
{
    if (isAdmin == YES)
    {
        _constraintLowerLeftViewX.constant = self.cancelButton.center.x - ((_editEventButton.frame.size.width *1.9));
        self.upperHalfView.hidden = NO;
        self.lowerHalfView.hidden = NO;
        self.nonAdminView.hidden = YES;
        self.viewParticipantsButton.layer.cornerRadius = self.viewParticipantsButton.frame.size.width/2;
        self.viewParticipantsButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.viewParticipantsButton.layer.borderWidth = 1.0;
        
        self.viewRequestButton.layer.cornerRadius = self.viewRequestButton.frame.size.width/2;
        self.viewRequestButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.viewRequestButton.layer.borderWidth = 1.0;
        
        self.editEventButton.layer.cornerRadius = self.editEventButton.frame.size.width/2;
        self.editEventButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.editEventButton.layer.borderWidth = 1.0;
        
        self.selectScorerButton.layer.cornerRadius = self.selectScorerButton.frame.size.width/2;
        self.selectScorerButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.selectScorerButton.layer.borderWidth = 1.0;
        
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.width/2;
        self.cancelButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.cancelButton.layer.borderWidth = 1.0;
        self.cancelButton.layer.masksToBounds = YES;
    }
    else
    {
        self.upperHalfView.hidden = YES;
        self.lowerHalfView.hidden = YES;
        self.nonAdminView.hidden = NO;
        self.viewParticipantsButtonNonAdmin.layer.cornerRadius = self.viewParticipantsButtonNonAdmin.frame.size.width/2;
        self.viewParticipantsButtonNonAdmin.layer.borderColor = [UIColor clearColor].CGColor;
        self.viewParticipantsButtonNonAdmin.layer.borderWidth = 1.0;
        //self.viewParticipantsButtonNonAdmin.layer.masksToBounds = YES;
    }
    
}

- (void)disableRequestButton:(BOOL)value
{
    
    self.viewRequestButton.userInteractionEnabled = !value;
    
}

- (IBAction)actionCancel
{
   // [self setHidden:YES];
    [self.delegate didCancelPreview];
}

- (IBAction)actionViewParticipants
{
    [self.delegate didSelectViewParticipants];
}

- (IBAction)actionViewRequests
{
    [self.delegate didSelectViewRequests];
}

- (IBAction)actionEditEvent
{
    [self.delegate didSelectEditEvent];
}

- (IBAction)actionSelectScorer
{
    [self.delegate didSelectSelectScorer];
}

@end
