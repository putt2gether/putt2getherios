//
//  PT_EventPreviewViewController.m
//  Putt2Gether
//
//  Created by Devashis on 07/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_EventPreviewViewController.h"

#import "PT_PreviewNormalTableViewCell.h"

#import "PT_PreviewRoundButtonTableViewCell.h"

#import "PT_SpotPrizeTableViewCell.h"

#import "PT_CreateEventBusinessModel.h"

#import "PT_StartEventViewController.h"

#import "PT_PreviewMoreView.h"

#import "PT_ViewParticipantsViewController.h"

#import "PT_ViewRequestsViewController.h"

#import "PT_SelectScorerMoreOptViewController.h"

#import "PT_StartEventViewController.h"

#import "PT_EnterScoreTableViewCell.h"

#import "PT_PreviewMoreView.h"

#import "PT_LeaderBoardViewController.h"

#import "PT_MyScoresModel.h"

#import "UIImageView+AFNetworking.h"

#import "PT_AddPlayerOptionsViewController.h"
#import "PT_ScoreCardSplFormatViewController.h"

#import "AFHTTPRequestOperationManager.h"


static NSString *const StartEventPostfix = @"startevent";
static NSString *const FetchBannerPostFix = @"getadvbanner";


@interface PT_EventPreviewViewController ()<UITableViewDataSource,
                                            UITableViewDelegate,
                                            PT_PreviewMoreDelegate,
                                            UIGestureRecognizerDelegate>
{
    
    BOOL isStartEventPopUpView;      //For start event popUpview
}

@property (weak, nonatomic) IBOutlet UITableView *tableOptions;

@property (strong, nonatomic) PT_CreateEventBusinessModel *createEventModel;

@property (weak, nonatomic) IBOutlet UIView *footerViewEditMode;

@property (strong, nonatomic) PT_CreatedEventModel *createventModel;

@property (strong, nonatomic) PT_PreviewMoreView  *preview;


@property (weak, nonatomic) IBOutlet UIButton *startEventButtonEditMode;
@property (weak, nonatomic) IBOutlet UILabel *startEventLabelEditMode;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *moreFooterLabel;
@property (assign, nonatomic) BOOL isMoreViewParticipants;
@property (weak, nonatomic) IBOutlet UIView *footerView;


@end

@implementation PT_EventPreviewViewController

- (instancetype)initWithModel:(PT_CreatedEventModel *)model andIsRequestToParticipate:(BOOL)requestToParticipate
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    self.createventModel = model;
    self.isRequestToParticipate = requestToParticipate;
    self.isEditMode = YES;
   
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.acceptRejectFooter.hidden = YES;
    self.popupView.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    _createEventModel = [PT_CreateEventBusinessModel new];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    //[tapGestureRecognizer setDelegate:self];
    [self.popupInsideView addGestureRecognizer:tapGestureRecognizer];
   // [self.tableOptions addGestureRecognizer:tapGestureRecognizer];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    dispatch_async(dispatch_get_main_queue(), ^{
       _preview.hidden = YES;
        
    });
    
    _popupView.hidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.bannnerView.hidden = YES;
    
    if (self.isEditMode ==YES)
    {
        self.titleLabel.text = @"EVENT DETAIL";
        self.footerViewEditMode.hidden = NO;
        self.footerViewEditMode.hidden = NO;
        self.footerView.hidden = NO;
        if (self.createventModel.adminId == [[MGUserDefaults sharedDefault] getUserId])
        {
            self.startEventButtonEditMode.hidden = NO;
            self.startEventLabelEditMode.hidden = NO;
            if (self.isRequestToParticipate == YES)
            {
                if ([self.createventModel.isEventStarted isEqualToString:@"6"])
                {
                    self.startEventLabelEditMode.text = @"REQUEST TO PARTICIPATE";
                }
                else if ([self.createventModel.isEventStarted isEqualToString:@"7"])
                {
                    self.startEventLabelEditMode.text = @"REQUEST PENDING";
                }
            }
            else
            {
                //1= start event, 2= resume round, 3= event not started, 4= started event, 5= accept
                if ([self.createventModel.isEventStarted isEqualToString:@"4"])
                {
                    self.startEventLabelEditMode.text = @"START ROUND";
                }
                
                else if ([self.createventModel.isEventStarted isEqualToString:@"2"])
                {
                    self.startEventLabelEditMode.text = @"RESUME ROUND";
                    self.moreFooterLabel.text = @"VIEW PARTICIPANTS";
                    self.isMoreViewParticipants = YES;
                }
                else if ([self.createventModel.isEventStarted isEqualToString:@"3"])
                {
                    self.startEventLabelEditMode.text = @"EVENT NOT STARTED";
                }else if ([self.createventModel.isEventStarted isEqualToString:@"9"]){
                    
                    self.startEventLabelEditMode.text = @"START ROUND";
                }else if ([self.createventModel.isEventStarted isEqualToString:@"8"]){
                    
                    self.startEventLabelEditMode.text = @"VIEW SCORE";

                }
            }
            
        }
        else
        {
            if (self.isRequestToParticipate == YES)
            {
                if ([self.createventModel.isEventStarted isEqualToString:@"6"])
                {
                    self.startEventLabelEditMode.text = @"REQUEST TO PARTICIPATE";
                }
                else if ([self.createventModel.isEventStarted isEqualToString:@"7"])
                {
                    self.startEventLabelEditMode.text = @"REQUEST PENDING";
                }

            }
            else
            {
                /*if ([self.createventModel.is_accepted isEqualToString:@"0"])
                {
                    //self.startEventButtonEditMode.hidden = YES;
                    //self.startEventLabelEditMode.hidden = YES;
                    self.footerViewEditMode.hidden = YES;
                    self.footerView.hidden = YES;
                }
                else*/
                {
                    // 1= start event, 2= resume round, 3= event not started, 4= started event, 5= accept
                    if ([self.createventModel.isEventStarted isEqualToString:@"4"])
                    {
                        self.startEventLabelEditMode.text = @"EVENT STARTED";
                    }
                    else if ([self.createventModel.isEventStarted isEqualToString:@"5"])
                    {
                        
                        self.acceptRejectFooter.hidden = NO;
//                        if ([self.createventModel.is_accepted isEqualToString:@"0"])
//                        {
//                            self.startEventLabelEditMode.text = @"ACCEPT";
//                        }
//                        else
//                        {
//                            self.startEventLabelEditMode.text = @"DECLINE";
//                        }
                    }
                    else if ([self.createventModel.isEventStarted isEqualToString:@"2"])
                    {
                        self.startEventLabelEditMode.text = @"RESUME ROUND";
                    }
                    else if ([self.createventModel.isEventStarted isEqualToString:@"3"])
                    {
                        self.startEventLabelEditMode.text = @"EVENT NOT STARTED";
                        //self.startEventLabelEditMode.hidden = YES;
                        //self.startEventButtonEditMode.hidden = YES;
                    }else if ([self.createventModel.isEventStarted isEqualToString:@"8"]){
                        
                        self.startEventLabelEditMode.text = @"VIEW SCORE";
                        
                    }
                    //self.startEventButtonEditMode.hidden = YES;
                    //self.startEventLabelEditMode.hidden = YES;
                }
            }
            
            
        }
    }
    else
    {
        
        self.footerViewEditMode.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tableOptions.tableFooterView = [UIView new];
    //spinnerSmall = [[SHActivityView alloc]init];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.isEditMode = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




#pragma mark - Action Methods
- (void)actionRequestForEvent
{
    NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createventModel.eventId];
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
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":userId,
                                @"event_id":eventId,
                                @"type":@"1",
                                @"version":@"2"
                                };
        
        NSString *urlString = @"http://clients.vfactor.in/puttdemo/requesttoparticipate";
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:urlString
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
                                  //[self.arrInvitations removeObjectAtIndex:sender.tag];
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      self.startEventLabelEditMode.text = @"REQUEST PENDING";
                                      self.createventModel.isEventStarted = @"7";
                                  });
                                  [self showAlertWithMessage:dicOutput[@"msg"]];
                              }
                              else
                              {
                                  //Pop up message
                                  [self showAlertWithMessage:dicOutput[@"msg"]];
                                  
                              }
                          }
                      }
                      
                  }
                  else
                  {
                      //Error pop up
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

-(void)startEventPopUP{
    
    self.popUpMainView.hidden = NO;
    
    self.popupLbl.text = @"Last chance to edit handicap to this event";
    
    if ([self.createventModel.playersInGame isEqualToString:@"4+"]) {
        
        self.popupLbl.text = @"Last chance to edit handicap or add participants to this event";

        [self.popupaddParticipantView setHidden:YES];
    }
    
    self.popupView.hidden = NO;
}

-(IBAction)actionStartEventPopup:(id)sender{
    
    isStartEventPopUpView = YES;

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
    
    NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createventModel.eventId],
                            @"version":@"2"
                            };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,StartEventPostfix];
        NSString *encoded = [[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             stringByReplacingOccurrencesOfString:@"%20"
                             withString:@""] ;
        encoded = [encoded stringByReplacingOccurrencesOfString:@"%E2%80%8B" withString:@""];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager setResponseSerializer:responseSerializer];
        
        [manager POST:encoded parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (responseObject != nil)
             {
                 NSDictionary *dicResponseData = responseObject;
                 
                 NSDictionary *dicOutput = dicResponseData[@"output"];
                 NSString *message = dicOutput[@"message"];
                 if ([dicOutput[@"status"] isEqualToString:@"1"])
                 {
                     
                     
                     PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                     
                     [self presentViewController:startVC animated:YES completion:nil];
                     
                 }
                 else if ([message isEqualToString:@"Event already started."])
                 {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                         
                         [self presentViewController:startVC animated:YES completion:nil];
                     });
                 }
                 else
                 {
                     [self showAlertWithMessage:message];
                 }
             }


         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error:%@",[error localizedDescription]);
             [self showAlertWithMessage:[error localizedDescription]];
         }];
        
    /*
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,StartEventPostfix];
    [mainDAO postRequest:urlString
          withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              if (!error)
              {
                  if (responseData != nil)
                  {
                      NSDictionary *dicResponseData = responseData;
                      
                      NSDictionary *dicOutput = dicResponseData[@"output"];
                      NSString *message = dicOutput[@"message"];
                      if ([dicOutput[@"status"] isEqualToString:@"1"])
                      {
                          
                          
                              PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                              
                              [self presentViewController:startVC animated:YES completion:nil];
                          
                      }
                      else if ([message isEqualToString:@"Event already started."])
                      {
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                              
                              [self presentViewController:startVC animated:YES completion:nil];
                          });
                      }
                      else
                      {
                          [self showAlertWithMessage:message];
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
        */
    }
}

//Pop Up actions
-(IBAction)actionEditHandicap:(id)sender{
    
    [self didSelectViewParticipants];
}

-(IBAction)actionaddPaticipants:(id)sender{
    
    PT_AddPlayerOptionsViewController *addPlayersOptionsVC = [[PT_AddPlayerOptionsViewController alloc] initWithEventModel:self.createventModel];
    
    addPlayersOptionsVC.isComingFromAddParticipant = YES;
    addPlayersOptionsVC.numberOfPlayers = NumberOfPlayers_MoreThan4;
    
    [self presentViewController:addPlayersOptionsVC animated:YES completion:nil];
    
}

- (IBAction)actionStartEvent
{
    if ([self.createventModel.isEventStarted isEqualToString:@"3"])
    {
        return;
    }
    if (self.isRequestToParticipate == YES)
    {
        if ([self.createventModel.isEventStarted isEqualToString:@"6"])
        {
            [self actionRequestForEvent];
            return;
        }
        else
        {
            return;
        }
    }
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
       // [self showLoadingView:YES];
        if ([self.createventModel.isEventStarted isEqualToString:@"1"])
           
        {
            
            if  (self.createventModel.adminId == [[MGUserDefaults sharedDefault] getUserId])
            {
                if (isStartEventPopUpView == NO) {
                    
                    [self startEventPopUP];
                    return;
                    
                }
                

            
            
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                    
                    [self presentViewController:startVC animated:YES completion:nil];
                });

            }
        }
        else
        {
             if ([self.createventModel.isEventStarted isEqualToString:@"8"])
            {
                
                if ([self.createventModel.formatId integerValue] == FormatMatchPlayId ||
                    [self.createventModel.formatId integerValue] == FormatAutoPressId ||
                    [self.createventModel.formatId integerValue] == Format420Id ||
                    [self.createventModel.formatId integerValue] == Format21Id ||
                    [self.createventModel.formatId integerValue] == FormatVegasId){
                    
                    PT_ScoreCardSplFormatViewController *scorecardViewController = [[PT_ScoreCardSplFormatViewController alloc] initWithEvent:self.createventModel];
                    scorecardViewController.isSeenAfterDelegate = YES;
                    [self presentViewController:scorecardViewController animated:YES completion:nil];
                    
                }else{
                    
                    PT_LeaderBoardViewController *leaderBoard = [[PT_LeaderBoardViewController alloc] initWithEvent:self.createventModel];
                    leaderBoard.isSeenAfterDelegate = YES;
                    [self presentViewController:leaderBoard animated:YES completion:nil];
                    
                }
                
                return;
            }
            //check if user needs to be navigate to leaderboard screen
           else if (self.createventModel.isSingleScreen == YES)
            {
                if ([self.createventModel.formatId integerValue] == FormatMatchPlayId ||
                    [self.createventModel.formatId integerValue] == FormatAutoPressId ||
                    [self.createventModel.formatId integerValue] == Format420Id ||
                    [self.createventModel.formatId integerValue] == Format21Id ||
                    [self.createventModel.formatId integerValue] == FormatVegasId)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                        
                        [self presentViewController:startVC animated:YES completion:nil];
                    });

                }
                else
                {
                    /*PT_LeaderBoardViewController *leaderboardViewController = [[PT_LeaderBoardViewController alloc] initWithEvent:self.createventModel];
                    leaderboardViewController.eventPreviewVC = self;
                    [self presentViewController:leaderboardViewController animated:YES completion:nil];*/
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                        
                        [self presentViewController:startVC animated:YES completion:nil];
                    });
                }
                
                return;
            }
            
            if ([self.createventModel.isEventStarted isEqualToString:@"1"])
            {
                [self showAlertWithMessage:@"Only Admin can start the event."];
            }
            else
            {
                
                if ([self.createventModel.isEventStarted isEqualToString:@"9"])
                {
                    

                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isBanner"] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"eventIdOfBanner"] isEqualToString:[NSString stringWithFormat:@"%li", (long)self.createventModel.eventId]]) {
                        
                        self.bannnerView.hidden = NO;

                        _bannnerImg.image = [UIImage imageWithData:[[MGUserDefaults sharedDefault] getBannerImage]];
                        
                        [_bannnercloseBtn addTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                    
                    [self fetchBannerDetail];
                    
                    [_bannnercloseBtn addTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    }
                
                    //MArk:-If Player Delegates his/her score send him to
                }
                
                else if ([self.createventModel.isEventStarted isEqualToString:@"5"])
                {
                    if ([self.createventModel.is_accepted isEqualToString:@"0"])//not accepted so accept
                    {
                        [self acceptOrRejectForModel:self.createventModel status:@"1" indexNumber:nil];
                    }
                    else//decline
                    {
                        //[self acceptOrRejectForModel:self.createventModel status:@"2" indexNumber:nil];
                    }
                }
                
                
                else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                    
                    [self presentViewController:startVC animated:YES completion:nil];
                });
                }

            }
            
        }
        
    }

}

-(IBAction)actionAccept:(id)sender{
    
    [self acceptOrRejectForModel:self.createventModel status:@"1" indexNumber:nil];
    
}

-(IBAction)actionReject:(id)sender{
    
    [self acceptOrRejectForModel:self.createventModel status:@"2" indexNumber:nil];

}

- (void)acceptOrRejectForModel:(PT_CreatedEventModel *)model status:(NSString *)status indexNumber:(UIButton *)sender
{
    NSString *eventId = [NSString stringWithFormat:@"%li",(long)model.eventId];
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
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
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":userId,
                                @"event_id":eventId,
                                //@"admin_id":[NSString stringWithFormat:@"%li",model.adminId],
                                @"status":status,
                                @"version":@"2"
                                };
        
        NSString *urlString = @"accepteventinvitation";
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
                              NSLog(@"RECEIVED INVTES");
                              NSDictionary *dicOutput = responseData[@"output"];
                              NSDictionary*dicData = dicOutput[@"data"];
                              //Check Success
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  if ([status isEqualToString:@"1"])
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                        ///self.startEventLabelEditMode.text = @"ACCEPTED";
                                          [self fetchEventwithType:InviteType_Detail];
                                          
                                      });
                                      
                                  }
                                  else
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          //self.startEventLabelEditMode.text = @"DECLINE";
                                          //self.createventModel.is_accepted = @"0";
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                              delegate.tabBarController.tabBar.hidden = NO;
                                              [delegate.tabBarController setSelectedIndex:1];
                                              //[self actionBAck];
                                              UIViewController *vc = self.presentingViewController;
                                              while (vc.presentingViewController) {
                                                  vc = vc.presentingViewController;
                                              }
                                              [vc dismissViewControllerAnimated:YES completion:NULL];
                                          });
                                          
                                      });
                                      
                                      
                                  }
                              }
                              else
                              {
                                  //Pop up message
                                  [self showAlertWithMessage:dicOutput[@"message"]];
                              }
                          }
                      }
                      
                  }
                  else
                  {
                      //Error pop up
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

- (void)fetchEventwithType:(InviteType)type
{
    NSString *eventId = [NSString stringWithFormat:@"%li",self.createventModel.eventId];
    NSString *userId = [NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]];
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
                                              
                                              //if (model.isAdmin == YES)
                                              
                                                  
                                                self.createventModel = model;
                                              [self updateFooterWith:model];
                                              self.acceptRejectFooter.hidden = YES;
                                              [self.view setNeedsDisplay];
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
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

-(void)updateFooterWith:(PT_CreatedEventModel *)model
{
    self.titleLabel.text = @"EVENT DETAIL";
    self.footerViewEditMode.hidden = NO;
    self.footerViewEditMode.hidden = NO;
    self.footerView.hidden = NO;
    if (model.adminId == [[MGUserDefaults sharedDefault] getUserId])
    {
        self.startEventButtonEditMode.hidden = NO;
        self.startEventLabelEditMode.hidden = NO;
        if (self.isRequestToParticipate == YES)
        {
            if ([model.isEventStarted isEqualToString:@"6"])
            {
                self.startEventLabelEditMode.text = @"REQUEST TO PARTICIPATE";
            }
            else if ([model.isEventStarted isEqualToString:@"7"])
            {
                self.startEventLabelEditMode.text = @"REQUEST PENDING";
            }
        }
        else
        {
            //1= start event, 2= resume round, 3= event not started, 4= started event, 5= accept
            if ([model.isEventStarted isEqualToString:@"4"])
            {
                self.startEventLabelEditMode.text = @"START ROUND";
            }
            
            else if ([model.isEventStarted isEqualToString:@"2"])
            {
                self.startEventLabelEditMode.text = @"RESUME ROUND";
                self.moreFooterLabel.text = @"VIEW PARTICIPANTS";
                self.isMoreViewParticipants = YES;
            }
            else if ([model.isEventStarted isEqualToString:@"3"])
            {
                self.startEventLabelEditMode.text = @"EVENT NOT STARTED";
            }else if ([model.isEventStarted isEqualToString:@"9"]){
                
                self.startEventLabelEditMode.text = @"START ROUND";
            }else if ([model.isEventStarted isEqualToString:@"8"]){
                
                self.startEventLabelEditMode.text = @"VIEW SCORE";
                
            }
        }
        
    }
    else
    {
        if (self.isRequestToParticipate == YES)
        {
            if ([model.isEventStarted isEqualToString:@"6"])
            {
                self.startEventLabelEditMode.text = @"REQUEST TO PARTICIPATE";
            }
            else if ([model.isEventStarted isEqualToString:@"7"])
            {
                self.startEventLabelEditMode.text = @"REQUEST PENDING";
            }
            
        }
        else
        {
            /*if ([self.createventModel.is_accepted isEqualToString:@"0"])
             {
             //self.startEventButtonEditMode.hidden = YES;
             //self.startEventLabelEditMode.hidden = YES;
             self.footerViewEditMode.hidden = YES;
             self.footerView.hidden = YES;
             }
             else*/
            {
                // 1= start event, 2= resume round, 3= event not started, 4= started event, 5= accept
                if ([model.isEventStarted isEqualToString:@"4"])
                {
                    self.startEventLabelEditMode.text = @"EVENT STARTED";
                }
                else if ([model.isEventStarted isEqualToString:@"5"])
                {
                    
                    self.acceptRejectFooter.hidden = NO;
                    //                        if ([self.createventModel.is_accepted isEqualToString:@"0"])
                    //                        {
                    //                            self.startEventLabelEditMode.text = @"ACCEPT";
                    //                        }
                    //                        else
                    //                        {
                    //                            self.startEventLabelEditMode.text = @"DECLINE";
                    //                        }
                }
                else if ([model.isEventStarted isEqualToString:@"2"])
                {
                    self.startEventLabelEditMode.text = @"RESUME ROUND";
                }
                else if ([model.isEventStarted isEqualToString:@"3"])
                {
                    self.startEventLabelEditMode.text = @"EVENT NOT STARTED";
                    //self.startEventLabelEditMode.hidden = YES;
                    //self.startEventButtonEditMode.hidden = YES;
                }else if ([model.isEventStarted isEqualToString:@"8"]){
                    
                    self.startEventLabelEditMode.text = @"VIEW SCORE";
                    
                }
                //self.startEventButtonEditMode.hidden = YES;
                //self.startEventLabelEditMode.hidden = YES;
            }
        }
    }

}


-(void)closeButton:(UIButton *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
        
        [self presentViewController:startVC animated:YES completion:nil];
    });

    
}

- (IBAction)actionHome:(id)sender
{
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

- (IBAction)actionBAck
{
    if (self.isComingAfterDelegate == YES || self.isViewScore == YES) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.tabBarController.tabBar.hidden = NO;
            [delegate.tabBarController setSelectedIndex:1];
            //[self actionBAck];
            UIViewController *vc = self.presentingViewController;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:NULL];
        });
    }else{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)actionCreateEvent
{
    if (self.isEditMode == YES)
    {
        
    }
    else
    {
        //Golf Course
        PT_SelectGolfCourseModel *golfCourseModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getGolfCourse];
        NSString *golfCourseId = [NSString stringWithFormat:@"%li",(long)golfCourseModel.golfCourseId];
        
        if([golfCourseId length] < 1)
        {
            return;
        }
        
        //Event Name
        NSString *eventName = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventName];
        
        //Number of players
        
        NSString *noOfPlayers = [self.createEventModel getNumberOfPlayers];
        
        //Version
        NSString *version = @"2";
        
        //Event Format
        PT_StrokePlayListItemModel *formatModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFormat];
        NSString *eventFormat = [NSString stringWithFormat:@"%li",(long)formatModel.strokeId];//@"2";
        
        //TEam Or Individual
        NSString *teamIndividual = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam];
        
        //Start Date
        NSString *startDate = [self.createEventModel getEventDate];
        
        //StartTime
        NSString *startTime = [self.createEventModel getEventTime];
        
        //numberOfHoles
        NSString *numberOfHoles = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfHoles];
        
        //Public or Private
        //NSString *eventType = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventType];
        NSString *eventType = [self.createEventModel getPublicOrPrivate];
        
        //SelectHole
        NSString *selectHole = [self.createEventModel getSelectHole];
        
        //Event Admin
        NSString *eventAdmin = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];
        
        //End Date
        NSString *endDate = @"0000-00-00";
        
        //End Time
        NSString *endTime = @"00:00:00";
        
        //Event Handicap
        NSString *eventIsHandicap = @"1";
        
        //Stroke play id
        PT_StrokePlayListItemModel *strokePlayModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFormat];
        NSString *eventStrokePlayId = [NSString stringWithFormat:@"%li",(long)strokePlayModel.strokeId];
        
        //TEam Individual
        NSString *eventIsTeam = [self.createEventModel getIsEventTeam];
        
        //TEam Number
        NSString *teamNumber = [self.createEventModel getTeamNumber];
        
        //Event friend number
        NSString *eventNumberFriend = [NSString stringWithFormat:@"%li",(unsigned long)[[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventSuggestionFriends] count]];
        
        //Event id spot
        NSString *eventIsSPot = [self.createEventModel getEventIsSpot];
        
        //Closest To Pin
        NSDictionary *closestToPin = [self.createEventModel getCLosestToPin];
        
        //Long Drive
        NSDictionary *longDrive = [self.createEventModel getLongDrive];
        
        //Straight Drive
        NSDictionary *straightDrive = [self.createEventModel getStraightDrive];
        
        //Scorers List
        NSDictionary *dictScorer = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"44",@"0",@"45",@"47",@"42",@"0",@"43", nil];
        //NSArray
        
        //Team list
        NSArray *arrTeams = [NSArray arrayWithArray:[self.createEventModel getTeam]];
        
        //Invite List
        NSArray *arrInviteList = [self.createEventModel getAddedThroughEmailList];//[[NSArray alloc] init];
        
        //group list
        NSArray *arrGroupList = [self.createEventModel getGroups];;
        
        //Event Suggestion Friend List
        NSArray *arrSuggestionFriends = [self.createEventModel getSuggestionFriendList];
        
        //Event Tee
        NSArray *arrEventTee = [self.createEventModel getEventTee];
        
        NSString *IndividualOrTeam = [self.createEventModel getIIndividualOrTeam];
        
        NSString *scorerType = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getScorerEntryType];
        
        NSDictionary *param;
        if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsScorerTypeRequired] == YES)
        {
            param = @{@"event_golf_course_id":golfCourseId,
                      @"version":version,
                      @"event_name":eventName,
                      @"no_of_player":noOfPlayers,
                      @"event_format_id":eventFormat,
                      @"event_is_individual":eventIsTeam,
                      @"event_tee_id":arrEventTee,
                      @"event_start_date":startDate,
                      @"event_start_time":startTime,
                      @"num_of_holes":numberOfHoles,
                      @"event_is_public":eventType,
                      @"select_holes":selectHole,
                      @"event_admin_id":eventAdmin,
                      @"event_end_date":endDate,
                      @"event_end_time":endTime,
                      @"event_is_handicap":eventIsHandicap,
                      @"event_stroke_play_id":eventStrokePlayId,
                      @"event_is_team":IndividualOrTeam,
                      @"event_team_num":teamNumber,
                      @"event_friend_num":eventNumberFriend,
                      @"event_is_spot":eventIsSPot,
                      @"closest_pin":closestToPin,
                      @"long_drive":longDrive,
                      @"straight_drive":straightDrive,
                      //@"scrorer_list":dictScorer,
                      @"team_list":arrTeams,
                      @"invited_email_list":arrInviteList,
                      @"event_group_list":arrGroupList,
                      @"event_friend_list":arrSuggestionFriends,
                      @"is_singlescreen":scorerType,
                      };
        }
        else
        {
            param = @{@"event_golf_course_id":golfCourseId,
                      @"version":version,
                      @"event_name":eventName,
                      @"no_of_player":noOfPlayers,
                      @"event_format_id":eventFormat,
                      @"event_is_individual":eventIsTeam,
                      @"event_tee_id":arrEventTee,
                      @"event_start_date":startDate,
                      @"event_start_time":startTime,
                      @"num_of_holes":numberOfHoles,
                      @"event_is_public":eventType,
                      @"select_holes":selectHole,
                      @"event_admin_id":eventAdmin,
                      @"event_end_date":endDate,
                      @"event_end_time":endTime,
                      @"event_is_handicap":eventIsHandicap,
                      @"event_stroke_play_id":eventStrokePlayId,
                      @"event_is_team":IndividualOrTeam,
                      @"event_team_num":teamNumber,
                      @"event_friend_num":eventNumberFriend,
                      @"event_is_spot":eventIsSPot,
                      @"closest_pin":closestToPin,
                      @"long_drive":longDrive,
                      @"straight_drive":straightDrive,
                      //@"scrorer_list":dictScorer,
                      @"team_list":arrTeams,
                      @"invited_email_list":arrInviteList,
                      @"event_group_list":arrGroupList,
                      @"event_friend_list":arrSuggestionFriends,
                      };
        }
        
        
        NSLog(@"%@",param);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
    
        
        NSString *urlString = @"createevent";
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dataOutput = responseData[@"output"];
                          NSLog(@"data output:%@",dataOutput);
                          NSDictionary *dataEvent= dataOutput[@"Event"];
                          NSLog(@"Event Data:%@",dataEvent);
                          
                          if ([dataOutput[@"status"] isEqualToString:@"1"])
                          {
                              UIAlertController * alert=   [UIAlertController
                                                            alertControllerWithTitle:@"PUTT2GETHER"
                                                            message:dataEvent[@"message"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
                              
                              
                              
                              UIAlertAction* cancel = [UIAlertAction
                                                       actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           //[alert dismissViewControllerAnimated:YES completion:nil];
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               
                                                               
                                                               //[self dismissViewControllerAnimated:YES completion:nil];
                                                               AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                               delegate.tabBarController.tabBar.hidden = NO;
                                                               [delegate.tabBarController setSelectedIndex:1];
                                                               [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultValues];
                                                               UIViewController *vc = self.presentingViewController;
                                                               while (vc.presentingViewController) {
                                                                   vc = vc.presentingViewController;
                                                               }
                                                               [vc dismissViewControllerAnimated:YES completion:NULL];
                                                           });
                                                           
                                                           //[self dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
                              
                              [alert addAction:cancel];
                              
                              [self presentViewController:alert animated:YES completion:nil];
                          }
                          else{
                              UIAlertController * alert=   [UIAlertController
                                                            alertControllerWithTitle:@"PUTT2GETHER"
                                                            message:dataOutput[@"message"]
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
              }];
    }
    
    
    
}


#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == PreviewEventCellType_SelectHoles)
    {
        if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getis18HolesSelected] == YES || self.createventModel.totalHoleNumber == 18)
        {
            return 0;
        }
        else
        {
            return 44.0f;
        }
    }
    if (indexPath.row == PreviewEventCellType_SpotPrize)
    {
        if (self.isEditMode == YES)
        {
            if (self.createventModel.isSpot == YES)
            {
                return 214.0f;
            }
            else
            {
                return 0.0;
            }
        }
        else
        {
            if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"4+"])
            {
                return 214.0f;
            }
            else
            {
                return 0.0;
            }
        }
    }
    if (indexPath.row == PreviewEventCellType_TeamIndividual)
    {
        if (self.isEditMode == YES)
        {
            if ([self.createventModel.numberOfPlayers isEqualToString:@"1"] ||
                [self.createventModel.numberOfPlayers isEqualToString:@"2"] ||
                [self.createventModel.numberOfPlayers isEqualToString:@"3"] ||
                [self.createventModel.numberOfPlayers isEqualToString:@"4+"])
            {
                return 0.0;
            }
            else
            {
                return 44.0;
            }
        }
        else
        {
            if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"1"] ||
                [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"2"] ||
                [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"3"] ||
                [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
            {
                return 0.0;
            }
            else
            {
                return 44.0;
            }
        }
    }
    if (indexPath.row == PreviewEventCellType_EventType)
    {
        if (self.isEditMode == YES)
        {
            if ([self.createventModel.numberOfPlayers isEqualToString:@"1"]||
                [self.createventModel.numberOfPlayers isEqualToString:@"2"] ||
                [self.createventModel.numberOfPlayers isEqualToString:@"3"] ||
                [self.createventModel.numberOfPlayers isEqualToString:@"4"])
            {
                return 0.0;
            }
            else
            {
                return 44.0;
            }
        }
        else{
            if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"4+"])
            {
                return 44.0;
            }
            else
            {
                return 0.0;
            }
        }

    }
    if (indexPath.row == PreviewEventCellType_Scorer)
    {
        if (self.isEditMode == YES)
        {
            if ([self.createventModel.numberOfPlayers isEqualToString:@"2"] || [self.createventModel.numberOfPlayers isEqualToString:@"3"] || [self.createventModel.numberOfPlayers isEqualToString:@"4"])
            {
                return 44.0;
            }
            else
            {
                return 0.0;
            }
        }
        else
        {
            if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"1"])
            {
                return 0;
            }
            else
            {
                return 44.0;
            }
        }
        
    }
    else
    {
        return 44.0f;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 12;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *colorBorderBlue = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UITableViewCell *cell;
    switch (indexPath.row) {
        case PreviewEventCellType_GolfCource:
        {
            PT_PreviewRoundButtonTableViewCell *cellGolf = [tableView dequeueReusableCellWithIdentifier:@"GolfCourse"];
            
            if (cellGolf == nil)
            {
                cellGolf = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
                
                cellGolf.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            NSString *golfCourseName = nil;
            if (self.isEditMode == YES)
            {
                golfCourseName = [self.createventModel.golfCourseName uppercaseString];
            }
            else
            {
                PT_SelectGolfCourseModel *model = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getGolfCourse];
                golfCourseName = model.golfCourseName;
            }
            //PT_SelectGolfCourseModel *model = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getGolfCourse];
            cellGolf.title.text = @"GOLF COURSE";
            //cellGolf.value.text = model.golfCourseName;
            cellGolf.value.text = golfCourseName;
            cellGolf.value.hidden = NO;
            
            cellGolf.button1.hidden = YES;
            cellGolf.button2.hidden = YES;
            cellGolf.button3.hidden = YES;
            
            cell = cellGolf;
            
        }
            break;
        case PreviewEventCellType_EventName:
        {
            PT_PreviewRoundButtonTableViewCell *cellEventName = [tableView dequeueReusableCellWithIdentifier:@"EventName"];
            
            if (cellEventName == nil)
            {
                cellEventName = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell"
                                                               owner:self
                                                             options:nil] objectAtIndex:0];
                
                cellEventName.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            cellEventName.title.text = @"EVENT NAME";
            cellEventName.value.hidden = NO;
            
            cellEventName.button1.hidden = YES;
            cellEventName.button2.hidden = YES;
            cellEventName.button3.hidden = YES;
            
            NSString *eventName = nil;
            
            if (self.isEditMode == YES)
            {
                eventName = self.createventModel.eventName;
            }
            else
            {
                eventName = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventName];
            }
            
            //cellEventName.value.text = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventName];
            cellEventName.value.text = eventName;
            
            cell = cellEventName;
            
        }
            break;
        case PreviewEventCellType_NumOfPlayers:
        {
            PT_PreviewRoundButtonTableViewCell *cellNumOfPlayers = [tableView dequeueReusableCellWithIdentifier:@"NumOfPlayers"];
            
            if (cellNumOfPlayers == nil)
            {
                cellNumOfPlayers = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellNumOfPlayers.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cellNumOfPlayers.title.text = @"NO. OF PLAYERS";
            cellNumOfPlayers.button1.backgroundColor = colorBorderBlue;
            [cellNumOfPlayers.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cellNumOfPlayers.button1.layer.cornerRadius = cellNumOfPlayers.button1.frame.size.width/2;
            cellNumOfPlayers.button1.layer.borderColor = [UIColor whiteColor].CGColor;
            cellNumOfPlayers.button1.layer.borderWidth = 1.0f;
            cellNumOfPlayers.button1.layer.masksToBounds = YES;
            if (self.isEditMode == YES)
            {
                [cellNumOfPlayers.button1 setTitle:[NSString stringWithFormat:@"%@",self.createventModel.numberOfPlayers] forState:UIControlStateNormal];
            }
            else
            {
                if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
                {
                    //NSArray *arrPlayers = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayersFor4Plus];
                    //if (arrPlayers != nil)
                    {
                        //[cellNumOfPlayers.button1 setTitle:[NSString stringWithFormat:@"%li",[arrPlayers count]] forState:UIControlStateNormal];
                        [cellNumOfPlayers.button1 setTitle:[NSString stringWithFormat:@"%li",self.totalCount4PlusPlayers+1] forState:UIControlStateNormal];
                    }
                    //else
                    {
                        //[cellNumOfPlayers.button1 setTitle:@"0" forState:UIControlStateNormal];
                    }
                }
                else
                {
                    [cellNumOfPlayers.button1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] forState:UIControlStateNormal];
                }

            }
            
            
            
            cellNumOfPlayers.button2.hidden = YES;
            cellNumOfPlayers.button3.hidden = YES;
            
            
            cell = cellNumOfPlayers;
        }
            break;
        case PreviewEventCellType_TeamIndividual:
        {
            PT_PreviewRoundButtonTableViewCell *cellTeamIndividual = [tableView dequeueReusableCellWithIdentifier:@"TeamIndividual"];
            
            if (cellTeamIndividual == nil)
            {
                cellTeamIndividual = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellTeamIndividual.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cellTeamIndividual.title.text = @"TEAM/INDIVIDUAL";
            if (self.isEditMode == YES)
            {
                cellTeamIndividual.value.text = [self.createventModel.isIndividual uppercaseString];
                if ([self.createventModel.numberOfPlayers isEqualToString:@"1"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"2"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"3"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"4+"])
                {
                    cellTeamIndividual.hidden = YES;
                }
                if ([self.createventModel.numberOfPlayers integerValue] < 4 && [self.createventModel.isIndividual isEqualToString:@"Individual"])
                {
                    cellTeamIndividual.hidden = YES;
                }
            }
            else
            {
                if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"1"] ||
                    [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"2"] ||
                    [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"3"] ||
                    [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
                {
                    cellTeamIndividual.hidden = YES;
                }
                cellTeamIndividual.value.text = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] uppercaseString];
            }
            
            cellTeamIndividual.value.hidden = NO;
            
            cellTeamIndividual.button1.hidden = YES;
            cellTeamIndividual.button2.hidden = YES;
            cellTeamIndividual.button3.hidden = YES;
            
            cell = cellTeamIndividual;
        }
            break;
        case PreviewEventCellType_SelectFormat:
        {
            PT_PreviewRoundButtonTableViewCell *cellSelectFormat = [tableView dequeueReusableCellWithIdentifier:@"SelectFormat"];
            
            if (cellSelectFormat == nil)
            {
                cellSelectFormat = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellSelectFormat.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cellSelectFormat.title.text = @"FORMAT";
            
            if (self.isEditMode == YES)
            {
                cellSelectFormat.value.text = self.createventModel.formatName;
            }
            else
            {
                PT_StrokePlayListItemModel *model = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFormat];
                cellSelectFormat.value.text = model.strokeName;
            }
            
            
            cellSelectFormat.value.hidden = NO;
            
            cellSelectFormat.button1.hidden = YES;
            cellSelectFormat.button2.hidden = YES;
            cellSelectFormat.button3.hidden = YES;
            
            cell = cellSelectFormat;
        }
            break;
        case PreviewEventCellType_SelectTee:
        {
            PT_PreviewRoundButtonTableViewCell *cellSelectTee = [tableView dequeueReusableCellWithIdentifier:@"SelectTee"];
            
            if (cellSelectTee == nil)
            {
                cellSelectTee = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellSelectTee.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
            UIColor *blackColor = [UIColor blackColor];
            UIColor *whiteColor = [UIColor whiteColor];

            
            if (self.isEditMode == YES)
            {
                NSDictionary *dicEditEventTee = self.createventModel.teeId;
               
                //MEN
                NSDictionary *dicMen = dicEditEventTee[@"MenColor"];
                NSString *mHex = nil;
                NSNull *n=[NSNull null];
                //if ( dicMen == n )
                {
                    CGFloat r = [dicMen[@"r"] floatValue];
                    CGFloat g = [dicMen[@"g"] floatValue];
                    CGFloat b = [dicMen[@"b"] floatValue];
                    UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                    mHex = [self hexStringFromColor:jColor];
                    
                }
                if ([mHex isEqualToString:@"#FFFFFF"])
                {
                    [cellSelectTee.button1 setTitleColor:blueBGColor forState:UIControlStateNormal];
                    cellSelectTee.button1.layer.borderColor = blueBGColor.CGColor;
                }else if ([mHex isEqualToString:@"#C0C0C0"] || [mHex isEqualToString:@"#FFD700"] || [mHex isEqualToString:@"#FFFF00"]){
                    
                    [cellSelectTee.button1 setTitleColor:blackColor forState:UIControlStateNormal];
                    cellSelectTee.button1.layer.borderColor = whiteColor.CGColor;
                }

                else
                {
                    [cellSelectTee.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellSelectTee.button1.layer.borderColor = [UIColor clearColor].CGColor;
                }
                
                cellSelectTee.button1.backgroundColor = [UIColor colorFromHexString:mHex];
                cellSelectTee.button1.layer.cornerRadius = cellSelectTee.button1.frame.size.width/2;
                cellSelectTee.button1.layer.borderWidth = 1.0;
                cellSelectTee.button1.layer.masksToBounds = YES;
                [cellSelectTee.button1 setTitle:@"M" forState:UIControlStateNormal];
                
                //WOMEN
                NSLog(@"%@",dicEditEventTee);
                NSDictionary *dicLadies = dicEditEventTee[@"LadiesColor"];
                NSString *wHex = nil;
                //if ( dicLadies == n )
                {
                    CGFloat r = [dicLadies[@"r"] floatValue];
                    CGFloat g = [dicLadies[@"g"] floatValue];
                    CGFloat b = [dicLadies[@"b"] floatValue];
                    UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                    wHex = [self hexStringFromColor:jColor];
                    
                }
                if ([wHex isEqualToString:@"#FFFFFF"])
                {
                    [cellSelectTee.button2 setTitleColor:blueBGColor forState:UIControlStateNormal];
                    cellSelectTee.button2.layer.borderColor = blueBGColor.CGColor;
                }else if ([wHex isEqualToString:@"#C0C0C0"] || [wHex isEqualToString:@"#FFD700"] || [wHex isEqualToString:@"#FFFF00"]){
                    
                    [cellSelectTee.button2 setTitleColor:blackColor forState:UIControlStateNormal];
                    cellSelectTee.button2.layer.borderColor = whiteColor.CGColor;
                }
                else
                {
                    [cellSelectTee.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellSelectTee.button2.layer.borderColor = [UIColor clearColor].CGColor;
                }
                cellSelectTee.button2.backgroundColor = [UIColor colorFromHexString:wHex];
                cellSelectTee.button2.layer.cornerRadius = cellSelectTee.button2.frame.size.width/2;
                cellSelectTee.button2.layer.borderWidth = 1.0;
                cellSelectTee.button2.layer.masksToBounds = YES;
                [cellSelectTee.button2 setTitle:@"W" forState:UIControlStateNormal];
                
                //JUNIOR
                NSDictionary *dicJunior = dicEditEventTee[@"JuniorColor"];
                NSString *jHex = nil;
                //if ( dicJunior == n )
                //{
                    CGFloat r = [dicJunior[@"r"] floatValue];
                    CGFloat g = [dicJunior[@"g"] floatValue];
                    CGFloat b = [dicJunior[@"b"] floatValue];
                    UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                    jHex = [self hexStringFromColor:jColor];
                //}
                if ([jHex isEqualToString:@"#FFFFFF"])
                {
                    [cellSelectTee.button3 setTitleColor:blueBGColor forState:UIControlStateNormal];
                    cellSelectTee.button3.layer.borderColor = blueBGColor.CGColor;
                }else if ([jHex isEqualToString:@"#C0C0C0"] || [jHex isEqualToString:@"#FFD700"] || [jHex isEqualToString:@"#FFFF00"]){
                    
                    [cellSelectTee.button3 setTitleColor:blackColor forState:UIControlStateNormal];
                    cellSelectTee.button3.layer.borderColor = whiteColor.CGColor;
                }
                else
                {
                    [cellSelectTee.button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellSelectTee.button3.layer.borderColor = [UIColor clearColor].CGColor;
                }
                cellSelectTee.button3.backgroundColor = [UIColor colorFromHexString:jHex];
                cellSelectTee.button3.layer.cornerRadius = cellSelectTee.button3.frame.size.width/2;
                cellSelectTee.button3.layer.borderWidth = 1.0;
                cellSelectTee.button3.layer.masksToBounds = YES;
                [cellSelectTee.button3 setTitle:@"J" forState:UIControlStateNormal];


            }
            else
            {
                //Men Button
                cellSelectTee.button1.backgroundColor = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getTeeColorForMen];
                cellSelectTee.button1.layer.cornerRadius = cellSelectTee.button1.frame.size.width/2;
                cellSelectTee.button1.layer.borderWidth = 1.0;
                //if ([cellSelectTee.button1.backgroundColor isEqualToColor:[UIColor whiteColor]])
                if ([cellSelectTee.button1.backgroundColor color:cellSelectTee.button1.backgroundColor isEqualToColor:[UIColor whiteColor] withTolerance:0.2])
                {
                    cellSelectTee.button1.layer.borderColor = blueBGColor.CGColor;
                    [cellSelectTee.button1 setTitleColor:blueBGColor forState:UIControlStateNormal];
                }else if ([cellSelectTee.button1.backgroundColor color:cellSelectTee.button1.backgroundColor isEqualToColor:[UIColor yellowColor] withTolerance:0.2]){
                    
                    cellSelectTee.button1.layer.borderColor = [UIColor clearColor].CGColor;
                    [cellSelectTee.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                else
                {
                    cellSelectTee.button1.layer.borderColor = [UIColor clearColor].CGColor;
                    [cellSelectTee.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                cellSelectTee.button1.layer.masksToBounds = YES;
                [cellSelectTee.button1 setTitle:@"M" forState:UIControlStateNormal];
                
                //Women Button
                cellSelectTee.button2.backgroundColor = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getTeeColorForWomen];
                cellSelectTee.button2.layer.cornerRadius = cellSelectTee.button2.frame.size.width/2;
                cellSelectTee.button2.layer.borderWidth = 1.0;
                //if ([cellSelectTee.button2.backgroundColor isEqualToColor:[UIColor whiteColor]])
                if ([cellSelectTee.button2.backgroundColor color:cellSelectTee.button2.backgroundColor isEqualToColor:[UIColor whiteColor] withTolerance:0.2])
                {
                    cellSelectTee.button2.layer.borderColor = blueBGColor.CGColor;
                    [cellSelectTee.button2 setTitleColor:blueBGColor forState:UIControlStateNormal];
                }else if ([cellSelectTee.button2.backgroundColor color:cellSelectTee.button2.backgroundColor isEqualToColor:[UIColor yellowColor] withTolerance:0.2]){
                    
                    cellSelectTee.button2.layer.borderColor = [UIColor clearColor].CGColor;
                    [cellSelectTee.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                else
                {
                    cellSelectTee.button2.layer.borderColor = [UIColor clearColor].CGColor;
                    [cellSelectTee.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                cellSelectTee.button2.layer.masksToBounds = YES;
                [cellSelectTee.button2 setTitle:@"W" forState:UIControlStateNormal];
                
                //Junior Button
                NSLog(@"Original : %@  Color: %@",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getTeeColorForJunior],[UIColor whiteColor]);
                cellSelectTee.button3.backgroundColor = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getTeeColorForJunior];
                cellSelectTee.button3.layer.cornerRadius = cellSelectTee.button3.frame.size.width/2;
                cellSelectTee.button3.layer.borderWidth = 1.0;
                //if ([cellSelectTee.button3.backgroundColor isEqualToColor:[UIColor whiteColor]] )
                if ([cellSelectTee.button3.backgroundColor color:cellSelectTee.button3.backgroundColor isEqualToColor:[UIColor whiteColor] withTolerance:0.2])
                {
                    cellSelectTee.button3.layer.borderColor = blueBGColor.CGColor;
                    [cellSelectTee.button3 setTitleColor:blueBGColor forState:UIControlStateNormal];
                }else if ([cellSelectTee.button3.backgroundColor color:cellSelectTee.button3.backgroundColor isEqualToColor:[UIColor yellowColor] withTolerance:0.2]){
                    
                    cellSelectTee.button3.layer.borderColor = [UIColor clearColor].CGColor;
                    [cellSelectTee.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }

                else
                {
                    cellSelectTee.button3.layer.borderColor = [UIColor clearColor].CGColor;
                    [cellSelectTee.button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                cellSelectTee.button3.layer.masksToBounds = YES;
                [cellSelectTee.button3 setTitle:@"J" forState:UIControlStateNormal];
            }
            
            
            cellSelectTee.title.text = @"TEE";
            cell = cellSelectTee;
            
        }
            break;
        case PreviewEventCellType_EventTime:
        {
            PT_PreviewRoundButtonTableViewCell *cellEventTime = [tableView dequeueReusableCellWithIdentifier:@"EventTime"];
            
            if (cellEventTime == nil)
            {
                cellEventTime = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellEventTime.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cellEventTime.title.text = @"EVENT TIME";
            if (self.isEditMode == YES)
            {
                cellEventTime.value.text = self.createventModel.eventstartDateTime;
            }
            else
            {
                cellEventTime.value.text = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventTime];
            }
            
            cellEventTime.value.hidden = NO;
            
            cellEventTime.button1.hidden = YES;
            cellEventTime.button2.hidden = YES;
            cellEventTime.button3.hidden = YES;
            
            cell = cellEventTime;
        }
            break;
        case PreviewEventCellType_NoOfHoles:
        {
            PT_PreviewRoundButtonTableViewCell *cellNoOfHoles = [tableView dequeueReusableCellWithIdentifier:@"NoOfHoles"];
            
            if (cellNoOfHoles == nil)
            {
                cellNoOfHoles = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellNoOfHoles.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            cellNoOfHoles.title.text = @"NO. OF HOLES";
            cellNoOfHoles.button1.backgroundColor = colorBorderBlue;
            [cellNoOfHoles.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cellNoOfHoles.button1.layer.cornerRadius = cellNoOfHoles.button1.frame.size.width/2;
            cellNoOfHoles.button1.layer.borderColor = [UIColor whiteColor].CGColor;
            cellNoOfHoles.button1.layer.borderWidth = 1.0f;
            cellNoOfHoles.button1.layer.masksToBounds = YES;
            
            if (self.isEditMode == YES)
            {
                [cellNoOfHoles.button1 setTitle:[NSString stringWithFormat:@"%li",self.createventModel.totalHoleNumber] forState:UIControlStateNormal];
            }
            else
            {
                [cellNoOfHoles.button1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfHoles] forState:UIControlStateNormal];
            }
            
            
            cellNoOfHoles.button2.hidden = YES;
            cellNoOfHoles.button3.hidden = YES;
            
            
            cell = cellNoOfHoles;
        }
            break;
        case PreviewEventCellType_EventType:
        {
            PT_PreviewRoundButtonTableViewCell *cellEventType = [tableView dequeueReusableCellWithIdentifier:@"EventType"];
            
            if (cellEventType == nil)
            {
                cellEventType = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellEventType.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            cellEventType.title.text = @"EVENT TYPE";
            
            if (self.isEditMode == YES)
            {
                if ([self.createventModel.numberOfPlayers isEqualToString:@"1"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"2"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"3"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"4"])
                {
                    cellEventType.hidden = YES;
                }
                else
                {
                    cellEventType.hidden = NO;
                }
                cellEventType.value.text = [self.createventModel.eventType uppercaseString];
            }
            else
            {
                if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
                {
                    //cellEventType.hidden = YES;
                }
                else
                {
                    cellEventType.hidden = YES;
                }
                cellEventType.value.text = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventType];
            }
            
            
            cellEventType.value.hidden = NO;
            
            cellEventType.button1.hidden = YES;
            cellEventType.button2.hidden = YES;
            cellEventType.button3.hidden = YES;
            
            cell = cellEventType;
        }
            break;
        case PreviewEventCellType_SelectHoles:
        {
            PT_PreviewRoundButtonTableViewCell *cellSelectHoles = [tableView dequeueReusableCellWithIdentifier:@"SelectHoles"];
            
            if (cellSelectHoles == nil)
            {
                cellSelectHoles = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewRoundButtonTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellSelectHoles.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            cellSelectHoles.button1.hidden = YES;
            cellSelectHoles.button2.hidden = YES;
            cellSelectHoles.button3.hidden = YES;
            
            if(self.isEditMode == YES)
            {
                if (self.createventModel.totalHoleNumber == 18)
                {
                    cellSelectHoles.title.hidden = YES;
                    cellSelectHoles.value.hidden = YES;
                }
                else
                {
                    cellSelectHoles.title.text = @"HOLES";
                    cellSelectHoles.value.text = self.createventModel.holes;
                    cellSelectHoles.title.hidden = NO;
                    cellSelectHoles.value.hidden = NO;
                }
            }
            else
            {
                if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getis18HolesSelected] == NO)
                {
                    cellSelectHoles.title.text = @"HOLES";
                    cellSelectHoles.value.text = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFrontOrBack9];
                    cellSelectHoles.title.hidden = NO;
                    cellSelectHoles.value.hidden = NO;
                }
                else
                {
                    cellSelectHoles.title.hidden = YES;
                    cellSelectHoles.value.hidden = YES;
                }

            }
            
            cell = cellSelectHoles;
        }
            break;
        case PreviewEventCellType_SpotPrize:
        {
            
            PT_SpotPrizeTableViewCell *cellSpotPrize = [tableView dequeueReusableCellWithIdentifier:@"SelectFormat"];
            //cellSpotPrize = self.cellSpotPrizes;
            if (cellSpotPrize == nil)
            {
                cellSpotPrize = [[[NSBundle mainBundle] loadNibNamed:@"PT_SpotPrizeTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellSpotPrize.selectionStyle = UITableViewCellSelectionStyleNone;
                //self.cellSpotPrizes = cellSpotPrize;
            }
            else
            {
                
            }
            
            cellSpotPrize.constraintLeading.constant = 10;
            UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
            //cellSpotPrize.parentController = self;
            cellSpotPrize.yesButton.layer.borderWidth = 1.0;
            cellSpotPrize.yesButton.layer.cornerRadius = 9.0;
            cellSpotPrize.yesButton.layer.masksToBounds = YES;
            cellSpotPrize.yesButton.userInteractionEnabled = NO;
            
            cellSpotPrize.noButton.layer.borderWidth = 1.0;
            cellSpotPrize.noButton.layer.cornerRadius = 9.0;
            cellSpotPrize.noButton.layer.masksToBounds = YES;
            cellSpotPrize.noButton.userInteractionEnabled = NO;
            
            cellSpotPrize.spotPrizeView.layer.cornerRadius = 3.0;
            cellSpotPrize.spotPrizeView.layer.borderWidth = 0.0;
            cellSpotPrize.spotPrizeView.layer.masksToBounds = YES;
            
            if (self.isEditMode == YES)
            {
                cellSpotPrize.selectHoleLabel.text = @"HOLE";
                UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                if (self.createventModel.isSpot == YES)
                {
                    BOOL isClosestPinVisible,isLongDriveVisible,isStraightDriveVisible;
                    [cellSpotPrize showSpotOptionsForNumberOfHoles:self.createventModel.totalHoleNumber];
                    cellSpotPrize.lineView.hidden = YES;
                    cellSpotPrize.spotPrizeView.hidden = NO;
                    cellSpotPrize.yesButton.backgroundColor = blueBGColor;
                    [cellSpotPrize.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellSpotPrize.noButton.hidden = YES;
                    
                    if ([self.createventModel.closestPin count] > 0)
                    {
                        isClosestPinVisible = YES;
                        for (NSInteger counter = 0; counter < [self.createventModel.closestPin count]; counter++) {
                            NSDictionary *dicSpot = self.createventModel.closestPin[counter];
                            switch (counter) {

                                case 0:
                                {
                                    [cellSpotPrize.closestToPinButton3 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.closestToPinButton4.hidden = YES;
                                    cellSpotPrize.closestToPinButton2.hidden = YES;
                                    cellSpotPrize.closestToPinButton1.hidden = YES;
                                }
                                    break;
                                case 1:
                                {
                                    [cellSpotPrize.closestToPinButton4 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.closestToPinButton4.hidden = NO;
                                    cellSpotPrize.closestToPinButton2.hidden = YES;
                                    cellSpotPrize.closestToPinButton1.hidden = YES;
                                }
                                    break;
                                case 2:
                                {
                                    [cellSpotPrize.closestToPinButton2 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.closestToPinButton2.hidden = NO;
                                    cellSpotPrize.closestToPinButton1.hidden = YES;
                                }
                                    break;
                                case 3:
                                {
                                    [cellSpotPrize.closestToPinButton1 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton1.hidden = NO;
                                }
                                    break;
                                    
                            }
                        }
                    }
                    else
                    {
                        isClosestPinVisible = NO;
                        [cellSpotPrize hideClosestToPin];
                    }
                    
                    if ([self.createventModel.longDrive count] > 0)
                    {
                        isLongDriveVisible = YES;
                        for (NSInteger counter = 0; counter < [self.createventModel.longDrive count]; counter++) {
                            NSDictionary *dicSpot = self.createventModel.longDrive[counter];
                            switch (counter) {
                                    
                                case 0:
                                {
                                    [cellSpotPrize.longDriveButton3 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.longDriveButton4.hidden = YES;
                                    cellSpotPrize.longDriveButton2.hidden = YES;
                                    cellSpotPrize.longDriveButton1.hidden = YES;
                                }
                                    break;
                                case 1:
                                {
                                    [cellSpotPrize.longDriveButton4 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.longDriveButton4.hidden = NO;
                                    cellSpotPrize.longDriveButton2.hidden = YES;
                                    cellSpotPrize.longDriveButton1.hidden = YES;
                                }
                                    break;
                                case 2:
                                {
                                    [cellSpotPrize.longDriveButton2 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.longDriveButton2.hidden = NO;
                                    cellSpotPrize.longDriveButton1.hidden = YES;
                                }
                                    break;
                                case 3:
                                {
                                    [cellSpotPrize.longDriveButton1 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton1.hidden = NO;
                                }
                                    break;
                                    
                            }
                        }
                    }
                    else
                    {
                        isLongDriveVisible = NO;
                        [cellSpotPrize hideLongDrive];
                    }
                    if ([self.createventModel.straightDrive count] > 0)
                    {
                        isStraightDriveVisible = YES;
                        for (NSInteger counter = 0; counter < [self.createventModel.straightDrive count]; counter++) {
                            NSDictionary *dicSpot = self.createventModel.straightDrive[counter];
                            switch (counter) {
                                    
                                case 0:
                                {
                                    [cellSpotPrize.straightDriveButton3 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.straightDriveButton4.hidden = YES;
                                    cellSpotPrize.straightDriveButton2.hidden = YES;
                                    cellSpotPrize.straightDriveButton1.hidden = YES;
                                }
                                    break;
                                case 1:
                                {
                                    [cellSpotPrize.straightDriveButton4 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.straightDriveButton4.hidden = NO;
                                    cellSpotPrize.straightDriveButton2.hidden = YES;
                                    cellSpotPrize.straightDriveButton1.hidden = YES;
                                }
                                    break;
                                case 2:
                                {
                                    [cellSpotPrize.straightDriveButton2 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    cellSpotPrize.straightDriveButton2.hidden = NO;
                                    cellSpotPrize.straightDriveButton1.hidden = YES;
                                }
                                    break;
                                case 3:
                                {
                                    [cellSpotPrize.straightDriveButton1 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton1.hidden = NO;
                                }
                                    break;
                                    
                            }
                        }
                    }
                    else
                    {
                        isStraightDriveVisible = NO;
                        [cellSpotPrize hideStraightDrive];
                    }
                    
                    if (isClosestPinVisible == YES && isLongDriveVisible == YES && isStraightDriveVisible == NO)
                    {
                        [cellSpotPrize setLine2Visible];
                        [cellSpotPrize setLine3Visible];
                    }
                    
                }
                else
                {
                    cellSpotPrize.contentView.hidden = YES;
                    cellSpotPrize.spotPrizeView.hidden = YES;
                    cellSpotPrize.yesButton.backgroundColor = blueBGColor;
                    [cellSpotPrize.yesButton setTitle:@"NO" forState:UIControlStateNormal];
                    [cellSpotPrize.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellSpotPrize.noButton.hidden = YES;
                    cellSpotPrize.lineView.hidden = YES;
                }
            }
            else
            {
                if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"4+"])
                {
                    
                }
                else{
                    cellSpotPrize.hidden = YES;
                }
                if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsSpotPrize] == YES)
                {
                    BOOL isClosestPinVisible,isLongDriveVisible,isStraightDriveVisible;
                    
                    [cellSpotPrize showSpotOptionsForNumberOfHoles:[[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfHoles] integerValue]];
                    cellSpotPrize.spotPrizeView.hidden = NO;
                    cellSpotPrize.yesButton.backgroundColor = blueBGColor;
                    [cellSpotPrize.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellSpotPrize.noButton.hidden = YES;
                    
                    if ([self isClosestToPinPresent] == NO)
                    {
                        isClosestPinVisible = NO;
                        [cellSpotPrize hideClosestToPin];
                    }
                    else
                    {
                        isClosestPinVisible = YES;
                    }
                    NSMutableArray *arrClosestToPin = [NSMutableArray new];
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] length])
                    {
                        [arrClosestToPin addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData1]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] length])
                    {
                        [arrClosestToPin addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData2]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] length])
                    {
                        [arrClosestToPin addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData3]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] length])
                    {
                        [arrClosestToPin addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent]getSpotPrizeClosestToPinData4]];
                    }
                    
                    for (NSInteger counter = 0; counter < [arrClosestToPin count]; counter++) {
                        switch (counter) {
                            case 0:
                            {
                                [cellSpotPrize.closestToPinButton4 setTitle:arrClosestToPin[counter] forState:UIControlStateNormal];
                                cellSpotPrize.closestToPinButton3.hidden = YES;
                                cellSpotPrize.closestToPinButton2.hidden = YES;
                                cellSpotPrize.closestToPinButton1.hidden = YES;
                            }
                                break;
                            case 1:
                            {
                                [cellSpotPrize.closestToPinButton3 setTitle:arrClosestToPin[counter] forState:UIControlStateNormal];
                                cellSpotPrize.closestToPinButton3.hidden = NO;
                                cellSpotPrize.closestToPinButton2.hidden = YES;
                                cellSpotPrize.closestToPinButton1.hidden = YES;
                            }
                                break;
                            case 2:
                            {
                                [cellSpotPrize.closestToPinButton2 setTitle:arrClosestToPin[counter] forState:UIControlStateNormal];
                                cellSpotPrize.closestToPinButton2.hidden = NO;
                                cellSpotPrize.closestToPinButton1.hidden = YES;
                            }
                                break;
                            case 3:
                            {
                                [cellSpotPrize.closestToPinButton1 setTitle:arrClosestToPin[counter] forState:UIControlStateNormal];
                            
                                cellSpotPrize.closestToPinButton1.hidden = NO;
                            }
                                break;
                            
                        }
                    }
                    
                    if ([self isLongDrivePresent] == NO)
                    {
                        isLongDriveVisible = NO;
                        [cellSpotPrize hideLongDrive];
                    }
                    else
                    {
                        isLongDriveVisible = YES;
                    }
                    
                    NSMutableArray *arrLongDrive = [NSMutableArray new];
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] length])
                    {
                        [arrLongDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] length])
                    {
                        [arrLongDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] length])
                    {
                        [arrLongDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] length])
                    {
                        [arrLongDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4]];
                    }
                    
                    for (NSInteger counter = 0; counter < [arrLongDrive count]; counter++) {
                        switch (counter) {
                            case 0:
                            {
                                [cellSpotPrize.longDriveButton4 setTitle:arrLongDrive[counter] forState:UIControlStateNormal];
                                cellSpotPrize.longDriveButton3.hidden = YES;
                                cellSpotPrize.longDriveButton2.hidden = YES;
                                cellSpotPrize.longDriveButton1.hidden = YES;
                            }
                                break;
                            case 1:
                            {
                                [cellSpotPrize.longDriveButton3 setTitle:arrLongDrive[counter] forState:UIControlStateNormal];
                                cellSpotPrize.longDriveButton3.hidden = NO;
                                cellSpotPrize.longDriveButton2.hidden = YES;
                                cellSpotPrize.longDriveButton1.hidden = YES;
                            }
                                break;
                            case 2:
                            {
                                [cellSpotPrize.longDriveButton2 setTitle:arrLongDrive[counter] forState:UIControlStateNormal];
                                cellSpotPrize.longDriveButton2.hidden = NO;
                                cellSpotPrize.longDriveButton1.hidden = YES;
                            }
                                break;
                            case 3:
                            {
                                [cellSpotPrize.longDriveButton1 setTitle:arrLongDrive[counter] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton1.hidden = NO;
                            }
                                break;
                                
                        }
                    }
                    
                    
                    if ([self isStraightDrivePresent] == NO)
                    {
                        isStraightDriveVisible = NO;
                        [cellSpotPrize hideStraightDrive];
                    }
                    else
                    {
                        isStraightDriveVisible = YES;
                    }
                    
                    NSMutableArray *arrStraightDrive = [NSMutableArray new];
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] length])
                    {
                        [arrStraightDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] length])
                    {
                        [arrStraightDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] length])
                    {
                        [arrStraightDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3]];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] length])
                    {
                        [arrStraightDrive addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4]];
                    }
                    
                    for (NSInteger counter = 0; counter < [arrStraightDrive count]; counter++) {
                        switch (counter) {
                            case 0:
                            {
                                [cellSpotPrize.straightDriveButton4 setTitle:arrStraightDrive[counter] forState:UIControlStateNormal];
                                cellSpotPrize.straightDriveButton3.hidden = YES;
                                cellSpotPrize.straightDriveButton2.hidden = YES;
                                cellSpotPrize.straightDriveButton1.hidden = YES;
                            }
                                break;
                            case 1:
                            {
                                [cellSpotPrize.straightDriveButton3 setTitle:arrStraightDrive[counter] forState:UIControlStateNormal];
                                cellSpotPrize.straightDriveButton3.hidden = NO;
                                cellSpotPrize.straightDriveButton2.hidden = YES;
                                cellSpotPrize.straightDriveButton1.hidden = YES;
                            }
                                break;
                            case 2:
                            {
                                [cellSpotPrize.straightDriveButton2 setTitle:arrStraightDrive[counter] forState:UIControlStateNormal];
                                cellSpotPrize.straightDriveButton2.hidden = NO;
                                cellSpotPrize.straightDriveButton1.hidden = YES;
                            }
                                break;
                            case 3:
                            {
                                [cellSpotPrize.straightDriveButton1 setTitle:arrStraightDrive[counter] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton1.hidden = NO;
                            }
                                break;
                                
                        }
                    }
                    
                    if (isClosestPinVisible == YES && isLongDriveVisible == YES && isStraightDriveVisible == NO)
                    {
                        [cellSpotPrize setLine2Visible];
                        [cellSpotPrize setLine3Visible];
                    }
                }
                else
                {
                    cellSpotPrize.spotPrizeView.hidden = YES;
                    cellSpotPrize.yesButton.backgroundColor = blueBGColor;
                    [cellSpotPrize.yesButton setTitle:@"NO" forState:UIControlStateNormal];
                    [cellSpotPrize.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellSpotPrize.noButton.hidden = YES;
                    cellSpotPrize.lineView.hidden = YES;
                }
            }
            
            
            cell = cellSpotPrize;
            
             
        }
            break;
            
        case PreviewEventCellType_Scorer:
        {
            
            //UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
            //UIColor *whiteBGColor = [UIColor whiteColor];
            PT_EnterScoreTableViewCell *cellEnterScoreScreen = [tableView dequeueReusableCellWithIdentifier:@"SelectFormat"];
            cellEnterScoreScreen.parentController = self;
            if (cellEnterScoreScreen == nil)
            {
                cellEnterScoreScreen = [[[NSBundle mainBundle] loadNibNamed:@"PT_EnterScoreTableViewCell" owner:self options:nil] objectAtIndex:0];
                cellEnterScoreScreen.selectionStyle = UITableViewCellSelectionStyleNone;
                cellEnterScoreScreen.singleButton.userInteractionEnabled = NO;
                cellEnterScoreScreen.multiButton.userInteractionEnabled = NO;
            }
            if (self.isEditMode == NO)
            {
                if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"4+"])
                {
                    cellEnterScoreScreen.hidden = YES;
                }
                if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsScorerTypeRequired] == YES)
                {
                    [cellEnterScoreScreen.contentView setHidden:NO];
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getScorerEntryType] isEqualToString:singleScorerStatic])
                    {
                        cellEnterScoreScreen.multiButton.hidden = YES;
                        cellEnterScoreScreen.singleButton.userInteractionEnabled = NO;
                        
                    }
                    else if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getScorerEntryType] isEqualToString:multiScorerStatic])
                    {
                        cellEnterScoreScreen.multiButton.hidden = YES;
                        cellEnterScoreScreen.singleButton.userInteractionEnabled = NO;
                        [cellEnterScoreScreen.singleButton setTitle:@"MULTI" forState:UIControlStateNormal];
                        
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"1"])
                    {
                        cellEnterScoreScreen.hidden = YES;
                    }
                }
                else
                {
                    
                }
                
            }
            else{
                
                if ([self.createventModel.numberOfPlayers isEqualToString:@"2"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"3"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"4"])
                {
                    [cellEnterScoreScreen.contentView setHidden:NO];
                }
                else
                {
                    [cellEnterScoreScreen.contentView setHidden:YES];
                }
                if (self.createventModel.isSingleScreen == YES)
                {
                    cellEnterScoreScreen.multiButton.hidden = YES;
                    cellEnterScoreScreen.singleButton.userInteractionEnabled = NO;
                }
                else
                {
                    cellEnterScoreScreen.multiButton.hidden = YES;
                    cellEnterScoreScreen.singleButton.userInteractionEnabled = NO;
                    [cellEnterScoreScreen.singleButton setTitle:@"MULTI" forState:UIControlStateNormal];
                }
            }
            cellEnterScoreScreen.singleButton.layer.borderWidth = 1.0;
            cellEnterScoreScreen.singleButton.layer.cornerRadius = 9.0;
            cellEnterScoreScreen.singleButton.layer.masksToBounds = YES;
            
            cellEnterScoreScreen.multiButton.layer.borderWidth = 1.0;
            cellEnterScoreScreen.multiButton.layer.cornerRadius = 9.0;
            cellEnterScoreScreen.multiButton.layer.masksToBounds = YES;
            cell = cellEnterScoreScreen;
            
        }
            break;
            
    }
    
    return cell;
    
    
}

- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (BOOL)isClosestToPinPresent
{
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] length]>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isLongDrivePresent
{
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] length]>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isStraightDrivePresent
{
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] length]>0||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] length]>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (IBAction)actionScorer:(id)sender {
     PT_StartEventViewController*starteventController = [[PT_StartEventViewController alloc] initWithNibName:@"PT_StartEventViewController" bundle:nil];
    [self presentViewController:starteventController animated:YES completion:nil];
}

- (IBAction)actionMore
{
    if (self.isMoreViewParticipants == YES)
    {
        PT_ViewParticipantsViewController *viewParticipants = [[PT_ViewParticipantsViewController alloc] initWithEventModel:self.createventModel];
        viewParticipants.createdEventModel = self.createventModel;
        viewParticipants.previewVC = self;
        [self presentViewController:viewParticipants animated:YES completion:nil];
    }
    else
    {
        float height = self.view.frame.size.height - (self.view.frame.size.height * 40)/100 - 50;
        if (_preview == nil)
        {
            _preview = [[[NSBundle mainBundle] loadNibNamed:@"PT_PreviewMoreView" owner:self options:nil] firstObject];
            _preview.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - height);
            [self.popUpMainView setHidden:YES];
            [self.popupView setHidden:NO];
            [self.popupView addSubview:_preview];
        }
        
        _preview.hidden = NO;
        self.popupView.hidden = NO;
        _preview.delegate = self;
        if (self.self.createventModel.adminId == [[MGUserDefaults sharedDefault] getUserId])
        {
            [_preview setDefaultUIProperties:YES];
        }
        else
        {
            [_preview setDefaultUIProperties:NO];
        }
        
        //Disable View Requests button for players less than 4 and private events
        if ([self.createventModel.numberOfPlayers integerValue] <= 4)//if players less than 4 plus
        {
            [_preview disableRequestButton:YES];
        }
        else
        {
            //Private events will not have request to participate so no requests
            if ([self.createventModel.eventType isEqualToString:PUBLIC])
            {
                [_preview disableRequestButton:NO];
            }
            else
            {
                [_preview disableRequestButton:YES];
            }
        }

    }
    
    
}

-(void)didCancelPreview{
    
    [self.popUpMainView setHidden:YES];
    [self.popupView setHidden:YES];
    _preview.hidden = YES;
    
}


- (void)didSelectViewParticipants
{
    PT_ViewParticipantsViewController *viewParticipants = [[PT_ViewParticipantsViewController alloc] initWithEventModel:self.createventModel];
    viewParticipants.createdEventModel = self.createventModel;
    viewParticipants.previewVC = self;
    [self presentViewController:viewParticipants animated:YES completion:nil];
}

- (void)didSelectViewRequests
{
    PT_ViewRequestsViewController *viewRequests = [[PT_ViewRequestsViewController alloc] initWithEventModel:self.createventModel];
    viewRequests.previewVC = self;
    
    [self presentViewController:viewRequests animated:YES completion:nil];
}

- (void)didSelectEditEvent
{
    if (_createventModel.isStarted == 3) {
        
        [self showAlertWithMessage:@"Event already started can not edit event."];
        
        return;
    }
    PT_CreateViewController *createVC = [[PT_CreateViewController alloc]initWithCreateEventModel:self.createventModel];
    createVC.previewVC = self;
    [self presentViewController:createVC animated:YES completion:nil];
}

- (void)didSelectSelectScorer
{
    PT_SelectScorerMoreOptViewController *sVC = [[PT_SelectScorerMoreOptViewController alloc] initWithNibName:@"PT_SelectScorerMoreOptViewController" bundle:nil];
    sVC.createventModel = self.createventModel;
    [self presentViewController:sVC animated:YES completion:nil];
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
        
        
        NSDictionary *param = @{@"type":@"6",
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createventModel.eventId],
                                @"version":@"2"
                                };
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchBannerPostFix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
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

                                      
                                      [self.bannnerImg setImageWithURL:[NSURL URLWithString:model.eventName]];
                                      self.createventModel.isBannerSaved = YES;
                                      [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isBanner"];
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      NSString *imagePath = dicAtIndex[@"image_path"];
                                      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:model.golfCourseName forKey:@"bannerPath"];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li", (long)self.createventModel.eventId] forKey:@"eventIdOfBanner"];
                                      
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      [[MGUserDefaults sharedDefault] setBannerImage:data];
                                      
                                      self.bannnerView.hidden = NO;

                                      
                                  }else{
                                      
                                    
                                  }
                              }];
                          }
                          else
                          {
                              
                              self.bannnerView.hidden = YES;
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:self.createventModel];
                                  
                                  [self presentViewController:startVC animated:YES completion:nil];
                              });

                              

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
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isBanner"] isEqualToString:@"1"]) {
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"bannerPath"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }else{
    
    if (model.golfCourseName.length == 0) {
        
        
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.golfCourseName]];
    }
    }
    
}


@end
