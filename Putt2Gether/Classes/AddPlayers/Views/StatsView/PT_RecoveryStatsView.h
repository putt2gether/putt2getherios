//
//  PT_RecoveryStatsView.h
//  Putt2Gether
//
//  Created by nivesh on 11/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_RecoveryStatsView : UIView

@property(strong,nonatomic) IBOutlet UIButton *scrambleBtn ,*sandBtn;

@property (weak, nonatomic) IBOutlet UILabel *scrambleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sandSavesLabel;

@end
