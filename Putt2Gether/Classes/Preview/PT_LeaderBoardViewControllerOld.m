//
//  PT_LeaderBoardViewController.m
//  Putt2Gether
//
//  Created by Bunny on 9/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_LeaderBoardViewController.h"
#import "PT_LeaderStrokeplayTableViewCell.h"
#import "PT_ScoreCardViewController.h"
#import "PT_LeaderMoreView.h"
#import "PT_DelegateViewController.h"
#import "PT_StartEventViewController.h"

#import "PT_LeaderboardNameModel.h"

#import "PT_LeaderboardStrokeModel.h"

static NSString *const FetchEventParticipantsPostfix = @"getleaderboarddata";

static NSString *const FetchLeaderboardData = @"getleaderboard";

#define TabBGColor [UIColor colorWithRed:(250/251.0f) green:(251/255.0f) blue:(251/255.0f) alpha:1.0]


@interface PT_LeaderBoardViewController ()<UITableViewDelegate,UITableViewDataSource,PT_LeaderMoreDelegate>

{
    NSMutableArray *arrName;
    NSMutableArray*arrRank;
    NSMutableArray *arrStroke;
    NSMutableArray *arrhandicapLabel;
    CGFloat baseWidth;
    BOOL isStrokeDataToDisplay;
    SHActivityView *spinnerSmall;
    
    NSInteger currentSpotType;
    
   }

@property(nonatomic,strong)PT_LeaderMoreView*leaderView;
@property (strong, nonatomic) NSMutableArray *arrtable;
@property (nonatomic, strong) LoadingView *loadingView;

@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;
@property (weak, nonatomic) IBOutlet UIView *tabContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *tabScrollView;

//Models
@property (strong, nonatomic) NSMutableArray *arrLeaderboardStrokeArray;
@property (strong, nonatomic) NSMutableArray *arrSpotPrizeHoleData;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTabViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *golfCourseLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *feetAndInchesLabel;

@property (strong, nonatomic) UIView *tabUnderlineView;


@end

@implementation PT_LeaderBoardViewController

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    self.createdEventModel = model;
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (spinnerSmall == nil)
    {
        spinnerSmall = [[SHActivityView alloc]init];
        [self.loadingView addSubview:spinnerSmall];
        [self loadLoadingView];
        [self showLoadingView:NO];
        
    }
    spinnerSmall.spinnerSize = kSHSpinnerSizeTiny;
    spinnerSmall.spinnerColor = [UIColor blackColor];
    [spinnerSmall showAndStartAnimate];
    spinnerSmall.center = CGPointMake(_loadingView.frame.origin.x + spinnerSmall.frame.size.width, _loadingView.frame.origin.y + spinnerSmall.frame.size.height);
    
    self.eventNameLabel.text = [self.createdEventModel.eventName uppercaseString];
    self.golfCourseLabel.text = [self.createdEventModel.golfCourseName uppercaseString];

    [self fetchLeaderboardTabContentsForFormatId:self.createdEventModel.formatId];

      [_netstrokeBtn setTitle:@"NET   STROKEPLAY" forState:UIControlStateNormal];
    
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:64/255.0 blue:118/255.0 alpha:1]];
    [_netstrokeBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    [_netstrokeBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    
    _clickImageView1.hidden = NO;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
    
    _leaderView.hidden = YES;
    
    
    [self customdesisgn];
    //[self actionStroke];
    isStrokeDataToDisplay = NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tabScrollView.contentSize = CGSizeMake(baseWidth * ([arrName count]+1), 47);
}

-(void)viewWillAppear:(BOOL)animated
{
    //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultValues];
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
    spinnerSmall.spinnerColor = [UIColor blackColor];
    [self.loadingView addSubview:spinnerSmall];
    [spinnerSmall showAndStartAnimate];
    
    [self makespinnerSmallOnCentre];
}

-(void)makespinnerSmallOnCentre
{
    spinnerSmall.center = CGPointMake(self.loadingView.frame.size.width/2, self.loadingView.frame.size.height/2);
}


-(void)customdesisgn{
    
    [_strokeBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_strokeBtn.layer setBorderWidth:0.5f];
    
    [_closestBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_closestBtn.layer setBorderWidth:0.5f];
    
    [_longBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_longBtn.layer setBorderWidth:0.5f];
    
    [_straightBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_straightBtn.layer setBorderWidth:0.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TabView

- (void)createParticipantsButtons
{
    float width = 0.0;
    if ([arrName count] == 1)
    {
        width = self.view.frame.size.width;
    }
    else if ([arrName count] == 2)
    {
        width = self.view.frame.size.width/2 - 0.5;
    }
    else
    {
        width = self.view.frame.size.width/3 - 0.5;
    }
    baseWidth = width;
    __block float x = 0.0;
   //PT_LeaderboardNameModel *model = [arrName firstObject];
   
    
    for (UIView *sView in self.tabScrollView.subviews)
    {
        [sView removeFromSuperview];
    }
    _tabUnderlineView = [UIView new];
    _tabUnderlineView.backgroundColor = SplFormatBlueColor;
    [arrName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PT_LeaderboardNameModel *modelIndex = obj;
        UIButton *buttonPlayers = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonPlayers.frame = CGRectMake(x, 0, width, self.tabScrollView.frame.size.height);
        x = x + width+1;
        NSString *title;
        NSArray *arrStr = [modelIndex.display componentsSeparatedByString:@" "];
        for (NSInteger count = 0; count <[arrStr count]; count++)
        {
            if (count == 0)
            {
                title = [NSString stringWithFormat:@"%@ \n",arrStr[count]];
            }
            else
            {
                title = [NSString stringWithFormat:@"%@ %@",title,arrStr[count]];
            }
        }
        
        //buttonPlayers.backgroundColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
        buttonPlayers.backgroundColor = TabBGColor;
        buttonPlayers.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        buttonPlayers.layer.borderWidth = 0.4;
        [buttonPlayers setTitle:title forState:UIControlStateNormal];
        [buttonPlayers.titleLabel setTextColor:[UIColor whiteColor]];
        [buttonPlayers.titleLabel setFont:[UIFont fontWithName:@"Lato" size:14]];
        buttonPlayers.titleLabel.numberOfLines = 0;
        buttonPlayers.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        buttonPlayers.titleLabel.textAlignment = NSTextAlignmentCenter;
        [buttonPlayers setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        buttonPlayers.tag = idx;
        [buttonPlayers addTarget:self action:@selector(actionPlayerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabScrollView addSubview:buttonPlayers];
        if (idx == [arrName count] - 1)
        {
            self.tabScrollView.contentSize = CGSizeMake(baseWidth * ([arrName count]), 47);
        }
        if (idx == 0)
        {
            [buttonPlayers.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
            _tabUnderlineView.frame = CGRectMake(buttonPlayers.frame.origin.x, buttonPlayers.frame.size.height - 3, buttonPlayers.frame.size.width, 3);
            [buttonPlayers addSubview:_tabUnderlineView];
            [_tabUnderlineView bringToFront];
            if ([arrName count] == 1)
            {
                self.tabContentView.hidden = YES;
                self.constraintTabViewHeight.constant = 0;
            }
            else{
                //buttonPlayers.backgroundColor = [UIColor whiteColor];
                //[buttonPlayers setTitleColor:[UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0] forState:UIControlStateNormal];
                [buttonPlayers setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }];
    
}

- (void)actionPlayerSelected:(UIButton *)sender
{
    [_tabUnderlineView removeFromSuperview];
    [sender addSubview:_tabUnderlineView];
    UIColor *blueColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    if ([arrName count] == 1)
    {
        
    }
    else
    {
        
        //sender.backgroundColor = [UIColor whiteColor];
        
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    }
    
    for (NSInteger counter = 0; counter<[self.tabScrollView.subviews count]; counter++)
    {
        UIButton *btn = self.tabScrollView.subviews[counter];
        if (btn.tag == sender.tag)
        {
            
        }
        else
        {
            //btn.backgroundColor = blueColor;
            //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [sender.titleLabel setFont:[UIFont fontWithName:@"Lato" size:14]];
        }
    }
    PT_LeaderboardNameModel *model = [arrName objectAtIndex:sender.tag];
    currentSpotType = [model.spotType integerValue];
    switch ([model.spotType integerValue]) {
        case 1:
        {
            [self actionClosest:model];
        }
            break;
            
        case 2:
        {
            [self actionStraight:model];
        }
            break;
        case 3:
        {
            [self actionLong:model];
        }
            break;
        default:
        {
            [self actionStroke];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnCount;
    if (isStrokeDataToDisplay == YES)
    {
        returnCount = [self.arrLeaderboardStrokeArray count];
    }
    else{
        returnCount = [self.arrSpotPrizeHoleData count];
    }
    return returnCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellToReturn;
    if (isStrokeDataToDisplay == YES)
    {
        static NSString *cellIdentifier =@"cell";
        
        PT_LeaderStrokeplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == Nil)
        {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_LeaderStrokeplayTableViewCell" owner:self options:Nil] firstObject];
            
        }
        PT_LeaderboardStrokeModel *modelStroke = self.arrLeaderboardStrokeArray[indexPath.row];
        
        cell.rankLabel.text = modelStroke.current_position;
        if ([modelStroke.current_position isEqualToString:@"-"])
        {
            cell.rankLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
        }
        cell.playerLabel.text = [modelStroke.full_name uppercaseString];
        CGSize maximumSize = CGSizeMake(300, 9999);
        NSString *myString = modelStroke.full_name;
        UIFont *myFont = [UIFont fontWithName:@"Lato-Regular" size:12];
        CGSize myStringSize = [myString sizeWithFont:myFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:cell.rankLabel.lineBreakMode];
        cell.constraintPlayerWidth.constant = myStringSize.width;
        cell.holeLabel.text = modelStroke.no_of_hole_played;
        cell.holeLabel.hidden = NO;
        cell.strokelabel.text = [modelStroke.total uppercaseString];
        cell.handicapLabel.text = modelStroke.handicap_value;
        cellToReturn = cell;
    }
    else{
        static NSString *cellIdentifier =@"cell1";
        
        PT_LeaderStrokeplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == Nil)
        {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_LeaderStrokeplayTableViewCell" owner:self options:Nil] firstObject];
            
        }
        PT_LeaderboardStrokeModel *modelStroke = self.arrSpotPrizeHoleData[indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:233/255.0 green:237/255.0 blue:243/255.0 alpha:1];
        cell.rankLabel.text = modelStroke.current_position;
        if ([modelStroke.current_position isEqualToString:@"-"])
        {
            cell.rankLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
        }
        
        cell.playerLabel.text = modelStroke.full_name;
        CGSize maximumSize = CGSizeMake(300, 9999);
        NSString *myString = modelStroke.full_name;
        UIFont *myFont = [UIFont fontWithName:@"Lato-Regular" size:13];
        CGSize myStringSize = [myString sizeWithFont:myFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:cell.rankLabel.lineBreakMode];
        cell.constraintPlayerWidth.constant = myStringSize.width;
        cell.holeLabel.text = modelStroke.no_of_hole_played;
        cell.holeLabel.hidden = YES;
        //cell.strokelabel.text = modelStroke.total;
        cell.handicapLabel.text = modelStroke.handicap_value;
        NSString *strYards = [NSString stringWithFormat:@"%@",modelStroke.feet];
        if ([strYards length] == 0)
        {
            strYards = @"0";
        }
        NSString *strInches= [NSString stringWithFormat:@"%@",modelStroke.inches];
        if ([strInches length] == 0)
        {
            strInches = @"0";
        }
               switch (currentSpotType) {
            case 1://Closest
            {
                cell.strokelabel.text = [NSString stringWithFormat:@"%@' %@\"",strYards,strInches];
            }
                break;
                
            case 2://straight
            {
                cell.strokelabel.text = [NSString stringWithFormat:@"%@ YARDS",strYards];
            }
                break;
            case 3://long
            {
                
                cell.strokelabel.text = [NSString stringWithFormat:@"%@ YARDS",strYards];
            }
                break;
            
        }
        cellToReturn = cell;
    }
    return cellToReturn;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_LeaderboardStrokeModel *modelStroke = self.arrLeaderboardStrokeArray[indexPath.row];
    PT_ScoringIndividualPlayerModel *playerModel = [PT_ScoringIndividualPlayerModel new];
    playerModel.playerName = modelStroke.full_name;
    playerModel.playerId = [modelStroke.player_id integerValue];
    playerModel.handicap = [modelStroke.handicap_value integerValue];
    NSArray *arrToSend = [NSArray arrayWithObject:playerModel];
    PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:arrToSend];
    [self presentViewController:scorecardViewController animated:YES completion:nil];
    
}

- (IBAction)homeBtnClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate.tabBarController setSelectedIndex:0];
        //[self actionBAck];
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:NULL];
    });

}



-(IBAction)actionBack:(id)sender
{
    if (self.eventPreviewVC != nil)
    {
        self.eventPreviewVC.isEditMode = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)actionStroke{
    
    self.feetAndInchesLabel.hidden = YES;
    isStrokeDataToDisplay = YES;
    
    _holesplayedLabel.hidden =NO;
    _netstrokeBtn.hidden = NO;
    
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:64/255.0 blue:118/255.0 alpha:1]];
    NSString *formatName = self.createdEventModel.formatName;
   //[_netstrokeBtn setTitle:@"NET   STROKEPLAY" forState:UIControlStateNormal];
    [_netstrokeBtn setTitle:formatName forState:UIControlStateNormal];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
   [_netstrokeBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    
    _clickImageView1.hidden = NO;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
    
    [self.tableView reloadData];
    
}

-(IBAction)actionClosest:(PT_LeaderboardNameModel *)model
{
    NSString *eventId = [NSString stringWithFormat:@"%li",self.createdEventModel.eventId];
    NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
    NSString *holeNumber = model.holeNumber;
    
    _holesplayedLabel.hidden =YES;
    
    self.feetAndInchesLabel.hidden = NO;
    _netstrokeBtn.hidden = YES;
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1]];
    [_netstrokeBtn setTitle:@"FEET & INCHES" forState:UIControlStateNormal];
    //_netstrokeBtn.titleLabel.lineBreakMode = NSLine
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0f];
    [_netstrokeBtn setTitleColor: [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1] forState:UIControlStateNormal];
    
    _clickImageView1.hidden = YES;
    _clickImageView2.hidden = NO;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
    
    //[self.tableView reloadData];
    [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:holeNumber];
    
}

-(IBAction)actionLong:(PT_LeaderboardNameModel *)model
{
    
    _holesplayedLabel.hidden =YES;
    
    self.feetAndInchesLabel.hidden = YES;
    _netstrokeBtn.hidden = NO;
    
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1]];
    [_netstrokeBtn setTitle:@"YARDS" forState:UIControlStateNormal];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12.0f];
    //[_netstrokeBtn setTitleColor: [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1] forState:UIControlStateNormal];
    [_netstrokeBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    
    _clickImageView1.hidden = YES;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = NO;
    _clickImageView4.hidden = YES;

    
    //[self.tableView reloadData];
    
    NSString *eventId = [NSString stringWithFormat:@"%li",self.createdEventModel.eventId];
    NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
    NSString *holeNumber = model.holeNumber;
    
    [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:holeNumber];
    
}

-(IBAction)actionStraight:(PT_LeaderboardNameModel *)model{
    
    _holesplayedLabel.hidden =YES;
    
    self.feetAndInchesLabel.hidden = YES;
    _netstrokeBtn.hidden = NO;
    
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1]];
    [_netstrokeBtn setTitle:@"YARDS" forState:UIControlStateNormal];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:13.0f];
    //[_netstrokeBtn setTitleColor: [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1] forState:UIControlStateNormal];
    [_netstrokeBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];

    _clickImageView1.hidden = YES;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = NO;
    
    
    //[self.tableView reloadData];
    NSString *eventId = [NSString stringWithFormat:@"%li",self.createdEventModel.eventId];
    NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
    NSString *holeNumber = model.holeNumber;
    
    [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:holeNumber];
    
}

-(IBAction)actionhome:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate.tabBarController setSelectedIndex:0];
        //[self actionBAck];
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:NULL];
    });

    
}

-(IBAction)actionAddScore:(id)sender{
    
    /*PT_StartEventViewController *startEventViewController = [[PT_StartEventViewController alloc] initWithNibName:@"PT_StartEventViewController" bundle:nil];
    [self presentViewController:startEventViewController animated:YES completion:nil];
     */
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(IBAction)actionNetstroke:(id)sender{
    
    [self.tableView reloadData];
    
}

- (IBAction)actionMore
{
    
    _leaderView= [[[NSBundle mainBundle] loadNibNamed:@"PT_LeaderMoreView"
                                                owner:self options:nil] objectAtIndex:0];
    
    CGRect leaderViewframe = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    //    CGRect _tableViewFrame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 180);
    
    self.leaderView.frame = leaderViewframe;
    self.leaderView.hidden = NO;
    
   //self.leaderView.delegate = self;

    //    self.tableView.delegate = self;
    [self.view addSubview:self.leaderView];
}

- (void)didSelectScoreBoard
{
    PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithNibName:@"PT_ScoreCardViewController" bundle:nil];
    [self presentViewController:scorecardViewController animated:YES completion:nil];
}

- (void)didSelectDelegate{
    
    PT_DelegateViewController *delegateViewController = [[PT_DelegateViewController alloc] initWithNibName:@"PT_DelegateViewController" bundle:nil];
    [self presentViewController:delegateViewController animated:YES completion:nil];
    
    
}

- (void)didSelectEndRound{
    
}
- (void)didSelectShare{
    
}


- (void)loadLoadingView
{
    _loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
    
    self.loadingView.frame = self.view.bounds;
    
    [self.view addSubview:self.loadingView];
    
    //[self showLoadingView:NO];
    
    
}

- (void)showLoadingView:(BOOL)flag
{
    
    self.loadingView.hidden = !flag;
    
}

#pragma mark - AlertView

- (void)showAlertWithMessage:(NSString *)message
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


#pragma mark - Web service calls

- (void)fetchLeaderboardTabContentsForFormatId:(NSString *)formatId
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [self showLoadingView:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"format_id":formatId,
                                @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchEventParticipantsPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [self showLoadingView:NO];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"Success"])
                          {
                              arrName = [NSMutableArray new];
                              NSDictionary *dicData = dicOutput[@"data"];
                              
                              PT_LeaderboardNameModel *firstModel = [PT_LeaderboardNameModel new];
                              firstModel.display = dicData[@"format_name"];
                              firstModel.holeNumber = @"";
                              [arrName addObject:firstModel];
                              
                              id arrIsSpot = dicData[@"is_spot"];
                              
                              if ([arrIsSpot isKindOfClass:[NSArray class]])
                              {
                                  [arrIsSpot enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *object = obj;
                                      PT_LeaderboardNameModel *model = [PT_LeaderboardNameModel new];
                                      model.display = object[@"dislay_data"];
                                      model.holeNumber = [NSString stringWithFormat:@"%@",object[@"hole_number"]];
                                      model.spotType = [NSString stringWithFormat:@"%@",object[@"is_spot_type"]];
                                      [arrName addObject:model];
                                      if (idx == [arrIsSpot count] - 1)
                                      {
                                          [self createParticipantsButtons];
                                      }
                                      
                                  }];
                              }
                              else{
                                  [self createParticipantsButtons];
                              }
                              
                              NSArray *arrleaderboardStroke = dicData[@"leader_board"];
                              _arrLeaderboardStrokeArray = [NSMutableArray new];
                              [arrleaderboardStroke enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  NSDictionary *dicLeaderboardStroke = obj;
                                  PT_LeaderboardStrokeModel *leaderboardStrokeModel = [PT_LeaderboardStrokeModel new];
                                  leaderboardStrokeModel.current_position = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"current_position"]];
                                  leaderboardStrokeModel.feet = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"feet"]];
                                  leaderboardStrokeModel.full_name = dicLeaderboardStroke[@"full_name"];
                                  leaderboardStrokeModel.handicap_value = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"handicap_value"]];
                                  leaderboardStrokeModel.inches = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"inches"]];
                                  leaderboardStrokeModel.no_of_hole_played = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"no_of_hole_played"]];
                                  leaderboardStrokeModel.player_id = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"player_id"]];
                                  leaderboardStrokeModel.total = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"total"]];
                                  [self.arrLeaderboardStrokeArray addObject:leaderboardStrokeModel];
                                  if (idx == [arrleaderboardStroke count] - 1)
                                  {
                                      [self actionStroke];
                                  }
                              }];
                          }
                          
                          
                          }
                          else
                          {
                              [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }];
         
                  
                  
        
    }
    
}

- (void)fetchLeaderBoardDataForEventId:(NSString *)eventId
                           andFormatId:(NSString *)formatId
                         andHoleNumber:(NSString *)holeNumber
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [self showLoadingView:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"format_id":formatId,
                                @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"is_spot_hole_number":holeNumber,
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchLeaderboardData];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [self showLoadingView:NO];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                        
                              NSDictionary *dicData = dicOutput[@"data"];
                              
                              _arrSpotPrizeHoleData = [NSMutableArray new];
                              
                              NSArray *arrleaderboardStroke = dicData[@"player_score"];
                              
                              [arrleaderboardStroke enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  NSDictionary *dicLeaderboardStroke = obj;
                                  PT_LeaderboardStrokeModel *leaderboardStrokeModel = [PT_LeaderboardStrokeModel new];
                                  
                                  leaderboardStrokeModel.current_position = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"current_position"]];
                                  
                                  leaderboardStrokeModel.feet = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"feet"]];
                                  
                                  leaderboardStrokeModel.full_name = dicLeaderboardStroke[@"full_name"];
                                  
                                  leaderboardStrokeModel.handicap_value = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"handicap_value"]];
                                  
                                  leaderboardStrokeModel.inches = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"inches"]];
                                  
                                  leaderboardStrokeModel.no_of_hole_played = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"no_of_hole_played"]];
                                  
                                  leaderboardStrokeModel.player_id = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"player_id"]];
                                  leaderboardStrokeModel.total = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"total"]];
                                  [self.arrSpotPrizeHoleData addObject:leaderboardStrokeModel];
                                  if (idx == [arrleaderboardStroke count] - 1)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          isStrokeDataToDisplay = NO;
                                          
                                          [self.tableView reloadData];
                                      });
                                      
                                  }
                              }];
                              
                          }
                          
                          
                      }
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  
                  else
                  {
                      [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                  }
              }];
        
        
        
        
    }
 
}

@end
