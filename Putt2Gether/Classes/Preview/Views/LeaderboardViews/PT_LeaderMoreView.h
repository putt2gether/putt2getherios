//
//  PT_LeaderMoreView.h
//  Putt2Gether
//
//  Created by Bunny on 9/13/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PT_LeaderMoreDelegate <NSObject>

- (void)didSelectScoreBoard;

- (void)didSelectDelegate;

- (void)didSelectEndRound;

- (void)didSelectShare;

@end

@interface PT_LeaderMoreView : UIView

@property (nonatomic, assign) id <PT_LeaderMoreDelegate> delegate;




@property(strong,nonatomic) IBOutlet UIView *backgroundView;

@property(strong,nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)actionScorecardBtn:(id)sender;


@property(strong,nonatomic) IBOutlet NSLayoutConstraint *ConstraintendRound,*constraintDelegate,*ConstraintBottomView;







@end
