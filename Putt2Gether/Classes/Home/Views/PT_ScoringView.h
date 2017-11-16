//
//  PT_ScoringView.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 30/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_ScoringView : UIView
@property (weak, nonatomic) IBOutlet UIButton *par3sBtn;
@property (weak, nonatomic) IBOutlet UIButton *par4sBtn;
@property (weak, nonatomic) IBOutlet UIButton *par5sBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *centreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYHitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYMissedButton;

@end
