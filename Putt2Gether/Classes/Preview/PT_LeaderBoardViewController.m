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
#import <QuartzCore/QuartzCore.h>

#import "PT_MyScoresModel.h"

#import "UIImageView+AFNetworking.h"

static NSString *const FetchEventParticipantsPostfix = @"getleaderboarddata";

static NSString *const FetchLeaderboardData = @"getleaderboard";

static NSString *const FetchBannerPostFix = @"getadvbanner";

//static NSString *const deleteRoundPostFix = @"endscore";

#define TabBGColor [UIColor colorWithRed:(11/251.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0]


@interface PT_LeaderBoardViewController ()<UITableViewDelegate,UITableViewDataSource,PT_LeaderMoreDelegate>

{
    NSMutableArray *arrName;
    NSMutableArray*arrRank;
    NSMutableArray *arrStroke;
    NSMutableArray *arrhandicapLabel;
    CGFloat baseWidth;
    BOOL isStrokeDataToDisplay;
    NSInteger currentSpotType;
    BOOL selected;
    BOOL isLongDriveTabActive;
    BOOL isGrossTab;
    BOOL isStrokeSelected;
    BOOL isRefreshControl;
    
    IBOutlet UILabel *eventNameTitle;
    IBOutlet UILabel *golfCourseName;
    
   }

@property(nonatomic,strong)  PT_LeaderMoreView*leaderView;
@property (strong, nonatomic) NSMutableArray *arrtable;

@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;
@property (weak, nonatomic) IBOutlet UIView *tabContentView,*loaderView,*loaderInsideView;
@property (weak, nonatomic) IBOutlet UIScrollView *tabScrollView;

//Models
@property (strong, nonatomic) NSMutableArray *arrLeaderboardStrokeArray;
@property (strong, nonatomic) NSMutableArray *arrSpotPrizeHoleData,*arrBanner;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTabViewHeight;



@property (weak, nonatomic) IBOutlet UILabel *feetAndInchesLabel;

@property (strong, nonatomic) UIView *tabUnderlineView;

@property(strong,nonatomic) NSString *DelorSaveUrl,*holeNotoSend;

//Mark:-End Round PopUp
@property(weak,nonatomic) IBOutlet UIView *popUpView,*popBackView;

@property(strong,nonatomic) UIRefreshControl *refreshControl;

@property(assign,nonatomic) BOOL isRequestToParticipate;

@property(weak,nonatomic) MBProgressHUD *hud;


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
    
   
    
    self.eventNameLabel.text = [self.createdEventModel.eventName uppercaseString];
    self.golfCourseLabel.text = [self.createdEventModel.golfCourseName uppercaseString];
    
    eventNameTitle.text = [self.createdEventModel.eventName uppercaseString];
    golfCourseName.text = [self.createdEventModel.golfCourseName uppercaseString];
    

    [self fetchLeaderboardTabContentsForFormatId:self.createdEventModel.formatId];

      [_netstrokeBtn setTitle:self.createdEventModel.formatName forState:UIControlStateNormal];
    
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:64/255.0 blue:118/255.0 alpha:1]];
    [_netstrokeBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    [_netstrokeBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    
    _clickImageView1.hidden = NO;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
    
    _leaderView.hidden = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self customdesisgn];
    //[self actionStroke];
    isStrokeDataToDisplay = NO;
    
    isLongDriveTabActive = NO;
    isStrokeSelected = NO;
    isGrossTab = NO;
    //Mark:-Tapping outside to hide popUp
        [self.popUpView setHidden:YES];
    [self fetchBannerDetail];
    
    
    if (_isSeenAfterDelegate == YES) {
        
        [self.addScoreBtn setHidden:YES];
        [self.addScoreImg setHidden:YES];
        [self.addScoreLAbel setHidden: YES];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tabScrollView.contentSize = CGSizeMake(baseWidth * ([arrName count]) +baseWidth, 47);
}

-(void)viewWillAppear:(BOOL)animated
{
    //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultValues];
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
   
}


-(void)refreshTable:(UIRefreshControl *)refreshControl
{
    isRefreshControl = YES;
    //TODO: refresh your data

    if (isStrokeDataToDisplay == YES) {
        
        [self.arrLeaderboardStrokeArray removeAllObjects];
        
        
        [self fetchLeaderboardTabContentsForFormatId:self.createdEventModel.formatId];
        
        _arrLeaderboardStrokeArray = [NSMutableArray new];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        
        [self.tableView reloadData];
        

    }else{
        
        if (isLongDriveTabActive == YES) {
            
            [self.arrSpotPrizeHoleData removeAllObjects];
            
            NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
            NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
            
            [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:_holeNotoSend andSpotType:@"3"];
           
            
            _arrLeaderboardStrokeArray = [NSMutableArray new];
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
            
            
            
            [self.tableView reloadData];

            
            

        }else{
            
            if (isGrossTab == YES) {
                
                [self.arrSpotPrizeHoleData removeAllObjects];

                NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
                [self fetchLeaderBoardDataForEventId:eventId andFormatId:@"2" andHoleNumber:@"" andSpotType:@"1"];
                
                _arrLeaderboardStrokeArray = [NSMutableArray new];
                
                _tableView.delegate = self;
                _tableView.dataSource = self;
                
                
                
                [self.tableView reloadData];
                
                
            }else{
        
        [self.arrSpotPrizeHoleData removeAllObjects];
        
            NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
            NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
            

        
        [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:_holeNotoSend andSpotType:@"1"];
        
        _arrLeaderboardStrokeArray = [NSMutableArray new];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        
        [self.tableView reloadData];
                
            }
        }
        
    }
    
       [_refreshControl endRefreshing];
    
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
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        int screenHeight = screenRect.size.height;
        
        if (screenHeight == 568) {
            
            width = self.view.frame.size.width/3 - 12;
        }else{
            
            width = self.view.frame.size.width/3 + 15;

        }
        
    }
    baseWidth = width;
    __block float x = 0.0;
   //PT_LeaderboardNameModel *model = [arrName firstObject];
   
    
    for (UIView *sView in self.tabScrollView.subviews)
    {
        [sView removeFromSuperview];
    }
    _tabUnderlineView = [UIView new];
    _tabUnderlineView.backgroundColor = TabBGColor;
    [arrName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PT_LeaderboardNameModel *modelIndex = obj;
        UIButton *buttonPlayers = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonPlayers.frame = CGRectMake(x, 0, width, self.tabScrollView.frame.size.height);
        x = x + width;
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
        buttonPlayers.layer.borderColor = [[UIColor whiteColor] CGColor];
        buttonPlayers.layer.borderWidth = 0.4;
        [buttonPlayers setTitle:title forState:UIControlStateNormal];
        [buttonPlayers.titleLabel setTextColor:[UIColor whiteColor]];
        [buttonPlayers.titleLabel setFont:[UIFont fontWithName:@"Lato" size:14]];
        buttonPlayers.titleLabel.numberOfLines = 0;
        buttonPlayers.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        buttonPlayers.titleLabel.textAlignment = NSTextAlignmentCenter;
        [buttonPlayers setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
        buttonPlayers.tag = idx;
        [buttonPlayers addTarget:self action:@selector(actionPlayerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabScrollView addSubview:buttonPlayers];
        if (idx == [arrName count] - 1)
        {
            self.tabScrollView.contentSize = CGSizeMake(baseWidth * ([arrName count]) + baseWidth, 47);
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
                [buttonPlayers setTitleColor:TabBGColor forState:UIControlStateNormal];
                [buttonPlayers setBackgroundColor:[UIColor whiteColor]];

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
        
        sender.backgroundColor = [UIColor whiteColor];
        
        [sender setTitleColor:TabBGColor forState:UIControlStateNormal];
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
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:TabBGColor];
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
            [self actionStroke:model];
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
           // cell.rankLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13];
        }
        cell.playerLabel.text = [modelStroke.full_name uppercaseString];
        CGSize maximumSize = CGSizeMake(120, 9999);
        

        
        NSString *myString = cell.playerLabel.text;
        NSUInteger characterCount = [myString length];
        NSLog(@"%lu",(unsigned long)characterCount);
        
        if (characterCount > 11) {
            
            
            UIFont *myFont = [UIFont fontWithName:@"Lato-Regular" size:12];
            CGSize myStringSize = [myString sizeWithFont:myFont
                                       constrainedToSize:maximumSize
                                           lineBreakMode:cell.rankLabel.lineBreakMode];
            cell.constraintPlayerWidth.constant = myStringSize.width - 10;
        }else{
        
        UIFont *myFont = [UIFont fontWithName:@"Lato-Regular" size:12];
        CGSize myStringSize = [myString sizeWithFont:myFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:cell.rankLabel.lineBreakMode];
        cell.constraintPlayerWidth.constant = myStringSize.width;
        }
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
        //cell.backgroundColor = [UIColor colorWithRed:233/255.0 green:237/255.0 blue:243/255.0 alpha:1];
        cell.rankLabel.text = modelStroke.current_position;
        if ([modelStroke.current_position isEqualToString:@"-"])
        {
           // cell.rankLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13];
        }
        
        cell.playerLabel.text = modelStroke.full_name;
        CGSize maximumSize = CGSizeMake(120, 9999);
        NSString *myString = cell.playerLabel.text;
        
        NSUInteger characterCount = [myString length];
        NSLog(@"%lu",(unsigned long)characterCount);
        
        if (characterCount > 11) {
            
            UIFont *myFont = [UIFont fontWithName:@"Lato-Regular" size:12];
            CGSize myStringSize = [myString sizeWithFont:myFont
                                       constrainedToSize:maximumSize
                                           lineBreakMode:cell.rankLabel.lineBreakMode];
            cell.constraintPlayerWidth.constant = myStringSize.width ;
        }else{
        
        UIFont *myFont = [UIFont fontWithName:@"Lato-Regular" size:12];
        CGSize myStringSize = [myString sizeWithFont:myFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:cell.rankLabel.lineBreakMode];
        cell.constraintPlayerWidth.constant = myStringSize.width;
        }
        
        cell.holeLabel.text = modelStroke.no_of_hole_played;
        cell.strokelabel.text = [modelStroke.total uppercaseString];
        cell.handicapLabel.text = modelStroke.handicap_value;
        
        if (selected == YES) {
            
            if (modelStroke.no_of_hole_played == (id)[NSNull null] || modelStroke.no_of_hole_played.length == 0 || [modelStroke.no_of_hole_played isEqualToString:@"(null)"]){
                
                cell.holeLabel.hidden = YES;

            }else{
                cell.holeLabel.hidden = NO;

            
            }
            
        }else{
        
        cell.holeLabel.text = modelStroke.no_of_hole_played;
        cell.holeLabel.hidden = YES;
        //cell.strokelabel.text = modelStroke.total;
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
                
                //Mark:-if we are getting (-1) from service call then
                if ([strYards integerValue] == -1)
                {
                    strYards = @"-";
                    cell.strokelabel.text = @"-";
                }else{
                    
                cell.strokelabel.text = [NSString stringWithFormat:@"%@' %@\"",strYards,strInches];
                }
            }
                break;
                
            case 2://straight
            {
                if ([strYards integerValue] == -1)
                {
                    strYards = @"-";
                    cell.strokelabel.text = @"-";
                }else{
                    
                cell.strokelabel.text = [NSString stringWithFormat:@"%@' %@\"",strYards,strInches];
                }
            }
                break;
            case 3://long
            {
                if ([strYards integerValue] == -1)
                {
                    strYards = @"-";
                    cell.strokelabel.text = @"-";
                }else{
                
                cell.strokelabel.text = [NSString stringWithFormat:@"%@ ",strYards];
                }
            }
                break;
            
        }
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
    if (isStrokeDataToDisplay == YES) {
        
        PT_LeaderboardStrokeModel *modelStroke = self.arrLeaderboardStrokeArray[indexPath.row];
        PT_ScoringIndividualPlayerModel *playerModel = [PT_ScoringIndividualPlayerModel new];
        playerModel.playerName = modelStroke.full_name;
        playerModel.playerId = [modelStroke.player_id integerValue];
        playerModel.handicap = [modelStroke.handicap_value integerValue];
        NSArray *arrToSend = [NSArray arrayWithObject:playerModel];
        if (_isSeenAfterDelegate == YES) {
            
            PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:arrToSend];
            
            scorecardViewController.isComingFromMyscore = YES;
            [self presentViewController:scorecardViewController animated:YES completion:nil];
        }else{
        
        PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:arrToSend];
        [self presentViewController:scorecardViewController animated:YES completion:nil];
        }

        
    }else{
        
        PT_LeaderboardStrokeModel *modelStroke = self.arrSpotPrizeHoleData[indexPath.row];
        PT_ScoringIndividualPlayerModel *playerModel = [PT_ScoringIndividualPlayerModel new];
        playerModel.playerName = modelStroke.full_name;
        playerModel.playerId = [modelStroke.player_id integerValue];
        playerModel.handicap = [modelStroke.handicap_value integerValue];
        NSArray *arrToSend = [NSArray arrayWithObject:playerModel];
        
        if (_isSeenAfterDelegate == YES) {
            
            PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:arrToSend];
            scorecardViewController.isComingFromMyscore = YES;

            [self presentViewController:scorecardViewController animated:YES completion:nil];
        }else{

        
        PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:arrToSend];
        [self presentViewController:scorecardViewController animated:YES completion:nil];
        }
    }
    
    
}

- (IBAction)homeBtnClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate addTabBarAsRootViewController];
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
    if ([self.createdEventModel.isEventStarted isEqualToString:@"8"]) {
        
        [self fetchEvent:self.createdEventModel withType:InviteType_Detail];
    }else{
    
    if (self.eventPreviewVC != nil)
    {
        self.eventPreviewVC.isEditMode = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)actionStroke:(PT_LeaderboardNameModel *)model{
     //PT_LeaderboardNameModel *firstModel = [PT_LeaderboardNameModel new];
    
    
    
    if (_hud == nil && isRefreshControl == NO) {
        
        isRefreshControl = NO;
        self.loaderView.hidden = NO;

        _hud =  [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];

    }
    

    self.feetAndInchesLabel.hidden = YES;
    isStrokeDataToDisplay = YES;
    selected = NO;

    _holesplayedLabel.hidden =NO;
    _netstrokeBtn.hidden = NO;
    
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:64/255.0 blue:118/255.0 alpha:1]];
    NSString *formatName = [model.display uppercaseString];
   //[_netstrokeBtn setTitle:@"NET   STROKEPLAY" forState:UIControlStateNormal];
    [_netstrokeBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];

    [_netstrokeBtn setTitle:formatName forState:UIControlStateNormal];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
   [_netstrokeBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    
    _clickImageView1.hidden = NO;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
    
    if ( isStrokeSelected == YES) {
        
        NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
        
        [self fetchLeaderboardTabContentsForFormatId:formatId];
    }
    

    
    [self.tableView reloadData];
    
}

-(IBAction)actionClosest:(PT_LeaderboardNameModel *)model
{
    
    if (_hud == nil) {
        self.loaderView.hidden = NO;

      _hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];

    }

    isStrokeSelected = YES;

    NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
    NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
    NSString *holeNumber = model.holeNumber;
    
    _holeNotoSend = holeNumber;
    
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
    [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:holeNumber andSpotType:@"1"];
    
}

-(IBAction)actionLong:(PT_LeaderboardNameModel *)model{
    if (_hud == nil) {
        self.loaderView.hidden = NO;

        _hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
    }
    isStrokeSelected = YES;

    isLongDriveTabActive = YES;

    _holesplayedLabel.hidden =YES;
    
    self.feetAndInchesLabel.hidden = YES;
    _netstrokeBtn.hidden = NO;
    
    [_netstrokeBtn setBackgroundColor:[UIColor clearColor]];
    [_netstrokeBtn setTitle:@"YARDS" forState:UIControlStateNormal];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12.0f];
    [_netstrokeBtn setTitleColor: [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1] forState:UIControlStateNormal];
    //_netstrokeBtn.userInteractionEnabled = NO;
   // [_netstrokeBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    
    _clickImageView1.hidden = YES;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = NO;
    _clickImageView4.hidden = YES;

    
    //[self.tableView reloadData];
    
    NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
    NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
    NSString *holeNumber = model.holeNumber;
    
    _holeNotoSend = holeNumber;

    
    [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:holeNumber andSpotType:@"3"];
    
}

-(IBAction)actionStraight:(PT_LeaderboardNameModel *)model{
    
    
    if (_hud == nil) {
        
        self.loaderView.hidden = NO;

        _hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
    }
    
    isStrokeSelected = YES;

    _holesplayedLabel.hidden =YES;
    
    self.feetAndInchesLabel.hidden = NO;
    _netstrokeBtn.hidden = YES;
    
    [_netstrokeBtn setBackgroundColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1]];
    [_netstrokeBtn setTitle:@"FEET & INCHES" forState:UIControlStateNormal];
    _netstrokeBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:13.0f];
    [_netstrokeBtn setTitleColor: [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1] forState:UIControlStateNormal];
   // [_netstrokeBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];

    _clickImageView1.hidden = YES;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = NO;
    
    
    //[self.tableView reloadData];
    NSString *eventId = [NSString stringWithFormat:@"%li",self.createdEventModel.eventId];
    NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];
    NSString *holeNumber = model.holeNumber;
    
    _holeNotoSend = holeNumber;

    
    [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:holeNumber andSpotType:@"1"];
    
}

-(IBAction)actionhome:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate addTabBarAsRootViewController];
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


-(IBAction)actionNetstroke:(UIButton *)sender{
    
    
    NSString *formatId = [NSString stringWithFormat:@"%@",self.createdEventModel.formatId];

    if ([formatId isEqualToString:@"2"]) {
        
        
    }else{
        
        if (_hud == nil) {
            
            self.loaderView.hidden = NO;
            
            _hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
            
        }
        
        if (selected == YES) {
            
            NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
            selected = NO;
            isStrokeDataToDisplay = YES;
            [self fetchLeaderboardTabContentsForFormatId:formatId];
           // [self fetchLeaderBoardDataForEventId:eventId andFormatId:formatId andHoleNumber:@"" andSpotType:@"1"];

           
            [_netstrokeBtn setTitle:self.createdEventModel.formatName forState:UIControlStateNormal];
        }else{
    
    NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
        selected = YES;
            isStrokeDataToDisplay = NO;
            
            isGrossTab = YES;


    [self fetchLeaderBoardDataForEventId:eventId andFormatId:@"2" andHoleNumber:@"" andSpotType:@"1"];
        [_netstrokeBtn setTitle:@"GROSS STROKEPLAY" forState:UIControlStateNormal];
        
        }
        

    }
    
   
    
}

- (IBAction)actionMore
{
    
   // [_leaderView setHidden:NO];
    _leaderView= [[[NSBundle mainBundle] loadNibNamed:@"PT_LeaderMoreView"
                                                owner:self options:nil] objectAtIndex:0];
    
    CGRect leaderViewframe = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    if (_isSeenAfterDelegate == YES) {
        
        _leaderView.constraintDelegate.constant = _leaderView.constraintDelegate.constant - 60;
        _leaderView.ConstraintendRound.constant = _leaderView.ConstraintendRound.constant - 60;
        _leaderView.ConstraintBottomView.constant = 176.0f;
    }
    
    self.leaderView.frame = leaderViewframe;
    self.leaderView.hidden = NO;
    
   self.leaderView.delegate = self;

    //    self.tableView.delegate = self;
    [self.view addSubview:self.leaderView];
}

- (void)didSelectScoreBoard
{
//    PT_LeaderboardStrokeModel *modelStroke = self.arrLeaderboardStrokeArray[indexPath.row];
    PT_ScoringIndividualPlayerModel *playerModel = [PT_ScoringIndividualPlayerModel new];
    playerModel.playerName =  [NSString stringWithFormat:@"%@",[[MGUserDefaults sharedDefault] getDisplayName]];
    playerModel.playerId =  [[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]] integerValue];
    playerModel.handicap =  [[NSString stringWithFormat:@"%@",[[MGUserDefaults sharedDefault] getHandicap]] integerValue];
    NSArray *arrToSend = [NSArray arrayWithObject:playerModel];
    
    if (_isSeenAfterDelegate == YES) {
        
        PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:arrToSend];
        scorecardViewController.isComingFromMyscore = YES;
        
        [self presentViewController:scorecardViewController animated:YES completion:nil];
        
    }else{
    
    PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:arrToSend];
    [self presentViewController:scorecardViewController animated:YES completion:nil];
    }

}

- (void)didSelectDelegate{
    
    PT_DelegateViewController *delegateViewController = [[PT_DelegateViewController alloc] initWithNibName:@"PT_DelegateViewController" bundle:nil];
    [self presentViewController:delegateViewController animated:YES completion:nil];
    
    
}

- (void)didSelectEndRound{
    
    [self.leaderView setHidden:YES];
    [self.popUpView setHidden:NO];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.popBackView addGestureRecognizer:singleFingerTap];

    
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recon
{
    [self.popUpView setHidden:YES];

}
- (void)didSelectShare{
    
    [_leaderView setHidden:YES];
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        [imageData writeToFile:@"screenshot.png" atomically:YES];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    } else {
        NSLog(@"error while taking screenshot");
    }
    
    // grab an item we want to share
    NSArray *items = @[image];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // exclude several items
    NSArray *excluded = @[UIActivityTypeMessage, UIActivityTypePrint];
    controller.excludedActivityTypes = excluded;
    
    // and present it
    [self presentViewController:controller animated:YES completion:^{
        controller.completionWithItemsHandler = ^(NSString *activityType,
                                                  BOOL completed,
                                                  NSArray *returnedItems,
                                                  NSError *error){
            // react to the completion
            if (completed) {
                
                // user shared an item
                NSLog(@"We used activity type%@", activityType);
                
            } else {
                
                // user cancelled
                NSLog(@"We didn't want to share anything after all.");
            }
            
            if (error) {
                NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
            }
        };
    }];
    
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
    NSString *strFormatID = formatId;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        if (isRefreshControl == YES) {
            
        }else{
            
            if (_hud == nil) {
                
                _hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];

            }
        }
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"format_id":formatId,
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchEventParticipantsPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                          self.loaderView.hidden = YES;
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
                                      
                                      if (isStrokeSelected == YES) {
                                          
                                          isRefreshControl = NO;
                                          
                                      }else{
                                          
                                      
                                      [self actionStroke:firstModel];
                                      }
                                      
                                      [UIView transitionWithView: self.tableView
                                                        duration: 0.2f
                                                         options: UIViewAnimationOptionTransitionCrossDissolve
                                                      animations: ^(void)
                                       {
                                           [self.tableView reloadData];
                                           
                                       }
                                                      completion:^(BOOL finished){
                                                          
                                                      }];
                                      

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
                          UIAlertController * alert=   [UIAlertController
                                                        alertControllerWithTitle:@"PUTT2GETHER"
                                                        message:@"Connection Lost."
                                                        preferredStyle:UIAlertControllerStyleAlert];
                          
                          
                          
                          UIAlertAction* cancel = [UIAlertAction
                                                   actionWithTitle:@"Retry"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                                                   {
                                                       [self fetchLeaderboardTabContentsForFormatId:strFormatID];
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
                          
                          [alert addAction:cancel];
                          
                          [self presentViewController:alert animated:YES completion:nil];
                      }
                  }];
         
                  
                  
        
    }
    
}

- (void)fetchLeaderBoardDataForEventId:(NSString *)eventId
                           andFormatId:(NSString *)formatId
                         andHoleNumber:(NSString *)holeNumber
                           andSpotType:(NSString *)spotType
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        if (isRefreshControl == YES) {
            
            isRefreshControl = NO;
            
        }else{
          _hud  = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        }        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"format_id":formatId,
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"is_spot_hole_number":holeNumber,
                                @"is_spot_type":spotType,
                                @"version":@"2"
                                };
        
        NSLog(@"Param To send:- %@",param);
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchLeaderboardData];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                  self.loaderView.hidden = YES;

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
                                  NSLog(@"%@",leaderboardStrokeModel.handicap_value);
                                  
                                  leaderboardStrokeModel.inches = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"inches"]];
                                  
                                  leaderboardStrokeModel.no_of_hole_played = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"no_of_hole_played"]];
                                  
                                  leaderboardStrokeModel.player_id = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"player_id"]];
                                  leaderboardStrokeModel.total = [NSString stringWithFormat:@"%@",dicLeaderboardStroke[@"total"]];
                                  [self.arrSpotPrizeHoleData addObject:leaderboardStrokeModel];
                                  if (idx == [arrleaderboardStroke count] - 1)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          isStrokeDataToDisplay = NO;
                                          
                                      });
                                      
                                      [UIView transitionWithView: self.tableView
                                                        duration: 0.2f
                                                         options: UIViewAnimationOptionTransitionCrossDissolve
                                                      animations: ^(void)
                                       {
                                           [self.tableView reloadData];
                                           
                                       }
                                                      completion:^(BOOL finished){
                                                          
                                                      }];

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

//Mark:Pop Up button Action Methods
-(IBAction)actionDelete{
    
    _DelorSaveUrl = @"endscore";
    
    [self deleteorSaveRound];
    [self.popUpView setHidden:YES];
}
-(IBAction)actionModify{
    
    [self.popUpView setHidden:YES];
}
-(IBAction)actionSave{
    
    _DelorSaveUrl = @"submitscore";
    [self deleteorSaveRound];
    [self.popUpView setHidden:YES];

}

//Mark:-Service call for Delete a Round
-(void)deleteorSaveRound{
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,_DelorSaveUrl];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                  self.loaderView.hidden = YES;

                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              UIAlertController * alert=   [UIAlertController
                                                            alertControllerWithTitle:@"PUTT2GETHER"
                                                            message:@"Successfully Done.."
                                                            preferredStyle:UIAlertControllerStyleAlert];
                              
                              
                              
                              UIAlertAction* cancel = [UIAlertAction
                                                       actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                                delegate.tabBarController.tabBar.hidden = NO;
                                                               [delegate addTabBarAsRootViewController];

                                                                //[self actionBAck];
//                                                                UIViewController *vc = self.presentingViewController;
//                                                                while (vc.presentingViewController) {
//                                                                vc = vc.presentingViewController;
//                                                                }
//                                                                [vc dismissViewControllerAnimated:YES completion:NULL];
                                                               
                                                               //Mark:redirection to home viewController
//                                                               AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                                                               delegate.tabBarController.tabBar.hidden = NO;
//                                                               [delegate.tabBarController setSelectedIndex:0];
                                                           });
                                                           
                                                       }];
                              
                              [alert addAction:cancel];
                              
                              [self presentViewController:alert animated:YES completion:nil];
                              
                              
                              
                          
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


//Mark:- Banner in the Bottom Service Call
- (void)fetchBannerDetail
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        //[self showLoadingView:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        
        
        NSDictionary *param = @{@"type":@"3",
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        //[self showLoadingView:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchBannerPostFix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  //[self showLoadingView:NO];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              _arrBanner = [NSMutableArray new];
                              
                              NSArray *arrData = dicOutput[@"data"];
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  NSDictionary *dicAtIndex = obj;
                                  PT_MyScoresModel *model = [PT_MyScoresModel new];
                                  
                                  model.eventId = [dicAtIndex[@"event_id"] integerValue];
                                  model.formatId = [dicAtIndex[@"id"] integerValue];
                                  model.eventName = dicAtIndex[@"image_path"];
                                  model.golfCourseName = dicAtIndex[@"image_href"];
                                  [_arrBanner addObject:model];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      [self.bannerImg setImageWithURL:[NSURL URLWithString:model.eventName]];
                                  }else{
                                      
                                      [self.bannerImg removeFromSuperview];
                                      
                                  }
                              }];
                          }
                          else
                          {
                              //[self showAlertWithMessage:@"Empty."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
    
}

-(IBAction)actionBannerClicked:(UIButton *)sender{
    
    PT_MyScoresModel *model = _arrBanner[sender.tag];
    
    if (model.golfCourseName.length == 0) {
        
        
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.golfCourseName]];
    }
    
}

//Mark:-for sending on event Listing
- (void)fetchEvent:(PT_CreatedEventModel *)model withType:(InviteType)type
{
    NSString *eventId = [NSString stringWithFormat:@"%li",(long)model.eventId];
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
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
                                @"event_id":eventId,
                                @"request_to_participate":requestToPraticipate,
                                @"version":@"2"
                                };
        
        NSString *urlString = @"eventdetail";
        [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                  self.loaderView.hidden = YES;

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
                                      model.eventId = [eventId integerValue];
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
                                              
                                              //if (model.isAdmin == YES)
                                              if (type == InviteType_Edit)
                                              {
                                                  
                                              }
                                              else{
                                                  PT_EventPreviewViewController *createVC = [[PT_EventPreviewViewController alloc]initWithModel:model andIsRequestToParticipate:self.isRequestToParticipate];
                                                  
                                                  createVC.isComingAfterDelegate = YES;
                                                  
                                                  [self presentViewController:createVC animated:YES completion:nil];
                                              }
                                          });
                                      }
                                      
                                  }];
                              }
                              else
                              {
                                  //Pop up message
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
                  }
                  
                  
              }];
    }
    
}



@end
