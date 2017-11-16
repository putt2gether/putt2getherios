//
//  PT_MyGroupsViewController.m
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_MyGroupsViewController.h"
#import "PT_MoreViewController.h"

#import "PT_MygroupsTableViewCell.h"

#import "PT_CreateGroupViewController.h"

#import "PT_GroupItemModel.h"

#import "UIKit+AFNetworking.h"

static NSString *const GroupListPostfix = @"getgrouplist";

static NSString *const deletegroupPostfix = @"deletegroup";


@interface PT_MyGroupsViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *arrAddedGroups;
}


@end

@implementation PT_MyGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchFriendsGoups];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)actionBack:(id)sender{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate.tabBarController setSelectedIndex:4];
    //[self actionBAck];
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)actionHome:(id)sender{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate addTabBarAsRootViewController];
    //[self actionBAck];
//    UIViewController *vc = self.presentingViewController;
//    while (vc.presentingViewController) {
//        vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:NULL];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrAddedGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier =@"cell";
    
    PT_MygroupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == Nil)
    {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_MygroupsTableViewCell" owner:self options:Nil] firstObject];
        
        
        
        cell.arrowBtn.tag = indexPath.row;
        [cell.arrowBtn addTarget:self action:@selector(arrowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    
    cell.playerImage.layer.cornerRadius = cell.playerImage.frame.size.height/2;
    cell.playerImage.clipsToBounds = YES;
    PT_GroupItemModel *model = arrAddedGroups[indexPath.row];
    NSString *groupNameStr = [NSString stringWithFormat:@"%@ %li",model.groupName,(long)model.arrGroupMembers.count];
    cell.nameLabel.text = groupNameStr;
    [cell.playerImage setImageWithURL:[NSURL URLWithString:model.groupImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PT_GroupItemModel *model = arrAddedGroups[indexPath.row];
    PT_CreateGroupViewController *creategroupVC = [[PT_CreateGroupViewController alloc] initWithModel:model andType:GroupType_Members];
    [self presentViewController:creategroupVC animated:YES completion:nil];

    
}

-(void)arrowBtnClicked:(UIButton *) sender{
    
    PT_GroupItemModel *model = arrAddedGroups[sender.tag];
    PT_CreateGroupViewController *creategroupVC = [[PT_CreateGroupViewController alloc] initWithModel:model andType:GroupType_Members];
    [self presentViewController:creategroupVC animated:YES completion:nil];
    
    
}

- (IBAction)actionAddNewGroup
{
    PT_CreateGroupViewController *creategroupVC = [[PT_CreateGroupViewController alloc] initWithModel:nil andType:GroupType_CreateGroup];
    [self presentViewController:creategroupVC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        PT_GroupItemModel *model = arrAddedGroups[indexPath.row];

        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"group_id":[NSNumber numberWithInteger:model.groupId],
                                @"version":@"2"
                                };
        NSLog(@"%@",param);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,deletegroupPostfix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSDictionary *dicResponseData = responseData;
                              NSDictionary *dicOutput = dicResponseData[@"output"];
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  NSString *message = dicOutput[@"message"];
                                  
                                  
                                  
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:message
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
                      
                      else
                      {
                          
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  }
                  
                  
              }];
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

#pragma mark - Web Service calls

- (void)fetchFriendsGoups
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,GroupListPostfix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"output"])
                              {
                                  NSDictionary *dataOutput = responseData[@"output"];
                                  NSArray *suggestionList = dataOutput[@"data"];
                                  arrAddedGroups = [NSMutableArray new];
                                  if ([dataOutput[@"status"] integerValue] == 1)
                                  {
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          
                                          NSDictionary *dataObj = obj;
                                          PT_GroupItemModel *groupModel = [PT_GroupItemModel new];
                                          groupModel.groupId = [dataObj[@"group_id"] integerValue];
                                          groupModel.groupName = dataObj[@"group_name"];
                                          groupModel.groupImageURL = dataObj[@"profile_img"];
                                          groupModel.arrGroupMembers = dataObj[@"group_member_id"];
                                          [arrAddedGroups addObject:groupModel];
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [self.tableView reloadData];
                                                  
                                              });
                                              
                                          }
                                          
                                      }];
                                  }
                                  else
                                  {
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
                              else
                              {
                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
                                  [self showAlertWithMessage:messageError];
                              }
                              
                          }
                      }
                      
                      else
                      {
                          
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  }
                  
                  
              }];
    }
    
}


@end
