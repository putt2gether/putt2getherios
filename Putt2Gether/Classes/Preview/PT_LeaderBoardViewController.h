//
//  PT_LeaderBoardViewController.h
//  Putt2Gether
//
//  Created by Bunny on 9/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_LeaderMoreView.h"

#import "PT_EventPreviewViewController.h"

@interface PT_LeaderBoardViewController : UIViewController 

@property (strong,nonatomic)  IBOutlet UIButton *backBtn  ,*strokeBtn,*closestBtn,*longBtn,*straightBtn;

@property (weak, nonatomic) IBOutlet UILabel *golfCourseLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (strong, nonatomic) PT_EventPreviewViewController *eventPreviewVC;

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model;

-(IBAction)actionBack:(id)sender;

-(IBAction)actionStroke:(id)sender;

-(IBAction)actionhome:(id)sender;

-(IBAction)actionAddScore:(id)sender;

-(IBAction)actionClosest:(id)sender;

-(IBAction)actionLong:(id)sender;

- (IBAction)homeBtnClicked:(id)sender;

-(IBAction)actionStraight:(id)sender;

@property(strong,nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) IBOutlet UIButton *netstrokeBtn,*bannerTapBtn,*addScoreBtn;
-(IBAction)actionNetstroke:(id)sender;

@property (nonatomic,strong) IBOutlet UILabel *holesplayedLabel;

@property(weak,nonatomic) IBOutlet UIImageView *clickImageView1;
@property(weak,nonatomic) IBOutlet UIImageView *clickImageView2;
@property(weak,nonatomic) IBOutlet UIImageView *clickImageView3;
@property(weak,nonatomic) IBOutlet UIImageView *clickImageView4;

- (IBAction)actionMore:(id)sender;

@property(weak,nonatomic) IBOutlet UIImageView *bannerImg;

@property(assign,nonatomic) BOOL isSeenAfterDelegate;

//Mark:- property declaration for mantainig tabbar
@property(weak,nonatomic) IBOutlet UILabel *addScoreLAbel;

@property(weak,nonatomic) IBOutlet UIImageView *addScoreImg;

@end
