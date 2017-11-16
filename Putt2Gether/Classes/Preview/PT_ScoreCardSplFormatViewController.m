//
//  PT_ScoreCardSplFormatViewController.m
//  Putt2Gether
//
//  Created by Devashis on 20/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ScoreCardSplFormatViewController.h"

#import "PT_NewScoreCardCommonModel.h"
#import "PT_NewScoreCardPlayerDataModel.h"

#import "PT_ScoreCardTableViewCell.h"
#import "PT_ScoreCardBack9TableViewCell.h"

#import "PT_NewScoreCardFront9TableViewCell.h"
#import "PT_NewScoreCardBack9TableViewCell.h"

#import "PT_StandingsModel.h"

#import "PT_AutopressView.h"

#import "PT_MyScoresModel.h"

#import "UIImageView+AFNetworking.h"

#import "PT_FourTwoZeroView.h"

#import "PT_VegasFormatView.h"

#import "PT_AutoPressFormatView.h"

#import "PT_420Formatmodel.h"

#import "PT_TemplateDataViewController.h"

#import "PT_EventPreviewViewController.h"

static NSString *const FetchScoreDataSplFormatPostfix = @"getLatestFullScore";

static NSString *const FetchBannerPostFix = @"getadvbanner";

static NSInteger RowHeightConst = 24;

static NSString *const DefaultHexColorCode = @"#0b5a97";

@interface PT_ScoreCardSplFormatViewController ()<UITableViewDelegate,
UITableViewDataSource>
{
    
    IBOutlet UILabel *eventnameTitle;
    IBOutlet UILabel *golfCourseTitle;
}


@property (assign, nonatomic) BOOL isRequestToParticipate;


@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;

//Mark:-prperties for 420Format View
@property(strong,nonatomic)PT_FourTwoZeroView *fourTwoZeroView;

//Mark:-Prop for Vegas Format
@property(strong,nonatomic)PT_VegasFormatView *vegasFormatView;

//Mark:-prop for AutoPress
@property(strong,nonatomic)PT_AutoPressFormatView *autoPressFormatView;

@property (strong, nonatomic) PT_NewScoreCardCommonModel *commonModel;

@property (weak, nonatomic) IBOutlet UITableView *tableFront9;

@property (weak, nonatomic) IBOutlet UITableView *tableBack9;

@property (weak, nonatomic) IBOutlet UIView *colorCodeView,*loaderView,*loaderInsideView;;

@property(weak,nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *golfCourseLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *speacialFormatLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *speacialFormatRightButton;
@property (weak, nonatomic) IBOutlet UIButton *speacialFormatCentreButton;
@property (weak, nonatomic) IBOutlet UIImageView *speacialFormatDirectionImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintColoCpdeViewY;

@property (strong, nonatomic) PT_StandingsModel *standingModel;

@property (strong, nonatomic) PT_StandingsModel *standingModelBack9;

@property (weak, nonatomic) IBOutlet UIButton *eagleButton;

@property (weak, nonatomic) IBOutlet UIButton *birdieButton;

@property (weak, nonatomic) IBOutlet UIButton *bogeyButton;

@property (weak, nonatomic) IBOutlet UIButton *dBogeyButton;

@property (weak, nonatomic) IBOutlet UIButton *parButton;


@property (weak, nonatomic) IBOutlet UIView *bottomColorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDirectionImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYFront9View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYBack9View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYBottomColorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableBack9Height;
@property (strong, nonatomic) PT_AutopressView *autopressView;

@property(strong,nonatomic) NSMutableArray *arr420Format;

@end

@implementation PT_ScoreCardSplFormatViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.colorCodeView.layer.borderWidth = 0.8;
    self.colorCodeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    eventnameTitle.text = self.createdEventModel.eventName;
    golfCourseTitle.text = self.createdEventModel.golfCourseName;
    
    
    [self fetchScoreData];
    
    self.colorCodeView.layer.borderWidth = 0.8;
    self.colorCodeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.tableBack9.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableFront9.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    //Mark:-tap gesture over bottom color View
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOpenFormat)];
    [self.bottomColorView addGestureRecognizer:tap];
    
    [_speacialFormatLeftButton addTarget:self action:@selector(actionOpenFormat) forControlEvents:UIControlEventTouchUpInside];
    
    [_speacialFormatCentreButton addTarget:self action:@selector(actionOpenFormat) forControlEvents:UIControlEventTouchUpInside];
    
    [_speacialFormatRightButton addTarget:self action:@selector(actionOpenFormat) forControlEvents:UIControlEventTouchUpInside];
    
    //[self handleBottomColorView:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self fetchBannerDetail];

    if (_isComingFromMyscore == YES || _isSeenAfterDelegate == YES) {
        
        [self.addScoreBtn setHidden:YES];
    }
    
    self.eventNameLabel.text = self.createdEventModel.eventName;
    self.golfCourseLabel.text = self.createdEventModel.golfCourseName;
    
    
    if ([self.createdEventModel.formatId integerValue] == Format420Id)
    {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        UIFont *font1 = [UIFont fontWithName:@"Lato-Regular" size:22.0f];
        UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:10.0f];
        NSDictionary *dict1 = @{
                                NSFontAttributeName:font1};
        NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                NSFontAttributeName:font2};
        //Left
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"9\n"    attributes:dict1]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"ABHINAV 18"      attributes:dict2]];
        [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
        [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
        [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor whiteColor]];
        
        //Centre
        NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
        [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:@"5\n"    attributes:dict1]];
        [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:@"BASANT 17"      attributes:dict2]];
        [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
        [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
        [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
        
        //Right
        NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
        [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"3\n"    attributes:dict1]];
        [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"VIKAS 12"      attributes:dict2]];
        [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
        [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
        [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor whiteColor]];
        
        _speacialFormatDirectionImage.hidden = YES;
    }
    else
    {
        if ([self.createdEventModel.numberOfPlayers integerValue] == 2 ||
            [self.createdEventModel.numberOfPlayers integerValue] == 4)
        {
            //if (self.createdEventModel.)//Check fo rteam game
            
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            [style setLineBreakMode:NSLineBreakByWordWrapping];
            
            UIFont *font1 = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
            UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:7.0f];
            NSDictionary *dict1 = @{
                                    NSFontAttributeName:font1};
            NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                    NSFontAttributeName:font2};
            
            //Left
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
            if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
            {
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nSIMRAN 18\n"    attributes:dict1]];
                
            }
            else
            {
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM A\n"    attributes:dict1]];
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"SIMRAN 18 \n ABHINAV 17"      attributes:dict2]];
            }
            [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
            [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
            [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
            [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
            [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor blackColor]];
            
            UIFont *fontC1 = [UIFont fontWithName:@"Lato-Bold" size:18.0f];
            UIFont *fontC2 = [UIFont fontWithName:@"Lato-Regular"  size:8.0f];
            NSDictionary *dictC1 = @{
                                     NSFontAttributeName:fontC1};
            NSDictionary *dictC2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                     NSFontAttributeName:fontC2};
            //Centre
            NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
            [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:@"1 UP\n"    attributes:dictC1]];
            [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:@"THRU 18"      attributes:dictC2]];
            [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
            [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
            [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
            [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
            [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
            
            //Right
            NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
            if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
            {
                [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nDINESH 16\n"    attributes:dict1]];
            }
            else
            {
                [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM B\n"    attributes:dict1]];
                [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"DINESH 16 \n BASANT 15"      attributes:dict2]];
            }
            [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
            [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
            [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
            [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
            [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor blackColor]];
            
            _speacialFormatLeftButton.backgroundColor = SplFormatGrayColor;
            _speacialFormatRightButton.backgroundColor = SplFormatGrayColor;
            _speacialFormatCentreButton.backgroundColor = SplFormatRedTeamColor;
            _speacialFormatDirectionImage.hidden = NO;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    

    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
   
}

- (void)handleBottomColorView:(BOOL)isShow
{
    if ((!([self.createdEventModel.formatId integerValue] == Format420Id)) && isShow == YES)
    {
        if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId && isShow == YES)
        {
            self.constraintYFront9View.constant = self.constraintYFront9View.constant + self.bottomColorView.frame.size.height;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            int screenHeight = screenRect.size.height - 130;
            
            self.constraintYBottomColorView.constant = screenHeight ;
        }
        else
        {
            self.constraintYFront9View.constant = self.constraintYFront9View.constant + self.bottomColorView.frame.size.height - 35;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            int screenHeight = screenRect.size.height - 130 + 10;
            
            self.constraintYBottomColorView.constant = screenHeight ;
        }
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBack:(id)sender
{
    if (_isSeenAfterDelegate == YES) {
        
        [self fetchEventwithType:InviteType_Detail];
       
        return;
    }
    
    PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createdEventModel];
    [self presentViewController:startVC animated:YES completion:nil];

}
- (void)fetchEventwithType:(InviteType)type
{
    NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId];
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please check the internet connection and try again."
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
                                      model.playersInGame = dicData[@"players_in_game"];
                                      model.straightDrive = dicData[@"straight_drive"];
                                      model.teeId = dicData[@"tee_id"];
                                      model.totalHoleNumber = [dicData[@"total_hole_num"] integerValue];
                                      model.eventType = [dicData[@"type"] uppercaseString];
                                      model.isEventStarted = dicData[@"start_round_status"] ;
                                      model.is_accepted = [NSString stringWithFormat:@"%@",dicData[@"is_accepted"]];
                                      model.scorerId = [dicData[@"scorere_id"] integerValue];
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
                                              
                                              PT_EventPreviewViewController *createVC = [[PT_EventPreviewViewController alloc]initWithModel:model andIsRequestToParticipate:self.isRequestToParticipate];
                                              createVC.isViewScore = YES;
                                              [self presentViewController:createVC animated:YES completion:nil];
                                              
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
                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                    message:@"Connection Lost."
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
    
}




- (IBAction)actionAddScore:(id)sender
{
    PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createdEventModel];
    
    [self presentViewController:startVC animated:YES completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
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

-(IBAction)actionHtmlBtn
{
    PT_TemplateDataViewController *templtehtm = [[PT_TemplateDataViewController alloc] initWithEvent:self.createdEventModel];
    
    [self presentViewController:templtehtm animated:YES completion:nil];
}



- (void)fetchScoreData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSString *playerId = @"";
        if ([self.createdEventModel.formatId integerValue] == Format420Id)
        {
            //playerId = [NSString stringWithFormat:@"%li",self.playerId];
        }
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"player_id":playerId,
                                @"version":@"2"
                                };
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchScoreDataSplFormatPostfix];
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
                              [self parseDataForDictionary:dicData];
                              
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
                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                    message:@"Connection Lost."
                                                    preferredStyle:UIAlertControllerStyleAlert];
                      
                      
                      UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                          
                          [self fetchScoreData];
                          
                      }];
                      
                      UIAlertAction* cancel = [UIAlertAction
                                               actionWithTitle:@"Dismiss"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   
                                                   AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                   delegate.tabBarController.tabBar.hidden = NO;
                                                   [delegate.tabBarController setSelectedIndex:1];
                                                   UIViewController *vc = self.presentingViewController;
                                                   while (vc.presentingViewController) {
                                                       vc = vc.presentingViewController;
                                                   }
                                                   [vc dismissViewControllerAnimated:YES completion:NULL];
                                                   
                                               }];
                      [alert addAction:retry];
                      [alert addAction:cancel];
                      
                      [self presentViewController:alert animated:YES completion:nil];
                  }
                  
                  
              }];
    }
    
}




- (void)parseDataForDictionary:(NSDictionary *)dicData
{
    _holeStartNumber = [dicData[@"hole_start_from"] integerValue];
    _commonModel = [PT_NewScoreCardCommonModel new];
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
    
    _commonModel.eventAdmin = [NSString stringWithFormat:@"%@",dicData[@"event_admin_id"]];
    _commonModel.eventId = [NSString stringWithFormat:@"%@",dicData[@"event_id"]];
    _commonModel.eventName = dicData[@"event_name"];
    _commonModel.eventStrokePlayId = [NSString stringWithFormat:@"%@",dicData[@"event_stroke_play_id"]];
    _commonModel.golfCourseName = dicData[@"golf_course_name"];
    _commonModel.totalHoleNumber = [NSString stringWithFormat:@"%@",dicData[@"total_num_hole"]];
    
    //NSMutableArray *arrPlayers = [NSMutableArray new];
    
    NSDictionary *dicFRont9;
    //if (dicData[@"front_9_data"])
    if ([dicData valueForKey:@"front_9_data"] != nil)
    {
        NSArray *arrFront9 = dicData[@"front_9_data"];
        
        if ([arrFront9 count] > 0)
        {
            dicFRont9 = [arrFront9 firstObject];
            if (dicFRont9[@"team_a"])
            {
                //NSDictionary *dicTeamA = dicFRont9[@"team_a"];
                
                
            }
            if (dicFRont9[@"team_b"])
            {
                //NSDictionary *dicTeamB = dicFRont9[@"team_b"];
                
            }
            
            //INDEX VALUE
            NSDictionary *dicHoleIndex = dicFRont9[@"hole_index"];
            _commonModel.index1Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_1"]];
            _commonModel.index2Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_2"]];
            _commonModel.index3Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_3"]];
            _commonModel.index4Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_4"]];
            _commonModel.index5Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_5"]];
            _commonModel.index6Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_6"]];
            _commonModel.index7Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_7"]];
            _commonModel.index8Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_8"]];
            _commonModel.index9Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_9"]];
            
            //PAR VALUE
            NSDictionary *dicParValue = dicFRont9[@"par_value"];
            _commonModel.par1Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_1"]];
            _commonModel.par2Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_2"]];
            _commonModel.par3Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_3"]];
            _commonModel.par4Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_4"]];
            _commonModel.par5Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_5"]];
            _commonModel.par6Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_6"]];
            _commonModel.par7Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_7"]];
            _commonModel.par8Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_8"]];
            _commonModel.par9Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_9"]];
        }
        
    }
    
    NSInteger teamAId = 0;
    NSInteger teamBId = 0;
    
    NSDictionary *dicBack9;
    //18 hole game
    if (dicData[@"back_9_data"])
    {
        NSArray *arrBack9 = dicData[@"back_9_data"];
        dicBack9 = [arrBack9 firstObject];
        if ([_commonModel.totalHoleNumber integerValue] == 18)
        {
            self.tableBack9.hidden = NO;
        }
        else
        {
            self.tableBack9.hidden = YES;
        }
        NSDictionary *dicHoleIndex = dicBack9[@"hole_index"];
        _commonModel.index10Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_10"]];
        _commonModel.index11Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_11"]];
        _commonModel.index12Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_12"]];
        _commonModel.index13Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_13"]];
        _commonModel.index14Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_14"]];
        _commonModel.index15Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_15"]];
        _commonModel.index16Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_16"]];
        _commonModel.index17Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_17"]];
        _commonModel.index18Value = [NSString stringWithFormat:@"%@",dicHoleIndex[@"hole_index_18"]];
        
        //PAR VALUE
        NSDictionary *dicParValue = dicBack9[@"par_value"];
        _commonModel.par10Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_10"]];
        _commonModel.par11Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_11"]];
        _commonModel.par12Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_12"]];
        _commonModel.par13Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_13"]];
        _commonModel.par14Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_14"]];
        _commonModel.par15Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_15"]];
        _commonModel.par16Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_16"]];
        _commonModel.par17Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_17"]];
        _commonModel.par18Value = [NSString stringWithFormat:@"%@",dicParValue[@"par_value_18"]];
        
    }
    _standingModel = [PT_StandingsModel new];
    NSMutableArray *arrPlayersData = [NSMutableArray new];
    if ([_commonModel.totalHoleNumber integerValue] == 18)
    {
        if (!([self.createdEventModel.formatId integerValue] == FormatAutoPressId))
        {
            NSArray *arrStandings = dicFRont9[@"standings"];
            if ([arrStandings count] > 0)
            {
                [self setStandingsValue:arrStandings withModel:_standingModel startFromHole:0];
                
                NSDictionary *dicA = dicFRont9[@"team_a"];
                NSDictionary *dicTeamA = [dicA[@"player_list"] firstObject];
                NSDictionary *dicB = dicFRont9[@"team_b"];
                NSDictionary *dicTeamB = [dicB[@"player_list"] firstObject];
                
                teamAId = [dicTeamA[@"team_id"] integerValue];
                teamBId = [dicTeamB[@"team_id"] integerValue];
                NSArray *arrStandingsBack = dicBack9[@"standings"];
                if ([arrStandingsBack count] > 0)
                {
                    [self setStandingsValue:arrStandingsBack withModel:_standingModel startFromHole:9];
                    
                }
            }
            
            
        }
        
        
    }
    else
    {
        if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
        {
            self.tableBack9.hidden = NO;
            self.constraintYBack9View.constant = self.constraintYBack9View.constant - self.tableFront9.frame.size.height +40;
            self.constraintColoCpdeViewY.constant = self.constraintColoCpdeViewY.constant - self.tableFront9.frame.size.height;
            self.tableFront9.hidden = YES;
            self.tableFront9.hidden = YES;
            
            if (!([self.createdEventModel.formatId integerValue] == FormatAutoPressId))
            {
                
                NSArray *arrStandingsBack = dicBack9[@"standings"];
                if ([arrStandingsBack count] > 0)
                {
                    //[self setStandingsValue:arrStandingsBack withModel:_standingModel startFromHole:0];
                    [self setStandingsValueforBack9:arrStandingsBack withModel:_standingModel];
                    
                    NSDictionary *dicA = dicBack9[@"team_a"];
                    NSDictionary *dicTeamA = [dicA[@"player_list"] firstObject];
                    NSDictionary *dicB = dicBack9[@"team_b"];
                    NSDictionary *dicTeamB = [dicB[@"player_list"] firstObject];
                    
                    teamAId = [dicTeamA[@"team_id"] integerValue];
                    teamBId = [dicTeamB[@"team_id"] integerValue];
                    //self.constraintYBack9View.constant = self.constraintYBack9View.constant + 20;
                    
                }
            }
            
        }
        else{
            self.tableBack9.hidden = YES;
            self.constraintColoCpdeViewY.constant = self.constraintColoCpdeViewY.constant - self.tableFront9.frame.size.height;
            
            if (!([self.createdEventModel.formatId integerValue] == FormatAutoPressId))
            {
                NSArray *arrStandings = dicFRont9[@"standings"];
                if ([arrStandings count] > 0)
                {
                    [self setStandingsValue:arrStandings withModel:_standingModel startFromHole:0];
                    
                    NSDictionary *dicA = dicFRont9[@"team_a"];
                    NSDictionary *dicTeamA = [dicA[@"player_list"] firstObject];
                    NSDictionary *dicB = dicFRont9[@"team_b"];
                    NSDictionary *dicTeamB = [dicB[@"player_list"] firstObject];
                    
                    teamAId = [dicTeamA[@"team_id"] integerValue];
                    teamBId = [dicTeamB[@"team_id"] integerValue];
                }
                
                
            }
        }
        
    }
    
    
    NSString *strHoleNumber = @"";
    
    if ([_commonModel.totalHoleNumber integerValue]  == 18)
    {
        //TEAM A
        NSDictionary *dicF9 = dicFRont9[@"team_a"];
        NSArray *arrFront9 = dicF9[@"player_list"] ;
        for (NSInteger counterFRont9 = 0; counterFRont9 < [arrFront9 count]; counterFRont9++)
        {
            NSDictionary *dicB9 = dicBack9[@"team_a"];
            NSArray *arrBack9 = dicB9[@"player_list"] ;
            
            NSDictionary *dicPlayersFront9 = arrFront9[counterFRont9];
            NSDictionary *dicPlayersBack9 = arrBack9[counterFRont9];
            
            PT_NewScoreCardPlayerDataModel *model = [PT_NewScoreCardPlayerDataModel new];
            model.playerName = [dicPlayersFront9[@"name"] uppercaseString];
            model.playerId = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"player_id"]];
            model.handicap = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"handicap_value"]];
            model.shortName = dicPlayersFront9[@"short_name"];
            model.color = dicPlayersFront9[@"color"];
            if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
            {
                teamAId = [model.playerId integerValue];
            }
            NSDictionary *dicHoleNumer1 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_1"];
            NSDictionary *dicHoleNumer2 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_2"];
            NSDictionary *dicHoleNumer3 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_3"];
            NSDictionary *dicHoleNumer4 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_4"];
            NSDictionary *dicHoleNumer5 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_5"];
            NSDictionary *dicHoleNumer6 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_6"];
            NSDictionary *dicHoleNumer7 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_7"];
            NSDictionary *dicHoleNumer8 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_8"];
            NSDictionary *dicHoleNumer9 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_9"];
            
            model.hole_num_1 = [NSString stringWithFormat:@"%@",dicHoleNumer1[@"score"]];
            model.hole_num_2 = [NSString stringWithFormat:@"%@",dicHoleNumer2[@"score"]];
            model.hole_num_3 = [NSString stringWithFormat:@"%@",dicHoleNumer3[@"score"]];
            model.hole_num_4 = [NSString stringWithFormat:@"%@",dicHoleNumer4[@"score"]];
            model.hole_num_5 = [NSString stringWithFormat:@"%@",dicHoleNumer5[@"score"]];
            model.hole_num_6 = [NSString stringWithFormat:@"%@",dicHoleNumer6[@"score"]];
            model.hole_num_7 = [NSString stringWithFormat:@"%@",dicHoleNumer7[@"score"]];
            model.hole_num_8 = [NSString stringWithFormat:@"%@",dicHoleNumer8[@"score"]];
            model.hole_num_9 = [NSString stringWithFormat:@"%@",dicHoleNumer9[@"score"]];
            
            if ([dicHoleNumer1[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_1 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_1 = @"#ffffff";
            }
            if ([dicHoleNumer2[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_2 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_2 = @"#ffffff";
            }
            if ([dicHoleNumer3[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_3 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_3 = @"#ffffff";
            }
            if ([dicHoleNumer4[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_4 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_4 = @"#ffffff";
            }
            if ([dicHoleNumer5[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_5 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_5 = @"#ffffff";
            }
            if ([dicHoleNumer6[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_6 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_6 = @"#ffffff";
            }
            if ([dicHoleNumer7[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_7 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_7 = @"#ffffff";
            }
            if ([dicHoleNumer8[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_8 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_8 = @"#ffffff";
            }
            if ([dicHoleNumer9[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_9 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_9 = @"#ffffff";
            }
            
            NSDictionary *dicBackHoleNumer1 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_10"];
            NSDictionary *dicBackHoleNumer2 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_11"];
            NSDictionary *dicBackHoleNumer3 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_12"];
            NSDictionary *dicBackHoleNumer4 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_13"];
            NSDictionary *dicBackHoleNumer5 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_14"];
            NSDictionary *dicBackHoleNumer6 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_15"];
            NSDictionary *dicBackHoleNumer7 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_16"];
            NSDictionary *dicBackHoleNumer8 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_17"];
            NSDictionary *dicBackHoleNumer9 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_18"];
            
            model.hole_num_10 = [NSString stringWithFormat:@"%@",dicBackHoleNumer1[@"score"]];
            model.hole_num_11 = [NSString stringWithFormat:@"%@",dicBackHoleNumer2[@"score"]];
            model.hole_num_12 = [NSString stringWithFormat:@"%@",dicBackHoleNumer3[@"score"]];
            model.hole_num_13 = [NSString stringWithFormat:@"%@",dicBackHoleNumer4[@"score"]];
            model.hole_num_14 = [NSString stringWithFormat:@"%@",dicBackHoleNumer5[@"score"]];
            model.hole_num_15 = [NSString stringWithFormat:@"%@",dicBackHoleNumer6[@"score"]];
            model.hole_num_16 = [NSString stringWithFormat:@"%@",dicBackHoleNumer7[@"score"]];
            model.hole_num_17 = [NSString stringWithFormat:@"%@",dicBackHoleNumer8[@"score"]];
            model.hole_num_18 = [NSString stringWithFormat:@"%@",dicBackHoleNumer9[@"score"]];
            
            if ([dicBackHoleNumer1[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_10 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_10 = @"#ffffff";
            }
            if ([dicBackHoleNumer2[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_11 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_11 = @"#ffffff";
            }
            if ([dicBackHoleNumer3[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_12 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_12 = @"#ffffff";
            }
            if ([dicBackHoleNumer4[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_13 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_13 = @"#ffffff";
            }
            if ([dicBackHoleNumer5[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_14 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_14 = @"#ffffff";
            }
            if ([dicBackHoleNumer6[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_15 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_15 = @"#ffffff";
            }
            if ([dicBackHoleNumer7[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_16 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_16 = @"#ffffff";
            }
            if ([dicBackHoleNumer8[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_17 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_17 = @"#ffffff";
            }
            if ([dicBackHoleNumer9[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_18 = dicPlayersBack9[@"color"];;
            }
            else
            {
                model.hole_color_18 = @"#ffffff";
            }
            
            
            [arrPlayersData addObject:model];
        }
        //TEAM B
        NSDictionary *dicF9TeamB = dicFRont9[@"team_b"];
        NSArray *arrFront9TeamB = dicF9TeamB[@"player_list"] ;
        for (NSInteger counterFRont9 = 0; counterFRont9 < [arrFront9TeamB count]; counterFRont9++)
        {
            NSDictionary *dicB9 = dicBack9[@"team_b"];
            NSArray *arrBack9 = dicB9[@"player_list"] ;
            
            NSDictionary *dicPlayersFront9 = arrFront9TeamB[counterFRont9];
            NSDictionary *dicPlayersBack9 = arrBack9[counterFRont9];
            
            PT_NewScoreCardPlayerDataModel *model = [PT_NewScoreCardPlayerDataModel new];
            model.playerName = [dicPlayersFront9[@"name"] uppercaseString];
            model.playerId = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"player_id"]];
            model.handicap = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"handicap_value"]];
            model.shortName = dicPlayersFront9[@"short_name"];
            model.color = dicPlayersFront9[@"color"];
            
            if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
            {
                teamBId = [model.playerId integerValue];
            }
            
            NSDictionary *dicHoleNumer1 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_1"];
            NSDictionary *dicHoleNumer2 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_2"];
            NSDictionary *dicHoleNumer3 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_3"];
            NSDictionary *dicHoleNumer4 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_4"];
            NSDictionary *dicHoleNumer5 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_5"];
            NSDictionary *dicHoleNumer6 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_6"];
            NSDictionary *dicHoleNumer7 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_7"];
            NSDictionary *dicHoleNumer8 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_8"];
            NSDictionary *dicHoleNumer9 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_9"];
            
            model.hole_num_1 = [NSString stringWithFormat:@"%@",dicHoleNumer1[@"score"]];
            model.hole_num_2 = [NSString stringWithFormat:@"%@",dicHoleNumer2[@"score"]];
            model.hole_num_3 = [NSString stringWithFormat:@"%@",dicHoleNumer3[@"score"]];
            model.hole_num_4 = [NSString stringWithFormat:@"%@",dicHoleNumer4[@"score"]];
            model.hole_num_5 = [NSString stringWithFormat:@"%@",dicHoleNumer5[@"score"]];
            model.hole_num_6 = [NSString stringWithFormat:@"%@",dicHoleNumer6[@"score"]];
            model.hole_num_7 = [NSString stringWithFormat:@"%@",dicHoleNumer7[@"score"]];
            model.hole_num_8 = [NSString stringWithFormat:@"%@",dicHoleNumer8[@"score"]];
            model.hole_num_9 = [NSString stringWithFormat:@"%@",dicHoleNumer9[@"score"]];
            
            if ([dicHoleNumer1[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_1 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_1 = @"#ffffff";
            }
            if ([dicHoleNumer2[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_2 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_2 = @"#ffffff";
            }
            if ([dicHoleNumer3[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_3 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_3 = @"#ffffff";
            }
            if ([dicHoleNumer4[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_4 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_4 = @"#ffffff";
            }
            if ([dicHoleNumer5[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_5 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_5 = @"#ffffff";
            }
            if ([dicHoleNumer6[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_6 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_6 = @"#ffffff";
            }
            if ([dicHoleNumer7[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_7 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_7 = @"#ffffff";
            }
            if ([dicHoleNumer8[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_8 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_8 = @"#ffffff";
            }
            if ([dicHoleNumer9[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_9 = dicPlayersFront9[@"color"];
            }
            else
            {
                model.hole_color_9 = @"#ffffff";
            }
            
            NSDictionary *dicBackHoleNumer1 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_10"];
            NSDictionary *dicBackHoleNumer2 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_11"];
            NSDictionary *dicBackHoleNumer3 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_12"];
            NSDictionary *dicBackHoleNumer4 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_13"];
            NSDictionary *dicBackHoleNumer5 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_14"];
            NSDictionary *dicBackHoleNumer6 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_15"];
            NSDictionary *dicBackHoleNumer7 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_16"];
            NSDictionary *dicBackHoleNumer8 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_17"];
            NSDictionary *dicBackHoleNumer9 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_18"];
            
            model.hole_num_10 = [NSString stringWithFormat:@"%@",dicBackHoleNumer1[@"score"]];
            model.hole_num_11 = [NSString stringWithFormat:@"%@",dicBackHoleNumer2[@"score"]];
            model.hole_num_12 = [NSString stringWithFormat:@"%@",dicBackHoleNumer3[@"score"]];
            model.hole_num_13 = [NSString stringWithFormat:@"%@",dicBackHoleNumer4[@"score"]];
            model.hole_num_14 = [NSString stringWithFormat:@"%@",dicBackHoleNumer5[@"score"]];
            model.hole_num_15 = [NSString stringWithFormat:@"%@",dicBackHoleNumer6[@"score"]];
            model.hole_num_16 = [NSString stringWithFormat:@"%@",dicBackHoleNumer7[@"score"]];
            model.hole_num_17 = [NSString stringWithFormat:@"%@",dicBackHoleNumer8[@"score"]];
            model.hole_num_18 = [NSString stringWithFormat:@"%@",dicBackHoleNumer9[@"score"]];
            
            if ([dicBackHoleNumer1[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_10 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_10 = @"#ffffff";
            }
            if ([dicBackHoleNumer2[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_11 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_11 = @"#ffffff";
            }
            if ([dicBackHoleNumer3[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_12 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_12 = @"#ffffff";
            }
            if ([dicBackHoleNumer4[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_13 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_13 = @"#ffffff";
            }
            if ([dicBackHoleNumer5[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_14 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_14 = @"#ffffff";
            }
            if ([dicBackHoleNumer6[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_15 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_15 = @"#ffffff";
            }
            if ([dicBackHoleNumer7[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_16 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_16 = @"#ffffff";
            }
            if ([dicBackHoleNumer8[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_17 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_17 = @"#ffffff";
            }
            if ([dicBackHoleNumer9[@"is_lowest"] integerValue] == 1)
            {
                model.hole_color_18 = dicPlayersBack9[@"color"];
            }
            else
            {
                model.hole_color_18 = @"#ffffff";
            }
            
            
            
            [arrPlayersData addObject:model];
        }
        
        
    }
    else
    {
        if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
        {
            NSDictionary *dicB9 = dicBack9[@"team_a"];
            NSArray *arrBack9 = dicB9[@"player_list"] ;
            for (NSInteger counterB9 = 0; counterB9 < [arrBack9 count]; counterB9++)
            {
                //TEAM A
                NSDictionary *dicF9 = dicBack9[@"team_a"];
                NSArray *arrBack9 = dicF9[@"player_list"] ;
                for (NSInteger counterBack9 = 0; counterBack9 < [arrBack9 count]; counterBack9++)
                {
                
                    NSDictionary *dicPlayersBack9 = arrBack9[counterBack9];
                    
                    PT_NewScoreCardPlayerDataModel *model = [PT_NewScoreCardPlayerDataModel new];
                    model.playerName = [dicPlayersBack9[@"name"] uppercaseString];
                    model.playerId = [NSString stringWithFormat:@"%@",dicPlayersBack9[@"player_id"]];
                    model.handicap = [NSString stringWithFormat:@"%@",dicPlayersBack9[@"handicap_value"]];
                    model.shortName = dicPlayersBack9[@"short_name"];
                    model.color = dicPlayersBack9[@"color"];
                    
                    if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                    {
                        teamAId = [model.playerId integerValue];
                    }
                    
                    NSDictionary *dicBackHoleNumer1 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_10"];
                    NSDictionary *dicBackHoleNumer2 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_11"];
                    NSDictionary *dicBackHoleNumer3 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_12"];
                    NSDictionary *dicBackHoleNumer4 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_13"];
                    NSDictionary *dicBackHoleNumer5 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_14"];
                    NSDictionary *dicBackHoleNumer6 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_15"];
                    NSDictionary *dicBackHoleNumer7 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_16"];
                    NSDictionary *dicBackHoleNumer8 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_17"];
                    NSDictionary *dicBackHoleNumer9 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_18"];
                    
                    model.hole_num_10 = [NSString stringWithFormat:@"%@",dicBackHoleNumer1[@"score"]];
                    model.hole_num_11 = [NSString stringWithFormat:@"%@",dicBackHoleNumer2[@"score"]];
                    model.hole_num_12 = [NSString stringWithFormat:@"%@",dicBackHoleNumer3[@"score"]];
                    model.hole_num_13 = [NSString stringWithFormat:@"%@",dicBackHoleNumer4[@"score"]];
                    model.hole_num_14 = [NSString stringWithFormat:@"%@",dicBackHoleNumer5[@"score"]];
                    model.hole_num_15 = [NSString stringWithFormat:@"%@",dicBackHoleNumer6[@"score"]];
                    model.hole_num_16 = [NSString stringWithFormat:@"%@",dicBackHoleNumer7[@"score"]];
                    model.hole_num_17 = [NSString stringWithFormat:@"%@",dicBackHoleNumer8[@"score"]];
                    model.hole_num_18 = [NSString stringWithFormat:@"%@",dicBackHoleNumer9[@"score"]];
                    
                    if ([dicBackHoleNumer1[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_10 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_10 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer2[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_11 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_11 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer3[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_12 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_12 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer4[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_13 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_13 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer5[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_14 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_14 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer6[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_15 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_15 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer7[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_16 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_16 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer8[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_17 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_17 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer9[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_18 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_18 = @"#ffffff";
                    }
                    
                    [arrPlayersData addObject:model];
                }
                //TEAM B
                NSDictionary *dicB9TeamB = dicBack9[@"team_b"];
                NSArray *arrBack9TeamB = dicB9TeamB[@"player_list"] ;
                for (NSInteger counterBack9 = 0; counterBack9 < [arrBack9TeamB count]; counterBack9++)
                {
            
                    NSDictionary *dicPlayersBack9 = arrBack9TeamB[counterBack9];
                    
                    //NSDictionary *dicPlayersBack9 = arrBack9[counterBack9];
                    
                    PT_NewScoreCardPlayerDataModel *model = [PT_NewScoreCardPlayerDataModel new];
                    model.playerName = [dicPlayersBack9[@"name"] uppercaseString];
                    model.playerId = [NSString stringWithFormat:@"%@",dicPlayersBack9[@"player_id"]];
                    model.handicap = [NSString stringWithFormat:@"%@",dicPlayersBack9[@"handicap_value"]];
                    model.shortName = dicPlayersBack9[@"short_name"];
                    model.color = dicPlayersBack9[@"color"];
                    
                    if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                    {
                        teamBId = [model.playerId integerValue];
                    }
                    
                    NSDictionary *dicBackHoleNumer1 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_10"];
                    NSDictionary *dicBackHoleNumer2 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_11"];
                    NSDictionary *dicBackHoleNumer3 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_12"];
                    NSDictionary *dicBackHoleNumer4 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_13"];
                    NSDictionary *dicBackHoleNumer5 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_14"];
                    NSDictionary *dicBackHoleNumer6 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_15"];
                    NSDictionary *dicBackHoleNumer7 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_16"];
                    NSDictionary *dicBackHoleNumer8 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_17"];
                    NSDictionary *dicBackHoleNumer9 = [dicPlayersBack9[@"hole_score"] objectForKey:@"hole_num_18"];
                    
                    model.hole_num_10 = [NSString stringWithFormat:@"%@",dicBackHoleNumer1[@"score"]];
                    model.hole_num_11 = [NSString stringWithFormat:@"%@",dicBackHoleNumer2[@"score"]];
                    model.hole_num_12 = [NSString stringWithFormat:@"%@",dicBackHoleNumer3[@"score"]];
                    model.hole_num_13 = [NSString stringWithFormat:@"%@",dicBackHoleNumer4[@"score"]];
                    model.hole_num_14 = [NSString stringWithFormat:@"%@",dicBackHoleNumer5[@"score"]];
                    model.hole_num_15 = [NSString stringWithFormat:@"%@",dicBackHoleNumer6[@"score"]];
                    model.hole_num_16 = [NSString stringWithFormat:@"%@",dicBackHoleNumer7[@"score"]];
                    model.hole_num_17 = [NSString stringWithFormat:@"%@",dicBackHoleNumer8[@"score"]];
                    model.hole_num_18 = [NSString stringWithFormat:@"%@",dicBackHoleNumer9[@"score"]];
                    
                    if ([dicBackHoleNumer1[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_10 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_10 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer2[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_11 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_11 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer3[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_12 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_12 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer4[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_13 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_13 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer5[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_14 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_14 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer6[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_15 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_15 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer7[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_16 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_16 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer8[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_17 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_17 = @"#ffffff";
                    }
                    if ([dicBackHoleNumer9[@"is_lowest"] integerValue] == 1)
                    {
                        model.hole_color_18 = dicPlayersBack9[@"color"];
                    }
                    else
                    {
                        model.hole_color_18 = @"#ffffff";
                    }
                    
                    
                    
                    [arrPlayersData addObject:model];
                }

                
            }
        }
        else
        {
            //TEAM A
            NSDictionary *dicF9 = dicFRont9[@"team_a"];
            NSArray *arrFront9 = dicF9[@"player_list"] ;
            for (NSInteger counterFRont9 = 0; counterFRont9 < [arrFront9 count]; counterFRont9++)
            {
                
                
                NSDictionary *dicPlayersFront9 = arrFront9[counterFRont9];
                
                PT_NewScoreCardPlayerDataModel *model = [PT_NewScoreCardPlayerDataModel new];
                model.playerName = [dicPlayersFront9[@"name"] uppercaseString];
                model.playerId = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"player_id"]];
                model.handicap = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"handicap_value"]];
                model.shortName = dicPlayersFront9[@"short_name"];
                model.color = dicPlayersFront9[@"color"];
                
                NSDictionary *dicHoleNumer1 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_1"];
                NSDictionary *dicHoleNumer2 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_2"];
                NSDictionary *dicHoleNumer3 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_3"];
                NSDictionary *dicHoleNumer4 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_4"];
                NSDictionary *dicHoleNumer5 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_5"];
                NSDictionary *dicHoleNumer6 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_6"];
                NSDictionary *dicHoleNumer7 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_7"];
                NSDictionary *dicHoleNumer8 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_8"];
                NSDictionary *dicHoleNumer9 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_9"];
                
                if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                {
                    teamAId = [model.playerId integerValue];
                }
                
                model.hole_num_1 = [NSString stringWithFormat:@"%@",dicHoleNumer1[@"score"]];
                model.hole_num_2 = [NSString stringWithFormat:@"%@",dicHoleNumer2[@"score"]];
                model.hole_num_3 = [NSString stringWithFormat:@"%@",dicHoleNumer3[@"score"]];
                model.hole_num_4 = [NSString stringWithFormat:@"%@",dicHoleNumer4[@"score"]];
                model.hole_num_5 = [NSString stringWithFormat:@"%@",dicHoleNumer5[@"score"]];
                model.hole_num_6 = [NSString stringWithFormat:@"%@",dicHoleNumer6[@"score"]];
                model.hole_num_7 = [NSString stringWithFormat:@"%@",dicHoleNumer7[@"score"]];
                model.hole_num_8 = [NSString stringWithFormat:@"%@",dicHoleNumer8[@"score"]];
                model.hole_num_9 = [NSString stringWithFormat:@"%@",dicHoleNumer9[@"score"]];
                
    
                
                if ([dicHoleNumer1[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_1 = dicHoleNumer1[@"color"];
                }
                else
                {
                    model.hole_color_1 = @"#ffffff";
                }
                if ([dicHoleNumer2[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_2 = dicHoleNumer2[@"color"];
                }
                else
                {
                    model.hole_color_2 = @"#ffffff";
                }
                if ([dicHoleNumer3[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_3 = dicHoleNumer3[@"color"];
                }
                else
                {
                    model.hole_color_3 = @"#ffffff";
                }
                if ([dicHoleNumer4[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_4 = dicHoleNumer4[@"color"];
                }
                else
                {
                    model.hole_color_4 = @"#ffffff";
                }
                if ([dicHoleNumer5[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_5 = dicHoleNumer5[@"color"];
                }
                else
                {
                    model.hole_color_5 = @"#ffffff";
                }
                if ([dicHoleNumer6[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_6 = dicHoleNumer6[@"color"];
                }
                else
                {
                    model.hole_color_6 = @"#ffffff";
                }
                if ([dicHoleNumer7[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_7 = dicHoleNumer7[@"color"];
                }
                else
                {
                    model.hole_color_7 = @"#ffffff";
                }
                if ([dicHoleNumer8[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_8 = dicHoleNumer8[@"color"];
                }
                else
                {
                    model.hole_color_8 = @"#ffffff";
                }
                if ([dicHoleNumer9[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_9 = dicHoleNumer9[@"color"];
                }
                else
                {
                    model.hole_color_9 = @"#ffffff";
                }
                
                
                
                [arrPlayersData addObject:model];
            }
            //TEAM B
            NSDictionary *dicF9TeamB = dicFRont9[@"team_b"];
            NSArray *arrFront9TeamB = dicF9TeamB[@"player_list"] ;
            for (NSInteger counterFRont9 = 0; counterFRont9 < [arrFront9TeamB count]; counterFRont9++)
            {
                
                
                NSDictionary *dicPlayersFront9 = arrFront9TeamB[counterFRont9];
                
                PT_NewScoreCardPlayerDataModel *model = [PT_NewScoreCardPlayerDataModel new];
                model.playerName = [dicPlayersFront9[@"name"] uppercaseString];
                model.playerId = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"player_id"]];
                model.handicap = [NSString stringWithFormat:@"%@",dicPlayersFront9[@"handicap_value"]];
                model.shortName = dicPlayersFront9[@"short_name"];
                model.color = dicPlayersFront9[@"color"];
                
                if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                {
                    teamBId = [model.playerId integerValue];
                }
                
                NSDictionary *dicHoleNumer1 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_1"];
                NSDictionary *dicHoleNumer2 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_2"];
                NSDictionary *dicHoleNumer3 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_3"];
                NSDictionary *dicHoleNumer4 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_4"];
                NSDictionary *dicHoleNumer5 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_5"];
                NSDictionary *dicHoleNumer6 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_6"];
                NSDictionary *dicHoleNumer7 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_7"];
                NSDictionary *dicHoleNumer8 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_8"];
                NSDictionary *dicHoleNumer9 = [dicPlayersFront9[@"hole_score"] objectForKey:@"hole_num_9"];
                
                
                model.hole_num_1 = [NSString stringWithFormat:@"%@",dicHoleNumer1[@"score"]];
                model.hole_num_2 = [NSString stringWithFormat:@"%@",dicHoleNumer2[@"score"]];
                model.hole_num_3 = [NSString stringWithFormat:@"%@",dicHoleNumer3[@"score"]];
                model.hole_num_4 = [NSString stringWithFormat:@"%@",dicHoleNumer4[@"score"]];
                model.hole_num_5 = [NSString stringWithFormat:@"%@",dicHoleNumer5[@"score"]];
                model.hole_num_6 = [NSString stringWithFormat:@"%@",dicHoleNumer6[@"score"]];
                model.hole_num_7 = [NSString stringWithFormat:@"%@",dicHoleNumer7[@"score"]];
                model.hole_num_8 = [NSString stringWithFormat:@"%@",dicHoleNumer8[@"score"]];
                model.hole_num_9 = [NSString stringWithFormat:@"%@",dicHoleNumer9[@"score"]];
                
                if ([dicHoleNumer1[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_1 = dicHoleNumer1[@"color"];
                }
                else
                {
                    model.hole_color_1 = @"#ffffff";
                }
                if ([dicHoleNumer2[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_2 = dicHoleNumer2[@"color"];
                }
                else
                {
                    model.hole_color_2 = @"#ffffff";
                }
                if ([dicHoleNumer3[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_3 = dicHoleNumer3[@"color"];
                }
                else
                {
                    model.hole_color_3 = @"#ffffff";
                }
                if ([dicHoleNumer4[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_4 = dicHoleNumer4[@"color"];
                }
                else
                {
                    model.hole_color_4 = @"#ffffff";
                }
                if ([dicHoleNumer5[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_5 = dicHoleNumer5[@"color"];
                }
                else
                {
                    model.hole_color_5 = @"#ffffff";
                }
                if ([dicHoleNumer6[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_6 = dicHoleNumer6[@"color"];
                }
                else
                {
                    model.hole_color_6 = @"#ffffff";
                }
                if ([dicHoleNumer7[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_7 = dicHoleNumer7[@"color"];
                }
                else
                {
                    model.hole_color_7 = @"#ffffff";
                }
                if ([dicHoleNumer8[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_8 = dicHoleNumer8[@"color"];
                }
                else
                {
                    model.hole_color_8 = @"#ffffff";
                }
                if ([dicHoleNumer9[@"is_lowest"] integerValue] == 1)
                {
                    model.hole_color_9 = dicHoleNumer9[@"color"];
                }
                else
                {
                    model.hole_color_9 = @"#ffffff";
                }
                
                
                [arrPlayersData addObject:model];
            }
        }
    }
    
    _commonModel.arrPlayersDetail = [NSArray arrayWithArray:arrPlayersData];
    [self.tableFront9 reloadData];
    [self.tableBack9 reloadData];
    
    if ([self.createdEventModel.numberOfPlayers integerValue] == 2 && [self.createdEventModel.formatId integerValue] == FormatMatchPlayId)
    {
        
        if ([dicData[@"current_standing"] count] > 0)
        {
            [self handleBottomColorView:YES];
            NSDictionary *dicCurrentStandings = [dicData[@"current_standing"] firstObject];
            strHoleNumber = [NSString stringWithFormat:@"%@",dicCurrentStandings[@"hole_number"]];
            //UIColor *centreColor = [UIColor colorFromHexString:dicCurrentStandings[@"color"]];
            UIColor *centreColor;
            float y = self.speacialFormatDirectionImage.frame.origin.y;
            float width = self.speacialFormatDirectionImage.frame.size.width;
            float height = self.speacialFormatDirectionImage.frame.size.height;
            //NSString *scoreValue = [NSString stringWithFormat:@"%@",dicCurrentStandings[@"score_value"]];
            
            if ([dicCurrentStandings[@"winner"] integerValue] == teamAId)
            {
                
                centreColor = SplFormatRedTeamColor;
                //Left
                float x = self.speacialFormatCentreButton.frame.origin.x - width;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
                    self.speacialFormatDirectionImage.image = [UIImage imageNamed:LeftRedArrowImage];
                });
                
            }
            else if ([dicCurrentStandings[@"winner"] integerValue] == teamBId)
            {
                centreColor = SplFormatBlueColor;
                
                //Right
                float x = self.speacialFormatCentreButton.frame.origin.x + self.speacialFormatCentreButton.frame.size.width;
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
                    self.speacialFormatDirectionImage.image = [UIImage imageNamed:RightBlueArrowImage];
                });
            }
            else
                //if ([scoreValue isEqualToString:@"HALVED"])
            {
                //Hide arrow image
                self.speacialFormatDirectionImage.hidden = YES;
                centreColor = [UIColor colorFromHexString:dicCurrentStandings[@"color"]];
            }
            [[self speacialFormatCentreButton] setBackgroundColor:centreColor];
            
            //NSArray *arrTeam = dicData[@"team_data"];
            
            //if ([arrTeam count] > 1)
            {
                
                PT_NewScoreCardPlayerDataModel *modelPlayer1 = [self.commonModel.arrPlayersDetail firstObject];
                NSString *strTeamAMembers = [NSString stringWithFormat:@"%@ %@ ",modelPlayer1.playerName,modelPlayer1.handicap];
                
                
                PT_NewScoreCardPlayerDataModel *modelPlayer2 = [self.commonModel.arrPlayersDetail lastObject];
                NSString *strTeamBMembers = [NSString stringWithFormat:@"%@ %@ ",modelPlayer2.playerName,modelPlayer2.handicap];
                
                
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                [style setAlignment:NSTextAlignmentCenter];
                [style setLineBreakMode:NSLineBreakByWordWrapping];
                
                UIFont *font1 = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
                UIFont *font2 = [UIFont fontWithName:@"Lato-Bold"  size:10.0f];
                NSDictionary *dict1 = @{
                                        NSFontAttributeName:font1};
                NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                        NSFontAttributeName:font2};
                
                //Left
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
                
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@""    attributes:dict1]];
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:strTeamAMembers      attributes:dict2]];
                
                [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
                [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
                [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
                //[[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor blackColor]];
                [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor colorFromHexString:modelPlayer1.color]];
                
                
                
                //Right
                NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
                
                [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@""    attributes:dict1]];
                [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:strTeamBMembers      attributes:dict2]];
                
                [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
                [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
                [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
                //[[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor blackColor]];
                [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor colorFromHexString:modelPlayer2.color]];
            }
            
            /////////////////////Edit the Values Based on API- Currently unavailable
            UIFont *fontC1 = [UIFont fontWithName:@"Lato-Bold" size:18.0f];
            UIFont *fontC2 = [UIFont fontWithName:@"Lato-Regular"  size:8.0f];
            NSDictionary *dictC1 = @{
                                     NSFontAttributeName:fontC1};
            NSDictionary *dictC2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                     NSFontAttributeName:fontC2};
            //Centre
            NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
            NSString *centreTitle = [NSString stringWithFormat:@"%@ \n",dicCurrentStandings[@"score_value"]];
            [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:centreTitle    attributes:dictC1]];
            NSString *strThru = [NSString stringWithFormat:@"THRU %@",strHoleNumber];
            [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:strThru      attributes:dictC2]];
            [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
            [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
            [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
            [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
            [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
            
            ////////////////////////////////////////////////////////////////////////////////////
        }
        else
        {
            //Hide View
            self.bottomColorView.hidden = YES;
            
        }
    }
    if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId)
    {
        id arrBack9;
        id arrScoreValue;
        
        [[self speacialFormatCentreButton] setHidden:YES];
        
        NSDictionary *dicCurrentStandings = [dicData[@"current_standing"] firstObject];
        if ([dicCurrentStandings count] > 0)
        {
            if (_autopressView == nil)
            {
                _autopressView = [[[NSBundle mainBundle] loadNibNamed:@"PT_AutopressView" owner:self options:nil] firstObject];
                CGRect frameLeaderboard = self.bottomColorView.bounds;
                _autopressView.frame = CGRectMake(-1, 10, frameLeaderboard.size.width, frameLeaderboard.size.height - 10);
                [self.bottomColorView addSubview:_autopressView];
                
            }
            self.bottomColorView.hidden = NO;
            arrBack9 = dicCurrentStandings[@"back_to_9_score"];
            arrScoreValue = dicCurrentStandings[@"score_value"];
        }
        else
        {
            self.bottomColorView.hidden = YES;
        }
        
        
        
        
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
        if ([arrScoreValue isKindOfClass:[NSArray class]])
        {
            if ([arrScoreValue count] > 0)
            {
                
                for (NSInteger count = 0; count < [arrScoreValue count]; count++) {
                    NSDictionary *dicAtIndex = arrScoreValue[count];
                    NSString *strColor = dicAtIndex[@"color"];
                    if ([strColor length] == 0)
                    {
                        strColor = @"#000000";
                    }
                    UIColor * color = [UIColor colorFromHexString:strColor];
                    //UIColor * color = [UIColor colorFromHexString:dicAtIndex[@"color"]];
                    NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
                    NSString *textValue = [NSString stringWithFormat:@"%@ ",dicAtIndex[@"score"]];
                    NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
                    [attributedString appendAttributedString:subString];
                    
                }
                
                
            }
        }
        else if ([arrScoreValue isKindOfClass:[NSDictionary class]])
        {
            UIColor * color = [UIColor colorFromHexString:arrScoreValue[@"color"]];
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
            NSString *textValue = [NSString stringWithFormat:@"%@ ",arrScoreValue[@"score"]];
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
            [attributedString appendAttributedString:subString];
            
        }
        
        //BACK 9
        if ([arrBack9 isKindOfClass:[NSArray class]])
        {
            if ([arrBack9 count] > 0)
            {
                //Adding "&" text
                UIColor * colorBlack = [UIColor blackColor];
                NSDictionary * attributesAndText = [NSDictionary dictionaryWithObject:colorBlack forKey:NSForegroundColorAttributeName];
                NSString *textAnd = @" & ";
                NSAttributedString * subStringAnd = [[NSAttributedString alloc] initWithString:textAnd attributes:attributesAndText];
                [attributedString appendAttributedString:subStringAnd];
                
                for (NSInteger count = 0; count < [arrBack9 count]; count++) {
                    NSDictionary *dicAtIndex = arrBack9[count];
                    UIColor * color = [UIColor colorFromHexString:dicAtIndex[@"color"]];
                    NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
                    NSString *textValue = [NSString stringWithFormat:@"%@ ",dicAtIndex[@"score"]];
                    NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
                    [attributedString appendAttributedString:subString];
                    
                }
                
                
            }
        }
        else if ([arrBack9 isKindOfClass:[NSDictionary class]])
        {
            //Adding "&" text
            UIColor * colorBlack = [UIColor blackColor];
            NSDictionary * attributesAndText = [NSDictionary dictionaryWithObject:colorBlack forKey:NSForegroundColorAttributeName];
            NSString *textAnd = @" & ";
            NSAttributedString * subStringAnd = [[NSAttributedString alloc] initWithString:textAnd attributes:attributesAndText];
            [attributedString appendAttributedString:subStringAnd];
            
            UIColor * color = [UIColor colorFromHexString:arrBack9[@"color"]];
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
            NSString *textValue = [NSString stringWithFormat:@"%@ ",arrBack9[@"score"]];
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
            [attributedString appendAttributedString:subString];
            
        }
        
        _autopressView.autopressTitle.attributedText = attributedString;
        
        
    }
    [self checkIndexValue];
    
    if ([self.createdEventModel.formatId integerValue] == Format420Id)
    {
        if (dicData[@"current_standing"])
        {
            NSDictionary *dicCurrentStanding = [dicData[@"current_standing"] firstObject];
            
            //if (dicCurrentStanding[@"last"])
            if ([dicCurrentStanding count] > 0)
            {
                NSArray *arrLast = dicCurrentStanding[@"last"];
                if ([arrLast count] > 0)
                {
                    [self handleBottomColorView:YES];
                    [arrLast enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary *dicValues = obj;
                        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                        [style setAlignment:NSTextAlignmentCenter];
                        [style setLineBreakMode:NSLineBreakByWordWrapping];
                        
                        UIFont *font1 = [UIFont fontWithName:@"Lato-Regular" size:22.0f];
                        UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:10.0f];
                        NSDictionary *dict1 = @{
                                                NSFontAttributeName:font1};
                        NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                                NSFontAttributeName:font2};
                        switch (idx) {
                            case 0:
                            {
                                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
                                NSString *strValue = [NSString stringWithFormat:@"%@\n",dicValues[@"total"]];
                                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:strValue    attributes:dict1]];
                                
                                
                                //Mark:-for handling crash issue if array is empty
                                if (_commonModel.arrPlayersDetail  ==  nil) {
                                    
                                    
                                }else{
                                
                                NSLog(@"%@",_commonModel.arrPlayersDetail);
                                PT_NewScoreCardPlayerDataModel *model = _commonModel.arrPlayersDetail[0];
                                NSString *strName = [NSString stringWithFormat:@"%@ %@",model.shortName,model.handicap];
                                //NSString *strName = [NSString stringWithFormat:@"%@ ",model.playerName];
                                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:strName      attributes:dict2]];
                                [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
                                [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
                                [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                                [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
                                [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor whiteColor]];
                                
                                [[self speacialFormatLeftButton] setBackgroundColor:[UIColor colorFromHexString:model.color]];
                                }
                                
                            }
                                break;
                                
                            case 1:
                            {
                                //Centre
                                NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
                                NSString *strValue = [NSString stringWithFormat:@"%@\n",dicValues[@"total"]];
                                [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:strValue    attributes:dict1]];
                                PT_NewScoreCardPlayerDataModel *model = _commonModel.arrPlayersDetail[1];
                                NSString *strName = [NSString stringWithFormat:@"%@ %@",model.shortName,model.handicap];
                                //NSString *strName = [NSString stringWithFormat:@"%@ ",model.playerName];
                                [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:strName      attributes:dict2]];
                                [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
                                [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
                                [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                                [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
                                [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
                                
                                [[self speacialFormatCentreButton] setBackgroundColor:[UIColor colorFromHexString:model.color]];
                            }
                                break;
                            case 2:
                            {
                                //Right
                                NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
                                NSString *strValue = [NSString stringWithFormat:@"%@\n",dicValues[@"total"]];
                                [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:strValue    attributes:dict1]];
                                PT_NewScoreCardPlayerDataModel *model = _commonModel.arrPlayersDetail[2];
                                NSString *strName = [NSString stringWithFormat:@"%@ %@",model.shortName,model.handicap];
                                //NSString *strName = [NSString stringWithFormat:@"%@ ",model.playerName];
                                [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:strName      attributes:dict2]];
                                [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
                                [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
                                [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                                [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
                                [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor whiteColor]];
                                [[self speacialFormatRightButton] setBackgroundColor:[UIColor colorFromHexString:model.color]];
                            }
                                break;
                        }
                    }];
                }
                else
                {
                    self.bottomColorView.hidden = YES;
                }
            }
            else{
                //Hide Box
                self.bottomColorView.hidden = YES;
            }
        }
        else
        {
            
        }
        
    }
    
    if ([dicData[@"is_team"] integerValue] == 1)
    {
        
        if ([dicData[@"current_standing"] count] > 0)
        {
            [self handleBottomColorView:YES];
            NSDictionary *dicCurrentStandings = [dicData[@"current_standing"] firstObject];
            strHoleNumber = [NSString stringWithFormat:@"%@",dicCurrentStandings[@"hole_number"]];
            //UIColor *centreColor = [UIColor colorFromHexString:dicCurrentStandings[@"color"]];
            UIColor *centreColor;
            float y = self.speacialFormatDirectionImage.frame.origin.y;
            float width = self.speacialFormatDirectionImage.frame.size.width;
            float height = self.speacialFormatDirectionImage.frame.size.height;
            //NSString *scoreValue = [NSString stringWithFormat:@"%@",dicCurrentStandings[@"score_value"]];
            
            if ([dicCurrentStandings[@"winner"] integerValue] == teamAId)
            {
                
                centreColor = SplFormatRedTeamColor;
                //Left
                float x = self.speacialFormatCentreButton.frame.origin.x - width;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
                    self.speacialFormatDirectionImage.image = [UIImage imageNamed:LeftRedArrowImage];
                });
                
            }
            else if ([dicCurrentStandings[@"winner"] integerValue] == teamBId)
            {
                centreColor = SplFormatBlueColor;
                
                //Right
                float x = self.speacialFormatCentreButton.frame.origin.x + self.speacialFormatCentreButton.frame.size.width;
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
                    self.speacialFormatDirectionImage.image = [UIImage imageNamed:RightBlueArrowImage];
                });
            }
            else
                //if ([scoreValue isEqualToString:@"HALVED"])
            {
                //Hide arrow image
                self.speacialFormatDirectionImage.hidden = YES;
                centreColor = [UIColor colorFromHexString:dicCurrentStandings[@"color"]];
            }
            [[self speacialFormatCentreButton] setBackgroundColor:centreColor];
            
            //NSArray *arrTeam = dicData[@"team_data"];
            
            //if ([arrTeam count] > 1)
            {
                
                PT_NewScoreCardPlayerDataModel *modelPLayer1 = _commonModel.arrPlayersDetail[0];
                PT_NewScoreCardPlayerDataModel *modelPlayer2 = _commonModel.arrPlayersDetail[1];
                
                
                NSString *strTeamAMembers = [NSString stringWithFormat:@"%@ %@ \n %@ %@",modelPLayer1.playerName,modelPLayer1.handicap,modelPlayer2.playerName,modelPlayer2.handicap];
                
                
                PT_NewScoreCardPlayerDataModel *modelPlayer3 = _commonModel.arrPlayersDetail[2];
                PT_NewScoreCardPlayerDataModel *modelPlayer4 = _commonModel.arrPlayersDetail[3];
                NSString *strTeamBMembers = [NSString stringWithFormat:@"%@ %@ \n %@ %@",modelPlayer3.playerName,modelPlayer3.handicap,modelPlayer4.playerName,modelPlayer4.handicap];
                
                
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                [style setAlignment:NSTextAlignmentCenter];
                [style setLineBreakMode:NSLineBreakByWordWrapping];
                
                UIFont *font1 = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
                UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:7.0f];
                NSDictionary *dict1 = @{
                                        NSFontAttributeName:font1};
                NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                        NSFontAttributeName:font2};
                
                //Left
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
                
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM A\n"    attributes:dict1]];
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:strTeamAMembers      attributes:dict2]];
                
                NSRange selectedRange = NSMakeRange(0, 6); // 4 characters, starting at index 0
                
                [attString beginEditing];
                
                [attString addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor colorFromHexString:modelPLayer1.color]
                                  range:selectedRange];
                
                [attString endEditing];
                
                [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
                [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
                [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
                //[[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor blackColor]];
                
                
                
                //Right
                NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
                if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                {
                    [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nDINESH 16\n"    attributes:dict1]];
                }
                else
                {
                    [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM B\n"    attributes:dict1]];
                    [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:strTeamBMembers      attributes:dict2]];
                    
                    [attStringRight beginEditing];
                    
                    [attStringRight addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorFromHexString:modelPlayer3.color]
                                      range:selectedRange];
                    
                    [attStringRight endEditing];
                }
                [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
                [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
                [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
                //[[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor blackColor]];
            }
            
            /////////////////////Edit the Values Based on API- Currently unavailable
            UIFont *fontC1 = [UIFont fontWithName:@"Lato-Bold" size:18.0f];
            UIFont *fontC2 = [UIFont fontWithName:@"Lato-Regular"  size:8.0f];
            NSDictionary *dictC1 = @{
                                     NSFontAttributeName:fontC1};
            NSDictionary *dictC2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                     NSFontAttributeName:fontC2};
            //Centre
            NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
            NSString *centreTitle = [NSString stringWithFormat:@"%@ \n",dicCurrentStandings[@"score_value"]];
            [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:centreTitle    attributes:dictC1]];
            NSString *strThru = [NSString stringWithFormat:@"THRU %@",strHoleNumber];
            [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:strThru      attributes:dictC2]];
            [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
            [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
            [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
            [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
            [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
        }
        else
        {
            //Hide View
            self.bottomColorView.hidden = YES;
            
        }
    }
    
    //[self.tableFront9 reloadData];
    //[self.tableBack9 reloadData];
    if ([self.createdEventModel.numberOfPlayers integerValue] == 4)
    {
        if ([self.createdEventModel.formatId integerValue]== FormatAutoPressId)
        {
            self.constraintTableHeight.constant = RowHeightConst * 7;
            self.constraintTableBack9Height.constant = RowHeightConst * 7;
            if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
            {
                self.constraintYBack9View.constant = self.constraintYBack9View.constant - 40;
            }else{
            self.constraintYBack9View.constant = 7;
            }
        }
        else
        {
            self.constraintTableHeight.constant = RowHeightConst * 8;
            self.constraintTableBack9Height.constant = RowHeightConst * 8;
            if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
            {
                self.constraintYBack9View.constant = self.constraintYBack9View.constant - 40;
            }
            else
            {
                self.constraintYBack9View.constant = 5;
            }
            
        }
    }
    else if ([self.createdEventModel.formatId integerValue]== Format420Id)
    {
        self.constraintTableHeight.constant = RowHeightConst * 6;
        self.constraintTableBack9Height.constant = RowHeightConst * 6;
    }
    else if ([self.createdEventModel.numberOfPlayers integerValue] == 2 && [self.createdEventModel.formatId integerValue] == FormatAutoPressId)
    {
        self.constraintTableHeight.constant = RowHeightConst * 5;
        self.constraintTableBack9Height.constant = RowHeightConst * 5;
        //self.constraintYBack9View.constant = 5;
    }
    else if ([self.createdEventModel.numberOfPlayers integerValue] == 2 && [self.createdEventModel.formatId integerValue] == FormatMatchPlayId)
    {
        self.constraintTableHeight.constant = RowHeightConst * 6;
        self.constraintTableBack9Height.constant = RowHeightConst * 6;
        //self.constraintYBack9View.constant = 5;
    }
}


- (void)setStandingsValue:(NSArray *)arrStandings withModel:(PT_StandingsModel *)model startFromHole:(NSInteger)startHoleNumber
{
    // [arrStandings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    NSInteger countingLimit = 0;
    if (startHoleNumber == 0)
    {
        countingLimit = 9;
    }
    else
    {
        countingLimit = 18;
    }
    NSInteger counter = 0;
    for (NSInteger idx = startHoleNumber; idx < countingLimit; idx++)
    {
        NSDictionary *dicData = arrStandings[counter];
        counter++;
        switch (idx) {
            case 0:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    NSString *strValue = [NSString stringWithFormat:@"%@",[[dicData[@"score_value"] firstObject] objectForKey:@"score"]];
                    model.hole_num_1 = [NSString stringWithFormat:@"%@",[[dicData[@"score_value"] firstObject] objectForKey:@"score"]];
                }
                else
                {
                    model.hole_num_1 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_1 = dicData[@"color"];
                }
                if ([model.hole_num_1 length] == 0)
                {
                    model.hole_num_1 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_1 = @"#000000";
                }
                
            }
                break;
                
            case 1:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_2 = [NSString stringWithFormat:@"%@",[[dicData[@"score_value"] firstObject] objectForKey:@"score"]];
                }
                else
                {
                    model.hole_num_2 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_2 = dicData[@"color"];
                }
                if ([model.hole_num_2 length] == 0)
                {
                    model.hole_num_2 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_2 = @"#000000";
                }
            }
                break;
            case 2:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_3 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_3 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_3 = dicData[@"color"];
                }
                if ([model.hole_num_3 length] == 0)
                {
                    model.hole_num_3 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_3 = @"#000000";
                }
            }
                break;
            case 3:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_4 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_4 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_4 = dicData[@"color"];
                }
                if ([model.hole_num_4 length] == 0)
                {
                    model.hole_num_4 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_4 = @"#000000";
                }
            }
                break;
            case 4:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_5 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_5 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_5 = dicData[@"color"];
                }
                if ([model.hole_num_5 length] == 0)
                {
                    model.hole_num_5 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_5 = @"#000000";
                }
            }
                break;
            case 5:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_6 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_6 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_6 = dicData[@"color"];
                }
                if ([model.hole_num_6 length] == 0)
                {
                    model.hole_num_6 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_6 = @"#000000";
                }
            }
                break;
            case 6:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_7 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_7 =[NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_7 = dicData[@"color"];
                }
                if ([model.hole_num_7 length] == 0)
                {
                    model.hole_num_7 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_7 = @"#000000";
                }
            }
                break;
            case 7:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_8 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_8 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_8 = dicData[@"color"];
                }
                if ([model.hole_num_8 length] == 0)
                {
                    model.hole_num_8 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_8 = @"#000000";
                }
            }
                break;
            case 8:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_9 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_9 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_9 = dicData[@"color"];
                }
                if ([model.hole_num_9 length] == 0)
                {
                    model.hole_num_9 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_9 = @"#000000";
                }
            }
                break;
            case 9:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_10 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_10 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_10 = dicData[@"color"];
                }
                if ([model.hole_num_10 length] == 0)
                {
                    model.hole_num_10 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_10 = @"#000000";
                }
            }
                break;
            case 10:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_11 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_11 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_11 = dicData[@"color"];
                }
                if ([model.hole_num_11 length] == 0)
                {
                    model.hole_num_11 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_11 = @"#000000";
                }
            }
                break;
            case 11:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_12 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_12 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_12 = dicData[@"color"];
                }
                if ([model.hole_num_12 length] == 0)
                {
                    model.hole_num_12 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_12 = @"#000000";
                }
            }
                break;
            case 12:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_13 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_13 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_13 = dicData[@"color"];
                }
                if ([model.hole_num_13 length] == 0)
                {
                    model.hole_num_13 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_13 = @"#000000";
                }
            }
                break;
            case 13:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_14 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_14 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_14 = dicData[@"color"];
                }
                if ([model.hole_num_14 length] == 0)
                {
                    model.hole_num_14 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_14 = @"#000000";
                }
            }
                break;
            case 14:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_15 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_15 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_15 = dicData[@"color"];
                }
                if ([model.hole_num_15 length] == 0)
                {
                    model.hole_num_15 = @"-";
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_15 = @"#000000";
                }
            }
                break;
            case 15:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_16 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_16 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_16 = dicData[@"color"];
                }
                if ([model.hole_num_16 length] == 0)
                {
                    model.hole_num_16 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_16 = @"#000000";
                }
            }
                break;
            case 16:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_17 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_17 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_17 = dicData[@"color"];
                }
                if ([model.hole_num_17 length] == 0)
                {
                    model.hole_num_17 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_17 = @"#000000";
                }
            }
                break;
            case 17:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_18 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_18 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_18 = dicData[@"color"];
                }
                if ([model.hole_num_18 length] == 0)
                {
                    model.hole_num_18 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_18 = @"#000000";
                }
            }
                break;
        }
        
        /*if (idx == [arrStandings count] - 1)
         {
         dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableFront9 reloadData];
         [self.tableBack9 reloadData];
         
         });
         
         }*/
    }
    //];
}

- (void)setStandingsValueforBack9:(NSArray *)arrStandings withModel:(PT_StandingsModel *)model
{
    // [arrStandings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    NSInteger countingLimit = 0;
    
        countingLimit = 9;
    
    NSInteger counter = 0;
    for (NSInteger idx = 0; idx < countingLimit; idx++)
    {
        NSDictionary *dicData = arrStandings[counter];
        counter++;
        switch (idx) {
            case 0:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    NSString *strValue = [NSString stringWithFormat:@"%@",[[dicData[@"score_value"] firstObject] objectForKey:@"score"]];
                    model.hole_num_10 = [NSString stringWithFormat:@"%@",[[dicData[@"score_value"] firstObject] objectForKey:@"score"]];
                }
                else
                {
                    model.hole_num_10 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_10 = dicData[@"color"];
                }
                if ([model.hole_num_10 length] == 0)
                {
                    model.hole_num_10 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_10 = @"#000000";
                }
                
            }
                break;
                
            case 1:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_11 = [NSString stringWithFormat:@"%@",[[dicData[@"score_value"] firstObject] objectForKey:@"score"]];
                }
                else
                {
                    model.hole_num_11 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_11 = dicData[@"color"];
                }
                if ([model.hole_num_11 length] == 0)
                {
                    model.hole_num_11 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_11 = @"#000000";
                }
            }
                break;
            case 2:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_12 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_12 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_12 = dicData[@"color"];
                }
                if ([model.hole_num_12 length] == 0)
                {
                    model.hole_num_12 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_12 = @"#000000";
                }
            }
                break;
            case 3:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_13 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_13 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_13 = dicData[@"color"];
                }
                if ([model.hole_num_13 length] == 0)
                {
                    model.hole_num_13 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_13 = @"#000000";
                }
            }
                break;
            case 4:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_14 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_14 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_14 = dicData[@"color"];
                }
                if ([model.hole_num_14 length] == 0)
                {
                    model.hole_num_14 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_14 = @"#000000";
                }
            }
                break;
            case 5:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_15 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_15 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_15 = dicData[@"color"];
                }
                if ([model.hole_num_15 length] == 0)
                {
                    model.hole_num_15 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_15 = @"#000000";
                }
            }
                break;
            case 6:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_16 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_16 =[NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_16 = dicData[@"color"];
                }
                if ([model.hole_num_16 length] == 0)
                {
                    model.hole_num_16 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_16 = @"#000000";
                }
            }
                break;
            case 7:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_17 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_17 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_17 = dicData[@"color"];
                }
                if ([model.hole_num_17 length] == 0)
                {
                    model.hole_num_17 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_17 = @"#000000";
                }
            }
                break;
            case 8:
            {
                if ([dicData[@"score_value"] isKindOfClass:[NSArray class]])
                {
                    model.hole_num_18 = [[dicData[@"score_value"] firstObject] objectForKey:@"score"];
                }
                else
                {
                    model.hole_num_18 = [NSString stringWithFormat:@"%@",dicData[@"score_value"]];
                    model.color_hole_num_18 = dicData[@"color"];
                }
                if ([model.hole_num_18 length] == 0)
                {
                    model.hole_num_18 = @"-";
                    
                }
                if ([dicData[@"color"] length] == 0)
                {
                    model.color_hole_num_18 = @"#000000";
                }
            }
                break;
            
        }
        
        /*if (idx == [arrStandings count] - 1)
         {
         dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableFront9 reloadData];
         [self.tableBack9 reloadData];
         
         });
         
         }*/
    }
    //];
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnNmOfRows = 0;
    if ([_commonModel.arrPlayersDetail count]>0)
    {
        if (self.createdEventModel.isSingleScreen == NO)
        {
            returnNmOfRows = 3 + [_commonModel.arrPlayersDetail count];
        }
        else if ([self.createdEventModel.formatId integerValue] == Format420Id)
        {
            returnNmOfRows = 3 + [_commonModel.arrPlayersDetail count];
        }
        else
        {
            returnNmOfRows = 3 + [_commonModel.arrPlayersDetail count] + 1;
        }
        
    }
    if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId)
    {
        if (self.createdEventModel.isSingleScreen == NO)
        {
            returnNmOfRows = 3 + [_commonModel.arrPlayersDetail count];
        }
        else
        {
            if ([self.createdEventModel.numberOfPlayers integerValue] == 4)
            {
                returnNmOfRows = 3 + [_commonModel.arrPlayersDetail count];
            }
            else
            {
                return 5;
            }
            
        }
    }
    
    return returnNmOfRows;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeightConst;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableFront9)
    {
        static NSString *identifier = @"Identifier";
        
        //PT_ScoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        PT_NewScoreCardFront9TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_NewScoreCardFront9TableViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setDefaultBodering];
        
        if (indexPath.row == 0)
        {
            cell.ct1.text = @"1";
            cell.ct2.text = @"2";
            cell.ct3.text = @"3";
            cell.ct4.text = @"4";
            cell.ct5.text = @"5";
            cell.ct6.text = @"6";
            cell.ct7.text = @"7";
            cell.ct8.text = @"8";
            cell.ct9.text = @"9";
            
            cell.cellTitle.text = @"HOLE";
            cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            //cell.cellValue.text = [NSString stringWithFormat:@"F9"];
            cell.cellValue.text = [NSString stringWithFormat:@"IN"];
            //cell.cellValue.textAlignment = NSTextAlignmentCenter;
            
            cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
            //cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
            cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
            
            cell.l2.backgroundColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0];
            cell.cellValue.textColor = [UIColor whiteColor];
            
            switch (_holeStartNumber) {
                case 1:
                {
                    cell.c1.backgroundColor = [UIColor blackColor];
                    cell.ct1.textColor = [UIColor whiteColor];
                }
                    break;
                    
                case 2:
                {
                    cell.c2.backgroundColor = [UIColor blackColor];
                    cell.ct2.textColor = [UIColor whiteColor];
                }
                    break;
                case 3:
                {
                    cell.c3.backgroundColor = [UIColor blackColor];
                    cell.ct3.textColor = [UIColor whiteColor];
                }
                    break;
                case 4:
                {
                    cell.c4.backgroundColor = [UIColor blackColor];
                    cell.ct4.textColor = [UIColor whiteColor];
                }
                    break;
                case 5:
                {
                    cell.c5.backgroundColor = [UIColor blackColor];
                    cell.ct5.textColor = [UIColor whiteColor];
                }
                    break;
                case 6:
                {
                    cell.c6.backgroundColor = [UIColor blackColor];
                    cell.ct6.textColor = [UIColor whiteColor];
                }
                    break;
                case 7:
                {
                    cell.c7.backgroundColor = [UIColor blackColor];
                    cell.ct7.textColor = [UIColor whiteColor];
                }
                    break;
                case 8:
                {
                    cell.c8.backgroundColor = [UIColor blackColor];
                    cell.ct8.textColor = [UIColor whiteColor];
                }
                    break;
                case 9:
                {
                    cell.c9.backgroundColor = [UIColor blackColor];
                    cell.ct9.textColor = [UIColor whiteColor];
                }
                    break;
            }
        }
        
        
        if (indexPath.row == 1)
        {
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
            
            
        }
        
        if (indexPath.row == 2)
        {
            
            cell.ct1.text = _commonModel.par1Value;
            cell.ct2.text = _commonModel.par2Value;
            cell.ct3.text = _commonModel.par3Value;
            cell.ct4.text = _commonModel.par4Value;
            cell.ct5.text = _commonModel.par5Value;
            cell.ct6.text = _commonModel.par6Value;
            cell.ct7.text = _commonModel.par7Value;
            cell.ct8.text = _commonModel.par8Value;
            cell.ct9.text = _commonModel.par9Value;
            
            cell.cellTitle.text = @"PAR";
            cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
            
            NSInteger totalInteger = [_commonModel.par1Value integerValue] +
            [_commonModel.par2Value integerValue] +
            [_commonModel.par3Value integerValue] +
            [_commonModel.par4Value integerValue] +
            [_commonModel.par5Value integerValue] +
            [_commonModel.par6Value integerValue] +
            [_commonModel.par7Value integerValue] +
            [_commonModel.par8Value integerValue] +
            [_commonModel.par9Value integerValue];
            cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
        }
        
        else
        {
            
            switch (indexPath.row) {
                case 3:
                {
                    PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[0];
                    [self checkHoleNumberVAlueForMode:modelPlayer];
                    NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                    
                    
                    
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    
                    cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
        
                    if (modelPlayer.color.length>0)
                    {
                        [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                    }
                    if ([modelPlayer.hole_color_1 length] > 0)
                    {
                        cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_1];
                        cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_2];
                        cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_3];
                        cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_4];
                        cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_5];
                        cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_6];
                        cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_7];
                        cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_8];
                        cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_9];
                    }
                    
                    cell.ct1.text = modelPlayer.hole_num_1;
                    cell.ct2.text = modelPlayer.hole_num_2;
                    cell.ct3.text = modelPlayer.hole_num_3;
                    cell.ct4.text = modelPlayer.hole_num_4;
                    cell.ct5.text = modelPlayer.hole_num_5;
                    cell.ct6.text = modelPlayer.hole_num_6;
                    cell.ct7.text = modelPlayer.hole_num_7;
                    cell.ct8.text = modelPlayer.hole_num_8;
                    cell.ct9.text = modelPlayer.hole_num_9;
                    
                    cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                    cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    
                    if ([modelPlayer.hole_color_1 isEqualToString:@"#ffffff"])
                    {
                        cell.ct1.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct1.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_2 isEqualToString:@"#ffffff"])
                    {
                        cell.ct2.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct2.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_3 isEqualToString:@"#ffffff"])
                    {
                        cell.ct3.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct3.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_4 isEqualToString:@"#ffffff"])
                    {
                        cell.ct4.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct4.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_5 isEqualToString:@"#ffffff"])
                    {
                        cell.ct5.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct5.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_6 isEqualToString:@"#ffffff"])
                    {
                        cell.ct6.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct6.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_7 isEqualToString:@"#ffffff"])
                    {
                        cell.ct7.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct7.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_8 isEqualToString:@"#ffffff"])
                    {
                        cell.ct8.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct8.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_9 isEqualToString:@"#ffffff"])
                    {
                        cell.ct9.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct9.textColor = [UIColor whiteColor];
                    }
                    
                    NSInteger totalInteger = [modelPlayer.hole_num_1 integerValue] +
                    [modelPlayer.hole_num_2 integerValue] +
                    [modelPlayer.hole_num_3 integerValue] +
                    [modelPlayer.hole_num_4 integerValue] +
                    [modelPlayer.hole_num_5 integerValue] +
                    [modelPlayer.hole_num_6 integerValue] +
                    [modelPlayer.hole_num_7 integerValue] +
                    [modelPlayer.hole_num_8 integerValue] +
                    [modelPlayer.hole_num_9 integerValue];
                    cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                    
                }
                    break;
                    
                case 4:
                {
                    PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[1];
                    [self checkHoleNumberVAlueForMode:modelPlayer];
                    NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                    //NSString *title = [NSString stringWithFormat:@"%@(%@)",modelPlayer.shortName,modelPlayer.handicap];
                    //cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                    //cell.l1.backgroundColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0];
                    //cell.l1.backgroundColor = SplFormatBlueColor;
                    
                    cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                    //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                    if (modelPlayer.color.length>0)
                    {
                        [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                    }
                    if ([self.createdEventModel.numberOfPlayers integerValue] == 2 || [self.createdEventModel.numberOfPlayers integerValue] == 3)
                    {
                        title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                    }
                    
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    if ([modelPlayer.hole_color_1 length] > 0)
                    {
                        cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_1];
                        cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_2];
                        cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_3];
                        cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_4];
                        cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_5];
                        cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_6];
                        cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_7];
                        cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_8];
                        cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_9];
                    }
                    
                    cell.ct1.text = modelPlayer.hole_num_1;
                    cell.ct2.text = modelPlayer.hole_num_2;
                    cell.ct3.text = modelPlayer.hole_num_3;
                    cell.ct4.text = modelPlayer.hole_num_4;
                    cell.ct5.text = modelPlayer.hole_num_5;
                    cell.ct6.text = modelPlayer.hole_num_6;
                    cell.ct7.text = modelPlayer.hole_num_7;
                    cell.ct8.text = modelPlayer.hole_num_8;
                    cell.ct9.text = modelPlayer.hole_num_9;
                    
                    cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                    cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    
                    if ([modelPlayer.hole_color_1 isEqualToString:@"#ffffff"])
                    {
                        cell.ct1.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct1.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_2 isEqualToString:@"#ffffff"])
                    {
                        cell.ct2.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct2.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_3 isEqualToString:@"#ffffff"])
                    {
                        cell.ct3.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct3.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_4 isEqualToString:@"#ffffff"])
                    {
                        cell.ct4.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct4.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_5 isEqualToString:@"#ffffff"])
                    {
                        cell.ct5.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct5.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_6 isEqualToString:@"#ffffff"])
                    {
                        cell.ct6.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct6.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_7 isEqualToString:@"#ffffff"])
                    {
                        cell.ct7.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct7.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_8 isEqualToString:@"#ffffff"])
                    {
                        cell.ct8.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct8.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_9 isEqualToString:@"#ffffff"])
                    {
                        cell.ct9.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct9.textColor = [UIColor whiteColor];
                    }
                    
                    if ([self.createdEventModel.isIndividual isEqualToString:TEAM])
                    {
                        //cell.l1.backgroundColor = SplFormatRedTeamColor;
                    }
                    else if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                    {
                        //cell.l1.backgroundColor = SplFormatRedTeamColor;
                    }
                    
                    NSInteger totalInteger = [modelPlayer.hole_num_1 integerValue] +
                    [modelPlayer.hole_num_2 integerValue] +
                    [modelPlayer.hole_num_3 integerValue] +
                    [modelPlayer.hole_num_4 integerValue] +
                    [modelPlayer.hole_num_5 integerValue] +
                    [modelPlayer.hole_num_6 integerValue] +
                    [modelPlayer.hole_num_7 integerValue] +
                    [modelPlayer.hole_num_8 integerValue] +
                    [modelPlayer.hole_num_9 integerValue];
                    cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                }
                    break;
                case 5:
                {
                    if ([self.createdEventModel.formatId integerValue] == Format420Id)
                    {
                        PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[2];
                        [self checkHoleNumberVAlueForMode:modelPlayer];
                        NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                        //NSString *title = [NSString stringWithFormat:@"%@(%@)",modelPlayer.shortName,modelPlayer.handicap];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        //cell.l1.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(153/255.0f) blue:(77/255.0f) alpha:1.0f];
                        //cell.l1.backgroundColor = SplFormatGreenColor;
                        
                        cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                        //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                        if (modelPlayer.color.length>0)
                        {
                            [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                        }
                        
                        if ([modelPlayer.hole_color_1 length] > 0)
                        {
                            cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_1];
                            cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_2];
                            cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_3];
                            cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_4];
                            cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_5];
                            cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_6];
                            cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_7];
                            cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_8];
                            cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_9];
                        }
                        
                        cell.ct1.text = modelPlayer.hole_num_1;
                        cell.ct2.text = modelPlayer.hole_num_2;
                        cell.ct3.text = modelPlayer.hole_num_3;
                        cell.ct4.text = modelPlayer.hole_num_4;
                        cell.ct5.text = modelPlayer.hole_num_5;
                        cell.ct6.text = modelPlayer.hole_num_6;
                        cell.ct7.text = modelPlayer.hole_num_7;
                        cell.ct8.text = modelPlayer.hole_num_8;
                        cell.ct9.text = modelPlayer.hole_num_9;
                        
                        cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        
                        if ([modelPlayer.hole_color_1 isEqualToString:@"#ffffff"])
                        {
                            cell.ct1.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct1.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_2 isEqualToString:@"#ffffff"])
                        {
                            cell.ct2.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct2.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_3 isEqualToString:@"#ffffff"])
                        {
                            cell.ct3.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct3.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_4 isEqualToString:@"#ffffff"])
                        {
                            cell.ct4.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct4.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_5 isEqualToString:@"#ffffff"])
                        {
                            cell.ct5.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct5.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_6 isEqualToString:@"#ffffff"])
                        {
                            cell.ct6.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct6.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_7 isEqualToString:@"#ffffff"])
                        {
                            cell.ct7.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct7.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_8 isEqualToString:@"#ffffff"])
                        {
                            cell.ct8.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct8.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_9 isEqualToString:@"#ffffff"])
                        {
                            cell.ct9.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct9.textColor = [UIColor whiteColor];
                        }
                        
                        NSInteger totalInteger = [modelPlayer.hole_num_1 integerValue] +
                        [modelPlayer.hole_num_2 integerValue] +
                        [modelPlayer.hole_num_3 integerValue] +
                        [modelPlayer.hole_num_4 integerValue] +
                        [modelPlayer.hole_num_5 integerValue] +
                        [modelPlayer.hole_num_6 integerValue] +
                        [modelPlayer.hole_num_7 integerValue] +
                        [modelPlayer.hole_num_8 integerValue] +
                        [modelPlayer.hole_num_9 integerValue];
                        cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                    }
                    else if ([self.createdEventModel.numberOfPlayers integerValue] == 4)
                    {
                        PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[2];
                        [self checkHoleNumberVAlueForMode:modelPlayer];
                        NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                        //NSString *title = [NSString stringWithFormat:@"%@(%@)",modelPlayer.shortName,modelPlayer.handicap];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        //cell.l1.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(153/255.0f) blue:(77/255.0f) alpha:1.0f];
                        //cell.l1.backgroundColor = SplFormatGreenColor;
                        
                        cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                        //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                        if (modelPlayer.color.length>0)
                        {
                            [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                        }
                        
                        if ([modelPlayer.hole_color_1 length] > 0)
                        {
                            cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_1];
                            cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_2];
                            cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_3];
                            cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_4];
                            cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_5];
                            cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_6];
                            cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_7];
                            cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_8];
                            cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_9];
                        }
                        
                        cell.ct1.text = modelPlayer.hole_num_1;
                        cell.ct2.text = modelPlayer.hole_num_2;
                        cell.ct3.text = modelPlayer.hole_num_3;
                        cell.ct4.text = modelPlayer.hole_num_4;
                        cell.ct5.text = modelPlayer.hole_num_5;
                        cell.ct6.text = modelPlayer.hole_num_6;
                        cell.ct7.text = modelPlayer.hole_num_7;
                        cell.ct8.text = modelPlayer.hole_num_8;
                        cell.ct9.text = modelPlayer.hole_num_9;
                        
                        cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        
                        if ([modelPlayer.hole_color_1 isEqualToString:@"#ffffff"])
                        {
                            cell.ct1.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct1.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_2 isEqualToString:@"#ffffff"])
                        {
                            cell.ct2.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct2.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_3 isEqualToString:@"#ffffff"])
                        {
                            cell.ct3.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct3.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_4 isEqualToString:@"#ffffff"])
                        {
                            cell.ct4.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct4.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_5 isEqualToString:@"#ffffff"])
                        {
                            cell.ct5.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct5.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_6 isEqualToString:@"#ffffff"])
                        {
                            cell.ct6.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct6.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_7 isEqualToString:@"#ffffff"])
                        {
                            cell.ct7.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct7.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_8 isEqualToString:@"#ffffff"])
                        {
                            cell.ct8.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct8.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_9 isEqualToString:@"#ffffff"])
                        {
                            cell.ct9.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct9.textColor = [UIColor whiteColor];
                        }
                        
                        NSInteger totalInteger = [modelPlayer.hole_num_1 integerValue] +
                        [modelPlayer.hole_num_2 integerValue] +
                        [modelPlayer.hole_num_3 integerValue] +
                        [modelPlayer.hole_num_4 integerValue] +
                        [modelPlayer.hole_num_5 integerValue] +
                        [modelPlayer.hole_num_6 integerValue] +
                        [modelPlayer.hole_num_7 integerValue] +
                        [modelPlayer.hole_num_8 integerValue] +
                        [modelPlayer.hole_num_9 integerValue];
                        cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                    }
                    else
                    {
                    
                        NSString *title = @"STANDING";
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [cell.cellTitle setTextColor:[UIColor blackColor]];
                        
                        cell.ct1.text = _standingModel.hole_num_1;
                        cell.ct2.text = _standingModel.hole_num_2;
                        cell.ct3.text = _standingModel.hole_num_3;
                        cell.ct4.text = _standingModel.hole_num_4;
                        cell.ct5.text = _standingModel.hole_num_5;
                        cell.ct6.text = _standingModel.hole_num_6;
                        cell.ct7.text = _standingModel.hole_num_7;
                        cell.ct8.text = _standingModel.hole_num_8;
                        cell.ct9.text = _standingModel.hole_num_9;
                        
                        cell.ct1.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_1];
                        cell.ct2.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_2];
                        cell.ct3.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_3];
                        cell.ct4.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_4];
                        cell.ct5.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_5];
                        cell.ct6.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_6];
                        cell.ct7.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_7];
                        cell.ct8.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_8];
                        cell.ct9.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_9];
                        
                        cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        
                        cell.cellValue.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                        
                        
                        
                        NSInteger totalInteger = [_standingModel.hole_num_1 integerValue] +
                        [_standingModel.hole_num_2 integerValue] +
                        [_standingModel.hole_num_3 integerValue] +
                        [_standingModel.hole_num_4 integerValue] +
                        [_standingModel.hole_num_5 integerValue] +
                        [_standingModel.hole_num_6 integerValue] +
                        [_standingModel.hole_num_7 integerValue] +
                        [_standingModel.hole_num_8 integerValue] +
                        [_standingModel.hole_num_9 integerValue];
                        cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                    }
                    
                }
                    break;
                case 6:
                {
                    PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[3];
                    [self checkHoleNumberVAlueForMode:modelPlayer];
                    NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                    //NSString *title = [NSString stringWithFormat:@"%@(%@)",modelPlayer.shortName,modelPlayer.handicap];
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    //cell.l1.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(153/255.0f) blue:(77/255.0f) alpha:1.0f];
                    //cell.l1.backgroundColor = SplFormatGreenColor;
                    
                    cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                    //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                    if (modelPlayer.color.length>0)
                    {
                        [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                    }
                    
                    if ([modelPlayer.hole_color_1 length] > 0)
                    {
                        cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_1];
                        cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_2];
                        cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_3];
                        cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_4];
                        cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_5];
                        cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_6];
                        cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_7];
                        cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_8];
                        cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_9];
                    }
                    
                    cell.ct1.text = modelPlayer.hole_num_1;
                    cell.ct2.text = modelPlayer.hole_num_2;
                    cell.ct3.text = modelPlayer.hole_num_3;
                    cell.ct4.text = modelPlayer.hole_num_4;
                    cell.ct5.text = modelPlayer.hole_num_5;
                    cell.ct6.text = modelPlayer.hole_num_6;
                    cell.ct7.text = modelPlayer.hole_num_7;
                    cell.ct8.text = modelPlayer.hole_num_8;
                    cell.ct9.text = modelPlayer.hole_num_9;
                    
                    cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                    cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                    
                    if ([modelPlayer.hole_color_1 isEqualToString:@"#ffffff"])
                    {
                        cell.ct1.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct1.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_2 isEqualToString:@"#ffffff"])
                    {
                        cell.ct2.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct2.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_3 isEqualToString:@"#ffffff"])
                    {
                        cell.ct3.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct3.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_4 isEqualToString:@"#ffffff"])
                    {
                        cell.ct4.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct4.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_5 isEqualToString:@"#ffffff"])
                    {
                        cell.ct5.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct5.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_6 isEqualToString:@"#ffffff"])
                    {
                        cell.ct6.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct6.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_7 isEqualToString:@"#ffffff"])
                    {
                        cell.ct7.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct7.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_8 isEqualToString:@"#ffffff"])
                    {
                        cell.ct8.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct8.textColor = [UIColor whiteColor];
                    }
                    if ([modelPlayer.hole_color_9 isEqualToString:@"#ffffff"])
                    {
                        cell.ct9.textColor = [UIColor blackColor];
                    }
                    else
                    {
                        cell.ct9.textColor = [UIColor whiteColor];
                    }
                    
                    NSInteger totalInteger = [modelPlayer.hole_num_1 integerValue] +
                    [modelPlayer.hole_num_2 integerValue] +
                    [modelPlayer.hole_num_3 integerValue] +
                    [modelPlayer.hole_num_4 integerValue] +
                    [modelPlayer.hole_num_5 integerValue] +
                    [modelPlayer.hole_num_6 integerValue] +
                    [modelPlayer.hole_num_7 integerValue] +
                    [modelPlayer.hole_num_8 integerValue] +
                    [modelPlayer.hole_num_9 integerValue];
                    cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                }
                    break;
                case 7:
                {
                    NSString *title = @"STANDING";
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                    cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    [cell.cellTitle setTextColor:[UIColor blackColor]];
                    
                    cell.ct1.text = _standingModel.hole_num_1;
                    cell.ct2.text = _standingModel.hole_num_2;
                    cell.ct3.text = _standingModel.hole_num_3;
                    cell.ct4.text = _standingModel.hole_num_4;
                    cell.ct5.text = _standingModel.hole_num_5;
                    cell.ct6.text = _standingModel.hole_num_6;
                    cell.ct7.text = _standingModel.hole_num_7;
                    cell.ct8.text = _standingModel.hole_num_8;
                    cell.ct9.text = _standingModel.hole_num_9;
                    
                    cell.ct1.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_1];
                    cell.ct2.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_2];
                    cell.ct3.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_3];
                    cell.ct4.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_4];
                    cell.ct5.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_5];
                    cell.ct6.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_6];
                    cell.ct7.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_7];
                    cell.ct8.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_8];
                    cell.ct9.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_9];
                    
                    cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                    cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                    
                    cell.cellValue.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                    
                    
                    
                    NSInteger totalInteger = [_standingModel.hole_num_1 integerValue] +
                    [_standingModel.hole_num_2 integerValue] +
                    [_standingModel.hole_num_3 integerValue] +
                    [_standingModel.hole_num_4 integerValue] +
                    [_standingModel.hole_num_5 integerValue] +
                    [_standingModel.hole_num_6 integerValue] +
                    [_standingModel.hole_num_7 integerValue] +
                    [_standingModel.hole_num_8 integerValue] +
                    [_standingModel.hole_num_9 integerValue];
                    cell.cellValue.text = [NSString stringWithFormat:@"%li",totalInteger];
                }
            }
            
            
        }
        
        
        return cell;
    }
    else
    {
        UITableViewCell *cellToReturn = nil;
        
        
        if (indexPath.row == 0)
        {
            static NSString *identifier = @"IdentifierSeparate1";
            
            PT_NewScoreCardFront9TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_NewScoreCardFront9TableViewCell" owner:self options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
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
            
            cell.cellTitle.text = @"HOLE";
            cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            //cell.cellValue.text = [NSString stringWithFormat:@"   B9         TTL"];
            cell.cellValue.text = [NSString stringWithFormat:@"  OUT   TOT"];
            cell.cellValue.textAlignment = NSTextAlignmentLeft;
            
            cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:13];
            //cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
            cell.cellValue.font = [UIFont fontWithName:@"Lato-Bold" size:9.5];
            
            cell.l2.backgroundColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0];
            cell.cellValue.textColor = [UIColor whiteColor];
            
            switch (_holeStartNumber) {
                case 10:
                {
                    cell.c1.backgroundColor = [UIColor blackColor];
                    cell.ct1.textColor = [UIColor whiteColor];
                }
                    break;
                    
                case 11:
                {
                    cell.c2.backgroundColor = [UIColor blackColor];
                    cell.ct2.textColor = [UIColor whiteColor];
                }
                    break;
                case 12:
                {
                    cell.c3.backgroundColor = [UIColor blackColor];
                    cell.ct3.textColor = [UIColor whiteColor];
                }
                    break;
                case 13:
                {
                    cell.c4.backgroundColor = [UIColor blackColor];
                    cell.ct4.textColor = [UIColor whiteColor];
                }
                    break;
                case 14:
                {
                    cell.c5.backgroundColor = [UIColor blackColor];
                    cell.ct5.textColor = [UIColor whiteColor];
                }
                    break;
                case 15:
                {
                    cell.c6.backgroundColor = [UIColor blackColor];
                    cell.ct6.textColor = [UIColor whiteColor];
                }
                    break;
                case 16:
                {
                    cell.c7.backgroundColor = [UIColor blackColor];
                    cell.ct7.textColor = [UIColor whiteColor];
                }
                    break;
                case 17:
                {
                    cell.c8.backgroundColor = [UIColor blackColor];
                    cell.ct8.textColor = [UIColor whiteColor];
                }
                    break;
                case 18:
                {
                    cell.c9.backgroundColor = [UIColor blackColor];
                    cell.ct9.textColor = [UIColor whiteColor];
                }
                    break;
            }
            
            cellToReturn = cell;
        }
        else
        {
            static NSString *identifier = @"IdentifierSeparate2";
            PT_NewScoreCardBack9TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_NewScoreCardBack9TableViewCell" owner:self options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setDefaultBodering];
            
            if (indexPath.row == 1)
            {
                
                cell.ct1.text = _commonModel.index10Value;
                cell.ct2.text = _commonModel.index11Value;
                cell.ct3.text = _commonModel.index12Value;
                cell.ct4.text = _commonModel.index13Value;
                cell.ct5.text = _commonModel.index14Value;
                cell.ct6.text = _commonModel.index15Value;
                cell.ct7.text = _commonModel.index16Value;
                cell.ct8.text = _commonModel.index17Value;
                cell.ct9.text = _commonModel.index18Value;
                
                NSInteger totalInteger = [_commonModel.index1Value integerValue] +
                [_commonModel.index11Value integerValue] +
                [_commonModel.index12Value integerValue] +
                [_commonModel.index13Value integerValue] +
                [_commonModel.index14Value integerValue] +
                [_commonModel.index15Value integerValue] +
                [_commonModel.index16Value integerValue] +
                [_commonModel.index17Value integerValue] +
                [_commonModel.index18Value integerValue];
                cell.cellTitle.text = @"INDEX";
                //cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                cell.ct21.text = @"";
                
                NSInteger totalInteger1to9 = [_commonModel.index1Value integerValue] +
                [_commonModel.index2Value integerValue] +
                [_commonModel.index3Value integerValue] +
                [_commonModel.index4Value integerValue] +
                [_commonModel.index5Value integerValue] +
                [_commonModel.index6Value integerValue] +
                [_commonModel.index7Value integerValue] +
                [_commonModel.index8Value integerValue] +
                [_commonModel.index9Value integerValue];
                
                NSInteger total = totalInteger + totalInteger1to9;
                
                //cell.ct22.text = [NSString stringWithFormat:@"%li",total];
                cell.ct22.text = @"";
                
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                
                cellToReturn = cell;
            }
            
            if (indexPath.row == 2)
            {
                
                cell.ct1.text = _commonModel.par10Value;
                cell.ct2.text = _commonModel.par11Value;
                cell.ct3.text = _commonModel.par12Value;
                cell.ct4.text = _commonModel.par13Value;
                cell.ct5.text = _commonModel.par14Value;
                cell.ct6.text = _commonModel.par15Value;
                cell.ct7.text = _commonModel.par16Value;
                cell.ct8.text = _commonModel.par17Value;
                cell.ct9.text = _commonModel.par18Value;
                
                cell.cellTitle.text = @"PAR";
                cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                
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
                cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                
                NSInteger totalInteger1to9 =
                [_commonModel.par1Value integerValue] +
                [_commonModel.par2Value integerValue] +
                [_commonModel.par3Value integerValue] +
                [_commonModel.par4Value integerValue] +
                [_commonModel.par5Value integerValue] +
                [_commonModel.par6Value integerValue] +
                [_commonModel.par7Value integerValue] +
                [_commonModel.par8Value integerValue] +
                [_commonModel.par9Value integerValue];
                cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1to9+totalInteger];
                
                cellToReturn = cell;
            }
            
            else
            {
                
                switch (indexPath.row) {
                    case 3:
                    {
                        PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[0];
                        [self checkHoleNumberVAlueForMode:modelPlayer];
                        NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                        //NSString *title = [NSString stringWithFormat:@"%@(%@)",modelPlayer.shortName,modelPlayer.handicap];
                        //cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        //cell.l1.backgroundColor = [UIColor redColor];
                        //if ([self.createdEventModel.formatId integerValue] == Format420Id)
                        {
                            //title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                            //cell.l1.backgroundColor = SplFormatRedColor;
                        }
                        //else
                        {
                            //cell.l1.backgroundColor = SplFormatRedTeamColor;
                        }
                        //if ([self.createdEventModel.isIndividual isEqualToString:TEAM])
                        {
                            //cell.l1.backgroundColor = SplFormatBlueColor;
                        }
                        //else if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                        {
                            //title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                            //cell.l1.backgroundColor = SplFormatBlueColor;
                        }
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        
                        cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                        //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                        if (modelPlayer.color.length>0)
                        {
                            [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                        }
                        if ([modelPlayer.hole_color_10 length] > 0)
                        {
                            cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_10];
                            cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_11];
                            cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_12];
                            cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_13];
                            cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_14];
                            cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_15];
                            cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_16];
                            cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_17];
                            cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_18];
                        }
                        
                        cell.ct1.text = modelPlayer.hole_num_10;
                        cell.ct2.text = modelPlayer.hole_num_11;
                        cell.ct3.text = modelPlayer.hole_num_12;
                        cell.ct4.text = modelPlayer.hole_num_13;
                        cell.ct5.text = modelPlayer.hole_num_14;
                        cell.ct6.text = modelPlayer.hole_num_15;
                        cell.ct7.text = modelPlayer.hole_num_16;
                        cell.ct8.text = modelPlayer.hole_num_17;
                        cell.ct9.text = modelPlayer.hole_num_18;
                        
                        cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        
                        if ([modelPlayer.hole_color_10 isEqualToString:@"#ffffff"])
                        {
                            cell.ct1.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct1.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_11 isEqualToString:@"#ffffff"])
                        {
                            cell.ct2.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct2.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_12 isEqualToString:@"#ffffff"])
                        {
                            cell.ct3.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct3.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_13 isEqualToString:@"#ffffff"])
                        {
                            cell.ct4.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct4.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_14 isEqualToString:@"#ffffff"])
                        {
                            cell.ct5.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct5.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_15 isEqualToString:@"#ffffff"])
                        {
                            cell.ct6.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct6.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_16 isEqualToString:@"#ffffff"])
                        {
                            cell.ct7.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct7.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_17 isEqualToString:@"#ffffff"])
                        {
                            cell.ct8.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct8.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_18 isEqualToString:@"#ffffff"])
                        {
                            cell.ct9.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct9.textColor = [UIColor whiteColor];
                        }
                        
                        NSInteger totalInteger = [modelPlayer.hole_num_10 integerValue] +
                        [modelPlayer.hole_num_11 integerValue] +
                        [modelPlayer.hole_num_12 integerValue] +
                        [modelPlayer.hole_num_13 integerValue] +
                        [modelPlayer.hole_num_14 integerValue] +
                        [modelPlayer.hole_num_15 integerValue] +
                        [modelPlayer.hole_num_16 integerValue] +
                        [modelPlayer.hole_num_17 integerValue] +
                        [modelPlayer.hole_num_18 integerValue];
                        cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                        
                        NSInteger totalInteger1to9 = [modelPlayer.hole_num_1 integerValue] +
                        [modelPlayer.hole_num_2 integerValue] +
                        [modelPlayer.hole_num_3 integerValue] +
                        [modelPlayer.hole_num_4 integerValue] +
                        [modelPlayer.hole_num_5 integerValue] +
                        [modelPlayer.hole_num_6 integerValue] +
                        [modelPlayer.hole_num_7 integerValue] +
                        [modelPlayer.hole_num_8 integerValue] +
                        [modelPlayer.hole_num_9 integerValue];
                        cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1to9+totalInteger];
                        
                    }
                        break;
                        
                    case 4:
                    {
                        NSLog(@"%@",_commonModel.arrPlayersDetail);
                        PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[1];
                        [self checkHoleNumberVAlueForMode:modelPlayer];
                        NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                        //NSString *title = [NSString stringWithFormat:@"%@(%@)",modelPlayer.shortName,modelPlayer.handicap];
                        //cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        //cell.l1.backgroundColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0];
                        //cell.l1.backgroundColor = SplFormatBlueColor;
                        
                        cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                        //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                        if (modelPlayer.color.length>0)
                        {
                            [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                        }
                        
                        if ([modelPlayer.hole_color_10 length] > 0)
                        {
                            cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_10];
                            cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_11];
                            cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_12];
                            cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_13];
                            cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_14];
                            cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_15];
                            cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_16];
                            cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_17];
                            cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_18];
                        }
                        
                        if ([self.createdEventModel.numberOfPlayers integerValue] == 2 || [self.createdEventModel.numberOfPlayers integerValue] == 3)
                        {
                            title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                        }
                        
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        
                        cell.ct1.text = modelPlayer.hole_num_10;
                        cell.ct2.text = modelPlayer.hole_num_11;
                        cell.ct3.text = modelPlayer.hole_num_12;
                        cell.ct4.text = modelPlayer.hole_num_13;
                        cell.ct5.text = modelPlayer.hole_num_14;
                        cell.ct6.text = modelPlayer.hole_num_15;
                        cell.ct7.text = modelPlayer.hole_num_16;
                        cell.ct8.text = modelPlayer.hole_num_17;
                        cell.ct9.text = modelPlayer.hole_num_18;
                        
                        cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        
                        if ([modelPlayer.hole_color_10 isEqualToString:@"#ffffff"])
                        {
                            cell.ct1.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct1.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_11 isEqualToString:@"#ffffff"])
                        {
                            cell.ct2.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct2.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_12 isEqualToString:@"#ffffff"])
                        {
                            cell.ct3.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct3.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_13 isEqualToString:@"#ffffff"])
                        {
                            cell.ct4.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct4.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_14 isEqualToString:@"#ffffff"])
                        {
                            cell.ct5.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct5.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_15 isEqualToString:@"#ffffff"])
                        {
                            cell.ct6.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct6.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_16 isEqualToString:@"#ffffff"])
                        {
                            cell.ct7.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct7.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_17 isEqualToString:@"#ffffff"])
                        {
                            cell.ct8.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct8.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_18 isEqualToString:@"#ffffff"])
                        {
                            cell.ct9.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct9.textColor = [UIColor whiteColor];
                        }
                        
                        NSInteger totalInteger = [modelPlayer.hole_num_10 integerValue] +
                        [modelPlayer.hole_num_11 integerValue] +
                        [modelPlayer.hole_num_12 integerValue] +
                        [modelPlayer.hole_num_13 integerValue] +
                        [modelPlayer.hole_num_14 integerValue] +
                        [modelPlayer.hole_num_15 integerValue] +
                        [modelPlayer.hole_num_16 integerValue] +
                        [modelPlayer.hole_num_17 integerValue] +
                        [modelPlayer.hole_num_18 integerValue];
                        cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                        
                        NSInteger totalInteger1To9 = [modelPlayer.hole_num_1 integerValue] +
                        [modelPlayer.hole_num_2 integerValue] +
                        [modelPlayer.hole_num_3 integerValue] +
                        [modelPlayer.hole_num_4 integerValue] +
                        [modelPlayer.hole_num_5 integerValue] +
                        [modelPlayer.hole_num_6 integerValue] +
                        [modelPlayer.hole_num_7 integerValue] +
                        [modelPlayer.hole_num_8 integerValue] +
                        [modelPlayer.hole_num_9 integerValue];
                        
                        if ([self.createdEventModel.isIndividual isEqualToString:TEAM])
                        {
                            //cell.l1.backgroundColor = SplFormatRedTeamColor;
                        }
                        else if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
                        {
                            //cell.l1.backgroundColor = SplFormatRedTeamColor;
                        }
                        
                        cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1To9 + totalInteger];
                    }
                        break;
                    case 5:
                    {
                        if ([self.createdEventModel.formatId integerValue] == Format420Id)
                        {
                            PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[2];
                            [self checkHoleNumberVAlueForMode:modelPlayer];
                            NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                            cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                            cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                            
                            cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                            //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                            if (modelPlayer.color.length>0)
                            {
                                [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                            }
                            
                            if ([modelPlayer.hole_color_10 length] > 0)
                            {
                                cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_10];
                                cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_11];
                                cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_12];
                                cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_13];
                                cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_14];
                                cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_15];
                                cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_16];
                                cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_17];
                                cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_18];
                            }
                            
                            cell.ct1.text = modelPlayer.hole_num_10;
                            cell.ct2.text = modelPlayer.hole_num_11;
                            cell.ct3.text = modelPlayer.hole_num_12;
                            cell.ct4.text = modelPlayer.hole_num_13;
                            cell.ct5.text = modelPlayer.hole_num_14;
                            cell.ct6.text = modelPlayer.hole_num_15;
                            cell.ct7.text = modelPlayer.hole_num_16;
                            cell.ct8.text = modelPlayer.hole_num_17;
                            cell.ct9.text = modelPlayer.hole_num_18;
                            
                            cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                            cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            
                            if ([modelPlayer.hole_color_10 isEqualToString:@"#ffffff"])
                            {
                                cell.ct1.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct1.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_11 isEqualToString:@"#ffffff"])
                            {
                                cell.ct2.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct2.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_12 isEqualToString:@"#ffffff"])
                            {
                                cell.ct3.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct3.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_13 isEqualToString:@"#ffffff"])
                            {
                                cell.ct4.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct4.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_14 isEqualToString:@"#ffffff"])
                            {
                                cell.ct5.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct5.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_15 isEqualToString:@"#ffffff"])
                            {
                                cell.ct6.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct6.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_16 isEqualToString:@"#ffffff"])
                            {
                                cell.ct7.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct7.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_17 isEqualToString:@"#ffffff"])
                            {
                                cell.ct8.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct8.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_18 isEqualToString:@"#ffffff"])
                            {
                                cell.ct9.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct9.textColor = [UIColor whiteColor];
                            }
                            
                            NSInteger totalInteger = [modelPlayer.hole_num_10 integerValue] +
                            [modelPlayer.hole_num_11 integerValue] +
                            [modelPlayer.hole_num_12 integerValue] +
                            [modelPlayer.hole_num_13 integerValue] +
                            [modelPlayer.hole_num_14 integerValue] +
                            [modelPlayer.hole_num_15 integerValue] +
                            [modelPlayer.hole_num_16 integerValue] +
                            [modelPlayer.hole_num_17 integerValue] +
                            [modelPlayer.hole_num_18 integerValue];
                            cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                            
                            NSInteger totalInteger1To9 = [modelPlayer.hole_num_1 integerValue] +
                            [modelPlayer.hole_num_2 integerValue] +
                            [modelPlayer.hole_num_3 integerValue] +
                            [modelPlayer.hole_num_4 integerValue] +
                            [modelPlayer.hole_num_5 integerValue] +
                            [modelPlayer.hole_num_6 integerValue] +
                            [modelPlayer.hole_num_7 integerValue] +
                            [modelPlayer.hole_num_8 integerValue] +
                            [modelPlayer.hole_num_9 integerValue];
                            cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1To9+totalInteger];
                        }
                        //////////////////////////////////////////////
                        else if ([self.createdEventModel.numberOfPlayers integerValue] == 4)
                        {
                            PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[2];
                            [self checkHoleNumberVAlueForMode:modelPlayer];
                            NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                            cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                            cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                            
                            cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                            if (modelPlayer.color.length>0)
                            {
                                [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                            }
                            
                            if ([modelPlayer.hole_color_10 length] > 0)
                            {
                                cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_10];
                                cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_11];
                                cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_12];
                                cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_13];
                                cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_14];
                                cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_15];
                                cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_16];
                                cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_17];
                                cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_18];
                            }
                            
                            cell.ct1.text = modelPlayer.hole_num_10;
                            cell.ct2.text = modelPlayer.hole_num_11;
                            cell.ct3.text = modelPlayer.hole_num_12;
                            cell.ct4.text = modelPlayer.hole_num_13;
                            cell.ct5.text = modelPlayer.hole_num_14;
                            cell.ct6.text = modelPlayer.hole_num_15;
                            cell.ct7.text = modelPlayer.hole_num_16;
                            cell.ct8.text = modelPlayer.hole_num_17;
                            cell.ct9.text = modelPlayer.hole_num_18;
                            
                            cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                            cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                            
                            if ([modelPlayer.hole_color_10 isEqualToString:@"#ffffff"])
                            {
                                cell.ct1.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct1.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_11 isEqualToString:@"#ffffff"])
                            {
                                cell.ct2.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct2.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_12 isEqualToString:@"#ffffff"])
                            {
                                cell.ct3.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct3.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_13 isEqualToString:@"#ffffff"])
                            {
                                cell.ct4.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct4.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_14 isEqualToString:@"#ffffff"])
                            {
                                cell.ct5.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct5.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_15 isEqualToString:@"#ffffff"])
                            {
                                cell.ct6.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct6.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_16 isEqualToString:@"#ffffff"])
                            {
                                cell.ct7.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct7.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_17 isEqualToString:@"#ffffff"])
                            {
                                cell.ct8.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct8.textColor = [UIColor whiteColor];
                            }
                            if ([modelPlayer.hole_color_18 isEqualToString:@"#ffffff"])
                            {
                                cell.ct9.textColor = [UIColor blackColor];
                            }
                            else
                            {
                                cell.ct9.textColor = [UIColor whiteColor];
                            }
                            
                            NSInteger totalInteger = [modelPlayer.hole_num_10 integerValue] +
                            [modelPlayer.hole_num_11 integerValue] +
                            [modelPlayer.hole_num_12 integerValue] +
                            [modelPlayer.hole_num_13 integerValue] +
                            [modelPlayer.hole_num_14 integerValue] +
                            [modelPlayer.hole_num_15 integerValue] +
                            [modelPlayer.hole_num_16 integerValue] +
                            [modelPlayer.hole_num_17 integerValue] +
                            [modelPlayer.hole_num_18 integerValue];
                            cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                            
                            NSInteger totalInteger1To9 = [modelPlayer.hole_num_1 integerValue] +
                            [modelPlayer.hole_num_2 integerValue] +
                            [modelPlayer.hole_num_3 integerValue] +
                            [modelPlayer.hole_num_4 integerValue] +
                            [modelPlayer.hole_num_5 integerValue] +
                            [modelPlayer.hole_num_6 integerValue] +
                            [modelPlayer.hole_num_7 integerValue] +
                            [modelPlayer.hole_num_8 integerValue] +
                            [modelPlayer.hole_num_9 integerValue];
                            cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1To9+totalInteger];
                        }
                        else
                        {
                            NSString *title = @"STANDING";
                            cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                            cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                            
                            cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                            
                            [cell.cellTitle setTextColor:[UIColor blackColor]];
                            
                            cell.ct1.text = _standingModel.hole_num_10;
                            cell.ct2.text = _standingModel.hole_num_11;
                            cell.ct3.text = _standingModel.hole_num_12;
                            cell.ct4.text = _standingModel.hole_num_13;
                            cell.ct5.text = _standingModel.hole_num_14;
                            cell.ct6.text = _standingModel.hole_num_15;
                            cell.ct7.text = _standingModel.hole_num_16;
                            cell.ct8.text = _standingModel.hole_num_17;
                            cell.ct9.text = _standingModel.hole_num_18;
                            
                            cell.ct1.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_10];
                            cell.ct2.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_11];
                            cell.ct3.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_12];
                            cell.ct4.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_13];
                            cell.ct5.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_14];
                            cell.ct6.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_15];
                            cell.ct7.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_16];
                            cell.ct8.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_17];
                            cell.ct9.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_18];
                            
                            cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                            cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                            
                            
                            
                            NSInteger totalInteger = [_standingModel.hole_num_10 integerValue] +
                            [_standingModel.hole_num_11 integerValue] +
                            [_standingModel.hole_num_12 integerValue] +
                            [_standingModel.hole_num_13 integerValue] +
                            [_standingModel.hole_num_14 integerValue] +
                            [_standingModel.hole_num_15 integerValue] +
                            [_standingModel.hole_num_16 integerValue] +
                            [_standingModel.hole_num_17 integerValue] +
                            [_standingModel.hole_num_18 integerValue];
                            cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                            
                            NSInteger totalInteger1To9 = [_standingModel.hole_num_1 integerValue] +
                            [_standingModel.hole_num_2 integerValue] +
                            [_standingModel.hole_num_3 integerValue] +
                            [_standingModel.hole_num_4 integerValue] +
                            [_standingModel.hole_num_5 integerValue] +
                            [_standingModel.hole_num_6 integerValue] +
                            [_standingModel.hole_num_7 integerValue] +
                            [_standingModel.hole_num_8 integerValue] +
                            [_standingModel.hole_num_9 integerValue];
                            cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1To9+totalInteger];
                        }
                        
                    }
                        break;
                    case 6:
                    {
                        PT_NewScoreCardPlayerDataModel *modelPlayer = _commonModel.arrPlayersDetail[3];
                        [self checkHoleNumberVAlueForMode:modelPlayer];
                        NSString *title = [NSString stringWithFormat:@"%@ %@",modelPlayer.shortName,modelPlayer.handicap];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        
                        cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                        if (modelPlayer.color.length>0)
                        {
                            [cell.cellTitle setTextColor:[UIColor colorFromHexString:modelPlayer.color]];
                        }
                        
                        if ([modelPlayer.hole_color_10 length] > 0)
                        {
                            cell.c1.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_10];
                            cell.c2.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_11];
                            cell.c3.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_12];
                            cell.c4.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_13];
                            cell.c5.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_14];
                            cell.c6.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_15];
                            cell.c7.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_16];
                            cell.c8.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_17];
                            cell.c9.backgroundColor = [UIColor colorFromHexString:modelPlayer.hole_color_18];
                        }
                        
                        cell.ct1.text = modelPlayer.hole_num_10;
                        cell.ct2.text = modelPlayer.hole_num_11;
                        cell.ct3.text = modelPlayer.hole_num_12;
                        cell.ct4.text = modelPlayer.hole_num_13;
                        cell.ct5.text = modelPlayer.hole_num_14;
                        cell.ct6.text = modelPlayer.hole_num_15;
                        cell.ct7.text = modelPlayer.hole_num_16;
                        cell.ct8.text = modelPlayer.hole_num_17;
                        cell.ct9.text = modelPlayer.hole_num_18;
                        
                        cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:12];
                        
                        if ([modelPlayer.hole_color_10 isEqualToString:@"#ffffff"])
                        {
                            cell.ct1.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct1.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_11 isEqualToString:@"#ffffff"])
                        {
                            cell.ct2.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct2.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_12 isEqualToString:@"#ffffff"])
                        {
                            cell.ct3.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct3.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_13 isEqualToString:@"#ffffff"])
                        {
                            cell.ct4.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct4.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_14 isEqualToString:@"#ffffff"])
                        {
                            cell.ct5.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct5.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_15 isEqualToString:@"#ffffff"])
                        {
                            cell.ct6.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct6.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_16 isEqualToString:@"#ffffff"])
                        {
                            cell.ct7.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct7.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_17 isEqualToString:@"#ffffff"])
                        {
                            cell.ct8.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct8.textColor = [UIColor whiteColor];
                        }
                        if ([modelPlayer.hole_color_18 isEqualToString:@"#ffffff"])
                        {
                            cell.ct9.textColor = [UIColor blackColor];
                        }
                        else
                        {
                            cell.ct9.textColor = [UIColor whiteColor];
                        }
                        
                        NSInteger totalInteger = [modelPlayer.hole_num_10 integerValue] +
                        [modelPlayer.hole_num_11 integerValue] +
                        [modelPlayer.hole_num_12 integerValue] +
                        [modelPlayer.hole_num_13 integerValue] +
                        [modelPlayer.hole_num_14 integerValue] +
                        [modelPlayer.hole_num_15 integerValue] +
                        [modelPlayer.hole_num_16 integerValue] +
                        [modelPlayer.hole_num_17 integerValue] +
                        [modelPlayer.hole_num_18 integerValue];
                        cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                        
                        NSInteger totalInteger1To9 = [modelPlayer.hole_num_1 integerValue] +
                        [modelPlayer.hole_num_2 integerValue] +
                        [modelPlayer.hole_num_3 integerValue] +
                        [modelPlayer.hole_num_4 integerValue] +
                        [modelPlayer.hole_num_5 integerValue] +
                        [modelPlayer.hole_num_6 integerValue] +
                        [modelPlayer.hole_num_7 integerValue] +
                        [modelPlayer.hole_num_8 integerValue] +
                        [modelPlayer.hole_num_9 integerValue];
                        cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1To9+totalInteger];
                    }
                        break;
                    case 7:
                    {
                        NSString *title = @"STANDING";
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"((null))" withString:@""];
                        cell.cellTitle.text = [title stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        
                        cell.l2.backgroundColor = [UIColor colorWithRed:(232/255.0f) green:(233/255.0f) blue:(232/255.0f) alpha:1.0];
                        //[cell.cellTitle setTextColor:[UIColor whiteColor]];
                        
                        [cell.cellTitle setTextColor:[UIColor blackColor]];
                        
                        cell.ct1.text = _standingModel.hole_num_10;
                        cell.ct2.text = _standingModel.hole_num_11;
                        cell.ct3.text = _standingModel.hole_num_12;
                        cell.ct4.text = _standingModel.hole_num_13;
                        cell.ct5.text = _standingModel.hole_num_14;
                        cell.ct6.text = _standingModel.hole_num_15;
                        cell.ct7.text = _standingModel.hole_num_16;
                        cell.ct8.text = _standingModel.hole_num_17;
                        cell.ct9.text = _standingModel.hole_num_18;
                        
                        cell.ct1.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_10];
                        cell.ct2.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_11];
                        cell.ct3.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_12];
                        cell.ct4.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_13];
                        cell.ct5.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_14];
                        cell.ct6.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_15];
                        cell.ct7.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_16];
                        cell.ct8.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_17];
                        cell.ct9.textColor = [UIColor colorFromHexString:_standingModel.color_hole_num_18];
                        
                        cell.ct1.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct2.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct3.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct4.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct5.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct6.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct7.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct8.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct9.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.cellTitle.font = [UIFont fontWithName:@"Lato-Bold" size:10];
                        cell.ct21.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        cell.ct22.font = [UIFont fontWithName:@"Lato-Bold" size:11];
                        
                        
                        
                        NSInteger totalInteger = [_standingModel.hole_num_10 integerValue] +
                        [_standingModel.hole_num_11 integerValue] +
                        [_standingModel.hole_num_12 integerValue] +
                        [_standingModel.hole_num_13 integerValue] +
                        [_standingModel.hole_num_14 integerValue] +
                        [_standingModel.hole_num_15 integerValue] +
                        [_standingModel.hole_num_16 integerValue] +
                        [_standingModel.hole_num_17 integerValue] +
                        [_standingModel.hole_num_18 integerValue];
                        cell.ct21.text = [NSString stringWithFormat:@"%li",totalInteger];
                        
                        NSInteger totalInteger1To9 = [_standingModel.hole_num_1 integerValue] +
                        [_standingModel.hole_num_2 integerValue] +
                        [_standingModel.hole_num_3 integerValue] +
                        [_standingModel.hole_num_4 integerValue] +
                        [_standingModel.hole_num_5 integerValue] +
                        [_standingModel.hole_num_6 integerValue] +
                        [_standingModel.hole_num_7 integerValue] +
                        [_standingModel.hole_num_8 integerValue] +
                        [_standingModel.hole_num_9 integerValue];
                        cell.ct22.text = [NSString stringWithFormat:@"%li",totalInteger1To9+totalInteger];
                    }
                        break;
                }
                
                cellToReturn = cell;
                
            }
        }
        
        
        
        return cellToReturn;
    }
    
}

- (void)checkHoleNumberVAlueForMode:(PT_NewScoreCardPlayerDataModel *)model
{
    if ([model.hole_num_1 isEqualToString:@"0"])
    {
        model.hole_num_1 = @"-";
    }
    if ([model.hole_num_2 isEqualToString:@"0"])
    {
        model.hole_num_2 = @"-";
    }
    if ([model.hole_num_3 isEqualToString:@"0"])
    {
        model.hole_num_3 = @"-";
    }
    if ([model.hole_num_4 isEqualToString:@"0"])
    {
        model.hole_num_4 = @"-";
    }
    if ([model.hole_num_5 isEqualToString:@"0"])
    {
        model.hole_num_5 = @"-";
    }
    if ([model.hole_num_6 isEqualToString:@"0"])
    {
        model.hole_num_6 = @"-";
    }
    if ([model.hole_num_7 isEqualToString:@"0"])
    {
        model.hole_num_7 = @"-";
    }
    if ([model.hole_num_8 isEqualToString:@"0"])
    {
        model.hole_num_8 = @"-";
    }
    if ([model.hole_num_9 isEqualToString:@"0"])
    {
        model.hole_num_9 = @"-";
    }
    if ([model.hole_num_10 isEqualToString:@"0"])
    {
        model.hole_num_10 = @"-";
    }
    if ([model.hole_num_11 isEqualToString:@"0"])
    {
        model.hole_num_11 = @"-";
    }
    if ([model.hole_num_12 isEqualToString:@"0"])
    {
        model.hole_num_12 = @"-";
    }
    if ([model.hole_num_13 isEqualToString:@"0"])
    {
        model.hole_num_13 = @"-";
    }
    if ([model.hole_num_14 isEqualToString:@"0"])
    {
        model.hole_num_14 = @"-";
    }
    if ([model.hole_num_15 isEqualToString:@"0"])
    {
        model.hole_num_15 = @"-";
    }
    if ([model.hole_num_16 isEqualToString:@"0"])
    {
        model.hole_num_16 = @"-";
    }
    if ([model.hole_num_17 isEqualToString:@"0"])
    {
        model.hole_num_17 = @"-";
    }
    if ([model.hole_num_18 isEqualToString:@"0"])
    {
        model.hole_num_18 = @"-";
    }
    
    
}

- (void)checkIndexValue
{
    if ([_commonModel.index1Value isEqualToString:@"0"])
    {
        _commonModel.index1Value = @"-";
    }
    if ([_commonModel.index2Value isEqualToString:@"0"])
    {
        _commonModel.index2Value = @"-";
    }
    if ([_commonModel.index3Value isEqualToString:@"0"])
    {
        _commonModel.index3Value = @"-";
    }
    if ([_commonModel.index4Value isEqualToString:@"0"])
    {
        _commonModel.index4Value = @"-";
    }
    if ([_commonModel.index5Value isEqualToString:@"0"])
    {
        _commonModel.index5Value = @"-";
    }
    if ([_commonModel.index6Value isEqualToString:@"0"])
    {
        _commonModel.index6Value = @"-";
    }
    if ([_commonModel.index7Value isEqualToString:@"0"])
    {
        _commonModel.index7Value = @"-";
    }
    if ([_commonModel.index8Value isEqualToString:@"0"])
    {
        _commonModel.index8Value = @"-";
    }
    if ([_commonModel.index9Value isEqualToString:@"0"])
    {
        _commonModel.index9Value = @"-";
    }
    if ([_commonModel.index10Value isEqualToString:@"0"])
    {
        _commonModel.index10Value = @"-";
    }
    if ([_commonModel.index11Value isEqualToString:@"0"])
    {
        _commonModel.index11Value = @"-";
    }
    if ([_commonModel.index12Value isEqualToString:@"0"])
    {
        _commonModel.index12Value = @"-";
    }
    if ([_commonModel.index13Value isEqualToString:@"0"])
    {
        _commonModel.index14Value = @"-";
    }
    if ([_commonModel.index14Value isEqualToString:@"0"])
    {
        _commonModel.index15Value = @"-";
    }
    if ([_commonModel.index15Value isEqualToString:@"0"])
    {
        _commonModel.index16Value = @"-";
    }
    if ([_commonModel.index16Value isEqualToString:@"0"])
    {
        _commonModel.index16Value = @"-";
    }
    if ([_commonModel.index17Value isEqualToString:@"0"])
    {
        _commonModel.index17Value = @"-";
    }
    if ([_commonModel.index18Value isEqualToString:@"0"])
    {
        _commonModel.index18Value = @"-";
    }
    
    
    //Par Values
    if ([_commonModel.par1Value isEqualToString:@"0"])
    {
        _commonModel.par1Value = @"-";
    }
    if ([_commonModel.par2Value isEqualToString:@"0"])
    {
        _commonModel.par2Value = @"-";
    }
    if ([_commonModel.par3Value isEqualToString:@"0"])
    {
        _commonModel.par3Value = @"-";
    }
    if ([_commonModel.par4Value isEqualToString:@"0"])
    {
        _commonModel.par4Value = @"-";
    }
    if ([_commonModel.par5Value isEqualToString:@"0"])
    {
        _commonModel.par5Value = @"-";
    }
    if ([_commonModel.par6Value isEqualToString:@"0"])
    {
        _commonModel.par6Value = @"-";
    }
    if ([_commonModel.par7Value isEqualToString:@"0"])
    {
        _commonModel.par7Value = @"-";
    }
    if ([_commonModel.par8Value isEqualToString:@"0"])
    {
        _commonModel.par8Value = @"-";
    }
    if ([_commonModel.par9Value isEqualToString:@"0"])
    {
        _commonModel.par9Value = @"-";
    }
    if ([_commonModel.par10Value isEqualToString:@"0"])
    {
        _commonModel.par11Value = @"-";
    }
    if ([_commonModel.par11Value isEqualToString:@"0"])
    {
        _commonModel.par11Value = @"-";
    }
    if ([_commonModel.par12Value isEqualToString:@"0"])
    {
        _commonModel.par12Value = @"-";
    }
    if ([_commonModel.par13Value isEqualToString:@"0"])
    {
        _commonModel.par13Value = @"-";
    }
    if ([_commonModel.par14Value isEqualToString:@"0"])
    {
        _commonModel.par14Value = @"-";
    }
    if ([_commonModel.par15Value isEqualToString:@"0"])
    {
        _commonModel.par15Value = @"-";
    }
    if ([_commonModel.par16Value isEqualToString:@"0"])
    {
        _commonModel.par16Value = @"-";
    }
    if ([_commonModel.par17Value isEqualToString:@"0"])
    {
        _commonModel.par17Value = @"-";
    }
    if ([_commonModel.par18Value isEqualToString:@"0"])
    {
        _commonModel.par18Value = @"-";
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


//Mark:-for opening new format UI's
-(IBAction)actionOpenFormat{
    
    if ([self.createdEventModel.formatId integerValue] == Format420Id) {
        
        [self fourTwoZeroformatdata];
        
        
        
    }
    else if ([self.createdEventModel.formatId integerValue] == FormatVegasId) {
        
        [self vegasFormatData];
    } else if ([self.createdEventModel.formatId integerValue] == Format21Id){
        
        [self vegasFormatData];
    } else if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId){
        
        [self autoPressFormatData];
    }
    
    
}
-(void)openViewforFourTwozero{
    
    CGRect _tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    _fourTwoZeroView = [[[NSBundle mainBundle] loadNibNamed:@"PT_FourTwoZeroView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [self.view addSubview:self.fourTwoZeroView];
    [_fourTwoZeroView bringToFront];
    
    
    if (_fourTwoZeroView != nil)
    {
        self.fourTwoZeroView.frame = _tableViewFrame;
        self.fourTwoZeroView.hidden = NO;
        
        [_fourTwoZeroView loadDatawithArray:self.arr420Format];
    }
    
    
}

-(void)fourTwoZeroformatdata
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getexpandablescoreview"];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                  self.loaderView.hidden = YES;

                  NSLog(@"%@",responseData);
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arr420Format = [NSMutableArray new];
                              
                              if ([arrData isKindOfClass:[NSArray class]])
                              {
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicData = obj;
                                      PT_420Formatmodel *model420Format = [PT_420Formatmodel new];
                                      
                                      //firs array data
                                      NSMutableArray *arr4tColumn = [NSMutableArray new];
                                      arr4tColumn = dicData[@"first_array"];
                                      [arr4tColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrFirst == nil)
                                          {
                                              model420Format.arrFirst = [NSMutableArray new];
                                              model420Format.arrFirstColor = [NSMutableArray new];
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          [model420Format.arrFirst addObject:model.score];
                                          [model420Format.arrFirstColor addObject:model.color];
                                      }];
                                      
                                      
                                      //Mark:-Second Array
                                      NSMutableArray *arr4202ndColumn = [NSMutableArray new];
                                      arr4202ndColumn = dicData[@"second_array"];
                                      [arr4202ndColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrSecond == nil)
                                          {
                                              model420Format.arrSecond = [NSMutableArray new];
                                              model420Format.arrSecondColor = [NSMutableArray new];
                                              
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          [model420Format.arrSecond addObject:model.score];
                                          [model420Format.arrSecondColor addObject:model.color];
                                          
                                      }];
                                      //3rd Column
                                      
                                      //                                      modelSplFormat.arrScoreValue = [NSMutableArray new];
                                      //                                      if ([dicData[@"score_value"] isKindOfClass:[NSDictionary class]])
                                      //                                      {
                                      //                                          /*NSDictionary *dicFront9 = dicData[@"score_value"];
                                      //                                           PT_Front9Model *model = [PT_Front9Model new];
                                      //                                           model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                      //                                           model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                      //                                           [modelSplFormat.arrScoreValue addObject:model];
                                      //                                           */
                                      //                                      }
                                      //                                      else
                                      //                                      {
                                      //                                          NSMutableArray *arr3rdColumn = dicData[@"score_value"];
                                      //                                          if ([arr3rdColumn isKindOfClass:[NSMutableArray class]] && [arr3rdColumn count] > 0)
                                      //                                              [arr3rdColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      //                                                  if (modelSplFormat.arrScoreValue == nil)
                                      //                                                  {
                                      //                                                      modelSplFormat.arrScoreValue = [NSMutableArray new];
                                      //                                                  }
                                      //                                                  NSDictionary *dicFront9 = obj;
                                      //                                                  PT_Front9Model *model = [PT_Front9Model new];
                                      //                                                  model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                      //                                                  model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                      //                                                  [modelSplFormat.arrScoreValue addObject:model];
                                      //                                              }];
                                      //
                                      //                                      }
                                      //
                                      
                                      //Hole Number
                                      model420Format.hole_number = [dicData[@"hole_number"] integerValue];
                                      
                                      [self.arr420Format addObject:model420Format];
                                      
                                      if (idx == [arrData count] -1) {
                                          
                                          [self openViewforFourTwozero];
                                      }
                                      
                                      
                                      for (id value in _arr420Format) {
                                          NSLog(@"Value: %@", value);
                                      }
                                      //NSLog(@"%@",_arr420Format);
                                  }];
                              }
                              
                          }
                          else
                          {
                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
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

//Mark:-Temporay action method for Vegas Format
-(IBAction)actionTempBtn
{
    //    if ([self.createdEventModel.formatId integerValue] == FormatVegasId) {
    //
    //        [self vegasFormatData];
    //    }else if ([self.createdEventModel.formatId integerValue] == Format21Id){
    //
    //        [self vegasFormatData];
    //    }else if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId){
    //
    //        [self autoPressFormatData];
    //    }
    
}

-(void)vegasFormatDataShownOntap{
    
    CGRect _tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    _vegasFormatView = [[[NSBundle mainBundle] loadNibNamed:@"PT_VegasFormatView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [self.view addSubview:self.vegasFormatView];
    [_vegasFormatView bringToFront];
    
    
    if (_vegasFormatView != nil)
    {
        self.vegasFormatView.frame = _tableViewFrame;
        self.vegasFormatView.hidden = NO;
        
        [_vegasFormatView loadTableWithdata:self.arr420Format];
    }
    
    
}


-(void)vegasFormatData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getexpandablescoreview"];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                  self.loaderView.hidden = YES;

                  NSLog(@"%@",responseData);
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arr420Format = [NSMutableArray new];
                              
                              if ([arrData isKindOfClass:[NSArray class]])
                              {
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      
                                      
                                      NSDictionary *dicData = obj;
                                      PT_Front9Model *modelVegas = [PT_Front9Model new];
                                      
                                      modelVegas.holeNumber = [dicData[@"hole_number"] integerValue] ;
                                      modelVegas.aggScore = dicData[@"agg_score"] ;
                                      modelVegas.color = dicData[@"agg_color"];
                                      modelVegas.holeScore = dicData[@"hole_score"];
                                      modelVegas.colorhole = dicData[@"hole_color"];
                                      
                                      [self.arr420Format addObject:modelVegas];
                                      
                                      if (idx == [arrData count] - 1) {
                                          
                                          [self vegasFormatDataShownOntap];
                                      }
                                      
                                      [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                                      self.loaderView.hidden = YES;

                                  }];
                              }
                              
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                              self.loaderView.hidden = YES;

                              
                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
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

-(void)autopressViewOpen{
    
    CGRect _tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    _autoPressFormatView = [[[NSBundle mainBundle] loadNibNamed:@"PT_AutoPressFormatView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    [self.view addSubview:self.autoPressFormatView];
    [_autoPressFormatView bringToFront];
    
    
    if (_autoPressFormatView != nil)
    {
        self.autoPressFormatView.frame = _tableViewFrame;
        self.autoPressFormatView.hidden = NO;
        
        [_autoPressFormatView  loadTableWithdata:self.arr420Format];
    }
    
}

-(void)autoPressFormatData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getexpandablescoreview"];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                  self.loaderView.hidden = YES;

                  NSLog(@"%@",responseData);
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arr420Format = [NSMutableArray new];
                              
                              if ([arrData isKindOfClass:[NSArray class]])
                              {
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicData = obj;
                                      PT_420Formatmodel *model420Format = [PT_420Formatmodel new];
                                      
                                      //firs array data
                                      NSMutableArray *arr4tColumn = [NSMutableArray new];
                                      arr4tColumn = dicData[@"first_array"];
                                      [arr4tColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrFirst == nil)
                                          {
                                              model420Format.arrFirst = [NSMutableArray new];
                                              model420Format.arrFirstColor = [NSMutableArray new];
                                              model420Format.arrFirstCount = [NSMutableArray new];
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          
                                          [model420Format.arrFirst addObject:model.score];
                                          [model420Format.arrFirstColor addObject:model.color];
                                      }];
                                      
                                      
                                      //Mark:-Second Array
                                      NSMutableArray *arr4202ndColumn = [NSMutableArray new];
                                      arr4202ndColumn = dicData[@"second_array"];
                                      [arr4202ndColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrSecond == nil)
                                          {
                                              model420Format.arrSecond = [NSMutableArray new];
                                              model420Format.arrSecondColor = [NSMutableArray new];
                                              model420Format.arrSecondCount = [NSMutableArray new];
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          
                                          [model420Format.arrSecond addObject:model.score];
                                          [model420Format.arrSecondColor addObject:model.color];
                                          
                                      }];
                                      
                                      //Hole Number
                                      model420Format.hole_number = [dicData[@"hole_number"] integerValue];
                                      
                                      NSString *countArrFirst = dicData[@"first_array_count"];
                                      [model420Format.arrFirstCount addObject:countArrFirst];
                                      
                                      model420Format.secondArrayCount = [dicData[@"second_array_count"] integerValue];
                                      // [model420Format.arrSecondColor addObject:countArrSecond];
                                      NSLog(@"%@",countArrFirst);
                                      [self.arr420Format addObject:model420Format];
                                      
                                      
                                      if (idx == [arrData count] -1) {
                                          
                                          [self autopressViewOpen];
                                      }
                                      for (id value in _arr420Format) {
                                          NSLog(@"Value: %@", value);
                                      }
                                      NSLog(@"%@",_arr420Format);
                                  }];
                              }
                              
                          }
                          else
                          {
                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
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


@end
