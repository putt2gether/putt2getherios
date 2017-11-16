//
//  PT_PuttingStatsView.h
//  Putt2Gether
//
//  Created by nivesh on 11/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_PuttingStatsView : UIView

@property (strong,nonatomic) IBOutlet UIButton *holeBtn,*girBtn,*roundBtn;

@property (weak, nonatomic) IBOutlet UILabel *perHoleLabel;

@property (weak, nonatomic) IBOutlet UILabel *perGirLabel;

@property (weak, nonatomic) IBOutlet UILabel *perRoundLabel;


@end
