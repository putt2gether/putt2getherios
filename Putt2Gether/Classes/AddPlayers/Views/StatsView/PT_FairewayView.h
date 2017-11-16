//
//  PT_FairewayView.h
//  Putt2Gether
//
//  Created by nivesh on 11/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_FairewayView : UIView

@property(strong,nonatomic) IBOutlet UIButton * hitBtn,*leftBtn,*rightBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *centreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end
