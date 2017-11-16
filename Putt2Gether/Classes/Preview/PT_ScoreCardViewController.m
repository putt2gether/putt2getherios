//
//  PT_ScoreCardViewController.m
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ScoreCardViewController.h"

#import "PT_StartEventViewController.h"

#import "PT_ScoreCardTableViewCell.h"

#import "PT_ScoreCardBack9TableViewCell.h"

#import "PT_ScoreCardCommonModel.h"

#import "PT_ScoreIndividualModel.h"

#import "PT_PlayerItemModel.h"

#import "PT_ScoreCardSplFormatViewController.h"

#import "PT_LeaderBoardViewController.h"

#import "PT_MyScoresModel.h"

#import "UIImageView+AFNetworking.h"

#import "PT_StartEventViewController.h"

#import "PT_MyScoresViewController.h"

#import "PT_TemplateDataViewController.h"

static NSString *const FetchScorePostfix = @"getlatestfullscore";

static NSString *const FetchEventParticipantsPostfix = @"getscorecarddata";

static NSString *const FetchBannerPostFix = @"getadvbanner";


@interface PT_ScoreCardViewController ()<UITableViewDelegate,
                                         UITableViewDataSource>
{
    float yForColorCode;
    
    
    float yForTableBack9;
    float yForColorCodeView;
    
    IBOutlet UILabel *eventNameTitle;
    IBOutlet UILabel *golfCourseNameTitle;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSelectImageX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintColoCpdeViewY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableBack9Y;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (weak, nonatomic) IBOutlet UIView *front9ScoreView;

@property (weak, nonatomic) IBOutlet UIView *back9ScoreView;

@property (weak, nonatomic) IBOutlet UITableView *tableFront9;

@property (weak, nonatomic) IBOutlet UITableView *tableBack9;

@property (weak, nonatomic) IBOutlet UIView *colorCodeView,*loaderView,*loaderInsideView;

@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;

@property (strong, nonatomic) NSArray *arrPlayers;

@property (strong, nonatomic) PT_ScoringIndividualPlayerModel *currentIndividualPlayerModel;

@property (strong, nonatomic) PT_ScoreCardCommonModel *commonModel;

@property (weak, nonatomic) IBOutlet UIButton *eagleButton;

@property (weak, nonatomic) IBOutlet UIButton *birdieButton;

@property (weak, nonatomic) IBOutlet UIButton *bogeyButton;

@property (weak, nonatomic) IBOutlet UIButton *dBogeyButton;

@property (weak, nonatomic) IBOutlet UIButton *parButton;

@property (assign, nonatomic) BOOL isStablefordGameEnabled;

@property (strong, nonatomic) NSMutableArray *arrParticipantsList;

@end

@implementation PT_ScoreCardViewController

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model andPlayersArray:(NSArray *)playersArray
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    self.createdEventModel = model;
    self.arrPlayers = playersArray;
    NSInteger formatId = [self.createdEventModel.formatId integerValue];
    
    if (formatId == 5 ||
        formatId == 6 ||
        formatId == 7)
    {
        self.isStablefordGameEnabled = YES;
    }
    
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];

    self.eventNameLabel.text = self.createdEventModel.eventName;
    self.golfCourseLabel.text = self.createdEventModel.golfCourseName;
    
    eventNameTitle.text = self.createdEventModel.eventName;
    golfCourseNameTitle.text = self.createdEventModel.golfCourseName;
    
    
    
    self.colorCodeView.layer.borderWidth = 0.8;
    self.colorCodeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    yForColorCode = self.constraintColoCpdeViewY.constant;
    
    _currentIndividualPlayerModel = [self.arrPlayers firstObject];
    //[self fetchScoreData];
    
    [self fetchBannerDetail];
    
    
    //[self showLoadingView:NO];
    
    yForTableBack9 = 0.0;
    yForColorCodeView = 0.0;
    
   }



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //[self fetchPlayersList];
    [self createParticipantsButtons];
    
    self.viewWithAddscoreCentre.hidden = YES;
    self.viewWithHtmldata.hidden = YES;

    
    if ([self.createdEventModel.numberOfPlayers integerValue] == 1){
        
        self.viewWithAddscoreCentre.hidden = NO;

    }
    
    
    
    
    if ([self.createdEventModel.isEventStarted isEqualToString:@"8"] || _isComingFromMyscore == YES ) {
        
        self.viewWithAddscoreCentre.hidden = YES;
        self.viewWithHtmldata.hidden = NO;

        
        if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
            [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
            [self.createdEventModel.formatId integerValue] == Format420Id ||
            [self.createdEventModel.formatId integerValue] == Format21Id ||
            [self.createdEventModel.formatId integerValue] == FormatVegasId) {
        
            
            [self.addScoreBtn setHidden:YES];
            //[self.leaderboardBtn setHidden:YES];
            [self.addScoreImg setHidden:YES];
            [self.addScoreLbl setHidden:YES];
           // [self.leaderBoardImg setHidden:YES];
            //[self.leaderBoardLbl setHidden:YES];
            
        }else{
            

            [self.addScoreBtn setHidden:YES];
            //[self.leaderboardBtn setHidden:YES];
            [self.addScoreImg setHidden:YES];
            [self.addScoreLbl setHidden:YES];
            // [self.leaderBoardImg setHidden:YES];
            //[self.leaderBoardLbl setHidden:YES];
        }
    }

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(self.firstButton.frame.size.width * [self.arrParticipantsList count]+1, 47);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
}

-(IBAction)actionBack:(id)sender{
    
    if (_isComingFromMyscore == YES) {
        
        PT_MyScoresViewController *scoreVC = [[PT_MyScoresViewController alloc] initWithNibName:@"PT_MyScoresViewController" bundle:nil];
        
        [self presentViewController:scoreVC animated:YES completion:nil];
    }else{
    
    /*PT_StartEventViewController *starteventViewController = [[PT_StartEventViewController alloc] initWithNibName:@"PT_StartEventViewController" bundle:nil];
    [self presentViewController:starteventViewController animated:YES completion:nil];*/
    [self dismissViewControllerAnimated:YES completion:nil];
    }

}

-(IBAction)actionHtmlBtn
{
    PT_TemplateDataViewController *templtehtm = [[PT_TemplateDataViewController alloc] initWithEvent:self.createdEventModel];
    
    [self presentViewController:templtehtm animated:YES completion:nil];
}

//MArk:-for sharing the screenshot Button Action defined here
-(IBAction)actionShare:(id)sender{
    
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

- (IBAction)homeBtnClicked:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate addTabBarAsRootViewController];
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)actionPlayerSelected:(UIButton *)sender
{
   /* float width = 20;
    UIButton *btn = [self.scrollView.subviews objectAtIndex:sender.tag];
    self.selectImageView.frame = CGRectMake(btn.frame.origin.x + btn.frame.size.width/2 - width/2, btn.frame.origin.y + btn.frame.size.height - width, width, width);
    [self.scrollView addSubview:self.selectImageView];
    */
    
    UIColor *blueColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    if ([self.arrPlayers count] == 1)
    {
        
    }
    else
    {
        
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:blueColor forState:UIControlStateNormal];
    }
    
    for (NSInteger counter = 0; counter<[self.scrollView.subviews count]; counter++)
    {
        UIButton *btn = self.scrollView.subviews[counter];
        if (btn.tag == sender.tag)
        {
            
        }
        else
        {
            btn.backgroundColor = blueColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    PT_PlayerItemModel *model = [self.arrPlayers objectAtIndex:sender.tag];
    [self fetchScoreData:model.playerId];
}

- (void)createParticipantsButtons
{
    float width = 0.0;
    if ([self.arrPlayers count] == 1)
    {
        width = self.view.frame.size.width;
    }
    else if ([self.arrPlayers count] == 2)
    {
        //width = self.view.frame.size.width/2 - 0.5;
        width = self.view.frame.size.width/2;
    }
    else
    {
        //width = self.view.frame.size.width/3 - 0.5;
        width = self.view.frame.size.width/3;
    }
    
    __block float x = 0.0;
    PT_ScoringIndividualPlayerModel *model = [self.arrPlayers firstObject];
    [self fetchScoreData:model.playerId];
    
    for (UIView *sView in self.scrollView.subviews)
    {
        if ([sView isKindOfClass:[UIImageView class]])
        {
            
        }
        else
        {
            
        }
        [sView removeFromSuperview];
    }
    
    [self.arrPlayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PT_ScoringIndividualPlayerModel *modelIndex = obj;
        UIButton *buttonPlayers = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *titleStr = [NSString stringWithFormat:@"%@ %li",modelIndex.playerName,(long)modelIndex.handicap];
        buttonPlayers.frame = CGRectMake(x, 0, width, self.scrollView.frame.size.height);
        x = x + width + 0.5;
        buttonPlayers.backgroundColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
        //[buttonPlayers setTitle:modelIndex.playerName forState:UIControlStateNormal];
        [buttonPlayers setTitle:titleStr forState:UIControlStateNormal];
        [buttonPlayers.titleLabel setTextColor:[UIColor whiteColor]];
        [buttonPlayers.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:12]];
        
        //buttonPlayers.layer.borderColor = [[UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0] CGColor];
        //buttonPlayers.layer.borderWidth = 1.0;
        
        buttonPlayers.tag = idx;
        [buttonPlayers addTarget:self action:@selector(actionPlayerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:buttonPlayers];
        
        
        if (idx == [self.arrPlayers count] - 1)
        {
            float width = 20;
            UIButton *btn = [self.scrollView.subviews firstObject];
            self.selectImageView.frame = CGRectMake(btn.frame.origin.x + btn.frame.size.width/2 - width/2, btn.frame.origin.y + btn.frame.size.height - width, width, width);
            //[self.scrollView addSubview:self.selectImageView];
        }
        if (idx == 0)
        {
            if ([self.arrPlayers count] == 1)
            {
                
            }
            else{
                buttonPlayers.backgroundColor = [UIColor whiteColor];
                [buttonPlayers setTitleColor:[UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0] forState:UIControlStateNormal];
            }
        }
    }];
    
}

#pragma mark - Action Methods

-(IBAction)actionLeaderBoard:(id)sender{
    
    if ([self.createdEventModel.numberOfPlayers integerValue] != 1)
    {
        PT_LeaderBoardViewController *leaderboardViewController = [[PT_LeaderBoardViewController alloc] initWithEvent:self.createdEventModel];
        [self presentViewController:leaderboardViewController animated:YES completion:nil];
    }else{
        
        PT_LeaderBoardViewController *leaderboardViewController = [[PT_LeaderBoardViewController alloc] initWithEvent:self.createdEventModel];
        [self presentViewController:leaderboardViewController animated:YES completion:nil];
        
    }
    
    
}
- (IBAction)actionScorecard:(id)sender{
    

    PT_StartEventViewController *startEventVC = [[PT_StartEventViewController alloc] initWithEvent:self.createdEventModel];
    [self presentViewController:startEventVC animated:YES completion:nil];

    
    
    
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableFront9)
    {
        
        UITableViewCell *cellReturn = nil;
        
        switch (indexPath.row) {
            case 0:
            {
                static NSString *identifier = @"Identifier1";
                PT_ScoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardTableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [cell setDefaultBodering];
                cell.ct1.text = @"1";
                cell.ct2.text = @"2";
                cell.ct3.text = @"3";
                cell.ct4.text = @"4";
                cell.ct5.text = @"5";
                cell.ct6.text = @"6";
                cell.ct7.text = @"7";
                cell.ct8.text = @"8";
                cell.ct9.text = @"9";
                
                cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
                
                cell.cellTitle.text = @"HOLE";
                //cell.cellValue.text = [NSString stringWithFormat:@"F9"];
                cell.cellValue.text = [NSString stringWithFormat:@"IN"];
                
                cell.l2.backgroundColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0];
                cell.cellValue.textColor = [UIColor whiteColor];
                cellReturn = cell;
            }
                break;
                
            case 1:
            {
                static NSString *identifier = @"Identifier2";
                PT_ScoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardTableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [cell setDefaultBodering];
                cell.ct1.text = _commonModel.index1Value;
                cell.ct2.text = _commonModel.index2Value;
                cell.ct3.text = _commonModel.index3Value;
                cell.ct4.text = _commonModel.index4Value;
                cell.ct5.text = _commonModel.index5Value;
                cell.ct6.text = _commonModel.index6Value;
                cell.ct7.text = _commonModel.index7Value;
                cell.ct8.text = _commonModel.index8Value;
                cell.ct9.text = _commonModel.index9Value;
                
                NSInteger totalInteger = [_commonModel.index1Value integerValue] +
                                         [_commonModel.index2Value integerValue] +
                                         [_commonModel.index3Value integerValue] +
                                         [_commonModel.index4Value integerValue] +
                                         [_commonModel.index5Value integerValue] +
                                         [_commonModel.index6Value integerValue] +
                                         [_commonModel.index7Value integerValue] +
                                         [_commonModel.index8Value integerValue] +
                                         [_commonModel.index9Value integerValue];
                cell.cellTitle.text = @"INDEX";
                //cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                cell.cellValue.text = @"";
                
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                cellReturn = cell;
            }
                break;
            case 2:
            {
                static NSString *identifier = @"Identifier3";
                PT_ScoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardTableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [cell setDefaultBodering];
                cell.ct1.text = _commonModel.par1Value;
                cell.ct2.text = _commonModel.par2Value;
                cell.ct3.text = _commonModel.par3Value;
                cell.ct4.text = _commonModel.par4Value;
                cell.ct5.text = _commonModel.par5Value;
                cell.ct6.text = _commonModel.par6Value;
                cell.ct7.text = _commonModel.par7Value;
                cell.ct8.text = _commonModel.par8Value;
                cell.ct9.text = _commonModel.par9Value;
                
                NSInteger totalInteger = 
                [_commonModel.par1Value integerValue] +
                [_commonModel.par2Value integerValue] +
                [_commonModel.par3Value integerValue] +
                [_commonModel.par4Value integerValue] +
                [_commonModel.par5Value integerValue] +
                [_commonModel.par6Value integerValue] +
                [_commonModel.par7Value integerValue] +
                [_commonModel.par8Value integerValue] +
                [_commonModel.par9Value integerValue];
                
                cell.cellTitle.text = @"PAR";
                cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                cellReturn = cell;
            }
                break;
            case 3:
            {
                static NSString *identifier = @"Identifier4";
                PT_ScoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardTableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [cell setDefaultBodering];
                
                
                cell.ct1.text = _commonModel.gross1;
                cell.ct2.text = _commonModel.gross2;
                cell.ct3.text = _commonModel.gross3;
                cell.ct4.text = _commonModel.gross4;
                cell.ct5.text = _commonModel.gross5;
                cell.ct6.text = _commonModel.gross6;
                cell.ct7.text = _commonModel.gross7;
                cell.ct8.text = _commonModel.gross8;
                cell.ct9.text = _commonModel.gross9;
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                    cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
                    cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                });
                
                
                NSInteger totalInteger = 0;
                totalInteger =
                [_commonModel.gross1 integerValue] +
                [_commonModel.gross2 integerValue] +
                [_commonModel.gross3 integerValue] +
                [_commonModel.gross4 integerValue] +
                [_commonModel.gross5 integerValue] +
                [_commonModel.gross6 integerValue] +
                [_commonModel.gross7 integerValue] +
                [_commonModel.gross8 integerValue] +
                [_commonModel.gross9 integerValue];
                
                
                cell.cellTitle.text = @"G.SCORE";
                cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                
                if ([_commonModel.holeColor1 length] > 0)
                {
                    BOOL col1 = NO,col2 = NO,col3 = NO,col4 = NO,col5 = NO,col6 = NO,col7 = NO,col8 = NO,col9 = NO;
                    
                    if ([_commonModel.holeColor1 isEqualToString:@"#ffffff"])
                    {
                        col1 = YES;
                    }
                    else
                    {
                        cell.ct1.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor2 isEqualToString:@"#ffffff"])
                    {
                        col2 = YES;
                    }
                    else
                    {
                        cell.ct2.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor3 isEqualToString:@"#ffffff"])
                    {
                        col3 = YES;
                    }
                    else
                    {
                        cell.ct3.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor4 isEqualToString:@"#ffffff"])
                    {
                        col4 = YES;
                    }
                    else
                    {
                        cell.ct4.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor5 isEqualToString:@"#ffffff"])
                    {
                        col5 = YES;
                    }
                    else
                    {
                        cell.ct5.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor6 isEqualToString:@"#ffffff"])
                    {
                        col6 = YES;
                    }
                    else
                    {
                        cell.ct6.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor7 isEqualToString:@"#ffffff"])
                    {
                        col7 = YES;
                    }
                    else
                    {
                        cell.ct7.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor8 isEqualToString:@"#ffffff"])
                    {
                        col8 = YES;
                    }
                    else
                    {
                        cell.ct8.textColor = [UIColor whiteColor];
                    }
                    if ([_commonModel.holeColor9 isEqualToString:@"#ffffff"])
                    {
                        col9 = YES;
                    }
                    else
                    {
                        cell.ct9.textColor = [UIColor whiteColor];
                    }
                    
                    
                    
                    cell.c1.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor1];
                    cell.c2.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor2];
                    cell.c3.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor3];
                    cell.c4.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor4];
                    cell.c5.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor5];
                    cell.c6.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor6];
                    cell.c7.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor7];
                    cell.c8.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor8];
                    cell.c9.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor9];
                    
                    if (col1 == NO &&
                        col2 == NO &&
                        col3 == NO &&
                        col4 == NO &&
                        col5 == NO &&
                        col6 == NO &&
                        col7 == NO &&
                        col8 == NO &&
                        col9 == NO)
                    {
                        [cell setCBGColor];
                    }
                    else
                    {
                        
                    }
                }
                
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                cellReturn = cell;
                
            }
                break;
            case 4:
            {
                static NSString *identifier = @"Identifier5";
                PT_ScoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardTableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [cell setDefaultBodering];
                cell.ct1.text = _commonModel.position1;
                cell.ct2.text = _commonModel.position2;
                cell.ct3.text = _commonModel.position3;
                cell.ct4.text = _commonModel.position4;
                cell.ct5.text = _commonModel.position5;
                cell.ct6.text = _commonModel.position6;
                cell.ct7.text = _commonModel.position7;
                cell.ct8.text = _commonModel.position8;
                cell.ct9.text = _commonModel.position9;
                
                cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
                cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                
                NSInteger totalInteger = 
                [_commonModel.position1 integerValue] +
                [_commonModel.position2 integerValue] +
                [_commonModel.position3 integerValue] +
                [_commonModel.position4 integerValue] +
                [_commonModel.position5 integerValue] +
                [_commonModel.position6 integerValue] +
                [_commonModel.position7 integerValue] +
                [_commonModel.position8 integerValue] +
                [_commonModel.position9 integerValue];
                if (self.isStablefordGameEnabled == YES)
                {
                    cell.cellTitle.text = @"STABLEFORD";
                }
                else
                {
                    cell.cellTitle.text = @"POSITION";
                }
                
                cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                cell.contentView.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                cellReturn = cell;
            }
                break;
        }
        
        
        return cellReturn;
    }
    else
    {
        UITableViewCell *cellReturn = nil;
        switch (indexPath.row) {
            case 0:
            {
                static NSString *identifier = @"IdentifierSeparate0";
                
                PT_ScoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardTableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cellReturn = cell;
                
                [cell setDefaultBodering];
                cell.ct1.text = @"10";
                cell.ct2.text = @"11";
                cell.ct3.text = @"12";
                cell.ct4.text = @"13";
                cell.ct5.text = @"14";
                cell.ct6.text = @"15";
                cell.ct7.text = @"16";
                cell.ct8.text = @"17";
                cell.ct9.text = @"18";
                
                cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
                cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
                
                cell.cellTitle.text = @"HOLE";
                //cell.cellValue.text = [NSString stringWithFormat:@" B9     TTL"];
                cell.cellValue.text = [NSString stringWithFormat:@"OUT  TOT"];
                //[cell.cellValue setFont:[UIFont fontWithName:@"Lato-Bold" size:10.5]];
                cell.cellValue.textAlignment = NSTextAlignmentLeft;
                
                cell.l2.backgroundColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0];
                cell.cellValue.textColor = [UIColor whiteColor];
            }
                break;
                
            case 1:
            {
                static NSString *identifier = @"IdentifierSeparate";
                
                PT_ScoreCardBack9TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardBack9TableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cellReturn = cell;
                
                [cell setDefaultBodering];
                cell.ct1.text = _commonModel.index10Value;
                cell.ct2.text = _commonModel.index11Value;
                cell.ct3.text = _commonModel.index12Value;
                cell.ct4.text = _commonModel.index13Value;
                cell.ct5.text = _commonModel.index14Value;
                cell.ct6.text = _commonModel.index15Value;
                cell.ct7.text = _commonModel.index16Value;
                cell.ct8.text = _commonModel.index17Value;
                cell.ct9.text = _commonModel.index18Value;
                
                NSInteger totalInteger =
                [_commonModel.index10Value integerValue] +
                [_commonModel.index11Value integerValue] +
                [_commonModel.index12Value integerValue] +
                [_commonModel.index13Value integerValue] +
                [_commonModel.index14Value integerValue] +
                [_commonModel.index15Value integerValue] +
                [_commonModel.index16Value integerValue] +
                [_commonModel.index17Value integerValue] +
                [_commonModel.index18Value integerValue];
                
                NSInteger sumTotal = totalInteger +
                [_commonModel.index1Value integerValue] +
                [_commonModel.index2Value integerValue] +
                [_commonModel.index3Value integerValue] +
                [_commonModel.index4Value integerValue] +
                [_commonModel.index5Value integerValue] +
                [_commonModel.index6Value integerValue] +
                [_commonModel.index7Value integerValue] +
                [_commonModel.index8Value integerValue] +
                [_commonModel.index9Value integerValue];
                
                //cell.ct22.text = [NSString stringWithFormat:@"%li",sumTotal];
                cell.ct22.text = @"";
                
                cell.cellTitle.text = @"INDEX";
                //cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                cell.ct21.text = @"";
                
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
            }
                break;
            case 2:
            {
                static NSString *identifier = @"IdentifierSeparate";
                
                PT_ScoreCardBack9TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardBack9TableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cellReturn = cell;
                
                [cell setDefaultBodering];
                cell.ct1.text = _commonModel.par10Value;
                cell.ct2.text = _commonModel.par11Value;
                cell.ct3.text = _commonModel.par12Value;
                cell.ct4.text = _commonModel.par13Value;
                cell.ct5.text = _commonModel.par14Value;
                cell.ct6.text = _commonModel.par15Value;
                cell.ct7.text = _commonModel.par16Value;
                cell.ct8.text = _commonModel.par17Value;
                cell.ct9.text = _commonModel.par18Value;
                
                NSInteger totalInteger =
                [_commonModel.par10Value integerValue] +
                [_commonModel.par11Value integerValue] +
                [_commonModel.par12Value integerValue] +
                [_commonModel.par13Value integerValue] +
                [_commonModel.par14Value integerValue] +
                [_commonModel.par15Value integerValue] +
                [_commonModel.par16Value integerValue] +
                [_commonModel.par17Value integerValue] +
                [_commonModel.par18Value integerValue];
                
                NSInteger sumTotal = totalInteger +
                [_commonModel.par1Value integerValue] +
                [_commonModel.par2Value integerValue] +
                [_commonModel.par3Value integerValue] +
                [_commonModel.par4Value integerValue] +
                [_commonModel.par5Value integerValue] +
                [_commonModel.par6Value integerValue] +
                [_commonModel.par7Value integerValue] +
                [_commonModel.par8Value integerValue] +
                [_commonModel.par9Value integerValue];
                
                cell.ct22.text = [NSString stringWithFormat:@"%li",sumTotal];
                cell.cellTitle.text = @"PAR";
                cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
            }
                break;
            case 3:
            {
                static NSString *identifier = @"IdentifierSeparate";
                
                PT_ScoreCardBack9TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardBack9TableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cellReturn = cell;
                
                [cell setDefaultBodering];
                cell.ct1.text = _commonModel.gross10;
                cell.ct2.text = _commonModel.gross11;
                cell.ct3.text = _commonModel.gross12;
                cell.ct4.text = _commonModel.gross13;
                cell.ct5.text = _commonModel.gross14;
                cell.ct6.text = _commonModel.gross15;
                cell.ct7.text = _commonModel.gross16;
                cell.ct8.text = _commonModel.gross17;
                cell.ct9.text = _commonModel.gross18;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //if ([_commonModel.holeColor10 length] > 0)
                    BOOL col1 = NO,col2 = NO,col3 = NO,col4 = NO,col5 = NO,col6 = NO,col7 = NO,col8 = NO,col9 = NO;
                    {
                        
                        if ([_commonModel.holeColor10 length] > 0)
                        {
                            cell.c1.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor10];
                        }
                        if (_commonModel.holeColor11)
                        {
                            cell.c2.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor11];
                        }
                        if (_commonModel.holeColor12)
                        {
                            cell.c3.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor12];
                        }
                        if (_commonModel.holeColor13)
                        {
                            cell.c4.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor13];
                        }
                        if (_commonModel.holeColor14)
                        {
                            cell.c5.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor14];
                        }
                        if (_commonModel.holeColor15)
                        {
                            cell.c6.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor15];
                        }
                        if (_commonModel.holeColor16)
                        {
                            cell.c7.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor16];
                        }
                        if (_commonModel.holeColor17)
                        {
                            cell.c8.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor17];
                        }
                        if (_commonModel.holeColor18)
                        {
                            cell.c9.backgroundColor = [UIColor colorFromHexString:_commonModel.holeColor18];
                        }
                        BOOL col1 = NO,col2 = NO,col3 = NO,col4 = NO,col5 = NO,col6 = NO,col7 = NO,col8 = NO,col9 = NO;
                        
                        if ([_commonModel.holeColor10 isEqualToString:@"#ffffff"])
                        {
                            col1 = YES;
                        }
                        else
                        {
                            cell.ct1.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor11 isEqualToString:@"#ffffff"])
                        {
                            col2 = YES;
                        }
                        else
                        {
                            cell.ct2.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor12 isEqualToString:@"#ffffff"])
                        {
                            col3 = YES;
                        }
                        else
                        {
                            cell.ct3.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor13 isEqualToString:@"#ffffff"])
                        {
                            col4 = YES;
                        }
                        else
                        {
                            cell.ct4.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor14 isEqualToString:@"#ffffff"])
                        {
                            col5 = YES;
                        }
                        else
                        {
                            cell.ct5.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor15 isEqualToString:@"#ffffff"])
                        {
                            col6 = YES;
                        }
                        else
                        {
                            cell.ct6.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor16 isEqualToString:@"#ffffff"])
                        {
                            col7 = YES;
                        }
                        else
                        {
                            cell.ct7.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor17 isEqualToString:@"#ffffff"])
                        {
                            col8 = YES;
                        }
                        else
                        {
                            cell.ct8.textColor = [UIColor whiteColor];
                        }
                        if ([_commonModel.holeColor18 isEqualToString:@"#ffffff"])
                        {
                            col9 = YES;
                        }
                        else
                        {
                            cell.ct9.textColor = [UIColor whiteColor];
                        }
                        if (col1 == NO &&
                            col2 == NO &&
                            col3 == NO &&
                            col4 == NO &&
                            col5 == NO &&
                            col6 == NO &&
                            col7 == NO &&
                            col8 == NO &&
                            col9 == NO)
                        {
                            [cell setCBGColor];
                        }
                        else
                        {
                            
                        }
                    }
                });
                
                
                cell.cellTitle.text = @"G.SCORE";
                cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
                cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                
                NSInteger totalInteger =
                [_commonModel.gross10 integerValue] +
                [_commonModel.gross11 integerValue] +
                [_commonModel.gross12 integerValue] +
                [_commonModel.gross13 integerValue] +
                [_commonModel.gross14 integerValue] +
                [_commonModel.gross15 integerValue] +
                [_commonModel.gross16 integerValue] +
                [_commonModel.gross17 integerValue] +
                [_commonModel.gross18 integerValue];
                
                NSInteger sumTotal = totalInteger +
                [_commonModel.gross1 integerValue] +
                [_commonModel.gross2 integerValue] +
                [_commonModel.gross3 integerValue] +
                [_commonModel.gross4 integerValue] +
                [_commonModel.gross5 integerValue] +
                [_commonModel.gross6 integerValue] +
                [_commonModel.gross7 integerValue] +
                [_commonModel.gross8 integerValue] +
                [_commonModel.gross9 integerValue];
                
                cell.ct22.text = [NSString stringWithFormat:@"%li",sumTotal];
                cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                
                //[cell setCBGColor];
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                
            }
                break;
            case 4:
            {
                static NSString *identifier = @"IdentifierSeparate5";
                
                PT_ScoreCardBack9TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScoreCardBack9TableViewCell" owner:self options:nil] firstObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cellReturn = cell;
                
                [cell setDefaultBodering];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.ct1.text = _commonModel.position10;
                    cell.ct2.text = _commonModel.position11;
                    cell.ct3.text = _commonModel.position12;
                    cell.ct4.text = _commonModel.position13;
                    cell.ct5.text = _commonModel.position14;
                    cell.ct6.text = _commonModel.position15;
                    cell.ct7.text = _commonModel.position16;
                    cell.ct8.text = _commonModel.position17;
                    cell.ct9.text = _commonModel.position18;
                });
                
                
                cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
                cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:10.5];
                
                NSInteger totalInteger =
                [_commonModel.position11 integerValue] +
                [_commonModel.position12 integerValue] +
                [_commonModel.position13 integerValue] +
                [_commonModel.position14 integerValue] +
                [_commonModel.position15 integerValue] +
                [_commonModel.position16 integerValue] +
                [_commonModel.position17 integerValue] +
                [_commonModel.position18 integerValue] +
                [_commonModel.position10 integerValue];
                
                NSInteger sumTotal = totalInteger +
                [_commonModel.position1 integerValue] +
                [_commonModel.position2 integerValue] +
                [_commonModel.position3 integerValue] +
                [_commonModel.position4 integerValue] +
                [_commonModel.position5 integerValue] +
                [_commonModel.position6 integerValue] +
                [_commonModel.position7 integerValue] +
                [_commonModel.position8 integerValue] +
                [_commonModel.position9 integerValue];

                cell.ct22.text = [NSString stringWithFormat:@"%li",sumTotal];
                cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];

                if (self.isStablefordGameEnabled == YES)
                {
                    cell.cellTitle.text = @"STABLEFORD";
                }
                else
                {
                    cell.cellTitle.text = @"POSITION";
                }
                
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                cell.contentView.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
            }
                break;
        }
        
        
        return cellReturn;
    }
    
    
}

- (void)checkForNilPostionValues
{
    if (_commonModel != nil)
    {
        if ([_commonModel.position1 length] == 0 || [_commonModel.position1 isEqualToString:@"0"])
        {
            _commonModel.position1 = @"-";
        }
        if ([_commonModel.position2 length] == 0 || [_commonModel.position2 isEqualToString:@"0"])
        {
            _commonModel.position2 = @"-";
        }
        if ([_commonModel.position3 length] == 0 || [_commonModel.position3 isEqualToString:@"0"])
        {
            _commonModel.position3 = @"-";
        }
        if ([_commonModel.position4 length] == 0 || [_commonModel.position4 isEqualToString:@"0"])
        {
            _commonModel.position4 = @"-";
        }
        if ([_commonModel.position5 length] == 0  || [_commonModel.position5 isEqualToString:@"0"])
        {
            _commonModel.position5 = @"-";
        }
        if ([_commonModel.position6 length] == 0 || [_commonModel.position6 isEqualToString:@"0"])
        {
            _commonModel.position6 = @"-";
        }
        if ([_commonModel.position7 length] == 0 || [_commonModel.position7 isEqualToString:@"0"])
        {
            _commonModel.position7 = @"-";
        }
        if ([_commonModel.position8 length] == 0 || [_commonModel.position8 isEqualToString:@"0"])
        {
            _commonModel.position8 = @"-";
        }
        if ([_commonModel.position9 length] == 0 || [_commonModel.position9 isEqualToString:@"0"])
        {
            _commonModel.position9 = @"-";
        }
        if ([_commonModel.position10 length] == 0 || [_commonModel.position10 isEqualToString:@"0"])
        {
            _commonModel.position10 = @"-";
        }
        if ([_commonModel.position11 length] == 0 || [_commonModel.position11 isEqualToString:@"0"])
        {
            _commonModel.position11 = @"-";
        }
        if ([_commonModel.position12 length] == 0 || [_commonModel.position12 isEqualToString:@"0"])
        {
            _commonModel.position12 = @"-";
        }
        if ([_commonModel.position13 length] == 0 || [_commonModel.position13 isEqualToString:@"0"])
        {
            _commonModel.position13 = @"-";
        }
        if ([_commonModel.position14 length] == 0 || [_commonModel.position14 isEqualToString:@"0"])
        {
            _commonModel.position14 = @"-";
        }
        if ([_commonModel.position15 length] == 0 || [_commonModel.position15 isEqualToString:@"0"])
        {
            _commonModel.position15 = @"-";
        }
        if ([_commonModel.position16 length] == 0 || [_commonModel.position16 isEqualToString:@"0"])
        {
            _commonModel.position16 = @"-";
        }
        if ([_commonModel.position17 length] == 0 || [_commonModel.position17 isEqualToString:@"0"])
        {
            _commonModel.position17 = @"-";
        }
        if ([_commonModel.position18 length] == 0 || [_commonModel.position18 isEqualToString:@"0"])
        {
            _commonModel.position18 = @"-";
        }
    }
}
- (void)checkForNilGrossValues
{
    if (_commonModel != nil)
    {
        if ([_commonModel.gross1 length] == 0 || [_commonModel.gross1 isEqualToString:@"0"])
        {
            _commonModel.gross1 = @"-";
        }
        if ([_commonModel.gross2 length] == 0 || [_commonModel.gross2 isEqualToString:@"0"])
        {
            _commonModel.gross2 = @"-";
        }
        if ([_commonModel.gross3 length] == 0 || [_commonModel.gross3 isEqualToString:@"0"])
        {
            _commonModel.gross3 = @"-";
        }
        if ([_commonModel.gross4 length] == 0 || [_commonModel.gross4 isEqualToString:@"0"])
        {
            _commonModel.gross4 = @"-";
        }
        if ([_commonModel.gross5 length] == 0 || [_commonModel.gross5 isEqualToString:@"0"])
        {
            _commonModel.gross5 = @"-";
        }
        if ([_commonModel.gross6 length] == 0 || [_commonModel.gross6 isEqualToString:@"0"])
        {
            _commonModel.gross6 = @"-";
        }
        if ([_commonModel.gross7 length] == 0 || [_commonModel.gross7 isEqualToString:@"0"])
        {
            _commonModel.gross7 = @"-";
        }
        if ([_commonModel.gross8 length] == 0 || [_commonModel.gross8 isEqualToString:@"0"])
        {
            _commonModel.gross8 = @"-";
        }
        if ([_commonModel.gross9 length] == 0 || [_commonModel.gross9 isEqualToString:@"0"])
        {
            _commonModel.gross9 = @"-";
        }
        if ([_commonModel.gross10 length] == 0 || [_commonModel.gross10 isEqualToString:@"0"])
        {
            _commonModel.gross10 = @"-";
        }
        if ([_commonModel.gross11 length] == 0 || [_commonModel.gross11 isEqualToString:@"0"])
        {
            _commonModel.gross11 = @"-";
        }
        if ([_commonModel.gross12 length] == 0 || [_commonModel.gross12 isEqualToString:@"0"])
        {
            _commonModel.gross12 = @"-";
        }
        if ([_commonModel.gross13 length] == 0 || [_commonModel.gross13 isEqualToString:@"0"])
        {
            _commonModel.gross13 = @"-";
        }
        if ([_commonModel.gross14 length] == 0 || [_commonModel.gross14 isEqualToString:@"0"])
        {
            _commonModel.gross14 = @"-";
        }
        if ([_commonModel.gross15 length] == 0 || [_commonModel.gross15 isEqualToString:@"0"])
        {
            _commonModel.gross15 = @"-";
        }
        if ([_commonModel.gross16 length] == 0 || [_commonModel.gross16 isEqualToString:@"0"])
        {
            _commonModel.gross16 = @"-";
        }
        if ([_commonModel.gross17 length] == 0 || [_commonModel.gross17 isEqualToString:@"0"])
        {
            _commonModel.gross17 = @"-";
        }
        if ([_commonModel.gross18 length] == 0 || [_commonModel.gross18 isEqualToString:@"0"])
        {
            _commonModel.gross18 = @"-";
        }
    }
}

- (void)checkForNilParValues
{
    if (_commonModel != nil)
    {
        if ([_commonModel.par1Value length] == 0 || [_commonModel.par1Value isEqualToString:@"0"])
        {
            _commonModel.par1Value = @"-";
        }
        if ([_commonModel.par2Value length] == 0 || [_commonModel.par2Value isEqualToString:@"0"])
        {
            _commonModel.par2Value = @"-";
        }
        if ([_commonModel.par3Value length] == 0 || [_commonModel.par3Value isEqualToString:@"0"])
        {
            _commonModel.par3Value = @"-";
        }
        if ([_commonModel.par4Value length] == 0 || [_commonModel.par4Value isEqualToString:@"0"])
        {
            _commonModel.par4Value = @"-";
        }
        if ([_commonModel.par5Value length] == 0 || [_commonModel.par5Value isEqualToString:@"0"])
        {
            _commonModel.par5Value = @"-";
        }
        if ([_commonModel.par6Value length] == 0 || [_commonModel.par6Value isEqualToString:@"0"])
        {
            _commonModel.par6Value = @"-";
        }
        if ([_commonModel.par7Value length] == 0 || [_commonModel.par7Value isEqualToString:@"0"])
        {
            _commonModel.par7Value = @"-";
        }
        if ([_commonModel.par8Value length] == 0 || [_commonModel.par8Value isEqualToString:@"0"])
        {
            _commonModel.par8Value = @"-";
        }
        if ([_commonModel.par9Value length] == 0 || [_commonModel.par9Value isEqualToString:@"0"])
        {
            _commonModel.par9Value = @"-";
        }
        if ([_commonModel.par10Value length] == 0 || [_commonModel.par10Value isEqualToString:@"0"])
        {
            _commonModel.par10Value = @"-";
        }
        if ([_commonModel.par11Value length] == 0 || [_commonModel.par11Value isEqualToString:@"0"])
        {
            _commonModel.par11Value = @"-";
        }
        if ([_commonModel.par12Value length] == 0 || [_commonModel.par12Value isEqualToString:@"0"])
        {
            _commonModel.par12Value = @"-";
        }
        if ([_commonModel.par13Value length] == 0 || [_commonModel.par13Value isEqualToString:@"0"])
        {
            _commonModel.par13Value = @"-";
        }
        if ([_commonModel.par14Value length] == 0 || [_commonModel.par14Value isEqualToString:@"0"])
        {
            _commonModel.par14Value = @"-";
        }
        if ([_commonModel.par15Value length] == 0 || [_commonModel.par15Value isEqualToString:@"0"])
        {
            _commonModel.par15Value = @"-";
        }
        if ([_commonModel.par16Value length] == 0 || [_commonModel.par16Value isEqualToString:@"0"])
        {
            _commonModel.par16Value = @"-";
        }
        if ([_commonModel.par17Value length] == 0 || [_commonModel.par17Value isEqualToString:@"0"])
        {
            _commonModel.par17Value = @"-";
        }
        if ([_commonModel.par18Value length] == 0 || [_commonModel.par18Value isEqualToString:@"0"])
        {
            _commonModel.par18Value = @"-";
        }
    }
}

- (void)checkForNilIndexValues
{
    if (_commonModel != nil)
    {
        if ([_commonModel.index1Value length] == 0 || [_commonModel.index1Value isEqualToString:@"0"])
        {
            _commonModel.index1Value = @"-";
        }
        if ([_commonModel.index2Value length] == 0 || [_commonModel.index2Value isEqualToString:@"0"])
        {
            _commonModel.index2Value = @"-";
        }
        if ([_commonModel.index3Value length] == 0 || [_commonModel.index3Value isEqualToString:@"0"])
        {
            _commonModel.index3Value = @"-";
        }
        if ([_commonModel.index4Value length] == 0 || [_commonModel.index4Value isEqualToString:@"0"])
        {
            _commonModel.index4Value = @"-";
        }
        if ([_commonModel.index5Value length] == 0 || [_commonModel.index5Value isEqualToString:@"0"])
        {
            _commonModel.index5Value = @"-";
        }
        if ([_commonModel.index6Value length] == 0 || [_commonModel.index6Value isEqualToString:@"0"])
        {
            _commonModel.index6Value = @"-";
        }
        if ([_commonModel.index7Value length] == 0 || [_commonModel.index7Value isEqualToString:@"0"])
        {
            _commonModel.index7Value = @"-";
        }
        if ([_commonModel.index8Value length] == 0 || [_commonModel.index8Value isEqualToString:@"0"])
        {
            _commonModel.index8Value = @"-";
        }
        if ([_commonModel.index9Value length] == 0 || [_commonModel.index9Value isEqualToString:@"0"])
        {
            _commonModel.index9Value = @"-";
        }
        if ([_commonModel.index10Value length] == 0 || [_commonModel.index10Value isEqualToString:@"0"])
        {
            _commonModel.index10Value = @"-";
        }
        if ([_commonModel.index11Value length] == 0 || [_commonModel.index11Value isEqualToString:@"0"])
        {
            _commonModel.index11Value = @"-";
        }
        if ([_commonModel.index12Value length] == 0 || [_commonModel.index12Value isEqualToString:@"0"])
        {
            _commonModel.index12Value = @"-";
        }
        if ([_commonModel.index13Value length] == 0 || [_commonModel.index13Value isEqualToString:@"0"])
        {
            _commonModel.index13Value = @"-";
        }
        if ([_commonModel.index14Value length] == 0 || [_commonModel.index14Value isEqualToString:@"0"])
        {
            _commonModel.index14Value = @"-";
        }
        if ([_commonModel.index15Value length] == 0 || [_commonModel.index15Value isEqualToString:@"0"])
        {
            _commonModel.index15Value = @"-";
        }
        if ([_commonModel.index16Value length] == 0 || [_commonModel.index16Value isEqualToString:@"0"])
        {
            _commonModel.index16Value = @"-";
        }
        if ([_commonModel.index17Value length] == 0 || [_commonModel.index17Value isEqualToString:@"0"])
        {
            _commonModel.index17Value = @"-";
        }
        if ([_commonModel.index18Value length] == 0 || [_commonModel.index18Value isEqualToString:@"0"])
        {
            _commonModel.index18Value = @"-";
        }
    }
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


#pragma mark - Service calls
/*- (void)fetchPlayersList
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
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        [self showLoadingView:YES];
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
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arrParticipantsList = [NSMutableArray new];
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  
                                  NSDictionary *dicPlayers = obj;
                                  PT_PlayerItemModel *model = [PT_PlayerItemModel new];
                                  model.playerId = [dicPlayers[@"userId"] integerValue];
                                  model.playerName = dicPlayers[@"full_name"];
                                  
                                  [self.arrParticipantsList addObject:model];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      [self createParticipantsButtons];
                                  }
                              }];
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
                  }
                  else
                  {
                  }
                  
                  
              }];
    }

}
 */
- (void)fetchScoreData:(NSInteger)playerId
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
        /*NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"player_id":[NSString stringWithFormat:@"%li", self.currentIndividualPlayerModel.playerId],
                                @"version":@"2"
                                };*/
        
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"player_id":[NSString stringWithFormat:@"%li", (long)playerId],
                                @"version":@"2"
                                };
        
        NSLog(@"%@",param);
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchScorePostfix];
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
                              
                              NSDictionary *dicData = dicOutput[@"data"];

                              [self parseDataForDictionary:dicData];
                              

                              
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                              self.loaderView.hidden = YES;
                              [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                          self.loaderView.hidden = YES;

                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                      self.loaderView.hidden = YES;


                     [self showAlertWithMessage:@"Connection Lost"];
                      
                  }
                  
                  
              }];
    }
    
}

- (void)parseDataForDictionary:(NSDictionary *)dicData
{
    
    _commonModel = [PT_ScoreCardCommonModel new];
    _commonModel.birdie = [NSString stringWithFormat:@"%@",dicData[@"birdie_counter"]];
    [self.birdieButton setTitle:_commonModel.birdie forState:UIControlStateNormal];
    
    _commonModel.bogey = [NSString stringWithFormat:@"%@",dicData[@"bogey_counter"]];
    [self.bogeyButton setTitle:_commonModel.bogey forState:UIControlStateNormal];
    
    _commonModel.dBogey = [NSString stringWithFormat:@"%@",dicData[@"doublebogey_counter"]];
    [self.dBogeyButton setTitle:_commonModel.dBogey forState:UIControlStateNormal];
    
    _commonModel.eagle = [NSString stringWithFormat:@"%@",dicData[@"eagle_counter"]];
    [self.eagleButton setTitle:_commonModel.eagle forState:UIControlStateNormal];
    
    _commonModel.par = [NSString stringWithFormat:@"%@",dicData[@"par_counter"]];
    [self.parButton setTitle:_commonModel.par forState:UIControlStateNormal];
    
    _commonModel.eventAdmin = dicData[@"event_admin_id"];
    _commonModel.eventId = dicData[@"event_id"];
    _commonModel.eventName = dicData[@"event_name"];
    _commonModel.eventStrokePlayId = dicData[@"event_stroke_play_id"];
    _commonModel.golfCourseName = dicData[@"golf_course_name"];
   
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_1"]] length] > 0)
    {
        _commonModel.index1Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_1"]];
    }
    else
    {
        _commonModel.index1Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_2"]] length] > 0)
    {
        _commonModel.index2Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_2"]];
    }
    else
    {
        _commonModel.index2Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_3"]] length]> 0)
    {
        _commonModel.index3Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_3"]];
    }
    else
    {
        _commonModel.index3Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_4"]] length] > 0)
    {
       _commonModel.index4Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_4"]];
    }
    else
    {
        _commonModel.index4Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_5"]] length] > 0)
    {
       _commonModel.index5Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_5"]];
    }
    else
    {
        _commonModel.index5Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_6"]] length] > 0)
    {
        _commonModel.index6Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_6"]];
    }
    else
    {
        _commonModel.index6Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_7"]] length] > 0)
    {
        _commonModel.index7Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_7"]];
    }
    else
    {
        _commonModel.index7Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_8"]] length] > 0)
    {
        _commonModel.index8Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_8"]];
    }
    else
    {
        _commonModel.index8Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"hole_index_9"]] length] > 0)
    {
        _commonModel.index9Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_9"]];
    }
    else
    {
        _commonModel.index9Value = @"-";
    }
    
    _commonModel.holeNumber = dicData[@"total_num_hole"];
    
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_1"]] length] > 0)
    {
        _commonModel.par1Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_1"]];
    }
    else
    {
        _commonModel.par1Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_2"]] length] > 0)
    {
        _commonModel.par2Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_2"]];
        
    }
    else
    {
        _commonModel.par2Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_3"]] length] > 0)
    {
        _commonModel.par3Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_3"]];
        
    }
    else
    {
        _commonModel.par3Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_4"]] length] > 0)
    {
        _commonModel.par4Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_4"]];
        
    }
    else
    {
        _commonModel.par4Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_5"]] length] > 0)
    {
        _commonModel.par5Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_5"]];
        
    }
    else
    {
        _commonModel.par5Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_6"]] length] > 0)
    {
        _commonModel.par6Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_6"]];
        
    }
    else
    {
        _commonModel.par6Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_7"]] length] > 0)
    {
        _commonModel.par7Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_7"]];
        
    }
    else
    {
        _commonModel.par7Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_8"]] length] > 0)
    {
        _commonModel.par8Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_8"]];
        
    }
    else
    {
        _commonModel.par8Value = @"-";
    }
    if ([[NSString stringWithFormat:@"%@",dicData[@"par_value_9"]] length] > 0)
    {
        _commonModel.par9Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_9"]];
    }
    else
    {
        _commonModel.par9Value = @"-";
    }
    
    
    
    BOOL isHoleNumberPresent = NO;
    
    NSArray *arrPlayerHoleScore = dicData[@"player_hole_score"];
    NSDictionary *dicPlayerHoleScore = nil;
    if ([arrPlayerHoleScore count] > 0)
    {
        isHoleNumberPresent = YES;
    }
    if (isHoleNumberPresent == YES)
    {
        //dicPlayerHoleScore = arrPlayerHoleScore[0];
        for (NSInteger counter = 0; counter <[arrPlayerHoleScore count]; counter++)
        {
            NSDictionary *dicHoleScore = arrPlayerHoleScore[counter];
            NSInteger playerId = [dicHoleScore[@"player_id"] integerValue];
            //if (_currentIndividualPlayerModel.playerId == playerId)
            {
                dicPlayerHoleScore = arrPlayerHoleScore[counter];
            }
        }
        if ([dicPlayerHoleScore[@"hole_color_1"] length] > 0)
        {
            _commonModel.holeColor1 = dicPlayerHoleScore[@"hole_color_1"];
            
        }
        else
        {
            _commonModel.holeColor1 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_2"] length] > 0)
        {
            _commonModel.holeColor2 = dicPlayerHoleScore[@"hole_color_2"];
            
        }
        else
        {
            _commonModel.holeColor2 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_3"] length] > 0)
        {
            _commonModel.holeColor3 = dicPlayerHoleScore[@"hole_color_3"];
            
        }
        else
        {
            _commonModel.holeColor3 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_4"] length] > 0)
        {
            _commonModel.holeColor4 = dicPlayerHoleScore[@"hole_color_4"];
            
        }
        else
        {
            _commonModel.holeColor4 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_5"] length] > 0)
        {
            _commonModel.holeColor5 = dicPlayerHoleScore[@"hole_color_5"];
           
        }
        else
        {
            _commonModel.holeColor5 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_6"] length] > 0)
        {
            _commonModel.holeColor6 = dicPlayerHoleScore[@"hole_color_6"];
            
        }
        else
        {
            _commonModel.holeColor6 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_7"] length] > 0)
        {
            _commonModel.holeColor7 = dicPlayerHoleScore[@"hole_color_7"];
            
        }
        else
        {
            _commonModel.holeColor7 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_8"] length] > 0)
        {
            _commonModel.holeColor8 = dicPlayerHoleScore[@"hole_color_8"];
            
        }
        else
        {
            _commonModel.holeColor8 = @"-";
        }
        if ([dicPlayerHoleScore[@"hole_color_9"] length] > 0)
        {
            _commonModel.holeColor9 = dicPlayerHoleScore[@"hole_color_9"];
        }
        else
        {
            _commonModel.holeColor9 = @"-";
        }
        
        //GROSS SCORE VALUES
        
        
        
        
        if (self.isStablefordGameEnabled == YES)
        {
            //Gross Score
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_1"]] length] > 0)
            {
                _commonModel.gross1 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_1"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_2"]] length] > 0)
            {
                _commonModel.gross2 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_2"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_3"]] length] > 0)
            {
                _commonModel.gross3 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_3"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_4"]] length] > 0)
            {
                _commonModel.gross4 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_4"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_5"]] length] > 0)
            {
                _commonModel.gross5 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_5"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_6"]] length] > 0)
            {
                _commonModel.gross6 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_6"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_7"]] length] > 0)
            {
                _commonModel.gross7 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_7"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_8"]] length] > 0)
            {
                _commonModel.gross8 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_8"]];
                
            }
            
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_9"]] length] > 0)
            {
                _commonModel.gross9 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_9"]];
            }
            
            //Position
            if (dicPlayerHoleScore[@"hole_num_1"])
            {
                _commonModel.position1 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_1"]];
            }
            
            if (dicPlayerHoleScore[@"hole_num_2"])
            {
                
                _commonModel.position2 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_2"]];
                
            }
            
            if (dicPlayerHoleScore[@"hole_num_3"])
            {
                
                _commonModel.position3 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_3"]];
                
            }
            
            if (dicPlayerHoleScore[@"hole_num_4"])
            {
                
                _commonModel.position4 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_4"]];
                
            }
            
            if (dicPlayerHoleScore[@"hole_num_5"])
            {
                _commonModel.position5 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_5"]];
                
            }
            
            if (dicPlayerHoleScore[@"hole_num_6"])
            {
                
                _commonModel.position6 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_6"]];
                
            }
            
            if (dicPlayerHoleScore[@"hole_num_7"])
            {
                
                _commonModel.position7 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_7"]];
                
            }
            
            if (dicPlayerHoleScore[@"hole_num_8"])
            {
                
                _commonModel.position8 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_8"]];
                
            }
            
            if (dicPlayerHoleScore[@"hole_num_9"])
            {
                
                _commonModel.position9 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_9"]];
            }
            
        }
        else
        {
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_1"]] length] > 0)
            {
                _commonModel.gross1 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_1"]];
                
            }
            else
            {
                _commonModel.gross1 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_2"]] length] > 0)
            {
                _commonModel.gross2 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_2"]];
                
            }
            else
            {
                _commonModel.gross2 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_3"]] length] > 0)
            {
                _commonModel.gross3 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_3"]];
                
            }
            else
            {
                _commonModel.gross3 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_4"]] length] > 0)
            {
                _commonModel.gross4 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_4"]];
                
            }
            else
            {
                _commonModel.gross4 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_5"]] length] > 0)
            {
                _commonModel.gross5 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_5"]];
                
            }
            else
            {
                _commonModel.gross5 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_6"]] length] > 0)
            {
                _commonModel.gross6 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_6"]];
                
            }
            else
            {
                _commonModel.gross6 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_7"]] length] > 0)
            {
                _commonModel.gross7 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_7"]];
                
            }
            else
            {
                _commonModel.gross7 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_8"]] length] > 0)
            {
                _commonModel.gross8 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_8"]];
                
            }
            else
            {
                _commonModel.gross8 = @"-";
            }
            if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_9"]] length] > 0)
            {
                _commonModel.gross9 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_9"]];
            }
            else
            {
                _commonModel.gross9 = @"-";
            }
            
            if (dicPlayerHoleScore[@"position_1"])
            {
                _commonModel.position1 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_1"]];
            }
            else
            {
                _commonModel.position1 = @"-";
                
            }
            //if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_2"]] length] > 0)
            if (dicPlayerHoleScore[@"position_2"])
            {
                
                _commonModel.position2 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_2"]];
                
            }
            else
            {
                
                _commonModel.position2 = @"-";
                
            }
            
            if (dicPlayerHoleScore[@"position_3"])
            {
                
                _commonModel.position3 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_3"]];
                
            }
            else
            {
                
                _commonModel.position3 = @"-";
                
            }
            
            if (dicPlayerHoleScore[@"position_4"])
            {
                
                _commonModel.position4 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_4"]];
                
            }
            else
            {
                
                _commonModel.position4 = @"-";
                
            }
            
            if (dicPlayerHoleScore[@"position_5"])
            {
                _commonModel.position5 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_5"]];
                
            }
            else
            {
                _commonModel.position5 = @"-";
                
            }
            
            if (dicPlayerHoleScore[@"position_6"])
            {
                
                _commonModel.position6 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_6"]];
                
            }
            else
            {
                
                _commonModel.position6 = @"-";
                
            }
            
            if (dicPlayerHoleScore[@"position_7"])
            {
                
                _commonModel.position7 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_7"]];
                
            }
            else
            {
                
                _commonModel.position7 = @"-";
                
            }
            
            if (dicPlayerHoleScore[@"position_8"])
            {
                
                _commonModel.position8 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_8"]];
                
            }
            else
            {
                
                _commonModel.position8 = @"-";
                
            }
            
            if (dicPlayerHoleScore[@"position_9"])
            {
                
                _commonModel.position9 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_9"]];
            }
            else
            {
                
                _commonModel.position9 = @"-";
            }
        }
        
        
        
    }
    else
    {
        _commonModel.gross1 = @"-";
        _commonModel.gross2 = @"-";
        _commonModel.gross3 = @"-";
        _commonModel.gross4 = @"-";
        _commonModel.gross5 = @"-";
        _commonModel.gross6 = @"-";
        _commonModel.gross7 = @"-";
        _commonModel.gross8 = @"-";
        _commonModel.gross9 = @"-";
        
        _commonModel.position1 = @"-";
        _commonModel.position2 = @"-";
        _commonModel.position3 = @"-";
        _commonModel.position4 = @"-";
        _commonModel.position5 = @"-";
        _commonModel.position6 = @"-";
        _commonModel.position7 = @"-";
        _commonModel.position8 = @"-";
        _commonModel.position9 = @"-";
    }
    
    if ([_createdEventModel.back9 isEqualToString:@"Back 9"])
    {
        self.tableBack9.hidden = NO;
        _commonModel.index10Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_10"]];
        _commonModel.index11Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_11"]];
        _commonModel.index12Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_12"]];
        _commonModel.index13Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_13"]];
        _commonModel.index14Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_14"]];
        _commonModel.index15Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_15"]];
        _commonModel.index16Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_16"]];
        _commonModel.index17Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_17"]];
        _commonModel.index18Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_18"]];
        _commonModel.holeStartFrom = dicData[@"hole_start_from"];
        
        
        _commonModel.par10Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_10"]];
        _commonModel.par11Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_11"]];
        _commonModel.par12Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_12"]];
        _commonModel.par13Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_13"]];
        _commonModel.par14Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_14"]];
        _commonModel.par15Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_15"]];
        _commonModel.par16Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_16"]];
        _commonModel.par17Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_17"]];
        _commonModel.par18Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_18"]];
        
        if (isHoleNumberPresent == YES)
        {
            _commonModel.holeColor10 = dicPlayerHoleScore[@"hole_color_10"];
            _commonModel.holeColor11 = dicPlayerHoleScore[@"hole_color_11"];
            _commonModel.holeColor12 = dicPlayerHoleScore[@"hole_color_12"];
            _commonModel.holeColor13 = dicPlayerHoleScore[@"hole_color_13"];
            _commonModel.holeColor14 = dicPlayerHoleScore[@"hole_color_14"];
            _commonModel.holeColor15 = dicPlayerHoleScore[@"hole_color_15"];
            _commonModel.holeColor16 = dicPlayerHoleScore[@"hole_color_16"];
            _commonModel.holeColor17 = dicPlayerHoleScore[@"hole_color_17"];
            _commonModel.holeColor18 = dicPlayerHoleScore[@"hole_color_18"];
            
            
            
            
            
            // Position 10 to 18
            if (self.isStablefordGameEnabled == YES)
            {
                _commonModel.gross10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_10"]];
                _commonModel.gross11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_11"]];
                _commonModel.gross12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_12"]];
                _commonModel.gross13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_13"]];
                _commonModel.gross14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_14"]];
                _commonModel.gross15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_15"]];
                _commonModel.gross16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_16"]];
                _commonModel.gross17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_17"]];
                _commonModel.gross18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_18"]];
                
                if (dicPlayerHoleScore[@"hole_num_10"])
                {
                    _commonModel.position10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_10"]];
                }
                
                if (dicPlayerHoleScore[@"hole_num_11"])
                {
                    
                    _commonModel.position11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_11"]];
                    
                }
                if (dicPlayerHoleScore[@"hole_num_12"])
                {
                    
                    _commonModel.position12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_12"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_13"])
                {
                    
                    _commonModel.position13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_13"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_14"])
                {
                    _commonModel.position14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_14"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_15"])
                {
                    
                    _commonModel.position15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_15"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_16"])
                {
                    
                    _commonModel.position16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_16"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_17"])
                {
                    
                    _commonModel.position17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_17"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_18"])
                {
                    
                    _commonModel.position18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_18"]];
                }
                
            }
            else
            {
                _commonModel.gross10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_10"]];
                _commonModel.gross11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_11"]];
                _commonModel.gross12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_12"]];
                _commonModel.gross13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_13"]];
                _commonModel.gross14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_14"]];
                _commonModel.gross15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_15"]];
                _commonModel.gross16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_16"]];
                _commonModel.gross17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_17"]];
                _commonModel.gross18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_18"]];
                
                if (dicPlayerHoleScore[@"position_10"])
                {
                    _commonModel.position10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_10"]];
                }
                else
                {
                    _commonModel.position10 = @"-";
                    
                }
                //if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_2"]] length] > 0)
                if (dicPlayerHoleScore[@"position_11"])
                {
                    
                    _commonModel.position11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_11"]];
                    
                }
                else
                {
                    
                    _commonModel.position11 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_12"])
                {
                    
                    _commonModel.position12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_12"]];
                    
                }
                else
                {
                    
                    _commonModel.position12 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_13"])
                {
                    
                    _commonModel.position13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_13"]];
                    
                }
                else
                {
                    
                    _commonModel.position13 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_14"])
                {
                    _commonModel.position14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_14"]];
                    
                }
                else
                {
                    _commonModel.position14 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_15"])
                {
                    
                    _commonModel.position15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_15"]];
                    
                }
                else
                {
                    
                    _commonModel.position15 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_16"])
                {
                    
                    _commonModel.position16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_16"]];
                    
                }
                else
                {
                    
                    _commonModel.position16 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_17"])
                {
                    
                    _commonModel.position17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_17"]];
                    
                }
                else
                {
                    
                    _commonModel.position17 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_18"])
                {
                    
                    _commonModel.position18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_18"]];
                }
                else
                {
                    
                    _commonModel.position18 = @"-";
                }
            }
            
        }
    }
    
    
    if ([_commonModel.holeNumber integerValue] == 18 )
    {
        
        self.tableBack9.hidden = NO;
        _commonModel.index10Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_10"]];
        _commonModel.index11Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_11"]];
        _commonModel.index12Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_12"]];
        _commonModel.index13Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_13"]];
        _commonModel.index14Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_14"]];
        _commonModel.index15Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_15"]];
        _commonModel.index16Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_16"]];
        _commonModel.index17Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_17"]];
        _commonModel.index18Value = [NSString stringWithFormat:@"%@",dicData[@"hole_index_18"]];
        _commonModel.holeStartFrom = dicData[@"hole_start_from"];
        
        
        _commonModel.par10Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_10"]];
        _commonModel.par11Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_11"]];
        _commonModel.par12Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_12"]];
        _commonModel.par13Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_13"]];
        _commonModel.par14Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_14"]];
        _commonModel.par15Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_15"]];
        _commonModel.par16Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_16"]];
        _commonModel.par17Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_17"]];
        _commonModel.par18Value = [NSString stringWithFormat:@"%@",dicData[@"par_value_18"]];
        
        if (isHoleNumberPresent == YES)
        {
            _commonModel.holeColor10 = dicPlayerHoleScore[@"hole_color_10"];
            _commonModel.holeColor11 = dicPlayerHoleScore[@"hole_color_11"];
            _commonModel.holeColor12 = dicPlayerHoleScore[@"hole_color_12"];
            _commonModel.holeColor13 = dicPlayerHoleScore[@"hole_color_13"];
            _commonModel.holeColor14 = dicPlayerHoleScore[@"hole_color_14"];
            _commonModel.holeColor15 = dicPlayerHoleScore[@"hole_color_15"];
            _commonModel.holeColor16 = dicPlayerHoleScore[@"hole_color_16"];
            _commonModel.holeColor17 = dicPlayerHoleScore[@"hole_color_17"];
            _commonModel.holeColor18 = dicPlayerHoleScore[@"hole_color_18"];
            
            
            
           
            
            // Position 10 to 18
            if (self.isStablefordGameEnabled == YES)
            {
                _commonModel.gross10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_10"]];
                _commonModel.gross11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_11"]];
                _commonModel.gross12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_12"]];
                _commonModel.gross13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_13"]];
                _commonModel.gross14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_14"]];
                _commonModel.gross15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_15"]];
                _commonModel.gross16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_16"]];
                _commonModel.gross17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_17"]];
                _commonModel.gross18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"gross_score_18"]];
                
                if (dicPlayerHoleScore[@"hole_num_10"])
                {
                    _commonModel.position10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_10"]];
                }
               
                if (dicPlayerHoleScore[@"hole_num_11"])
                {
                    
                    _commonModel.position11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_11"]];
                    
                }
                if (dicPlayerHoleScore[@"hole_num_12"])
                {
                    
                    _commonModel.position12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_12"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_13"])
                {
                    
                    _commonModel.position13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_13"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_14"])
                {
                    _commonModel.position14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_14"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_15"])
                {
                    
                    _commonModel.position15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_15"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_16"])
                {
                    
                    _commonModel.position16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_16"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_17"])
                {
                    
                    _commonModel.position17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_17"]];
                    
                }
                
                if (dicPlayerHoleScore[@"hole_num_18"])
                {
                    
                    _commonModel.position18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_18"]];
                }
                
            }
            else
            {
                _commonModel.gross10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_10"]];
                _commonModel.gross11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_11"]];
                _commonModel.gross12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_12"]];
                _commonModel.gross13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_13"]];
                _commonModel.gross14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_14"]];
                _commonModel.gross15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_15"]];
                _commonModel.gross16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_16"]];
                _commonModel.gross17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_17"]];
                _commonModel.gross18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"hole_num_18"]];
                
                if (dicPlayerHoleScore[@"position_10"])
                {
                    _commonModel.position10 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_10"]];
                }
                else
                {
                    _commonModel.position10 = @"-";
                    
                }
                //if ([[NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_2"]] length] > 0)
                if (dicPlayerHoleScore[@"position_11"])
                {
                    
                    _commonModel.position11 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_11"]];
                    
                }
                else
                {
                    
                    _commonModel.position11 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_12"])
                {
                    
                    _commonModel.position12 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_12"]];
                    
                }
                else
                {
                    
                    _commonModel.position12 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_13"])
                {
                    
                    _commonModel.position13 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_13"]];
                    
                }
                else
                {
                    
                    _commonModel.position13 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_14"])
                {
                    _commonModel.position14 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_14"]];
                    
                }
                else
                {
                    _commonModel.position14 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_15"])
                {
                    
                    _commonModel.position15 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_15"]];
                    
                }
                else
                {
                    
                    _commonModel.position15 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_16"])
                {
                    
                    _commonModel.position16 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_16"]];
                    
                }
                else
                {
                    
                    _commonModel.position16 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_17"])
                {
                    
                    _commonModel.position17 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_17"]];
                    
                }
                else
                {
                    
                    _commonModel.position17 = @"-";
                    
                }
                
                if (dicPlayerHoleScore[@"position_18"])
                {
                    
                    _commonModel.position18 = [NSString stringWithFormat:@"%@",dicPlayerHoleScore[@"position_18"]];
                }
                else
                {
                    
                    _commonModel.position18 = @"-";
                }
            }
            
        }
        else{
            _commonModel.gross10 = @"-";
            _commonModel.gross11 = @"-";
            _commonModel.gross12 = @"-";
            _commonModel.gross13 = @"-";
            _commonModel.gross14 = @"-";
            _commonModel.gross15 = @"-";
            _commonModel.gross16 = @"-";
            _commonModel.gross17 = @"-";
            _commonModel.gross18 = @"-";
            
            _commonModel.position10 = @"-";
            _commonModel.position11 = @"-";
            _commonModel.position12 = @"-";
            _commonModel.position13 = @"-";
            _commonModel.position14 = @"-";
            _commonModel.position15 = @"-";
            _commonModel.position16 = @"-";
            _commonModel.position17 = @"-";
            _commonModel.position18 = @"-";
        }
        
        
    }
    else
    {
        self.tableBack9.hidden = YES;
        if ([self.createdEventModel.back9 isEqualToString:@"Front 9"])
        {
            self.constraintColoCpdeViewY.constant = self.constraintColoCpdeViewY.constant - self.tableFront9.frame.size.height;
            yForColorCodeView = self.constraintColoCpdeViewY.constant;
        }
        
        
    }
    if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
    {
        self.tableFront9.hidden = YES;
        self.tableBack9.hidden = NO;
        //To prevent multiple time change of y axis
        if (yForTableBack9 == 0.0)
        {
            self.constraintTableBack9Y.constant = self.constraintTableBack9Y.constant - self.tableFront9.frame.size.height;
            self.constraintColoCpdeViewY.constant = self.constraintColoCpdeViewY.constant - self.tableFront9.frame.size.height;
            yForTableBack9 = self.constraintTableBack9Y.constant;
            yForColorCodeView = self.constraintColoCpdeViewY.constant;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkForNilPostionValues];
        [self checkForNilGrossValues];
        [self checkForNilParValues];
        [self checkForNilIndexValues];
        
        
        
        [self.tableFront9 reloadData];
        [self.tableBack9 reloadData];
        
    });
    
    [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
    self.loaderView.hidden = YES;

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
        
        
        NSDictionary *param = @{@"type":@"4",
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
                                      [self.bannerBtn removeFromSuperview];
                                  }
                              }];
                          }
                          else
                          {
                              [self.bannerImg removeFromSuperview];
                              [self.bannerBtn removeFromSuperview];
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


@end
