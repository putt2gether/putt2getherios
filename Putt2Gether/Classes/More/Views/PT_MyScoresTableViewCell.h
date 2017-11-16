//
//  PT_MyScoresTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 13/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_MyScoresTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *totalBgView;
@property (weak, nonatomic) IBOutlet UIImageView *winnerBgImage;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *venue;
@property (weak, nonatomic) IBOutlet UILabel *ranking;
@property (weak, nonatomic) IBOutlet UIImageView *imageBadge1;
@property (weak, nonatomic) IBOutlet UIImageView *imageBadge2;
@property (weak, nonatomic) IBOutlet UIImageView *imageBadge3;
@property (weak, nonatomic) IBOutlet UIImageView *imageBadge4;
@property (weak, nonatomic) IBOutlet UIImageView *imageWinnerCentre;

@property(weak,nonatomic) IBOutlet UIButton *popBtn;

@end
