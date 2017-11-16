//
//  PT_PuttingView.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 02/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_PuttingView : UIView

@property(strong,nonatomic) IBOutlet UIButton *holeBtn; 

@property(strong,nonatomic) IBOutlet UIButton *girBtn;

@property(strong,nonatomic) IBOutlet UIButton *roundBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *centreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYHitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYMissedButton;

@end
