//
//  PT_ViewRequestsViewController.m
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ViewRequestsViewController.h"

#import "PT_ViewRequestsTableViewCell.h"

#import "PT_InvitationItemModel.h"

#import "PT_ViewRequestsModel.h"

#import "UIKit+AFNetworking.h"

@interface PT_ViewRequestsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_arrRequests;
    IBOutlet UITableView *tableRequests;
    PT_CreatedEventModel *_createdEventModel;
    
    UIButton *currentSelectedButton;
}


@end

@implementation PT_ViewRequestsViewController

- (instancetype)initWithEventModel:(PT_CreatedEventModel *)model
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    _createdEventModel = model;
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    
    [self fetchRequestList];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
    
}
-(void)dealloc
{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 83.5;
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrRequests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_ViewRequestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ViewRequestsTableViewCell"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    PT_ViewRequestsModel *model = _arrRequests[indexPath.row];
    
    NSString *name = [NSString stringWithFormat:@"%@(%li)",model.playerName,model.handicap];
    cell.username.text = name;
    [cell.userImage setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:[UIImage imageNamed:@"add_player"]];
    
    cell.userImage.layer.borderColor = [[UIColor clearColor] CGColor];
    cell.userImage.layer.borderWidth = 1.0f;
    cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width/2;
    cell.userImage.layer.masksToBounds = YES;
    
    if ([model.isAccepted isEqualToString:@"Pending"])
    {
        
    }
    else
    {
        [cell.acceptButton setTitle:@"ACCEPTED" forState:UIControlStateNormal];
        [cell.acceptButton setBackgroundColor:[UIColor colorWithRed:12/255.0 green:159/255.0 blue:50/255.0 alpha:1]];
    }
    
    [cell.acceptButton addTarget:self action:@selector(actionAcceptBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.declineButton addTarget:self action:@selector(actionDeclineBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.acceptButton.tag = indexPath.row;
    cell.declineButton.tag = indexPath.row;
    return cell;
}

- (void)actionAcceptBtnClicked:(UIButton *)sender
{
    currentSelectedButton = sender;
    //[sender setTitle:@"ACCEPTED" forState:UIControlStateNormal];
    //[sender setBackgroundColor:[UIColor colorWithRed:12/255.0 green:159/255.0 blue:50/255.0 alpha:1]];
    [self acceptOrRejectInvitationwithStatus:@"1"];
}

- (void)actionDeclineBtnClicked:(UIButton *)sender
{
    currentSelectedButton = sender;
    //[_arrRequests removeObjectAtIndex:sender.tag];
    
    //[tableRequests reloadData];
    
    [self acceptOrRejectInvitationwithStatus:@"2"];
    
}

- (IBAction)actionBack
{
    self.previewVC.isEditMode = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark - Service Requests

- (void)fetchRequestList
{
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
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li",(long)_createdEventModel.eventId],
                                @"admin_id":[NSString stringWithFormat:@"%li",(long)_createdEventModel.adminId],
                                @"version":@"2"
                                };
        
        NSString *urlString = @"http://clients.vfactor.in/puttdemo/geteventrequestlist";
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
                                  _arrRequests = [NSMutableArray new];
                                  NSDictionary *dicData = dicOutput[@"data"];
                                  NSArray *arrinvitations = dicData[@"Request"];
                                  
                                  [arrinvitations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicInvitation = obj;
                                      PT_ViewRequestsModel *model = [PT_ViewRequestsModel new];
                                      model.isAccepted = dicInvitation[@"is_accepted"];
                                      model.eventId = [dicInvitation[@"event_id"] integerValue];
                                      model.eventName = dicInvitation[@"event_name"];
                                      model.playerId = [dicInvitation[@"user_id"] integerValue];
                                      model.playerName = dicInvitation[@"user"];
                                      model.photo_url = dicInvitation[@"photo_url"];
                                      model.handicap = [dicInvitation[@"handicap"] integerValue];
                                      model.isEventStarted = dicInvitation[@"is_started"];
                                      
                                      [_arrRequests addObject:model];
                                      if (idx == [_arrRequests count] - 1)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [tableRequests reloadData];
                                          });
                                      }
                                      
                                  }];
                              }
                              else
                              {
                                  //Pop up message
                                  NSDictionary *dicOutput = responseData[@"output"];
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:dicOutput[@"message"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
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

- (void)acceptOrRejectInvitationwithStatus:(NSString *)status
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
        PT_ViewRequestsModel *requestModel = _arrRequests[currentSelectedButton.tag];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li",(long)requestModel.eventId],
                                @"user_id":[NSString stringWithFormat:@"%li",(long)requestModel.playerId],
                                @"status":status,
                                @"version":@"2"
                                };
        
        NSString *urlString = @"http://clients.vfactor.in/puttdemo/accepteventinvitation";
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
                                  //NSDictionary *dicData = dicOutput[@"data"];
                                  if ([dicOutput[@"message"] isEqualToString:@"Accepted"])
                                  {
                                      [currentSelectedButton setTitle:@"ACCEPTED" forState:UIControlStateNormal];
                                      [currentSelectedButton setBackgroundColor:[UIColor colorWithRed:12/255.0 green:159/255.0 blue:50/255.0 alpha:1]];
                                  }
                                  else if ([dicOutput[@"message"] isEqualToString:@"Rejected"])
                                  {
                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PUTT2GETHER" message:@"Do you want to reject the request?" preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                          [alert dismissViewControllerAnimated:YES completion:nil];

                                      }];
                                      
                                      UIAlertAction *actionReject = [UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                          
                                          [_arrRequests removeObjectAtIndex:currentSelectedButton.tag];
                                          
                                          [tableRequests reloadData];
                                          
                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                          
                                      }];
                                      
                                      [alert addAction:actionCancel];
                                      [alert addAction:actionReject];
                                      
                                      [self presentViewController:alert animated:YES completion:nil];
                                      
                                  }
                                  currentSelectedButton = nil;
                                  [self showAlertWithMessage:dicOutput[@"message"]];
                                  
                                  
                              }
                              else
                              {
                                  //Pop up message
                                  NSDictionary *dicOutput = responseData[@"output"];
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:dicOutput[@"message"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
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

@end
