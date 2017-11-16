//
//  PT_InviteViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_InviteViewController.h"

#import "PT_CreateViewController.h"

#import "MGMainDAO.h"

#import "UIView+Hierarchy.h"

#import "addPatcipantsVCViewController.h"

#import "PT_InvitationItemModel.h"

#import "PT_CreatedEventModel.h"

#import "PT_CreateViewController.h"

#import "PT_EventPreviewViewController.h"

#import "PT_MyScoresModel.h"

#import "UIImageView+AFNetworking.h"

#import "PT_CalenderViewController.h"


static NSString *const FetchBannerPostFix = @"getadvbanner";



static NSString *const GetGolfCoursePostFix = @"getnearestgolfcourse";

@interface PT_InviteViewController ()
{
    IBOutlet UILabel *titleLabel;
}

@property (strong, nonatomic) NSMutableArray *arrInvitations,*arrBanner;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property(weak,nonatomic) IBOutlet UILabel *headerLabel;
//For Request to participate
@property (assign, nonatomic) BOOL isRequestToParticipate;
@property (strong, nonatomic) NSString *golfCourseId;
@property (strong, nonatomic) NSString *dateSelected;

@property (strong, nonatomic) NSString *titleString;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint *heightConstraintBanner;

@end

@implementation PT_InviteViewController

- (instancetype)initWithDate:(NSString *)date andGolfCourse:(NSString *)golfCourseId
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    self.isRequestToParticipate = YES;
    self.golfCourseId = golfCourseId;
    self.dateSelected  = date;
    self.titleString = @"EVENT LISTING";
    
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.titleString.length > 0)
    {
        titleLabel.text = self.titleString;
    }
    [self.tableView registerClass:[CustomCell class]
           forCellReuseIdentifier:@"Cell"];
    
    self.tableView.tableFooterView = [[UIView new] initWithFrame:CGRectZero];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self fetchBannerDetail];

    //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultValues];
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.isRequestToParticipate == YES)
    {
        self.footerView.hidden = YES;
        [self fetchInviteListForDate:self.dateSelected andGolfCourse:self.golfCourseId];
    }
    else
    {
        [self fetchInviteList];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
   
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrInvitations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellIdentifier =@"cell";
        
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == Nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:Nil];
            
            cell = [nib objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
            PT_InvitationItemModel *model = self.arrInvitations[indexPath.row];
            
            cell.eventNameLabel.text = model.eventName;
            cell.timeLabel.text = model.eventStartTime;
            cell.dateLabel.text = model.startDate;
            cell.adminLabel.text = @"ADMIN:";
            //cell.adminNameLabel.text = [[MGUserDefaults sharedDefault] getDisplayName];
    cell.adminNameLabel.text = model.admin;
            cell.venueNameLabel.text = model.golfCourseName;
    cell.editButton.tag = indexPath.row;
    cell.declineButton.tag = indexPath.row;
    cell.accptButton.tag = indexPath.row;
    cell.bannerBtn.tag = indexPath.row;
    
    if ([model.bannerImg isEqualToString:@""]) {
        
        [cell.bannerImg setHidden:YES];
        
    }else{
        [cell.bannerImg setHidden:NO];
 [cell.bannerBtn addTarget:self action:@selector(actionBannerTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bannerImg setImageWithURL:[NSURL URLWithString:model.bannerImg]];
    }
    
    if (self.isRequestToParticipate == YES)
    {
        cell.editButton.hidden = YES;
        cell.declineButton.hidden = YES;
        cell.accptButton.hidden = YES;
        
        [cell.editButton addTarget:self action:@selector(actionRequestForEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.editButton.layer.cornerRadius = 5;
        cell.editButton.clipsToBounds = YES;
        
        [cell.editButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        
        cell.editButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
        
        [cell.editButton setBackgroundColor:[UIColor colorWithRed:6/255.0
                                                            green:68/255.0
                                                             blue:116/255.0
                                                            alpha:1]];
        
        [cell.editButton setTitle:@"REQUEST" forState:UIControlStateNormal];
    }
    else
    {
        //edit button
        
        if ([model.isStarted isEqualToString:@"Started"]|| [model.isEventStarted isEqualToString:@"Closed"])
        {
            
        }
        else
        {
            [cell.editButton addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.editButton.layer.cornerRadius = 5;
        cell.editButton.clipsToBounds = YES;
        
        [cell.editButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        
        cell.editButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
        
        //decline button
        
        
        
        cell.declineButton.layer.cornerRadius = 5;
        cell.declineButton.clipsToBounds = YES;
        [cell.declineButton setBackgroundColor:[UIColor colorWithRed:237/255.0
                                                               green:28/255.0
                                                                blue:36/255.0
                                                               alpha:1]];
        [cell.declineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.declineButton setTitle:@"DECLINE" forState:UIControlStateNormal];
        cell.declineButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
        //accptbutton
        
        
        cell.accptButton.layer.cornerRadius =5;
        cell.accptButton.clipsToBounds = YES;
        [cell.accptButton setBackgroundColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1]];
        [cell.accptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        cell.accptButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
        
        
        NSLog(@"UserId:-->%li",[[MGUserDefaults sharedDefault] getUserId]);
        NSLog(@"UserId Model:-->%li",model.adminId);
        
        if ([[MGUserDefaults sharedDefault] getUserId] == model.adminId)
        {
            [cell.editButton setTitle:@"EDIT" forState:UIControlStateNormal];
            [cell.editButton setBackgroundColor:[UIColor colorWithRed:6/255.0
                                                                green:68/255.0
                                                                 blue:116/255.0
                                                                alpha:1]];
            [cell.accptButton setTitle:[ACCEPTED uppercaseString] forState:UIControlStateNormal];
            [cell.accptButton setBackgroundColor:[UIColor colorWithRed:12/255.0 green:159/255.0 blue:50/255.0 alpha:1]];
            [cell.declineButton setUserInteractionEnabled:NO];
            
            
        }
        else
        {
            [cell.editButton setTitle:@"DETAILS" forState:UIControlStateNormal];
            [cell.editButton setBackgroundColor:[UIColor lightGrayColor]];
            if ([model.isAccepted isEqualToString:@"Pending"])
            {
                [cell.accptButton setTitle:[ACCEPT uppercaseString] forState:UIControlStateNormal];
                [cell.accptButton addTarget:self action:@selector(accptBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.declineButton addTarget:self action:@selector(declineBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                [cell.accptButton setTitle:[ACCEPTED uppercaseString] forState:UIControlStateNormal];
                [cell.accptButton addTarget:self action:@selector(accptBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.accptButton.backgroundColor = [UIColor colorWithRed:12/255.0
                                                                   green:159/255.0
                                                                    blue:50/255.0
                                                                   alpha:1];
            }
            
        }
    }
    
    
    
    
    
    
        return cell;

    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PT_InvitationItemModel *model = self.arrInvitations[indexPath.row];
    
    [self fetchEvent:model withType:InviteType_Detail];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequestToParticipate == YES)
    {
        return 117.0f;
    }
    else
    {
        return 157.0f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addBtnClicked
{
    if ([self.arrGolfCoursesList count]>0)
    {
        addPatcipantsVCViewController *selctGC = [[addPatcipantsVCViewController alloc] initWithDelegate:self andGolfCourseList:self.arrGolfCoursesList];
        
        [self presentViewController:selctGC animated:YES completion:nil];
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


#pragma mark - Action Methods

- (void)actionRequestForEvent:(UIButton *)sender
{
    PT_InvitationItemModel *model = self.arrInvitations[sender.tag];
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
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":userId,
                                @"event_id":eventId,
                                @"type":@"1",
                                @"version":@"2"
                                };
        
        NSString *urlString = @"eventdetail";
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.tableView animated:YES];
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
                                      [sender setTitle:@"PENDING" forState:UIControlStateNormal];
                                  });
                                  [self showAlertWithMessage:@"YOUR REQUEST HAS BEEN SENT TO THE ADMIN."];
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

- (void)editBtnClicked:(UIButton *)sender
{
    PT_InvitationItemModel *model = self.arrInvitations[sender.tag];
    if ([[MGUserDefaults sharedDefault] getUserId] == model.adminId)
    {
        [self fetchEvent:model withType:InviteType_Edit];
    }
    else
    {
        [self fetchEvent:model withType:InviteType_Detail];
    }
    

    
}

//Mark:- action method for banner images
-(void)actionBannerTapped:(UIButton *)sender
{
    PT_InvitationItemModel *model = _arrInvitations[sender.tag];
    
    if (model.bannerHref.length == 0) {
        
        
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.bannerHref]];
    }

    
}

- (void)declineBtnClicked:(UIButton *)sender {
    
    
    PT_InvitationItemModel *model = self.arrInvitations[sender.tag];
    //if ([model.isStarted isEqualToString:@"Started"]|| [model.isEventStarted isEqualToString:@"Closed"])
    {
        
    }
    //else
    {
       
        [self acceptOrRejectForModel:model status:@"2" indexNumber:sender];
    }
    
    
}
- (IBAction)accptBtnClicked:(UIButton *)sender
{
    PT_InvitationItemModel *model = self.arrInvitations[sender.tag];
    
    //if ([model.isStarted isEqualToString:@"Started"]|| [model.isEventStarted isEqualToString:@"Closed"])
    {
        
    }
    //else
    {
        [self acceptOrRejectForModel:model status:@"1" indexNumber:sender];
    }
}


- (IBAction)homeBtnClicked:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate addTabBarAsRootViewController];
    
//    UIViewController *vc = self.presentingViewController;
//    while (vc.presentingViewController) {
//        vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:NULL];
        
    });
}
- (IBAction)addBtnClicked:(id)sender {
    
    addPatcipantsVCViewController *partcipantsViewController = [[addPatcipantsVCViewController alloc] initWithNibName:@"addPatcipantsVCViewController" bundle:nil];
    [self presentViewController:partcipantsViewController animated:YES completion:nil];
    [_addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
}
- (IBAction)backBtnClicked:(UIButton *)sender {
    if (self.isRequestToParticipate == YES)
    {
        
        PT_InvitationItemModel *countryModel = _arrInvitations[sender.tag];
        
        PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
        model.golfCourseName = countryModel.golfCourseName;
        model.golfCourseId = countryModel.golfCourseid;
       // model.golfCourseHasEvent = countryModel.countryHasEvent;
        model.golfCourseLocation = countryModel.location;

        PT_CalenderViewController *calenderVC = [[PT_CalenderViewController alloc] initWithGolfCourse:model];
        [self presentViewController:calenderVC animated:YES completion:nil];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate addTabBarAsRootViewController];
    }
    
   
}

#pragma mark - Service Calls

- (void)acceptOrRejectForModel:(PT_InvitationItemModel *)model status:(NSString *)status indexNumber:(UIButton *)sender
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
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSLog(@"RECEIVED INVTES");
                              NSDictionary *dicOutput = responseData[@"output"];
                              //Check Success
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  if ([status isEqualToString:@"1"])
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [sender setTitle:@"ACCEPTED" forState:UIControlStateNormal];
                                          [sender setBackgroundColor:[UIColor colorWithRed:12/255.0 green:159/255.0 blue:50/255.0 alpha:1]];
                                      });
                                      
                                  }
                                  else //if ([status isEqualToString:@"0"])
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          NSArray *insertIndexPaths = [[NSArray alloc] initWithObjects:
                                                                       [NSIndexPath indexPathForRow:sender.tag inSection:0],
                                                                       nil];
                                          [self.tableView beginUpdates];
                                         
                                          [self.tableView deleteRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                                          [self.tableView endUpdates];
                                          [self.arrInvitations removeObjectAtIndex:sender.tag];
                                          //[self.tableView reloadData];
                                      });
                                      
                                      
                                  }
                              }
                              else
                              {
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

- (void)fetchEvent:(PT_InvitationItemModel *)model withType:(InviteType)type
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
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                  
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
                                      model.closestPin = [NSArray new];
                                
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
                                              if (type == InviteType_Edit)
                                              {
                                                  PT_CreateViewController *createVC = [[PT_CreateViewController alloc]initWithCreateEventModel:model];
                                                  
                                                  [self presentViewController:createVC animated:YES completion:nil];
                                              }
                                              else{
                                                  PT_EventPreviewViewController *createVC = [[PT_EventPreviewViewController alloc]initWithModel:model andIsRequestToParticipate:self.isRequestToParticipate];
                                                  
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
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }

}

- (void)fetchInviteList
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];;
    }
    else
    {
#if (TARGET_OS_SIMULATOR)

        delegate.latestLocation = [[CLLocation alloc] initWithLatitude:28.5922729 longitude:77.33453080000004];
        
#endif
        //[self showLoadingView:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        
        NSString *urlString = @"geteventinvitationlist";
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSLog(@"RECEIVED INVTES");
                              NSDictionary *dicOutput = responseData[@"output"];
                              //Check Success
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  _arrInvitations = [NSMutableArray new];
                                  NSDictionary *dicData = dicOutput[@"data"];
                                  NSArray *arrinvitations = dicData[@"Invitation"];
                                  self.arrInvitations = [NSMutableArray new];
                                  if (arrinvitations != nil && [dicData[@"Invitation"] isKindOfClass:[NSArray class]])
                                  {
                                      [arrinvitations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          NSDictionary *dicInvitation = obj;
                                          PT_InvitationItemModel *model = [PT_InvitationItemModel new];
                                          model.addPlayerType = dicInvitation[@"add_player_type"];
                                          model.admin = dicInvitation[@"admin"];
                                          model.adminId = [dicInvitation[@"admin_id"] integerValue];
                                          model.createdDate = dicInvitation[@"creation_date"];
                                          model.eventDisplaynumber = [dicInvitation[@"event_display_number"] integerValue];
                                          model.eventId = [dicInvitation[@"event_id"] integerValue];
                                          model.eventName = [dicInvitation[@"event_name"] uppercaseString];
                                          model.eventStartTime = dicInvitation[@"event_start_time"];
                                          model.formatId = [dicInvitation[@"format_id"] integerValue];
                                          model.formatName = dicInvitation[@"formate_name"] ;
                                          model.golfCourseid = [dicInvitation[@"golf_course_id"] integerValue];
                                          model.golfCourseName = [dicInvitation[@"golf_course_name"] uppercaseString];
                                          model.isAccepted = dicInvitation[@"is_accepted"];
                                          model.isEdit = dicInvitation[@"is_edit"];
                                          model.isStarted = dicInvitation[@"is_started"];
                                          model.isSubmitScore = [dicInvitation[@"is_submit_score"] integerValue];
                                          model.location = dicInvitation[@"location"];
                                          model.playerId = [dicInvitation[@"player_id"] integerValue];
                                          model.readsatus = [dicInvitation[@"read_status"] integerValue];
                                          model.startDate = dicInvitation[@"start_date"];
                                          model.isEventStarted = dicInvitation[@"is_started"];
                                          model.bannerImg = dicInvitation[@"banner_image"];
                                          model.bannerHref = dicInvitation[@"banner_href"];
                                          [self.arrInvitations addObject:model];
                                          if (idx == [arrinvitations count] - 1)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [self.tableView reloadData];
                                                  CATransition *transition = [CATransition animation];
                                                  transition.type = kCATransitionPush;
                                                  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                  transition.fillMode = kCAFillRuleNonZero;
                                                  transition.duration = 0.6;
                                                  transition.subtype = kCATransitionFromBottom;
                                                  
                                                  [self.tableView.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
                                              });
                                          }
                                          
                                      }];
                                  }
                                  
                              }
                              else
                              {
                                  //Pop up message
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:@"No data Found"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                               delegate.tabBarController.tabBar.hidden = NO;
                                                               [delegate addTabBarAsRootViewController];

                                                               //[self actionBAck];
                                                               
                                                               
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
                      [self fetchInviteList];
                  }
                  
                  
              }];
    }

}

- (void)fetchInviteListForDate:(NSString *)date andGolfCourse:(NSString *)golfCourse
{
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
        NSDictionary *param = @{@"current_date":date,
                                @"golf_course_id":golfCourse,
                                @"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        
        NSString *urlString = @"geteventperdate";
        [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                  NSLog(@"Response:-%@",responseData);
                  [_headerLabel setText:@"Event Listing"];
                 // [_backBTN setTitle:@"Event Listing" forState:UIControlStateNormal];
                  _footerView.hidden = NO;
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSLog(@"RECEIVED INVTES");
                              NSDictionary *dicOutput = responseData[@"output"];
                              //Check Success
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  _arrInvitations = [NSMutableArray new];
                                  id data = dicOutput[@"data"];
                                  if (!([data isKindOfClass:[NSNull class]]))
                                  {
                                      NSArray *arrinvitations = dicOutput[@"data"];
                                      //NSArray *arrinvitations = dicData[@"Invitation"];
                                      self.arrInvitations = [NSMutableArray new];
                                      
                                      [arrinvitations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          NSDictionary *dicInvitation = obj;
                                          PT_InvitationItemModel *model = [PT_InvitationItemModel new];
                                          model.addPlayerType = dicInvitation[@"add_player_type"];
                                          model.admin = dicInvitation[@"admin"];
                                          model.adminId = [dicInvitation[@"admin_id"] integerValue];
                                          model.createdDate = dicInvitation[@"creation_date"];
                                          model.eventDisplaynumber = [dicInvitation[@"event_display_number"] integerValue];
                                          model.eventId = [dicInvitation[@"event_id"] integerValue];
                                          model.eventName = [dicInvitation[@"event_name"] uppercaseString];
                                          model.eventStartTime = dicInvitation[@"event_start_time"];
                                          model.formatId = [dicInvitation[@"format_id"] integerValue];
                                          model.formatName = [dicInvitation[@"formate_name"] uppercaseString];
                                          model.golfCourseid = [dicInvitation[@"golf_course_id"] integerValue];
                                          model.golfCourseName = [dicInvitation[@"golf_course_name"] uppercaseString];
                                          model.isAccepted = dicInvitation[@"is_accepted"];
                                          model.isEdit = dicInvitation[@"is_edit"];
                                          model.isStarted = dicInvitation[@"is_started"];
                                          model.isSubmitScore = [dicInvitation[@"is_submit_score"] integerValue];
                                          model.location = dicInvitation[@"location"];
                                          model.playerId = [dicInvitation[@"player_id"] integerValue];
                                          model.readsatus = [dicInvitation[@"read_status"] integerValue];
                                          model.startDate = dicInvitation[@"start_date"];
                                          model.isEventStarted = dicInvitation[@"is_started"];
                                          
                                          
                                          [self.arrInvitations addObject:model];
                                          if (idx == [arrinvitations count] - 1)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [self.tableView reloadData];
                                                  
                                              });
                                          }
                                          
                                      }];
                                  }
                                  
                              }
                              else
                              {
                                  [self showAlertWithMessage:@"No Event Found"];
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
        
        
        NSDictionary *param = @{@"type":@"1",
                                @"event_id":@"0",
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
                                  [self.arrBanner addObject:model];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      [self.bannerImage setImageWithURL:[NSURL URLWithString:model.eventName]];
                                  }else{
                                      
                                      [self.bannerImage removeFromSuperview];
                                      [self.bannerBtn removeFromSuperview];
                                  }
                              }];
                          }
                          else
                          {
                              [self.bannerImage removeFromSuperview];
                              [self.bannerBtn removeFromSuperview];
                              //self.heightConstraintBanner.constant = 0.0f;
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
