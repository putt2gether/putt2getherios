//
//  PT_StatsViewController.m
//  Putt2Gether
//
//  Created by Bunny on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_StatsViewController.h"

#import "PT_ScoreView.h"

#import "PT_FairewayView.h"

#import "PT_PuttingStatsView.h"

#import "PT_RecoveryStatsView.h"

#import "PT_GirView.h"

#import "PT_Last10View.h"

typedef NS_ENUM(NSInteger,CurrentFunction)
{
    CurrentFunction_Score,
    CurrentFunction_Gir,
    CurrentFunction_Fairways,
    CurrentFunction_Putting,
    CurrentFunction_Recovery
};

@interface PT_StatsViewController ()<UIGestureRecognizerDelegate>
{
    NSString *titleString;
    CurrentFunction currentFuntionTag;
}
@property (weak, nonatomic) IBOutlet UILabel *eventsTitle;
@property (assign, nonatomic) float gapWidthLowerView;
@property (assign, nonatomic) float scrollVerticalDelta;
@property (strong, nonatomic) PT_GirView *girView;
@property (strong, nonatomic) PT_FairewayView *fairwayView;
@property (strong, nonatomic) PT_ScoreView *scoreView;
@property (strong, nonatomic) PT_PuttingStatsView *puttingStatsView;
@property (strong, nonatomic) PT_RecoveryStatsView *recoveryStatsView;




@end

@implementation PT_StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self customdesign];
    
    [self setUpScrollForLowerView];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [panRecognizer setDelegate:self];
    [self.scrollView addGestureRecognizer:panRecognizer];
    [self.view addGestureRecognizer:panRecognizer];
    
}

-(void)panRecognized:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // you might want to do something at the start of the pan
    }
    
    CGPoint distance = [sender translationInView:self.view]; // get distance of pan/swipe in the view in which the gesture recognizer was added
    CGPoint velocity = [sender velocityInView:self.view]; // get velocity of pan/swipe in the view in which the gesture recognizer was added
    float usersSwipeSpeed = abs(velocity.x); // use this if you need to move an object at a speed that matches the users swipe speed
    NSLog(@"swipe speed:%f", usersSwipeSpeed);
    if (sender.state == UIGestureRecognizerStateEnded) {
        [sender cancelsTouchesInView]; // you may or may not need this - check documentation if unsure
        if (distance.x > 0) { // right
            [UIView animateWithDuration:0.25 animations:^{
                [self rightSwiped];
            }];
            //[self rightSwiped];
        } else if (distance.x < 0) { //left
            [UIView animateWithDuration:0.25 animations:^{
                [self leftSwiped];
            }];
            //[self leftSwiped];
        }
        if (distance.y > 0) { // down
            NSLog(@"user swiped down");
        } else if (distance.y < 0) { //up
            NSLog(@"user swiped up");
        }
        // Note: if you don't want both axis directions to be triggered (i.e. up and right) you can add a tolerence instead of checking the distance against 0 you could check for greater and less than 50 or 100, etc.
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self actionScore:_scoreBtn];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self actionBack];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNumberOfEventsTitle:titleString];
    _eventsTitle.text = titleString;
}

-(void)customdesign{
    
    [_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_girBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_fairwayBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_puttingBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_recoveryBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    
    self.gapWidthLowerView = 95;
    self.scrollVerticalDelta = 200;
}


- (void)setUpScrollForLowerView
{
    
    //CGRect frameLowerView = CGRectMake(0, 0, self.view.frame.size.width, self.lowerView.frame.size.height);
    
    
    
    
    _pageControl.numberOfPages=5;
    [_pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    
    //self.contentView.frame = frameLowerView;
    CGFloat x=0;
    for (int counter = 0; counter < 5; counter++)
    {
        if (counter == 0 )
        {
            PT_ScoreView *lower1 = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreView" owner:self options:nil] firstObject];
            
            [lower1.scoreLabel setTextColor:[UIColor blackColor]];
            _scoreView.changeBtn.layer.cornerRadius = 5.0;
            _scoreView.changeBtn.layer.masksToBounds = YES;
            
            _scoreView.par3sBtn.layer.cornerRadius = 5.0;
            _scoreView.par3sBtn.layer.masksToBounds = YES;
            
            _scoreView.par4sBtn.layer.cornerRadius = 5.0;
            _scoreView.par4sBtn.layer.masksToBounds = YES;
            
            _scoreView.par5sBtn.layer.cornerRadius = 5.0;
            _scoreView.par5sBtn.layer.masksToBounds = YES;
            
            _scoreView.inBtn.layer.cornerRadius = 5.0;
            _scoreView.inBtn.layer.masksToBounds = YES;
            
            _scoreView.outBtn.layer.cornerRadius = 5.0;
            _scoreView.outBtn.layer.masksToBounds = YES;
            //            {
            //                lower1.constraintYHitButton.constant = self.constraintYHitButton;
            //                lower1.constraintYMissedButton.constant = self.constraintYMissedButton;
            
            lower1.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            //            UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
            //            [_scoreBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateNormal];
            //
            //
            //            [_girBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
            //
            
            [self.scrollView addSubview:lower1];
            
        }
        
        
        
        if(counter == 1)
        {
            
            PT_GirView *lower1 = [[[NSBundle mainBundle] loadNibNamed:@"PT_GirView" owner:self options:nil] firstObject];
            lower1.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            lower1.hitLabel.text = _girStatsHit;
            lower1.missedLabel.text = _girStatsMissed;
            
            [self.scrollView addSubview:lower1];
            
        }
        
        
        if(counter == 2)
        {
            
            PT_FairewayView *lower1 = [[[NSBundle mainBundle] loadNibNamed:@"PT_FairewayView" owner:self options:nil] firstObject];
            
            _fairwayView.hitBtn.layer.cornerRadius = 10.0;
            _fairwayView.hitBtn.layer.masksToBounds = YES;
            
            _fairwayView.leftBtn.layer.cornerRadius = 10.0;
            _fairwayView.leftBtn.layer.masksToBounds = YES;
            
            _fairwayView.rightBtn.layer.cornerRadius = 10.0;
            _fairwayView.rightBtn.layer.masksToBounds = YES;
            lower1.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            //_fairwayView = lower1;
            
            [self.scrollView addSubview:lower1];
        }
        
        if(counter == 3)
        {
            
            PT_PuttingStatsView *lower1 = [[[NSBundle mainBundle] loadNibNamed:@"PT_PuttingStatsView" owner:self options:nil] firstObject];
            
            _puttingStatsView.holeBtn.layer.cornerRadius = 10.0;
            _puttingStatsView.holeBtn.layer.masksToBounds = YES;
            
            _puttingStatsView.girBtn.layer.cornerRadius = 10.0;
            _puttingStatsView.girBtn.layer.masksToBounds = YES;
            
            _puttingStatsView.roundBtn.layer.cornerRadius = 10.0;
            _puttingStatsView.roundBtn.layer.masksToBounds = YES;
            
            
            lower1.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            //            UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
            //
            //            [_puttingBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateSelected];
            //            [_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
            [self.scrollView addSubview:lower1];
        }
        
        
        
        if(counter == 4)
        {
            
            PT_RecoveryStatsView *lower1 = [[[NSBundle mainBundle] loadNibNamed:@"PT_RecoveryStatsView" owner:self options:nil] firstObject];
            
            _recoveryStatsView.scrambleBtn.layer.cornerRadius = 10.0;
            // _recoveryStatsView.scrambleBtn.layer.borderWidth = 1.0;
            _recoveryStatsView.scrambleBtn.layer.masksToBounds = YES;
            
            _recoveryStatsView.sandBtn.layer.cornerRadius = 10.0;
            // _recoveryStatsView.scrambleBtn.layer.borderWidth = 1.0;
            _recoveryStatsView.sandBtn.layer.masksToBounds = YES;
            lower1.frame = CGRectMake(x+0, 0, self.lowerView.frame.size.width, self.lowerView.frame.size.height);
            //            UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
            //
            //            [_recoveryBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateSelected];
            //            [_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
            [self.scrollView addSubview:lower1];
        }
        
        
        
        x+=self.lowerView.frame.size.width - self.gapWidthLowerView;
        
        
    }
    
    
    
    float ContentWidth = self.lowerView.frame.size.width * 5 - (self.gapWidthLowerView * 5);
    //self.scrollView.contentSize = CGSizeMake(ContentWidth, self.scrollView.frame.size.height - self.scrollVerticalDelta);
    self.scrollView.contentSize = CGSizeMake(ContentWidth, self.scrollView.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    
    [self actionScore:self.scoreBtn];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat viewWidth = _scrollView.frame.size.width;
    // content offset - tells by how much the scroll view has scrolled.
    
    int pageNumber = floor((_scrollView.contentOffset.x - viewWidth/50) / viewWidth) +1;
    
    _pageControl.currentPage=pageNumber;
}


-(void)pageChanged{
    
}


- (IBAction)actionScore:(id)sender
{
    currentFuntionTag = CurrentFunction_Score;
    for (UIView *views in self.lowerView.subviews)
    {
        [views removeFromSuperview];
    }
    //[self.view addSubview:_numberOfEventsTitle];
    _eventsTitle.text = titleString;
    
    
    if (self.scoreView == nil)
    {
        _scoreView = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreView" owner:self options:nil] firstObject];
        self.scoreView.frame = self.lowerView.bounds;
        _scoreView.parentVC = self;
        [_scoreView setBasicElements];
        _scoreView.changeBtn.layer.cornerRadius = 5.0;
        _scoreView.changeBtn.layer.masksToBounds = YES;
        
        _scoreView.par3sBtn.layer.cornerRadius = 5.0;
        _scoreView.par3sBtn.layer.masksToBounds = YES;
        
        _scoreView.par4sBtn.layer.cornerRadius = 5.0;
        _scoreView.par4sBtn.layer.masksToBounds = YES;
        
        _scoreView.par5sBtn.layer.cornerRadius = 4.0;
        _scoreView.par5sBtn.layer.masksToBounds = YES;
        
        _scoreView.inBtn.layer.cornerRadius = 4.0;
        _scoreView.inBtn.layer.masksToBounds = YES;
        
        _scoreView.outBtn.layer.cornerRadius = 4.0;
        _scoreView.outBtn.layer.masksToBounds = YES;
        
    }

    [self.lowerView addSubview:self.scoreView];
    
    UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
    [_scoreBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateNormal];
    
    [_girBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_fairwayBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_puttingBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_recoveryBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    // [self setUpScrollForLowerView];
    
    // [_scoreBtn setSelected:NO];
    //[_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats(click)"] forState:UIControlStateSelected];
    //[_scoreBtn setImage:[UIImage imageNamed:@"mystats(click)"]
    // forState:UIControlStateSelected];
    
    if (_dictScoreStats == nil)
    {
        return;
    }
    
    float lastGross = [_dictScoreStats[@"last_gross_score"] floatValue];
    _scoreView.grossScoreLabel.text = [NSString stringWithFormat:@"%0.1f",lastGross];
    
    float par3S = [_dictScoreStats[@"last_par3s"] floatValue];
    _scoreView.par3SLabel.text = [NSString stringWithFormat:@"%0.1f",par3S];

    
    float par4S = [_dictScoreStats[@"last_par4s"] floatValue];
    _scoreView.par4SLabel.text = [NSString stringWithFormat:@"%0.1f",par4S];

    
    float par5S = [_dictScoreStats[@"last_par5s"] floatValue];
    _scoreView.par5SLabel.text = [NSString stringWithFormat:@"%0.1f",par5S];

    
    float lastIn = [_dictScoreStats[@"last_in"] floatValue];
    _scoreView.inLabel.text = [NSString stringWithFormat:@"%0.1f",lastIn];

    
    float lastOut = [_dictScoreStats[@"last_out"] floatValue];
    _scoreView.outLabel.text = [NSString stringWithFormat:@"%0.1f",lastOut];

    
    float grossAvg = [_dictScoreStats[@"avg_gross_score"] floatValue];
    [_scoreView.changeBtn setTitle:[NSString stringWithFormat:@"%0.1f",grossAvg]
                          forState:UIControlStateNormal];
    _scoreView.DgrossScoreStr = grossAvg;

    
    float grossPar3S = [_dictScoreStats[@"avg_par3s"] floatValue];
    [_scoreView.par3sBtn setTitle:[NSString stringWithFormat:@"%0.1f",grossPar3S]
                         forState:UIControlStateNormal];
    //double number = [_dictScoreStats[@"avg_par3s"] doubleValue ];
    _scoreView.Dpar3Sstr = grossPar3S;

    
    float grossPar4S = [_dictScoreStats[@"avg_par4s"] floatValue];
    [_scoreView.par4sBtn setTitle:[NSString stringWithFormat:@"%0.1f",grossPar4S]
                         forState:UIControlStateNormal];
   // double numberpar4s = [_dictScoreStats[@"avg_par4s"] doubleValue ];
    
    _scoreView.Dpar4Sstr = grossPar4S;
    
    float grossPar5S = [_dictScoreStats[@"avg_par5s"] floatValue];
    [_scoreView.par5sBtn setTitle:[NSString stringWithFormat:@"%0.1f",grossPar5S]
                         forState:UIControlStateNormal];
    _scoreView.Dpar5Sstr = grossPar5S;

    
    float avgIn = [_dictScoreStats[@"avg_in"] floatValue];
    [_scoreView.inBtn setTitle:[NSString stringWithFormat:@"%0.1f",avgIn] forState:UIControlStateNormal];
    _scoreView.DinStr = avgIn;

    
    float avgOut = [_dictScoreStats[@"avg_out"] floatValue];
    [_scoreView.outBtn setTitle:[NSString stringWithFormat:@"%0.1f",avgOut] forState:UIControlStateNormal];
    _scoreView.DoutStr = avgOut;

    
    
    
    
    if ([_dictScoreStats[@"gscore_change_color"] length] > 0)
    {
        _scoreView.grossScoreStr = _dictScoreStats[@"gscore_change"];
        _scoreView.grossChangeColor = [UIColor colorFromHexString:_dictScoreStats[@"gscore_change_color"]];
    }
    if ([_dictScoreStats[@"par3_change_color"] length] > 0)
    {
        _scoreView.par3Sstr = _dictScoreStats[@"par3_change"];
        _scoreView.par3SChangeColor = [UIColor colorFromHexString:_dictScoreStats[@"par3_change_color"]];
    }
    if ([_dictScoreStats[@"par4_change_color"] length] > 0)
    {
        _scoreView.par4Sstr = _dictScoreStats[@"par4_change"];

        _scoreView.par4SChangeColor = [UIColor colorFromHexString:_dictScoreStats[@"par4_change_color"]];
    }
    if ([_dictScoreStats[@"par5_change_color"] length] > 0)
    {
        _scoreView.par5Sstr = _dictScoreStats[@"par5_change"];

        _scoreView.par5SChangeColor = [UIColor colorFromHexString:_dictScoreStats[@"par5_change_color"]];
    }
    if ([_dictScoreStats[@"in_change_color"] length] > 0)
    {
        _scoreView.inStr = _dictScoreStats[@"in_change"];
        _scoreView.inChangeColor = [UIColor colorFromHexString:_dictScoreStats[@"in_change_color"]];
    }
    if ([_dictScoreStats[@"out_change_color"] length] > 0)
    {
        _scoreView.outStr = _dictScoreStats[@"out_change"];
        _scoreView.outChangeColor = [UIColor colorFromHexString:_dictScoreStats[@"out_change_color"]];
    }
    
    [_scoreView setBasicElements];
    
}

- (IBAction)actionGir:(id)sender
{
    currentFuntionTag = CurrentFunction_Gir;
    for (UIView *views in self.lowerView.subviews)
    {
        [views removeFromSuperview];
    }
    if (self.girView == nil)
    {
        _girView = [[[NSBundle mainBundle] loadNibNamed:@"PT_GirView" owner:self options:nil] firstObject];
        _girView.frame = self.lowerView.bounds;
        
    }
    [self.lowerView addSubview:self.girView];
    
    _girView.hitLabel.text = _girStatsHit;
    _girView.missedLabel.text = _girStatsMissed;
    
    
    
    UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
    [_girBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateNormal];
    
    [_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_fairwayBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_puttingBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_recoveryBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    // [self setUpScrollForLowerView];
}
- (IBAction)actionfairway:(id)sender
{
    currentFuntionTag = CurrentFunction_Fairways;
    for (UIView *views in self.lowerView.subviews)
    {
        [views removeFromSuperview];
    }
    if (self.fairwayView == nil)
    {
        _fairwayView = [[[NSBundle mainBundle] loadNibNamed:@"PT_FairewayView" owner:self options:nil] firstObject];
        _fairwayView.frame = self.lowerView.bounds;
        _fairwayView.hitBtn.layer.cornerRadius = 10.0;
        _fairwayView.hitBtn.layer.masksToBounds = YES;
        
        _fairwayView.leftBtn.layer.cornerRadius = 10.0;
        _fairwayView.leftBtn.layer.masksToBounds = YES;
        
        _fairwayView.rightBtn.layer.cornerRadius = 10.0;
        _fairwayView.rightBtn.layer.masksToBounds = YES;
    }
    _fairwayView.leftLabel.text = _fairwaysLeft;
    _fairwayView.centreLabel.text = _fairwaysCentre;
    _fairwayView.rightLabel.text = _fairwaysRight;
    [self.lowerView addSubview:self.fairwayView];
    
    UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
    [_fairwayBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateNormal];
    
    [_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_girBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_puttingBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_recoveryBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    
    
}
- (IBAction)actionPutting:(id)sender
{
    currentFuntionTag = CurrentFunction_Putting;
    for (UIView *views in self.lowerView.subviews)
    {
        [views removeFromSuperview];
    }
    if (self.puttingStatsView == nil)
    {
        _puttingStatsView = [[[NSBundle mainBundle] loadNibNamed:@"PT_PuttingStatsView" owner:self options:nil] firstObject];
        _puttingStatsView.frame = self.lowerView.bounds;
        
        _puttingStatsView.holeBtn.layer.cornerRadius = 10.0;
        _puttingStatsView.holeBtn.layer.masksToBounds = YES;
        
        _puttingStatsView.girBtn.layer.cornerRadius = 10.0;
        _puttingStatsView.girBtn.layer.masksToBounds = YES;
        
        _puttingStatsView.roundBtn.layer.cornerRadius = 10.0;
        _puttingStatsView.roundBtn.layer.masksToBounds = YES;

        
    }
    _puttingStatsView.perHoleLabel.text = _puttLeft;
    _puttingStatsView.perGirLabel.text = _puttCentre;
    _puttingStatsView.perRoundLabel.text = _puttRight;
    
    [self.lowerView addSubview:self.puttingStatsView];
    
    UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
    [_puttingBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateNormal];
    
    [_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_girBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_fairwayBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_recoveryBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    
    
    
}
- (IBAction)actionRecovery:(id)sender{

    currentFuntionTag = CurrentFunction_Recovery;
    for (UIView *views in self.lowerView.subviews)
    {
        [views removeFromSuperview];
    }
    if (self.recoveryStatsView == nil)
    {
        _recoveryStatsView = [[[NSBundle mainBundle] loadNibNamed:@"PT_RecoveryStatsView" owner:self options:nil] firstObject];
        _recoveryStatsView.frame = self.lowerView.bounds;
        _recoveryStatsView.scrambleBtn.layer.cornerRadius = 10.0;
        // _recoveryStatsView.scrambleBtn.layer.borderWidth = 1.0;
        _recoveryStatsView.scrambleBtn.layer.masksToBounds = YES;
        
        _recoveryStatsView.sandBtn.layer.cornerRadius = 10.0;
        // _recoveryStatsView.scrambleBtn.layer.borderWidth = 1.0;
        _recoveryStatsView.sandBtn.layer.masksToBounds = YES;
    }
    
    self.recoveryStatsView.scrambleLabel.text = _recoveryStatsHit;
    self.recoveryStatsView.sandSavesLabel.text = _recoveryMissed;
    
    
    [self.lowerView addSubview:self.recoveryStatsView];
    
    UIImage *pressedbuttonImage = [UIImage imageNamed:@"mystats(click)"];
    [_recoveryBtn setBackgroundImage:pressedbuttonImage forState:UIControlStateNormal];
    
    [_scoreBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_girBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_puttingBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    [_fairwayBtn setBackgroundImage:[UIImage imageNamed:@"mystats"] forState:UIControlStateNormal];
    
    
}

- (void)updateCurrentView
{
    _eventsTitle.text = titleString;
    switch (currentFuntionTag) {
        case CurrentFunction_Score:
        {
            [self actionScore:_scoreBtn];
        }
            break;
        case CurrentFunction_Gir:
        {
            [self actionGir:_girBtn];
        }
            break;
        case CurrentFunction_Fairways:
        {
            [self actionfairway:_fairwayBtn];
        }
            break;
        case CurrentFunction_Putting:
        {
            [self actionPutting:_puttingBtn];
        }
            break;
        case CurrentFunction_Recovery:
        {
            [self actionRecovery:_recoveryBtn];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSelectNumberOfEvents:(id)sender
{
    PT_Last10View *last10View= [[[NSBundle mainBundle] loadNibNamed:@"PT_Last10View"
                                                owner:self options:nil] objectAtIndex:0];
    last10View.homeVC = self.homeVC;
    
    CGRect last10frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    //    CGRect _tableViewFrame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 180);
    
    last10View.frame = last10frame;
    last10View.hidden = NO;
    //    self.tableView.delegate = self;
    [self.view addSubview:last10View];
}


- (IBAction)actionBack
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate setIsStatsSelected:NO];
    
    [self.view removeFromSuperview];
    
    [self willMoveToParentViewController:nil];
}

- (void)setNumberOfEventsTitle:(NSString *)title
{
    titleString = title;
    
    
}


- (void)rightSwiped
{
    
        switch (currentFuntionTag) {
            case CurrentFunction_Score:
            {
    
            }
                break;
            case CurrentFunction_Gir:
            {
                [self actionScore:_scoreBtn];
            }
                break;
            case CurrentFunction_Fairways:
            {
                [self actionGir:_girBtn];
            }
                break;
            case CurrentFunction_Putting:
            {
                [self actionfairway:_fairwayBtn];
            }
                break;
            case CurrentFunction_Recovery:
            {
                [self actionPutting:_puttingBtn];
            }
                break;
                
            
        }

//    switch (currentFuntionTag) {
//        case CurrentFunction_Score:
//        {
//             [self actionGir:_girBtn];
//        }
//            break;
//        case CurrentFunction_Gir:
//        {
//            [self actionfairway:_fairwayBtn];
//        }
//            break;
//        case CurrentFunction_Fairways:
//        {
//            [self actionPutting:_puttingBtn];
//        }
//            break;
//        case CurrentFunction_Putting:
//        {
//            [self actionRecovery:_recoveryBtn];
//        }
//            break;
//        case CurrentFunction_Recovery:
//        {
//            
//        }
//            break;
//            
//            
//    }
    
}

- (void)leftSwiped
{
    switch (currentFuntionTag) {
        case CurrentFunction_Score:
        {
            [self actionGir:_girBtn];
        }
            break;
        case CurrentFunction_Gir:
        {
            [self actionfairway:_fairwayBtn];
        }
            break;
        case CurrentFunction_Fairways:
        {
            [self actionPutting:_puttingBtn];
        }
            break;
        case CurrentFunction_Putting:
        {
            [self actionRecovery:_recoveryBtn];
        }
            break;
        case CurrentFunction_Recovery:
        {
            
        }
            break;
            
            
    }

    
    //currentFuntionTag = CurrentFunction_Score;
//    switch (currentFuntionTag) {
//        case CurrentFunction_Score:
//        {
//            
//        }
//            break;
//        case CurrentFunction_Gir:
//        {
//            [self actionScore:_scoreBtn];
//        }
//            break;
//        case CurrentFunction_Fairways:
//        {
//            [self actionGir:_girBtn];
//        }
//            break;
//        case CurrentFunction_Putting:
//        {
//            [self actionfairway:_fairwayBtn];
//        }
//            break;
//        case CurrentFunction_Recovery:
//        {
//            [self actionPutting:_puttingBtn];
//        }
//            break;
//            
//        
//    }
}

@end
