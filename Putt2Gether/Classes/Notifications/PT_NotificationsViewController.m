//
//  PT_NotificationsViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_NotificationsViewController.h"
#import "PT_HomeViewController.h"
#import "PT_NotificationsModel.h"

#import "PT_StartEventViewController.h"

#import "PT_CreateViewController.h"

#import "PT_ViewRequestsViewController.h"

#import "PT_PreviewMoreView.h"

#import "PT_MyScoresModel.h"

#import "UIImageView+AFNetworking.h"

static NSString *const FetchBannerPostFix = @"getadvbanner";


static NSString *const GetNotificationPostfix = @"getusernotification";

@interface PT_NotificationsViewController ()<PT_PreviewMoreDelegate>
{
    
    NSMutableArray *arrNotifications,*indexArr;
    
    NSInteger notificationId;
    
}


@property(nonatomic,strong) NSAttributedString *attrString;

@property(nonatomic,strong)  PT_CreatedEventModel*createdEventModel;

@property(nonatomic,strong) NSMutableArray *arrCreated,*arrBanner;

@property (assign, nonatomic) BOOL isRequestToParticipate;



@end

@implementation PT_NotificationsViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [[NSMutableArray alloc] initWithObjects:@"YOUR EVENT 'BUNNY EVENT' IS SCHEDULED IN 15 MINS",@"NOTIFICATIONS2",@"NOTIFICATIONS3",@"NOTIFY4", nil];
    
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    indexArr = [NSMutableArray new];
    
    [self fetchBannerDetail];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchNotifications];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// number of row in the section,
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrNotifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.textLabel.textColor = [UIColor blackColor];
        
    }
    
    // Set the data for this cell:
    PT_NotificationsModel *model = arrNotifications[indexPath.row];
    
    NSString *str = [model.message uppercaseString];
    
    _attrString = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];
    cell.textLabel.attributedText = _attrString;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping; // Pre-iOS6 use UILineBreakModeWordWrap
    
    
    
    if (model.readStatus > 0 && model.pushType > 0) {
        
        [self setCellColor:[UIColor blackColor] ForCell:cell];
        
    }else if (model.pushType == 0){
        
        [self setCellColor:[UIColor lightGrayColor] ForCell:cell];
        
    }
    else if ([indexArr containsObject:indexPath]){
        
        if (model.readStatus > 0) {
            [self setCellColor:[UIColor blackColor] ForCell:cell];  //highlight colour
            
        }else{
            
            [self setCellColor:[UIColor lightTextColor] ForCell:cell];
            
        }
        //cell.contentView.backgroundColor = [UIColor lightTextColor];
    }
    
    else{
        
        cell.backgroundColor = [UIColor colorFromHexString:@"#cfe9f9"];
        //[indexArr addObject:indexPath];
    }
    
    cell.detailTextLabel.text = model.send_date;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.numberOfLines = 4;
    cell.imageView.image = [UIImage imageNamed:@"dot1x"];
    
    
    
    
    return cell;
}
/*
 - (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 
 
 - (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
 // Add your Colour.
 UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
 [self setCellColor:[UIColor lightGrayColor] ForCell:cell];  //highlight colour
 }
 
 
 - (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
 // Reset Colour.
 UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
 [self setCellColor:[UIColor whiteColor] ForCell:cell]; //normal color
 
 }
 */
- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    // cell.backgroundColor = color;
    cell.textLabel.textColor = color;
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [indexArr addObject:indexPath];
    
    PT_NotificationsModel *model = arrNotifications[indexPath.row];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    notificationId = model.alertID;
    
    if (model.pushType == 0){
        
        
        
    }else{
        
        [self notificationReadCount];
        
    }
    
    
    PT_CreatedEventModel *model2 = [PT_CreatedEventModel new];
    
    model2.adminId = model.adminID;
    model2.eventId = model.eventID;
    model2.eventstartDateTime = model.send_date;
    
    
    
    //    if (model.readStatus > 0) {
    //
    ////        NSLog(@"Message already Read");
    ////        UIAlertController * alert=   [UIAlertController
    ////                                      alertControllerWithTitle:@"PUTT2GETHER"
    ////                                      message:@"Message already Read!"
    ////                                      preferredStyle:UIAlertControllerStyleAlert];
    ////
    ////
    ////
    ////        UIAlertAction* cancel = [UIAlertAction
    ////                                 actionWithTitle:@"Ok"
    ////                                 style:UIAlertActionStyleDefault
    ////                                 handler:^(UIAlertAction * action)
    ////                                 {
    ////                                     [alert dismissViewControllerAnimated:YES completion:nil];
    ////
    ////                                 }];
    ////
    ////        [alert addAction:cancel];
    ////
    ////        [self presentViewController:alert animated:YES completion:nil];
    //
    //
    //    }else
    //
    //    {
    //    }
    if ((model.pushType == 2) || (model.pushType == 3) || (model.pushType == 4) || (model.pushType == 6) || (model.pushType == 8) || (model.pushType == 9))  {
        
        [self fetchEvent:model withType:InviteType_Detail];
        
    }else if (model.pushType == 5){
        
        
        
        PT_StartEventViewController *startVC = [[PT_StartEventViewController alloc] initWithEvent:model2];
        
        [self presentViewController:startVC animated:YES completion:nil];
        
    }else if (model.pushType == 7){
        
        PT_ViewRequestsViewController *viewRequests = [[PT_ViewRequestsViewController alloc] initWithEventModel:model2];
        //viewRequests.previewVC = self;
        
        [self presentViewController:viewRequests animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
    //[indexArr addObject:[NSNumber numberWithInt:selectedRow]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)notifiBtnClicked:(id)sender {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate addTabBarAsRootViewController];
    
}


- (void)fetchNotifications
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];;
    }
    else
    {
        
        //[self showLoadingView:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,GetNotificationPostfix];
        [MBProgressHUD showHUDAddedTo:self.myTableView animated:YES];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  //[self showLoadingView:NO];
                   [MBProgressHUD hideHUDForView:self.myTableView animated:YES];
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
                                  
                                  if ([arrData isKindOfClass:[NSArray class]])
                                  {
                                      if (arrNotifications == nil)
                                      {
                                          arrNotifications = [NSMutableArray new];
                                      }
                                      
                                      
                                      [arrNotifications removeAllObjects];
                                      
                                      [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          NSDictionary *dicAtIndex = obj;
                                          PT_NotificationsModel *model = [PT_NotificationsModel new];
                                         // model.subject = dicAtIndex[@"subject"];
                                          model.message = dicAtIndex[@"message"];
                                          model.send_date = dicAtIndex[@"send_date"];
                                          model.readStatus = [dicAtIndex[@"read_status"] integerValue];
                                          model.alertID = [dicAtIndex[@"alert_id"] integerValue];
                                          model.pushType = [dicAtIndex[@"push_type"] integerValue];
                                          model.eventID = [dicAtIndex[@"event_id"] integerValue];
                                          model.adminID = [dicAtIndex[@"admin_id"] integerValue];
                                          [arrNotifications addObject:model];
                                        
                                          
                                          if (idx == [arrData count] - 1)
                                          {
                                              
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  
                                                  [self.myTableView reloadData];
                                                  
                                                  
                                              });
                                             
                                          }
                                      }];
                                  }
                                  
                              }
                              else
                              {
                                  [MBProgressHUD hideHUDForView:self.myTableView animated:YES];
                                  
                                  //Pop up message
                              }
                          }
                      }
                      
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.myTableView animated:YES];
                      [self showAlertWithMessage:@"Connection Lost."];
                      //Error pop up
                  }
                  
                  
              }];
    }
}


-(void)notificationReadCount
{
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];;
    }
    else
    {
        
        //[self showLoadingView:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2",
                                @"notification_id":[NSNumber numberWithInteger:notificationId],
                                @"is_read":@"1"
                                };
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"marknotificationisread"];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
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
                                  
                              }
                              else
                              {
                                  //Pop up message
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


//Mark:-for sending on event Listing
- (void)fetchEvent:(PT_NotificationsModel *)model withType:(InviteType)type
{
    NSString *eventId = [NSString stringWithFormat:@"%li",model.eventID];
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
        [MBProgressHUD showHUDAddedTo:self.myTableView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.myTableView animated:YES];
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
        
        
        NSDictionary *param = @{@"type":@"7",
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
                                  [_arrBanner addObject:model];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      [self.bannerImage setImageWithURL:[NSURL URLWithString:model.eventName]];
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



@end
