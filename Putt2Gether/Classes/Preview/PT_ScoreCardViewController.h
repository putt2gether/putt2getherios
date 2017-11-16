//
//  PT_ScoreCardViewController.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_ScoreCardViewController : UIViewController


@property(strong,nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *golfCourseLabel;

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model andPlayersArray:(NSArray *)playersArray;

-(IBAction)actionBack:(id)sender;

//Mark:-property declration for Banner Details

@property(weak,nonatomic) IBOutlet UIImageView *bannerImg;

@property(weak,nonatomic) IBOutlet UIButton *bannerBtn;

@property(strong,nonatomic) NSMutableArray *arrBanner;

@property(weak,nonatomic) IBOutlet UIButton *addScoreBtn,*leaderboardBtn;

@property(assign,nonatomic) BOOL isComingFromMyscore;

//Mark:-for improving tababr touch property declaration
@property(weak,nonatomic) IBOutlet UILabel *addScoreLbl,*leaderBoardLbl;

@property(weak,nonatomic) IBOutlet UIImageView *addScoreImg,*leaderBoardImg;

@property(weak,nonatomic) IBOutlet UIView *viewWithAddscoreCentre,*viewWithHtmldata;

@property(weak,nonatomic) IBOutlet NSLayoutConstraint *addScoreWidthConstraint;

@end
