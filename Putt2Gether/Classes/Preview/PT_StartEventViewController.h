//
//  PT_StartEventViewController.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 31/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger FormatMatchPlayId = 10;

static NSInteger FormatAutoPressId = 11;

static NSInteger Format420Id = 12;//Change this

static NSInteger Format21Id = 14;//Change this

static NSInteger FormatVegasId = 13;//change this

#define SplFormatRedColor  [UIColor colorWithRed:(142/255.0f) green:(18/255.0f) blue:(18/255.0f) alpha:1.0];

#define SplFormatBlueColor  [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];

#define SplFormatGreenColor  [UIColor colorWithRed:(50/255.0f) green:(86/255.0f) blue:(4/255.0f) alpha:1.0];

#define SplFormatGrayColor  [UIColor colorWithRed:(228/255.0f) green:(228/255.0f) blue:(228/255.0f) alpha:1.0];

#define SplFormatRedTeamColor  [UIColor colorWithRed:(206/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0];

@interface PT_StartEventViewController : UIViewController
{
    int nbr;
    NSMutableArray *list;
    NSInteger selectedindex;
}

@property (strong, nonatomic) NSMutableArray *arrSplFormatLeaderboard;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn,*leaderBoardBtn;
-(IBAction)actionBottomBtn:(id)sender;

-(IBAction)actionLeaderBoard:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *popupView, *popupView2 , *tablebtnView;

@property (assign, nonatomic) BOOL isFront9;



//@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (weak, nonatomic) IBOutlet UIButton *incre1Btn;
- (IBAction)actionpopupViewBtn:(id)sender;

- (IBAction)actionIncre1:(id)sender;

- (IBAction)actionDecre1:(id)sender;

- (IBAction)actionIncre2:(id)sender;

- (IBAction)actionDecre2:(id)sender;





@property (weak, nonatomic) IBOutlet UILabel *closetLabel;

@property (weak, nonatomic) IBOutlet UILabel *closet2Label;

@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
- (IBAction)actionYesBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *noBtn;
- (IBAction)actionNoBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *DelegateBtn;

- (IBAction)actionDelegate:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *ScorecardBtn;

- (IBAction)actionScorecard:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *BTn1;

- (IBAction)actionBtn1:(id)sender;

- (IBAction)actionBtn2:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *Btn2;
- (IBAction)actionLeftArrow:(id)sender;

- (IBAction)actionRightArrow:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *Btn3;
- (IBAction)actionBtn3:(id)sender;

//@property (weak, nonatomic) IBOutlet UIButton *Btn4;
//- (IBAction)actionBtn4:(id)sender;

@property(weak,nonatomic) IBOutlet UIButton *leftBtn;

@property(weak,nonatomic) IBOutlet UIButton *hitBtn;

@property(weak,nonatomic) IBOutlet UIButton *rightBtn;

@property(weak,nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)actionbackBtn:(id)sender;


@property(weak,nonatomic) IBOutlet UIImageView *clickImageView1;
@property(weak,nonatomic) IBOutlet UIImageView *clickImageView2;
@property(strong,nonatomic) IBOutlet UIImageView *clickImageView3;
@property(weak,nonatomic) IBOutlet UIImageView *clickImageView4;

@property(weak,nonatomic) IBOutlet UIView *bottomCentreView;

@property(weak,nonatomic) IBOutlet UIView *bottomrightView;
@property(weak,nonatomic) IBOutlet UIView *bottomleftView;

@property(nonatomic,retain) NSNumber * number;
@property (weak, nonatomic) IBOutlet UIButton *tableBtn
;
- (IBAction)actionTableBtn:(id)sender;


- (instancetype)initWithEvent:(PT_CreatedEventModel *)model;

- (IBAction)actionIncrementGross:(UIButton *)sender;
- (IBAction)actionDecreamentGross:(UIButton *)sender;

- (IBAction)actionDecreamentPutts:(UIButton *)sender;
- (IBAction)actionIncreamentPutts:(UIButton *)sender;

- (IBAction)actionLeftBtn:(id)sender;
- (IBAction)actionHitBtn:(id)sender;
- (IBAction)actionRightBtn:(id)sender;


//Mark:-BottomView Buttons
@property(nonatomic,weak) IBOutlet UIButton *ScoreCardBottomBtn,*SaveBottomBtn,*scoreCentreBtn,*saveCentreBtn;
@property(nonatomic,weak) IBOutlet UILabel *scoreCentreLabel;

//Mark:-par hole Button
@property(weak,nonatomic) IBOutlet UIButton *parHoleBtn;

//Mark:-property declration for banner Details
@property(weak,nonatomic) IBOutlet UIView *bannnerView;

@property(weak,nonatomic) IBOutlet UIImageView *bannnerImg;

@property(weak,nonatomic) IBOutlet UIButton *bannnercloseBtn;

@property(strong,nonatomic) NSMutableArray *arrBanner;


//Mark:-End Round PopUp
@property(weak,nonatomic) IBOutlet UIView *popUpView,*popBackView,*loaderView,*loaderInsideView;


@end
