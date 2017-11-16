//
//  PT_ScoreCardSplFormatViewController.h
//  Putt2Gether
//
//  Created by Devashis on 20/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_StartEventViewController.h"

@interface PT_ScoreCardSplFormatViewController : UIViewController

@property (assign, nonatomic) NSInteger playerId;

@property (assign, nonatomic) NSInteger holeStartNumber;

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model;

//Mark:-property declration for Banner Details

@property(weak,nonatomic) IBOutlet UIImageView *bannerImg;

@property(weak,nonatomic) IBOutlet UIButton *bannerBtn;

@property(strong,nonatomic) NSMutableArray *arrBanner;

@property(weak,nonatomic) IBOutlet UIButton *addScoreBtn;

@property(assign,nonatomic) BOOL isComingFromMyscore;

@property(assign,nonatomic) BOOL isSeenAfterDelegate;

@property(weak,nonatomic) IBOutlet UIButton *htmlBtn;

@end
