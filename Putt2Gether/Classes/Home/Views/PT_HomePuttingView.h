//
//  PT_HomePuttingView.h
//  Putt2Gether
//
//  Created by Devashis on 20/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_HomePuttingView : UIView

@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *missedButton;
@property (weak, nonatomic) IBOutlet UIButton *last10Button;
@property (weak, nonatomic) IBOutlet UIButton *girButton;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *centreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYHitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYMissedButton;

@end
