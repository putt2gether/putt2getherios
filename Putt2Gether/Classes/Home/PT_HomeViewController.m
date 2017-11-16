//
//  PT_HomeViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_HomeViewController.h"

#import "PT_HomeLowerView.h"

#import "UIView+Hierarchy.h"

#import "PT_HomePuttingView.h"
#import "PT_ScoringView.h"
#import "PT_PuttingView.h"
#import "PT_Last10View.h"

#import "PT_NotificationsModel.h"

#import "PT_StatsViewController.h"

#import "UITabBarController+Designing.h"

#import "PT_StartEventViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

static NSString *const GetUpcomingEventPostfix = @"getupcomingeventlist";

static NSString *const GetPieChartDataPostfix = @"getstatspichart";

static NSString *const GetGirStats = @"getgirstats";

static NSString *const GetRecoveryStats = @"getrecoverystats";

static NSString *const GetFairwayStats = @"getfairwaystats";
static NSString *const ScoringAvgPostfixFairwayStats = @"getscorestats";

static NSString *const GetStatsPostfix = @"getstats";

static NSString *TabHomeImage = @"stats";


@interface PT_HomeViewController ()<XYPieChartDataSource,XYPieChartDelegate, UIScrollViewDelegate>
{
    BOOL isReloadPieChart;
    BOOL isAppFirstLoad;
}

@property (strong, nonatomic)PT_StatsViewController *statViewController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightDownView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthPieChart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightPieChart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYAxisPieChart;


@property (weak, nonatomic) PT_Last10View *last10View;


@property (weak, nonatomic) IBOutlet UIView *lowerView;
@property (assign,nonatomic) NSInteger constraintYHitButton;
@property (assign, nonatomic) NSInteger constraintYMissedButton;
@property (assign, nonatomic) float gapWidthLowerView;
@property (assign, nonatomic) float scrollVerticalDelta;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic)IBOutlet UIPageControl *pageControl;

@property (assign, nonatomic) BOOL isConstaraintApplicable;

@property (strong, nonatomic) UIButton *buttonPercentageLevel;

//Lower Views Sliding
@property (strong, nonatomic)PT_HomeLowerView *lower1;
@property (strong, nonatomic)PT_HomeLowerView *lowerRecovery;
@property (strong, nonatomic) PT_ScoringView *scoringAvgView;
@property (strong, nonatomic) PT_PuttingView *puttingView;

@property (strong, nonatomic) PT_HomePuttingView *lower1Fairways;

//Upcoming Event
@property (weak, nonatomic) IBOutlet UILabel *upcomingEventName;
@property (weak, nonatomic) IBOutlet UILabel *upcomingEventGolfCourseName;
@property (weak, nonatomic) IBOutlet UILabel *upcomingEventDate;
@property (weak, nonatomic) IBOutlet UILabel *upcomingEventHeader;
@property (strong, nonatomic) NSString *currentEventId;
@property (assign, nonatomic) NSInteger birdieCount;
@property (assign, nonatomic) NSInteger parCount;
@property (assign, nonatomic) NSInteger bogeyCount;
@property (assign, nonatomic) NSInteger dBogeyCount;
@property (assign, nonatomic) NSInteger eagleCount;
@property (strong, nonatomic) NSString *avgScore;
@property (strong, nonatomic) NSString *currentIndex,*isResumeStatus;

//Scroll view Contents
//Gir View Stats
@property (strong, nonatomic) NSString *girStatsHit;
@property (strong, nonatomic) NSString *girStatsMissed;

//Recovery Stats
@property (strong, nonatomic) NSString *recoveryStatsHit;
@property (strong, nonatomic) NSString *recoveryMissed;

//Fairway
@property (strong, nonatomic) NSString *fairwaysLeft;
@property (strong, nonatomic) NSString *fairwaysRight;
@property (strong, nonatomic) NSString *fairwaysCentre;

//Putting
@property (strong, nonatomic) NSString *puttLeft;
@property (strong, nonatomic) NSString *puttRight;
@property (strong, nonatomic) NSString *puttCentre;

//Scoring Average
@property (strong, nonatomic) NSString *scoringAverageLeft;
@property (strong, nonatomic) NSString *scoringRight;
@property (strong, nonatomic) NSString *scoringCentre;

//Number of events
@property (assign, nonatomic) NSInteger numberOfEvents;

@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

//upcoming event redirection
@property (assign, nonatomic) BOOL isRequestToParticipate;

@property(weak,nonatomic) IBOutlet UILabel *bottomUpcomingLbl;

@property(strong,nonatomic) MBProgressHUD *hud;

@property(strong,nonatomic) NSTimer *timer;


@end

@implementation PT_HomeViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isAppFirstLoad = YES;
    
    //[self.pieChartLeft reloadData];
    
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePieChartPercentToggle:)];
    _upcomingEventView.hidden = YES;
    [self customdesign];
    
    UIView *button2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button2View.backgroundColor = [UIColor redColor];
    button2View.hidden=YES;
    _buttonView.hidden = YES;
    _last10View.hidden = YES;
    
       
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LayersAdded:) name:@"LayersAdded" object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.slices = [NSMutableArray arrayWithCapacity:5];
    
    [self.pieChartLeft setDataSource:self];
    [self.pieChartLeft setStartPieAngle:M_PI_2];
    [self.pieChartLeft setAnimationSpeed:1.0];
    [self.pieChartLeft setLabelRadius:160];
    [self.pieChartLeft setLabelColor:[UIColor whiteColor]];
    [self.pieChartLeft setShowPercentage:YES];
    [self.pieChartLeft setPieBackgroundColor:[UIColor whiteColor]];
    [self.pieChartLeft setUserInteractionEnabled:YES];
    [self.pieChartLeft setLabelShadowColor:[UIColor clearColor]];
    
    //[self setPieChart];
        //[self setUpScrollForLowerView];
    //[self initializeCallsForNumberOfEvents:1];
    
    _numberOfEvents = 10;
    
    _statViewController = [PT_StatsViewController new];
    _statViewController.homeVC = self;
    
   _timer =  [NSTimer scheduledTimerWithTimeInterval:.55 target:self selector:@selector(startOrientationNotifications) userInfo:nil repeats: NO];
    
    
    
    
    
}

-(void)startOrientationNotifications {
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isReloadPieChart = NO;
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation ==  UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        
        
            
        }
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    
//    if (delegate.tabBarController.tabBar) {
//        
//        [delegate.tabBarController.tabBar removeFromSuperview];
//    }
//    
//    
//    [delegate.tabBarController setDeisgnForOrientaion];

    
  }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.pieChartLeft reloadData];
    
    
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    if ([UIScreen mainScreen].bounds.size.height == 568) {
        _last10Btn.frame = CGRectMake(122, 425, 80, 25); //iphone 5
    } else
        if([UIScreen mainScreen].bounds.size.height == 667){
            _last10Btn.frame = CGRectMake(145, 525, 80, 25); //iphone 6
        }
        else
        if([UIScreen mainScreen].bounds.size.height == 736){
            _last10Btn.frame = CGRectMake(168, 595, 80, 25); //iphone 6s
        }else{
            
            _last10Btn.frame = CGRectMake(self.view.frame.size.width/2 - 40, self.pageControl.frame.origin.y - 20, 80, 25); //ipad

        }
    
}

- (float)getCurrentIndexFontSize
{
    if (self.currentIndex.length<3)
    {
        return 60.0;
    }
    else
    {
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            return 50.0;
        }
        else
        {
            return 60.0;
        }
    }
    
}
- (void)handlePieChartPercentToggle:(UITapGestureRecognizer *)recognizer
{
    if (self.buttonPercentageLevel.tag == 0)
    {
        self.buttonPercentageLevel.tag = 1;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.currentIndex];
        
        /*[attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:60.0f]
                                 range:NSMakeRange(0, self.currentIndex.length)];*/
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:[self getCurrentIndexFontSize]]
                                 range:NSMakeRange(0, self.currentIndex.length)];
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:34/255.0 green:49/255.0 blue:63/255.0 alpha:1]
                                 range:NSMakeRange(0, self.currentIndex.length)];
        _percentageLabel.attributedText = attributedString;
    }
    else
    {
        self.buttonPercentageLevel.tag = 0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.avgScore];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:60.0f]
                                 range:NSMakeRange(0, self.avgScore.length)];
        
        
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:34/255.0 green:49/255.0 blue:63/255.0 alpha:1]
                                 range:NSMakeRange(0, self.avgScore.length)];
        _percentageLabel.attributedText = attributedString;
    }
}
- (void)actionPercentageToggle
{
    if (self.buttonPercentageLevel.tag == 1)
    {
        self.buttonPercentageLevel.tag = 2;
        [self setPieChart];
    }
    else
    {
        self.buttonPercentageLevel.tag = 1;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.currentIndex];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:78.0f]
                                 range:NSMakeRange(0, self.avgScore.length)];
        
        
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:34/255.0 green:49/255.0 blue:63/255.0 alpha:1]
                                 range:NSMakeRange(0, self.avgScore.length)];
        _percentageLabel.attributedText = attributedString;
    }
}
- (void)setLowerViewContentConstraints
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        int screenHeight = screenRect.size.height;
        if (screenHeight == 568)
        {
            self.constraintHeightDownView.constant = 170;
            self.constraintYHitButton = 5;
            self.constraintYMissedButton = 5;
            self.isConstaraintApplicable = YES;
            self.gapWidthLowerView = 95;
            self.scrollVerticalDelta = 160;
            [self setUpScrollForLowerView];
        }
        else if (screenHeight == 667)
        {
            self.constraintHeightDownView.constant = 220;
            self.constraintYHitButton = 32;
            self.constraintYMissedButton = 32;
            self.isConstaraintApplicable = YES;
            self.gapWidthLowerView = 40;
            self.scrollVerticalDelta = 110;
            [self setUpScrollForLowerView];
        }
        else if (screenHeight == 736)
        {
            self.constraintHeightDownView.constant = 260;
            self.constraintYHitButton = 32;
            self.constraintYMissedButton = 32;
            self.isConstaraintApplicable = YES;
            self.gapWidthLowerView = 40;
            self.scrollVerticalDelta = 110;
            [self setUpScrollForLowerView];
            
        }
        //Added for Ipad compatibilty
        else{
            
            self.constraintHeightDownView.constant = 260;
            self.constraintYHitButton = 32;
            self.constraintYMissedButton = 32;
            self.isConstaraintApplicable = YES;
            self.gapWidthLowerView = 40;
            self.scrollVerticalDelta = 110;
            [self setUpScrollForLowerView];
        }
    });
    
}
- (void)setPieChart
{
    self.percentageLabel.backgroundColor = [UIColor redColor];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    if (screenHeight == 568)
    {
        [self setAttributedPropertiesWithHeight:10.0  BoldHeight:10.0];
        self.constraintWidthPieChart.constant = 210;
        self.constraintHeightPieChart.constant = 210;
        self.constraintYAxisPieChart.constant = 8;
        [self.pieChartLeft setPieCenter:CGPointMake(106, 104)];
        [self.pieChartLeft setPieRadius:78];
        [self.pieChartLeft setLabelFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
        
        //self.constraintHeightDownView.constant = 170;
        [self.pieChartLeft setLabelRadius:67];
        
        if (_percentBGView == nil)
            
        {
            _percentBGView = [UIView new];
            [self.percentBGView setFrame:CGRectMake(50,
                                                    50,
                                                    self.pieChartLeft.frame.size.width - 130,
                                                    self.pieChartLeft.frame.size.height - 130)];
        }
        if (_percentageLabel == nil)
        {
            _percentageLabel = [UILabel new];
            
            [self.percentageLabel setFrame:CGRectMake(6.5,
                                                      6.5,
                                                      self.percentBGView.frame.size.width - 13,
                                                      self.percentBGView.frame.size.height - 13)];
            [self.percentBGView addSubview:self.percentageLabel];
            [self.percentBGView addGestureRecognizer:_tapGestureRecognizer];
            //[self.percentageLabel addGestureRecognizer:_tapGestureRecognizer];
            //[self.percentageLabel bringToFront];
            [self.pieChartLeft bringToFront];
            
        }
        
        
        if ([self.avgScore length] == 0 ||[self.avgScore isEqualToString:@"(null)"]|| [self.avgScore isEqualToString:@"-"])
        {
            self.avgScore = @"--          AVG. SCORE";
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.avgScore];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:60.0f]
                                 range:NSMakeRange(0, self.avgScore.length)];
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:34/255.0 green:49/255.0 blue:63/255.0 alpha:1]
                                 range:NSMakeRange(0, self.avgScore.length)];
        
        NSString *pattern = @"AVG. SCORE";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        
        //  enumerate matches
        NSRange range = NSMakeRange(0,[self.avgScore length]);
        [expression enumerateMatchesInString:self.avgScore options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange californiaRange = [result rangeAtIndex:0];
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Lato-Regular" size:9.0f]
                                     range:californiaRange];
        }];
        /*[attributedString addAttribute:NSFontAttributeName
         value:[UIFont fontWithName:@"Lato-Regular" size:9.0f]
         range:NSMakeRange(5, 17)];*/
        
        _percentageLabel.attributedText = attributedString;
        
        
        self.percentageLabel.backgroundColor = [UIColor colorWithRed:(235/255.0f) green:(240/255.0f) blue:(246/255.0f) alpha:1.0];
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        self.percentageLabel.numberOfLines = 0;
        self.percentageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.percentBGView setBackgroundColor:[UIColor whiteColor]];
        [self.pieChartLeft addSubview:self.percentBGView];
        
        [self.percentBGView.layer setCornerRadius:self.percentBGView.frame.size.width /2];
        [self.percentageLabel.layer setCornerRadius:self.percentageLabel.frame.size.height /2];
        self.percentageLabel.layer.masksToBounds = YES;
        
        //self.constraintYHitButton.constant = 5;
        //self.constraintYMissedButton.constant = 5;
        //self.constraintYHitButton = 5;
        //self.constraintYMissedButton = 5;
        //self.isConstaraintApplicable = YES;
        //self.gapWidthLowerView = 95;
        //self.scrollVerticalDelta = 160;
    }
    else if (screenHeight == 667)
    {
        
        [self setAttributedPropertiesWithHeight:12.0  BoldHeight:12.0];
        self.constraintYAxisPieChart.constant = 15;
        [self.pieChartLeft setPieCenter:CGPointMake(120, 118)];
        [self.pieChartLeft setPieRadius:98];
        //self.constraintHeightDownView.constant = 220;
        [self.pieChartLeft setLabelRadius:85];
        [self.pieChartLeft setLabelColor:[UIColor whiteColor]];
        
        
        
        if (_percentBGView == nil)
        {
            _percentBGView = [UIView new];
            [self.percentBGView setFrame:CGRectMake(45.5,
                                                    46.5,
                                                    self.pieChartLeft.frame.size.width - 95,
                                                    self.pieChartLeft.frame.size.height - 95)];
        }
        if (_percentageLabel == nil)
        {
            _percentageLabel = [UILabel new];
            
            [self.percentageLabel setFrame:CGRectMake(8.5,
                                                      8.5,
                                                      self.percentBGView.frame.size.width - 17.5,
                                                      self.percentBGView.frame.size.height - 17.5)];
            [self.percentBGView addSubview:self.percentageLabel];
            [self.percentBGView addGestureRecognizer:_tapGestureRecognizer];
            //[self.percentageLabel addGestureRecognizer:_tapGestureRecognizer];
            //[self.percentageLabel bringToFront];
            //[self.pieChartLeft bringToFront];
            //self.percentageLabel.backgroundColor = [UIColor redColor];
            
        }
        NSString *text = [NSString stringWithFormat:@"%@            AVG. SCORE",self.avgScore];
        if ([self.avgScore length] == 0  ||[self.avgScore isEqualToString:@"(null)"] || [self.avgScore isEqualToString:@"-"])
        {
            text = [NSString stringWithFormat:@"--\n AVG. SCORE"];//@"--     AVG. SCORE";
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:78.0f]
                                 range:NSMakeRange(0, 2)];
        
        
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:34/255.0 green:49/255.0 blue:63/255.0 alpha:1]
                                 range:NSMakeRange(0, 7)];
        NSString *pattern = @"AVG. SCORE";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        
        //  enumerate matches
        NSRange range = NSMakeRange(0,[text length]);
        [expression enumerateMatchesInString:text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange californiaRange = [result rangeAtIndex:0];
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Lato-Regular" size:9.0f]
                                     range:californiaRange];
        }];
        /*[attributedString addAttribute:NSFontAttributeName
         value:[UIFont fontWithName:@"Lato-Regular" size:11.0f]
         range:NSMakeRange(5, 17)];*/
        
        _percentageLabel.attributedText = attributedString;
        
        self.percentageLabel.backgroundColor = [UIColor colorWithRed:(235/255.0f) green:(240/255.0f) blue:(246/255.0f) alpha:1.0];
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        
        self.pieChartLeft.labelFont = [UIFont fontWithName:@"Lato-Regular" size:13];
        self.pieChartLeft.labelShadowColor = [UIColor clearColor];
        self.pieChartLeft.labelColor = [UIColor blackColor];
        
        self.percentageLabel.numberOfLines = 0;
        self.percentageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.percentBGView setBackgroundColor:[UIColor whiteColor]];
        [self.pieChartLeft addSubview:self.percentBGView];
        
        [self.percentBGView.layer setCornerRadius:self.percentBGView.frame.size.width /2];
        [self.percentageLabel.layer setCornerRadius:self.percentageLabel.frame.size.height /2];
        self.percentageLabel.layer.masksToBounds = YES;
        
        //self.constraintYHitButton.constant = 42;
        //self.constraintYMissedButton.constant = 42;
        //self.constraintYHitButton = 32;
        //self.constraintYMissedButton = 32;
        //self.isConstaraintApplicable = YES;
        //self.gapWidthLowerView = 40;
        //self.scrollVerticalDelta = 110;
        
    }
    else if (screenHeight == 736)
    {
        [self setAttributedPropertiesWithHeight:12.0  BoldHeight:12.0];
        self.constraintWidthPieChart.constant = 260;
        self.constraintHeightPieChart.constant = 260;
        self.constraintYAxisPieChart.constant = 34;
        [self.pieChartLeft setPieCenter:CGPointMake(130, 130)];
        [self.pieChartLeft setLabelRadius:105];
        //self.constraintHeightDownView.constant = 260;
        if (_percentBGView == nil)
        {
            _percentBGView = [UIView new];

            [self.percentBGView setFrame:CGRectMake(45,
                                                    45,
                                                    self.pieChartLeft.frame.size.width - 70,
                                                    self.pieChartLeft.frame.size.height - 70)];
        }
        if (_percentageLabel == nil)
        {
            _percentageLabel = [UILabel new];
            
            [self.percentageLabel setFrame:CGRectMake(20,
                                                      20,
                                                      self.percentBGView.frame.size.width - 40,
                                                      self.percentBGView.frame.size.height - 40)];
            [self.percentBGView addSubview:self.percentageLabel];
            [self.percentBGView addGestureRecognizer:_tapGestureRecognizer];
            //[self.percentageLabel addGestureRecognizer:_tapGestureRecognizer];
        }
        
        NSString *text = [NSString stringWithFormat:@"%@            AVG. SCORE",self.avgScore];
        if ([self.avgScore length] == 0  ||[self.avgScore isEqualToString:@"(null)"] || [self.avgScore isEqualToString:@"-"])
        {
            text = [NSString stringWithFormat:@"--\n AVG. SCORE"];//@"--     AVG. SCORE";
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:78.0f]
                                 range:NSMakeRange(0, 2)];
        
        
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:34/255.0 green:49/255.0 blue:63/255.0 alpha:1]
                                 range:NSMakeRange(0, 7)];
        NSString *pattern = @"AVG. SCORE";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        
        //  enumerate matches
        NSRange range = NSMakeRange(0,[text length]);
        [expression enumerateMatchesInString:text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange californiaRange = [result rangeAtIndex:0];
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Lato-Regular" size:9.0f]
                                     range:californiaRange];
        }];
        /*[attributedString addAttribute:NSFontAttributeName
         value:[UIFont fontWithName:@"Lato-Regular" size:11.0f]
         range:NSMakeRange(5, 17)];*/
        
        _percentageLabel.attributedText = attributedString;
        
        self.percentageLabel.backgroundColor = [UIColor colorWithRed:(235/255.0f) green:(240/255.0f) blue:(246/255.0f) alpha:1.0];
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        
        self.pieChartLeft.labelFont = [UIFont fontWithName:@"Lato-Regular" size:13];
        self.pieChartLeft.labelShadowColor = [UIColor clearColor];
        self.pieChartLeft.labelColor = [UIColor blackColor];
        
        self.percentageLabel.numberOfLines = 0;
        self.percentageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.percentBGView setBackgroundColor:[UIColor whiteColor]];
        [self.pieChartLeft addSubview:self.percentBGView];
        [self.pieChartLeft setPieRadius:120];

        [self.percentBGView.layer setCornerRadius:self.percentBGView.frame.size.width /2];
        [self.percentageLabel.layer setCornerRadius:self.percentageLabel.frame.size.height /2];
        self.percentageLabel.layer.masksToBounds = YES;

        //self.gapWidthLowerView = 1;
    }
    // Added for ipad compatibility
    else{
        
        [self setAttributedPropertiesWithHeight:16.0  BoldHeight:16.0]; //12.0
        self.constraintWidthPieChart.constant = 280;  //260
        self.constraintHeightPieChart.constant = 280;  //260
        self.constraintYAxisPieChart.constant = 34;
        [self.pieChartLeft setPieCenter:CGPointMake(140, 140)]; //130
        [self.pieChartLeft setLabelRadius:140];  //180
        //self.constraintHeightDownView.constant = 260;
        if (_percentBGView == nil)
        {
            _percentBGView = [UIView new];

            [self.percentBGView setFrame:CGRectMake(20,
                                                    20,
                                                    self.pieChartLeft.frame.size.width ,
                                                    self.pieChartLeft.frame.size.height)];  //70 x,y are 45
        }
        if (_percentageLabel == nil)
        {
            _percentageLabel = [UILabel new];
            
            [self.percentageLabel setFrame:CGRectMake(15,
                                                      15,
                                                      self.percentBGView.frame.size.width - 30,
                                                      self.percentBGView.frame.size.height - 30)]; //20
            [self.percentBGView addSubview:self.percentageLabel];
            [self.percentBGView addGestureRecognizer:_tapGestureRecognizer];
            //[self.percentageLabel addGestureRecognizer:_tapGestureRecognizer];
        }
        
        
        NSString *text = [NSString stringWithFormat:@"%@                   AVG. SCORE",self.avgScore];
        if ([self.avgScore length] == 0  ||[self.avgScore isEqualToString:@"(null)"] || [self.avgScore isEqualToString:@"-"])
        {
            text = [NSString stringWithFormat:@"--\n AVG. SCORE"];//@"--     AVG. SCORE";
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Lato-Bold" size:100.0f]
                                 range:NSMakeRange(0, 2)];
        
        
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:34/255.0 green:49/255.0 blue:63/255.0 alpha:1]
                                 range:NSMakeRange(0, 7)];
        NSString *pattern = @"AVG. SCORE";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        
        //  enumerate matches
        NSRange range = NSMakeRange(0,[text length]);
        [expression enumerateMatchesInString:text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange californiaRange = [result rangeAtIndex:0];
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Lato-Regular" size:20.0f]
                                     range:californiaRange];
        }];
        /*[attributedString addAttribute:NSFontAttributeName
         value:[UIFont fontWithName:@"Lato-Regular" size:11.0f]
         range:NSMakeRange(5, 17)];*/
        
        _percentageLabel.attributedText = attributedString;
        
        self.percentageLabel.backgroundColor = [UIColor colorWithRed:(235/255.0f) green:(240/255.0f) blue:(246/255.0f) alpha:1.0];
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        
        self.pieChartLeft.labelFont = [UIFont fontWithName:@"Lato-Regular" size:13];
        self.pieChartLeft.labelShadowColor = [UIColor clearColor];
        self.pieChartLeft.labelColor = [UIColor blackColor];
        [self.pieChartLeft setPieRadius:160];

        
        self.percentageLabel.numberOfLines = 0;
        self.percentageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.percentBGView setBackgroundColor:[UIColor whiteColor]];
        [self.pieChartLeft addSubview:self.percentBGView];
        
        [self.percentBGView.layer setCornerRadius:self.percentBGView.frame.size.width /2];
        [self.percentageLabel.layer setCornerRadius:self.percentageLabel.frame.size.height /2];
        self.percentageLabel.layer.masksToBounds = YES;

    }
    
    
    if (_buttonPercentageLevel != nil)
    {
        [_buttonPercentageLevel removeFromSuperview];
        _buttonPercentageLevel = nil;
    }
    _buttonPercentageLevel = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonPercentageLevel.backgroundColor = [UIColor clearColor];
    _buttonPercentageLevel.frame = self.percentageLabel.frame;
    [self.pieChartLeft addSubview:_buttonPercentageLevel];
    self.buttonPercentageLevel.tag = 0;
    //[_buttonPercentageLevel addTarget:self action:@selector(actionPercentageToggle) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.pieChartLeft reloadData];
}

-(void)customdesign
{
    _last10Btn.layer.cornerRadius = 12.0f;
    _last10Btn.clipsToBounds = YES;
}

- (void)setAttributedPropertiesWithHeight:(CGFloat)height BoldHeight:(CGFloat)boldHeight
{
    NSMutableArray * arrColors = [NSMutableArray new];
    /*if (self.sliceColors == nil)
     {
     self.sliceColors =[NSArray arrayWithObjects:
     [UIColor colorWithRed:10/255.0 green:92/255.0 blue:135/255.0 alpha:1],
     [UIColor colorWithRed:50/255.0 green:86/255.0 blue:4/255.0 alpha:1],
     [UIColor colorWithRed:147/255.0 green:148/255.0 blue:148/255.0 alpha:1],
     
     [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1],
     [UIColor colorWithRed:244/255.0 green:170/255.0 blue:67/255.0 alpha:1],nil];
     }
     */
    NSNumber *one,*two, *three,*four,*five;
    [_slices removeAllObjects];
    if (_birdieCount == 0 &&
        _parCount == 0 &&
        _bogeyCount == 0 &&
        _dBogeyCount == 0 &&
        _eagleCount == 0)
        
    {
        self.pieChartLeft.isAllValueZero = YES;
        self.pieChartLeft.arrNames = nil;
        self.pieChartLeft.arrNames = [NSMutableArray new];
        
        if (self.sliceColors == nil)
        {
            self.sliceColors =[NSArray arrayWithObjects:
                               [UIColor colorWithRed:10/255.0 green:92/255.0 blue:135/255.0 alpha:1],
                               [UIColor colorWithRed:50/255.0 green:86/255.0 blue:4/255.0 alpha:1],
                               [UIColor colorWithRed:147/255.0 green:148/255.0 blue:148/255.0 alpha:1],
                               
                               [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1],
                               [UIColor colorWithRed:244/255.0 green:170/255.0 blue:67/255.0 alpha:1],nil];
        }
        
        one = [NSNumber numberWithInt:20];
        [_slices addObject:one];
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"BIRDIE \n %@%%",one]];
        one = [NSNumber numberWithInt:0];
        
        two = [NSNumber numberWithInt:20];
        [_slices addObject:two];
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"PAR \n %@%%",two]];
        two = [NSNumber numberWithInt:0];
        
        three = [NSNumber numberWithInt:20];
        [_slices addObject:three];
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"BOGEY \n %@%%",three]];
        [arrColors addObject:[UIColor colorWithRed:147/255.0 green:148/255.0 blue:148/255.0 alpha:1]];
        three = [NSNumber numberWithInt:0];
        
        four = [NSNumber numberWithInt:20];
        [_slices addObject:four];
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"D.BOGEY+ \n %@%%",four]];
        four = [NSNumber numberWithInt:0];
        
        five = [NSNumber numberWithInt:20];
        [_slices addObject:five];
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"EAGLE+ \n %@%%",five]];
        five = [NSNumber numberWithInt:0];
        
        //[self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"BIRDIE \n %@%%",one]];
    
        //[self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"PAR \n %@%%",two]];
    
        //[self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"BOGEY \n %@%%",three]];
    
        //[self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"D.BOGEY+ \n %@%%",four]];
    
        //[self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"EAGLE+ \n %@%%",five]];
        
        
    }
    else
    {
        self.pieChartLeft.isAllValueZero = NO;
        if (_birdieCount)
        {
            one = [NSNumber numberWithInteger:_birdieCount];
            [_slices addObject:one];
            [arrColors addObject:[UIColor colorWithRed:10/255.0 green:92/255.0 blue:135/255.0 alpha:1]];
        }
        if (_parCount)
        {
            two = [NSNumber numberWithInteger:_parCount];
            [_slices addObject:two];
            [arrColors addObject:[UIColor colorWithRed:50/255.0 green:86/255.0 blue:4/255.0 alpha:1]];
        }
        if (_bogeyCount)
        {
            three = [NSNumber numberWithInteger:_bogeyCount];
            [_slices addObject:three];
            [arrColors addObject:[UIColor colorWithRed:147/255.0 green:148/255.0 blue:148/255.0 alpha:1]];
        }
        if (_dBogeyCount)
        {
            four = [NSNumber numberWithInteger:_dBogeyCount];
            [_slices addObject:four];
            [arrColors addObject:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
        }
        if (_eagleCount)
        {
            five = [NSNumber numberWithInteger:_eagleCount];
            [_slices addObject:five];
            [arrColors addObject:[UIColor colorWithRed:244/255.0 green:170/255.0 blue:67/255.0 alpha:1]];
        }
        self.sliceColors = nil;
        self.sliceColors = [NSArray arrayWithArray:arrColors];
    }
    
    
    
    //self.pieChartLeft.arrNames = [NSMutableArray new];
    self.pieChartLeft.arrNames = nil;
    self.pieChartLeft.arrNames = [NSMutableArray new];
    
    
    if (_birdieCount != 0)
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"BIRDIE \n %@%%",one]];
    
    if (_parCount != 0)
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"PAR \n %@%%",two]];
    
    if (_bogeyCount != 0)
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"BOGEY \n %@%%",three]];
    
    if (_dBogeyCount != 0)
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"D.BOGEY+ \n %@%%",four]];
    
    if (_eagleCount != 0)
        [self.pieChartLeft.arrNames addObject:[NSString stringWithFormat:@"EAGLE+ \n %@%%",five]];
    
    
    [self.pieChartLeft reloadData];
    
    if (_hud != nil) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }
    
    

    
}

/*- (void)viewDidAppear:(BOOL)animated
 {
 [super viewDidAppear:animated];
 [self.pieChartLeft reloadData];
 //[self.pieChartRight reloadData];
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self setLowerViewContentConstraints];
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (isReloadPieChart == YES)
    {
        isReloadPieChart = NO;
        if (delegate.isStatsSelected == YES)
        {
            [self addChildViewController:self.statViewController];
            self.statViewController.view.frame = [self.view bounds];
            [self.view addSubview:self.self.statViewController.view];
            [self.statViewController didMoveToParentViewController:self];
        }
    }
    else
    {
        if (delegate.isStatsSelected == YES)
        {
            [self addChildViewController:self.statViewController];
            self.statViewController.view.frame = [self.view bounds];
            [self.view addSubview:self.self.statViewController.view];
            [self.statViewController didMoveToParentViewController:self];
        }
        else
        {
            /*/dispatch_async(dispatch_get_main_queue(), ^{
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.tabBarController.tabBar.hidden = NO;
                
            });*/
           [self fetchAllStatsForNumberOfEvents:[NSString stringWithFormat:@"%li",(long)_numberOfEvents]];
            [self.statViewController willMoveToParentViewController:nil];
            [self.statViewController.view removeFromSuperview];
            [self.statViewController removeFromParentViewController];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                 [self fetchUpcomingMeetings];
            });
            
           
            
            if (_numberOfEvents == 0)
            {
                [_last10Btn setTitle:@"OVERALL" forState:UIControlStateNormal];
            }
            else
            {
                [_last10Btn setTitle:[NSString stringWithFormat:@"LAST %li",(long)_numberOfEvents] forState:UIControlStateNormal];
            }
            
            
            [_statViewController setNumberOfEventsTitle:_last10Btn.titleLabel.text];
            
            if (self.pieChartLeft.currentCount != 0)
            {
                self.pieChartLeft.currentCount = 0;
            }
        }
    }
    
    
}

- (void)setUpScrollForLowerView
{
    
    //CGRect frameLowerView = CGRectMake(0, 0, self.view.frame.size.width, self.lowerView.frame.size.height);
    
    
    
    
    _pageControl.numberOfPages=5;
    [_pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    
    //self.contentView.frame = frameLowerView;
    CGFloat x=0;
    for (int counter = 0; counter < 6; counter++)
    {
        if(counter==0)
        {
            _scoringAvgView = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoringView" owner:self options:nil] firstObject];
            _scoringAvgView.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            x=_scoringAvgView.frame.origin.x + _scoringAvgView.frame.size.width;
            _scoringAvgView.par3sBtn.layer.cornerRadius = 12.0;
            _scoringAvgView.par3sBtn.layer.masksToBounds = YES;
            _scoringAvgView.par4sBtn.layer.cornerRadius = 12.0;
            _scoringAvgView.par4sBtn.layer.masksToBounds = YES;
            _scoringAvgView.par5sBtn.layer.cornerRadius = 12.0;
            _scoringAvgView.par5sBtn.layer.masksToBounds = YES;
            [self.scrollView addSubview:_scoringAvgView];
            
            if (self.isConstaraintApplicable)
            {
                _scoringAvgView.constraintYHitButton.constant = self.constraintYHitButton + 4;
                _scoringAvgView.constraintYMissedButton.constant = self.constraintYMissedButton - 4;
            }
            
            
        }
        
        if(counter == 1)
        {
            
            _lower1Fairways = [[[NSBundle mainBundle] loadNibNamed:@"PT_HomePuttingView" owner:self options:nil] firstObject];
            _lower1Fairways.hitButton.layer.cornerRadius = 12.0;
            _lower1Fairways.hitButton.layer.masksToBounds = YES;
            
            _lower1Fairways.missedButton.layer.cornerRadius = 14.0;
            _lower1Fairways.missedButton.layer.masksToBounds = YES;
            
            _lower1Fairways.last10Button.layer.cornerRadius = 14.0;
            _lower1Fairways.last10Button.layer.masksToBounds = YES;
            
            _lower1Fairways.girButton.layer.cornerRadius = 14.0;
            _lower1Fairways.girButton.layer.masksToBounds = YES;
            
            
            if (self.isConstaraintApplicable)
            {
                _lower1Fairways.constraintYHitButton.constant = self.constraintYHitButton - 2;
                _lower1Fairways.constraintYMissedButton.constant = self.constraintYMissedButton - 2;
            }
            _lower1Fairways.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            x=_lower1Fairways.frame.origin.x + _lower1Fairways.frame.size.width;
            [self.scrollView addSubview:_lower1Fairways];
            
        }
        if (counter ==2) {
            _puttingView = [[[NSBundle mainBundle] loadNibNamed:@"PT_PuttingView" owner:self options:nil] firstObject];
            _puttingView.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            _puttingView.holeBtn.layer.cornerRadius = 12.0;
            _puttingView.holeBtn.layer.masksToBounds = YES;
            _puttingView.girBtn.layer.cornerRadius = 12.0;
            _puttingView.girBtn.layer.masksToBounds = YES;
            _puttingView.roundBtn.layer.cornerRadius = 12.0;
            _puttingView.roundBtn.layer.masksToBounds = YES;
            x=_puttingView.frame.origin.x + _puttingView.frame.size.width;
            [self.scrollView addSubview:_puttingView];
            
            if (self.isConstaraintApplicable)
            {
                _puttingView.constraintYHitButton.constant = self.constraintYHitButton + 4;
                _puttingView.constraintYMissedButton.constant = self.constraintYMissedButton - 4;
            }
            
            
        }
        if (counter == 3)
        {
            _lower1 = [[[NSBundle mainBundle] loadNibNamed:@"PT_HomeLowerView" owner:self options:nil] firstObject];
            _lower1.hitButton.layer.cornerRadius = 12.0;
            _lower1.hitButton.layer.masksToBounds = YES;
            
            _lower1.missedButton.layer.cornerRadius = 14.0;
            _lower1.missedButton.layer.masksToBounds = YES;
            
            if (self.isConstaraintApplicable)
            {
                _lower1.constraintYHitButton.constant = self.constraintYHitButton;
                _lower1.constraintYMissedButton.constant = self.constraintYMissedButton;
            }
            _lower1.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            
            //_lower1.backgroundColor = [UIColor redColor];
            x=_lower1.frame.origin.x + _lower1.frame.size.width;
            
            [self.scrollView addSubview:_lower1];
        }
        if (counter == 4)
        {
            _lowerRecovery = [[[NSBundle mainBundle] loadNibNamed:@"PT_HomeLowerView" owner:self options:nil] firstObject];
            _lowerRecovery.hitButton.layer.cornerRadius = 12.0;
            _lowerRecovery.hitButton.layer.masksToBounds = YES;
            
            _lowerRecovery.missedButton.layer.cornerRadius = 14.0;
            _lowerRecovery.missedButton.layer.masksToBounds = YES;
            
            if (self.isConstaraintApplicable)
            {
                _lowerRecovery.constraintYHitButton.constant = self.constraintYHitButton;
                _lowerRecovery.constraintYMissedButton.constant = self.constraintYMissedButton;
            }
            _lowerRecovery.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
//            /x=_lowerRecovery.frame.origin.x + _lowerRecovery.frame.size.width;
            
            [self.scrollView addSubview:_lowerRecovery];
            
            _lowerRecovery.topLabel.text = @"RECOVERY";
            _lowerRecovery.topLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0f];
            _lowerRecovery.leftLabel.text = @"38%";
            _lowerRecovery.rightLabel.text = @"40%";
            [_lowerRecovery.hitButton setTitle:@"SCRAMBLE" forState:UIControlStateNormal];
            [_lowerRecovery.missedButton setTitle:@"SAND SAVES" forState:UIControlStateNormal];
            //_lowerRecovery.backgroundColor = [UIColor greenColor];
        }
        
        
        
        
        //Done
        
        
        
        //x+=self.lowerView.frame.size.width - self.gapWidthLowerView;
        
    }
    
    
    
    
    float ContentWidth = self.lowerView.frame.size.width * 5.0 ;//- (self.gapWidthLowerView * 5);
    self.scrollView.contentSize = CGSizeMake(ContentWidth, self.scrollView.frame.size.height - self.scrollVerticalDelta);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    
}

- (void)setGirStats
{
    if ([_girStatsHit length] == 0)
    {
        _girStatsHit = @"0%";
    }
    if ([_girStatsMissed length] == 0)
    {
        _girStatsMissed = @"0%";
    }
    _lower1.leftLabel.text = _girStatsHit;
    _lower1.rightLabel.text = _girStatsMissed;
}

- (void)setFairways
{
    if ([_fairwaysLeft length] == 0)
    {
        _fairwaysLeft = @"0%";
    }
    if ([_fairwaysCentre length] == 0)
    {
        _fairwaysCentre = @"0%";
    }
    if ([_fairwaysRight length] == 0)
    {
        _fairwaysRight = @"0%";
    }
    _lower1Fairways.leftLabel.text = _fairwaysLeft;
    _lower1Fairways.centreLabel.text = _fairwaysCentre;
    _lower1Fairways.rightLabel.text = _fairwaysRight;
}


- (void)setRecoveryStats
{
    if ([_recoveryStatsHit length] == 0)
    {
        _recoveryStatsHit = @"0%";
    }
    if ([_recoveryMissed length] == 0)
    {
        _recoveryMissed = @"0%";
    }
    [_lowerRecovery.leftLabel setText:_recoveryStatsHit ];
    [_lowerRecovery.rightLabel setText:_recoveryMissed];
}


- (void)setScoringAverageStats
{
    if ([_scoringAverageLeft length] == 0)
    {
        _scoringAverageLeft = @"0%";
    }
    if ([_scoringCentre length] == 0)
    {
        _scoringCentre = @"0%";
    }
    if ([_scoringRight length] == 0)
    {
        _scoringRight = @"0%";
    }
    _scoringAvgView.leftLabel.text = _scoringAverageLeft;
    _scoringAvgView.centreLabel.text = _scoringCentre;
    _scoringAvgView.rightLabel.text = _scoringRight;
}

- (void)setPuttStats
{
    _puttingView.leftLabel.text = _puttLeft;
    _puttingView.centreLabel.text = _puttCentre;
    _puttingView.rightLabel.text = _puttRight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat viewWidth = _scrollView.frame.size.width;
    // content offset - tells by how much the scroll view has scrolled.
    
    int pageNumber = floor((_scrollView.contentOffset.x - viewWidth/50) / viewWidth) +1;
    
    _pageControl.currentPage=pageNumber;
    
    switch (pageNumber) {
        case 1:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self setGirStats];
                [self setScoringAverageStats];
            });
        }
            break;
            
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setFairways];
            });
            
            
        }
            break;
        case 3:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self setRecoveryStats];
                [self setPuttStats];
            });
            
        }
            break;
        case 4:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
               // [self setScoringAverageStats];
                [self setGirStats];
            });
            
        }
            break;
        case 5:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self setPuttStats];
                [self setRecoveryStats];
            });
            
        }
            break;
    }
    
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"Scrolled");
}
- (void)pageChanged
{
    
}
//popup view

//Initialize Service calls for Number Of Events
- (void)initializeCallsForNumberOfEvents:(NSInteger)count
{
    _numberOfEvents= count;
    NSString *titleString = nil;
    if (_numberOfEvents == 0)
    {
        [_last10Btn setTitle:@"OVERALL" forState:UIControlStateNormal];
        titleString = @"OVERALL";
    }else if(_numberOfEvents == 1){
        
        [_last10Btn setTitle:@"LAST GAME" forState:UIControlStateNormal];
        titleString = @"LAST GAME";
    }
    else
    {
        [_last10Btn setTitle:[NSString stringWithFormat:@"LAST %li",(long)count] forState:UIControlStateNormal];
        titleString = [NSString stringWithFormat:@"LAST %li",(long)count];
    }
    
    [_statViewController setNumberOfEventsTitle:titleString];
    [self fetchAllStatsForNumberOfEvents:[NSString stringWithFormat:@"%li",(long)count]];
    
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    //if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    //self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}


//- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
//{
//    return  (self.pieChartLeft.arrNames[index]);
//}

- (IBAction)upcominBtnClicked:(id)sender {
    
    if ([self.upcomingEventName.text length] == 0)
    {
        [self showAlertForMessage:@"There are no current upcoming events."];
    }
    else
    {
        _upcomingEventView.hidden = NO;
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self.upcomingFaded addGestureRecognizer:singleFingerTap];
        
        
    }
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    _upcomingEventView.hidden = YES;
    
}


-(IBAction)upcomingCloseBtn:(id)sender
{
    _upcomingEventView.hidden = YES;
    
}

- (IBAction)last10Btn:(id)sender {
    
    _last10View= [[[NSBundle mainBundle] loadNibNamed:@"PT_Last10View"
                                                owner:self options:nil] objectAtIndex:0];
    _last10View.homeVC = self;
    
    CGRect last10frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    //    CGRect _tableViewFrame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 180);
    
    self.last10View.frame = last10frame;
    self.last10View.hidden = NO;
    //    self.tableView.delegate = self;
    [self.view addSubview:self.last10View];
    
}

- (void)showAlertForMessage:(NSString *)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"PUTT2GETHER"
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Dismiss"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Web Service calls
/*
 - (void)fetchUpcomingMeetings
 {
 __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
 
 if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
 {
 [self showAlertForMessage:@"Please check the internet connection and try again."];
 }
 
 [self showLoadingView:YES];
 MGMainDAO *mainDAO = [MGMainDAO new];
 if ([delegate.deviceToken length] == 0)
 {
 delegate.deviceToken = DemoDeviceToken;
 }
 
 NSDateFormatter *formatter = [NSDateFormatter new];
 [formatter setDateFormat:@"yyyy-MM-dd"];
 NSString *date = [formatter stringFromDate:[NSDate date]];
 NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]],
 @"current_date":date,
 @"version":@"2",
 @"golf_course_id":@""};
 
 
 NSString *upcoming = @"getdashboardupcomingevent";
 //[mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,GetUpcomingEventPostfix]
 [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,upcoming]
 withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
 [self showLoadingView:NO];
 if (!error)
 {
 if (responseData != nil)
 {
 if ([responseData isKindOfClass:[NSDictionary class]])
 {
 if (responseData[@"output"])
 {
 NSDictionary *dict = responseData[@"output"];
 NSDictionary *dictOutput = dict[@"data"];
 if (dict[@"status"])
 {
 if ([dict[@"status"] isEqualToString:@"1"])
 {
 if (dictOutput[@"WeekEventList"])
 {
 NSArray *arrEvents = dictOutput[@"WeekEventList"];
 NSDictionary *dicEvent = [arrEvents firstObject];
 
 NSString *eventName = dicEvent[@"event_name"];
 NSString *date = dicEvent[@"start_date"];
 NSString *golfCourse = dicEvent[@"golf_course_name"];
 _currentEventId = dicEvent[@"event_id"];
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 self.upcomingEventName.text = [eventName uppercaseString];
 self.upcomingEventDate.text = [date uppercaseString];
 self.upcomingEventGolfCourseName.text = [golfCourse uppercaseString];
 //[self fetchPieChartValues];
 });
 
 }
 else
 {
 self.upcomingEventHeader.text = @"THER IS NO UPCOMING EVENT";
 self.upcomingEventName.text = nil;
 self.upcomingEventDate.text = nil;
 self.upcomingEventGolfCourseName.text = nil;
 }
 }
 else
 {
 //[self showLoadingView:NO];
 NSDictionary *dicData = responseData;
 NSDictionary *dictError = [dicData objectForKey:@"Error"];
 NSString *messageError = [dictError objectForKey:@"msg"];
 UIAlertController * alert=   [UIAlertController
 alertControllerWithTitle:@"PUTT2GETHER"
 message:messageError
 preferredStyle:UIAlertControllerStyleAlert];
 
 
 
 UIAlertAction* cancel = [UIAlertAction
 actionWithTitle:@"Dismiss"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action)
 {
 [alert dismissViewControllerAnimated:YES completion:nil];
 
 }];
 
 [alert addAction:cancel];
 
 [self presentViewController:alert animated:YES completion:nil];
 }
 }
 
 
 
 
 }
 
 
 }
 }
 
 else
 {
 
 
 
 }
 }
 else
 {
 NSDictionary *dicData = responseData;
 NSDictionary *dictError = [dicData objectForKey:@"Error"];
 NSString *messageError = [dictError objectForKey:@"msg"];
 UIAlertController * alert=   [UIAlertController
 alertControllerWithTitle:@"PUTT2GETHER"
 message:messageError
 preferredStyle:UIAlertControllerStyleAlert];
 
 
 
 UIAlertAction* cancel = [UIAlertAction
 actionWithTitle:@"Dismiss"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action)
 {
 [alert dismissViewControllerAnimated:YES completion:nil];
 
 }];
 
 [alert addAction:cancel];
 
 [self presentViewController:alert animated:YES completion:nil];
 }
 
 
 }];
 
 
 }
 */
- (void)fetchUpcomingMeetings
{
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertForMessage:@"Please check the internet connection and try again."];
    }
    
    MGMainDAO *mainDAO = [MGMainDAO new];
    if ([delegate.deviceToken length] == 0)
    {
        delegate.deviceToken = DemoDeviceToken;
    }
    
    NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                            @"version":@"2"
                            };
    NSString *upcoming = @"getdashboardupcomingevent";
    [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,upcoming]
          withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
              //[self showLoadingView:NO];
              if (!error)
              {
                  if (responseData != nil)
                  {
                      if ([responseData isKindOfClass:[NSDictionary class]])
                      {
                          if (responseData[@"output"])
                          {
                              NSDictionary *dict = responseData[@"output"];
                              NSDictionary *dictOutput = dict[@"data"];
                              if (dict[@"status"])
                              {
                                  if ([dict[@"status"] isEqualToString:@"1"])
                                  {
                                      if ([dictOutput count] > 0)
                                      {
                                          if ([dict[@"notifications_count"]integerValue] == 1) {
                                              
                                              if ( IDIOM == IPAD ) {
                                                  /* do something specifically for iPad. */
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                              } else {
                                                  /* do something specifically for iPhone or iPod touch. */
                                                  UITabBarItem *tabBarItem0 = [ delegate.tabBarController.tabBar.items objectAtIndex:3];
                                                  
                                                  [tabBarItem0 setImage:[[UIImage imageNamed:@"notification"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                                              }
                                              
                                              
                                          }
                                          
                                          
                                          
                                          NSString *eventName = dictOutput[@"event_name"];
                                          NSString *date = dictOutput[@"start_date"];
                                          NSString *golfCourse = dictOutput[@"golf_course_name"];
                                          _currentEventId = dictOutput[@"event_id"];
                                          NSString *isResume = dictOutput[@"is_resume"];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              if ([isResume isEqualToString:@"1"]) {
                                                  
                                                  _isResumeStatus = @"1";
                                                  self.bottomUpcomingLbl.text = @"RESUME ROUND";
                                                  self.upcomingEventHeader.text = @"RESUME ROUND";
                                                  self.upcomingEventName.text = [eventName uppercaseString];
                                                  self.upcomingEventHeader.textColor = [UIColor colorWithRed:35/255.0 green:157/255.0 blue:54/255.0 alpha:1];
                                                   self.bottomUpcomingLbl.textColor = [UIColor colorWithRed:35/255.0 green:157/255.0 blue:54/255.0 alpha:1];
                                                  self.upcomingEventDate.text = [date uppercaseString];
                                                  self.upcomingEventGolfCourseName.text = [golfCourse uppercaseString];
                                              }else{
                                              
                                                  _isResumeStatus = @"2";

                                              self.upcomingEventName.text = [eventName uppercaseString];
                                              self.upcomingEventDate.text = [date uppercaseString];
                                              self.upcomingEventGolfCourseName.text = [golfCourse uppercaseString];
                                              }
                                              //[self fetchPieChartValues];
                                          });
                                          
                                      }
                                      else
                                      {
                                          self.upcomingEventHeader.text = @"THER IS NO UPCOMING EVENT";
                                          self.upcomingEventName.text = nil;
                                          self.upcomingEventDate.text = nil;
                                          self.upcomingEventGolfCourseName.text = nil;
                                      }
                                  }
                                  else
                                  {
                                      //[self showLoadingView:NO];
                                      self.upcomingEventHeader.text = @"THER IS NO UPCOMING EVENT";
                                      self.upcomingEventName.text = nil;
                                      self.upcomingEventDate.text = nil;
                                      self.upcomingEventGolfCourseName.text = nil;
                                  }
                              }
                              
                          }
                          
                      }
                  }
                  
                  else
                  {
                  }
              }
              else
              {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                 /* NSDictionary *dicData = responseData;
                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                  NSString *messageError = [dictError objectForKey:@"msg"];
                  UIAlertController * alert=   [UIAlertController
                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                message:messageError
                                                preferredStyle:UIAlertControllerStyleAlert];
                  
                  
                  
                  UIAlertAction* cancel = [UIAlertAction
                                           actionWithTitle:@"Dismiss"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                  
                  [alert addAction:cancel];
                  
                  [self presentViewController:alert animated:YES completion:nil];*/
              }
              
          }];
    
}


-(IBAction)actionUpcomingEvent:(id)sender{
    
        [self fetchEventwithStatus:_isResumeStatus];
}



- (void)fetchAllStatsForNumberOfEvents:(NSString *)numberOfEvents
{
    
    NSString *num =  numberOfEvents;
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertForMessage:@"Please check the internet connection and try again."];
    }
    
    if (_hud == nil) {
        
        _hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    }
    
    MGMainDAO *mainDAO = [MGMainDAO new];
    if ([delegate.deviceToken length] == 0)
    {
        delegate.deviceToken = DemoDeviceToken;
    }
    
    NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                            @"no_of_event":numberOfEvents,
                            @"version":@"2"};
    delegate.tabBarController.tabBar.userInteractionEnabled = NO;

    [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,GetStatsPostfix]
          withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
              delegate.tabBarController.tabBar.userInteractionEnabled = YES;
              if (!error)
              {
                  
                  if (responseData != nil)
                  {
                      if ([responseData isKindOfClass:[NSDictionary class]])
                      {
                          if (responseData[@"output"])
                          {
                              NSDictionary *dict = responseData[@"output"];
                              
                              NSDictionary *dicData = dict[@"data"];
                              
                              if (dict[@"status"])
                              {
                                  if ([dict[@"status"] isEqualToString:@"1"])
                                  {
                                      
                                      NSDictionary *dicPieChart = dicData[@"pichart"];
                                      
                                      if (dicPieChart[@"no_of_eagle"])
                                      {
                                          _eagleCount = [dicPieChart[@"no_of_eagle"] integerValue];
                                      }
                                      if (dicPieChart[@"no_of_birdies"])
                                      {
                                          _birdieCount = [dicPieChart[@"no_of_birdies"] integerValue];
                                      }
                                      if (dicPieChart[@"no_of_pars"])
                                      {
                                          _parCount = [dicPieChart[@"no_of_pars"] integerValue];
                                      }
                                      if (dicPieChart[@"no_of_bogeys"])
                                      {
                                          _bogeyCount = [dicPieChart[@"no_of_bogeys"] integerValue];
                                      }
                                      if (dicPieChart[@"no_of_double_bogeys"])
                                      {
                                          _dBogeyCount = [dicPieChart[@"no_of_double_bogeys"] integerValue];
                                      }
                                      
                                      
                                      self.avgScore = [NSString stringWithFormat:@"%@",dicPieChart[@"gross_score"]];
                                      self.currentIndex = [NSString stringWithFormat:@"%@",dicPieChart[@"curent_position"]];
                                      //self.currentIndex = @"+99";
                                      //[self.pieChartLeft reloadData];
                                      
                                      [self setPieChart];
                                      
                                      
                                          
                                          NSDictionary *dicScoringAverage = dicData[@"score_stats"];
                                          _statViewController.dictScoreStats = dicScoringAverage;
                                      
                                          _scoringAverageLeft = [NSString stringWithFormat:@"%@",dicScoringAverage[@"avg_par3s"]];
                                      
                                          _scoringCentre = [NSString stringWithFormat:@"%@",dicScoringAverage[@"avg_par4s"]];
                                      
                                          _scoringRight = [NSString stringWithFormat:@"%@",dicScoringAverage[@"avg_par5s"]];
                                      
                                      _statViewController.scoringAverageLeft = _scoringAverageLeft;
                                      _statViewController.scoringCentre = _scoringCentre;
                                      _statViewController.scoringRight = _scoringRight;
                                          [self setScoringAverageStats];
                                      
                                      double delayInSeconds = 2.0;
                                      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                          
                                          isReloadPieChart = YES;
                                          
                                          //[delegate.tabBarController setSelectedIndex:0];
                                          
                                          // [self setPieChart];
                                          //if (isAppFirstLoad == YES)
                                          {
                                              //self.pieChartLeft.hidden = YES;
                                              isAppFirstLoad = NO;
                                              self.pieChartLeft.currentCount = 0;
                                              AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                              [delegate.tabBarController.viewControllers[0] viewDidAppear:YES];
                                              //self.pieChartLeft.hidden = NO;
                                          }
                                          
                                          
                                          
                                      });

                                          
                                          NSDictionary *dicGirStats = dicData[@"gir_percentage"];
                                          
                                          
                                          NSString *percent = @"%";
                                          NSString *hit = [NSString stringWithFormat:@"%@",dicGirStats[@"hit"]];
                                          if ([hit isEqualToString:@"-"])
                                          {
                                              _girStatsHit = hit;
                                          }
                                          else
                                          {
                                              float girHit = [dicGirStats[@"hit"] floatValue];
                                              //_girStatsHit = [NSString stringWithFormat:@"%0.1f%@",girHit,percent];
                                              _girStatsHit = [NSString stringWithFormat:@"%@%@",dicGirStats[@"hit"],percent];
                                          }
                                          
                                          NSString *missed = [NSString stringWithFormat:@"%@",dicGirStats[@"missed"]];
                                          if ([missed isEqualToString:@"-"])
                                          {
                                              _girStatsMissed = missed;
                                          }
                                          else
                                          {
                                              float girMissed = [dicGirStats[@"missed"] floatValue];
                                              //_girStatsMissed = [NSString stringWithFormat:@"%0.1f%@",girMissed,percent];
                                              _girStatsMissed = [NSString stringWithFormat:@"%@%@",dicGirStats[@"missed"],percent];
                                          }
                                          
                                          //FOR STATS
                                          _statViewController.girStatsHit = _girStatsHit;
                                          _statViewController.girStatsMissed = _girStatsMissed;
                                          
                                          [_lower1.leftLabel setText:_girStatsHit ];
                                          [_lower1.rightLabel setText:_girStatsMissed];
                                          [self setGirStats];
                                          
                                          
                                          
                                          NSDictionary *dicFairways = dicData[@"fairway_percentage"];
                                          NSString *left = [NSString stringWithFormat:@"%@",dicFairways[@"left"]];
                                          if ([left isEqualToString:@"-"])
                                          {
                                              _fairwaysLeft = left;
                                          }
                                          else
                                          {
                                              float fairLeft = [dicFairways[@"left"] floatValue];
                                              //_fairwaysLeft = [NSString stringWithFormat:@"%0.1f%@",fairLeft,percent];
                                              _fairwaysLeft = [NSString stringWithFormat:@"%@%@",dicFairways[@"left"],percent];
                                          }
                                          
                                          NSString *right = [NSString stringWithFormat:@"%@",dicFairways[@"right"]];
                                          if ([right isEqualToString:@"-"])
                                          {
                                              _fairwaysRight = right;
                                          }
                                          else
                                          {
                                              float fairRight = [dicFairways[@"right"] floatValue];
                                              //_fairwaysRight = [NSString stringWithFormat:@"%0.1f%@",fairRight,percent];
                                              _fairwaysRight = [NSString stringWithFormat:@"%@%@",dicFairways[@"right"],percent];
                                          }
                                          
                                          NSString *centre = [NSString stringWithFormat:@"%@",dicFairways[@"hit"]];
                                          if ([centre isEqualToString:@"-"])
                                          {
                                              _fairwaysCentre = centre;
                                          }
                                          else
                                          {
                                              float fairCentre = [dicFairways[@"hit"] floatValue];
                                              _fairwaysCentre = [NSString stringWithFormat:@"%0.1f%@",fairCentre,percent];
                                              //_fairwaysCentre = [NSString stringWithFormat:@"%@%@",dicFairways[@"hit"],percent];
                                          }
                                          
                                          [self setFairways];
                                          
                                          _statViewController.fairwaysLeft = _fairwaysLeft;
                                          _statViewController.fairwaysRight = _fairwaysRight;
                                          _statViewController.fairwaysCentre = _fairwaysCentre;
                                          
                                          NSDictionary *dicPutStats = dicData[@"putting_stats"];
                                          float putLeft = [dicPutStats[@"per_hole_avg"] floatValue];
                                          //_puttLeft = [NSString stringWithFormat:@"%0.1f",putLeft];
                                          _puttLeft = [NSString stringWithFormat:@"%@",dicPutStats[@"per_hole_avg"]];
                                          float putCentre = [dicPutStats[@"per_gir_avg"] floatValue];
                                          //_puttCentre = [NSString stringWithFormat:@"%0.1f",putCentre];
                                          _puttCentre = [NSString stringWithFormat:@"%@",dicPutStats[@"per_gir_avg"]];
                                          float putRight = [dicPutStats[@"per_round_avg"] floatValue];
                                          //_puttRight = [NSString stringWithFormat:@"%0.1f",putRight];
                                          _puttRight = [NSString stringWithFormat:@"%@",dicPutStats[@"per_round_avg"]];
                                          [self setPuttStats];
                                          
                                          _statViewController.puttLeft = _puttLeft;
                                          _statViewController.puttRight = _puttRight;
                                          _statViewController.puttCentre = _puttCentre;
                                          
                                          NSDictionary *dicRecoveryStats = dicData[@"recovery_stats"];
                                          NSString *scramble = [NSString stringWithFormat:@"%@",dicRecoveryStats[@"scrmbl_avg"]];
                                          if ([scramble isEqualToString:@"-"])
                                          {
                                              _recoveryStatsHit = scramble;
                                          }
                                          else
                                          {
                                              float recovHit = [dicRecoveryStats[@"scrmbl_avg"] floatValue];
                                              //_recoveryStatsHit = [NSString stringWithFormat:@"%0.1f%@",recovHit,percent];
                                              _recoveryStatsHit = [NSString stringWithFormat:@"%@%@",dicRecoveryStats[@"scrmbl_avg"],percent];
                                          }
                                          
                                          NSString *sand = [NSString stringWithFormat:@"%@",dicRecoveryStats[@"sand_avg"]];
                                          if ([sand isEqualToString:@"-"])
                                          {
                                              _recoveryMissed = sand;
                                          }
                                          else
                                          {
                                              float recoverMissed = [dicRecoveryStats[@"sand_avg"] floatValue];
                                              //_recoveryMissed = [NSString stringWithFormat:@"%0.1f%@",recoverMissed,percent];
                                              _recoveryMissed = [NSString stringWithFormat:@"%@%@",dicRecoveryStats[@"sand_avg"],percent];
                                          }
                                          
                                          _statViewController.recoveryStatsHit = _recoveryStatsHit;
                                          _statViewController.recoveryMissed = _recoveryMissed;
                                          
                                          [self setRecoveryStats];
                                          
                                          [_statViewController updateCurrentView];
                                          
                                      
                                      
                                     // });
                                      
                                      
                                  }
                                  else
                                  {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      delegate.tabBarController.tabBar.userInteractionEnabled = YES;
                                      
                                  }
                              }
                              
                          }
                          
                      }
                  }
                  
                  else
                  {
                      delegate.tabBarController.tabBar.userInteractionEnabled = YES;
                  }
              }
              else
              {
                  delegate.tabBarController.tabBar.userInteractionEnabled = YES;
                  //[self fetchAllStatsForNumberOfEvents:num];
                  //[MBProgressHUD hideHUDForView:self.view animated:YES];
                  UIAlertController * alert=   [UIAlertController
                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                message:@"Connection Lost. Net is too slow  Please try again"
                                                preferredStyle:UIAlertControllerStyleAlert];
                  
                  
                  
                  UIAlertAction* cancel = [UIAlertAction
                                           actionWithTitle:@"Refresh"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [self fetchAllStatsForNumberOfEvents:num];
                                               
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                  
                  [alert addAction:cancel];
                  
                  [self presentViewController:alert animated:YES completion:nil];
              }
              
              
          }];
    
    //delegate.tabBarController.tabBar.hidden = NO;
    //[delegate.tabBarController setSelectedIndex:0];
}

//Mark:-for sending on event Listing
- (void)fetchEventwithStatus:(NSString *)status
{
    //NSString *eventId = [NSString stringWithFormat:@"%li",model.eventID];
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
       // [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
#if (TARGET_OS_SIMULATOR)
        
        delegate.latestLocation = [[CLLocation alloc] initWithLatitude:28.5922729 longitude:77.33453080000004];
        
#endif
        //[self showLoadingView:YES];
        NSString *requestToPraticipate = @"";
        if (self.isRequestToParticipate == YES)
        {
            requestToPraticipate = @"1";
        }
        else
        {
            requestToPraticipate = @"0";
        }
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":userId,
                                @"event_id":_currentEventId,
                                @"request_to_participate":requestToPraticipate,
                                @"version":@"2"
                                };
        
        NSString *urlString = @"eventdetail";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSDictionary *dicOutput = responseData[@"output"];
                              //Check Success
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  NSArray *arrData = dicOutput[@"data"];
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicData = obj;
                                      PT_CreatedEventModel *model = [PT_CreatedEventModel new];
                                      model.eventId = [_currentEventId integerValue];
                                      model.adminId = [dicData[@"admin_id"] integerValue];
                                      model.closestPin = dicData[@"closest_pin"];
                                      model.eventName = [dicData[@"event_name"] uppercaseString];
                                      model.eventstartDateTime = [dicData[@"event_start_date_time"] uppercaseString];
                                      model.formatName = [dicData[@"format_name"] uppercaseString];
                                      model.formatId = dicData[@"format_id"];
                                      model.golfCourseId = [dicData[@"golf_course_id"] integerValue];
                                      model.golfCourseName = dicData[@"golf_course_name"];
                                      model.holes = [dicData[@"holes"] uppercaseString];
                                      model.isAdmin = [dicData[@"is_admin"] boolValue];
                                      model.isIndividual = dicData[@"is_individual"];
                                      model.isSpot = [dicData[@"is_spot"] boolValue];
                                      model.longDrive = dicData[@"long_drive"];
                                      model.numberOfPlayers = [NSString stringWithFormat:@"%@",dicData[@"no_of_player"]] ;
                                      model.straightDrive = dicData[@"straight_drive"];
                                      model.teeId = dicData[@"tee_id"];
                                      model.totalHoleNumber = [dicData[@"total_hole_num"] integerValue];
                                      model.eventType = [dicData[@"type"] uppercaseString];
                                      model.isEventStarted = dicData[@"start_round_status"] ;
                                      model.is_accepted = [NSString stringWithFormat:@"%@",dicData[@"is_accepted"]];
                                      model.isStarted = [dicData[@"is_started"] integerValue];
                                      if (dicData[@"holes"])
                                      {
                                          model.back9 = dicData[@"holes"];
                                      }
                                      NSString *is_singlescreen = [NSString stringWithFormat:@"%@",dicData[@"is_singlescreen"]];
                                      if ([is_singlescreen isEqualToString:@"1"])
                                      {
                                          model.isSingleScreen = YES;
                                      }
                                      else if ([is_singlescreen isEqualToString:@""])
                                      {
                                          model.isSingleScreen = NO;
                                      }
                                      //NSInteger count = [arrData count];
                                      if ([arrData count] == 1)
                                      {
                                          *stop = YES;
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              
                                              if ([status isEqualToString:@"1"]) {
                                                  
                                                  PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:model];
                                                  
                                                  [self presentViewController:startVC animated:YES completion:nil];
                                              }else{
                                                  
                                                  PT_EventPreviewViewController *createVC = [[PT_EventPreviewViewController alloc]initWithModel:model andIsRequestToParticipate:self.isRequestToParticipate];
                                                  
                                                  [self presentViewController:createVC animated:YES completion:nil];
                                              }
                                              
                                          });
                                          
                                          _upcomingEventView.hidden = YES;
                                      }
                                      
                                  }];
                              }
                              else
                              {
                                  //Pop up message
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];

                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:dicOutput[@"msg"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                          }
                      }
                      
                  }
                  else
                  {
                      //Error pop up
                      [self showAlertForMessage:[error localizedDescription]];
                  }
                  
                  
              }];
    }
    
}



@end
