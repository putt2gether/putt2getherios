//
//  PT_LeaderStrokeplayTableViewCell.h
//  Putt2Gether
//
//  Created by nivesh on 12/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_LeaderStrokeplayTableViewCell : UITableViewCell


@property (weak,nonatomic) IBOutlet UILabel *rankLabel,*playerLabel,*holeLabel,*strokelabel, *handicapLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPlayerWidth;

@end
