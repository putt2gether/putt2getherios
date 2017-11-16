//
//  PT_AddMembersViewController.m
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_AddMembersViewController.h"

#import "PT_CreateGroupTableViewCell.h"

#import "PT_AddMemberTableViewCell.h"

#import "PT_GroupMembersModel.h"

#import "PT_PlayerProfileViewController.h"

static NSString *const SuggestedFriendsPostfix = @"getgroupsuggessionfriendlist";

static NSString *const addPlayerPostFix = @"addgroupmember";


@interface PT_AddMembersViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    NSMutableArray *arrName;
    NSString *groupId;
}
@property(strong,nonatomic) NSMutableArray *arrContainer;


@property(strong,nonatomic) NSArray *sortedArray;

@property(assign,nonatomic)BOOL isSearching;

@end

@implementation PT_AddMembersViewController


- (instancetype)initWithGroupId:(NSString *)group
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    groupId = group;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    [self fetchSuggestionList];
    
     [_searchText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchText.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0);
    
    

}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearching) {
        
        return _sortedArray.count;
    }else{
        
      return [_arrContainer count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier =@"cell";
    
    PT_AddMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == Nil)
    {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_AddMemberTableViewCell" owner:self options:Nil] firstObject];
        //cell.backgroundColor = [UIColor colorWithRed:233/255.0 green:237/255.0 blue:243/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (_isSearching) {
        
        PT_GroupMembersModel *model = _sortedArray[indexPath.row];

        cell.nameLabel.text = model.memberName;
        
        if (model.isAddedToNewGroup == YES)
        {
            [cell.addBtn setTitle:@"REMOVE" forState:UIControlStateNormal];
        }
        else
        {
            [cell.addBtn setTitle:@"ADD" forState:UIControlStateNormal];
        }


        
    }else{
    
    
    PT_GroupMembersModel *model = _arrContainer[indexPath.row];
    cell.nameLabel.text = model.memberName;
    
    if (model.isAddedToNewGroup == YES)
    {
        [cell.addBtn setTitle:@"REMOVE" forState:UIControlStateNormal];
    }
    else
    {
        [cell.addBtn setTitle:@"ADD" forState:UIControlStateNormal];
    }
    }
    
    cell.addBtn.tag = indexPath.row;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(void)addBtnClicked:(UIButton *) sender{
    
    
    if (_isSearching) {
        
        PT_GroupMembersModel *model = _sortedArray[sender.tag];
        
        if (model.isAddedToNewGroup == NO)
        {
            model.isAddedToNewGroup = YES;
        }
        else
        {
            model.isAddedToNewGroup = NO;
        }

    }else
    {
    PT_GroupMembersModel *model = _arrContainer[sender.tag];
    
    if (model.isAddedToNewGroup == NO)
    {
        model.isAddedToNewGroup = YES;
    }
    else
    {
        model.isAddedToNewGroup = NO;
    }
    }
    [self.tableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PT_GroupMembersModel *model = _arrContainer[indexPath.row];

    PT_PlayerProfileViewController *playerVC = [[PT_PlayerProfileViewController alloc] initWithNibName:@"PT_PlayerProfileViewController" bundle:nil];
    [playerVC fetchUserDetails:model.memberId];
    [playerVC fetchMyScores:model.memberId];
    [self presentViewController:playerVC animated:YES completion:nil];
    
}



/*
PT_PlayerProfileViewController *playerVC = [[PT_PlayerProfileViewController alloc] initWithNibName:@"PT_PlayerProfileViewController" bundle:nil];
[playerVC fetchUserDetails:[NSString stringWithFormat:@"%ld",(long)playerModel.playerId]];
[playerVC fetchMyScores:[NSString stringWithFormat:@"%ld",(long)playerModel.playerId]];
[self presentViewController:playerVC animated:YES completion:nil];
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionBack:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(IBAction)actionSave:(id)sender{
    
    
    [self addPlayers];
    
   // NSMutableArray *arrSelectedPlayers = [NSMutableArray new];
    
//    [_arrContainer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PT_GroupMembersModel *model = obj;
//        if (model.isAddedToNewGroup == YES)
//        {
//            [arrSelectedPlayers addObject:model];
//        }
//        if (idx == [_arrContainer count] - 1)
//        {
//            [self.groupVC setSelectedPlayers:arrSelectedPlayers];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
}

#pragma mark - TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//Mark:-Searching through TextFeilds
-(void)textFieldDidChange:(UITextField *)txtFld
{
    
    if (txtFld.text && txtFld.text.length == 0)
    {
        
        self.sortedArray = nil;
        //self.tableView.hidden = YES;
        
        _isSearching = NO;
        [txtFld resignFirstResponder];
    }
    else{
        
        _isSearching = YES;

        NSString * match = txtFld.text;
        //sNSArray *listFiles = [[NSMutableArray alloc] init];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.memberName CONTAINS[c] %@", match];
        
        //or use Name like %@ //”Name” is the Key we are searching
        _sortedArray = [_arrContainer filteredArrayUsingPredicate:predicate];
        
        // Now if you want to sort search results Array
        //Sorting NSArray having NSDictionary as objects
        //_sortedArray = [[NSMutableArray alloc]initWithArray: [listFiles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        
        //Use sortedArray as your Table’s data source
    }
    
//    if ([_sortedArray count] == 0) {
//        
//    }else{
//        
//        [_tableView reloadData];
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        CGFloat tableHeight = 0.0f;
        for (int i = 0; i < [_sortedArray count]; i ++) {
            tableHeight += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, tableHeight);
    });
    
    
    
    
}



- (void)fetchSuggestionList
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
                                @"group_id":groupId,
                                @"version":@"2"
                                };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,SuggestedFriendsPostfix]
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
                                  
                                  NSArray *suggestionList = dataOutput[@"Suggestion List"];
                                  
                                  _arrContainer = [NSMutableArray new];
                                  
                                  if (!(suggestionList == (id)[NSNull null]))
                                  {
                                      //arrContainer = [NSMutableArray new];
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          
                                          NSDictionary *dataObj = obj;
                                          
                                          PT_GroupMembersModel *model = [PT_GroupMembersModel new];
                                          
                                          model.memberName = dataObj[@"full_name"];
                                          
                                          model.memberImageUrl = dataObj[@"profile_image"];
                                          
                                          model.memberId = [NSString stringWithFormat:@"%@",dataObj[@"member_id"]];
                                          model.memberHandicap = [NSString stringWithFormat:@"%@",dataObj[@"self_handicap"]];
                                          [_arrContainer addObject:model];
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              //dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [self.tableView reloadData];
                                              
                                              //});
                                              
                                          }
                                          
                                      }];
                                  }
                                  else
                                  {
                                      [self showAlertWithMessage:@"No data available. Please try again"];
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
                          
                          
                      }
                  }
                  else
                  {
                      [self showAlertWithMessage:@"Connection Lost."];
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

-(void)addPlayers{
    
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        //Group Members
        NSMutableArray *arrSelectedPlayers = [NSMutableArray new];
        NSMutableArray *arrPlayer = [NSMutableArray new];
        [_arrContainer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PT_GroupMembersModel *model = obj;
            if (model.isAddedToNewGroup == YES)
            {
                
                NSDictionary *dicAddedMember = [NSDictionary dictionaryWithObject:model.memberId forKey:@"member_id"];
                
                [arrSelectedPlayers addObject:dicAddedMember];
                [arrPlayer addObject:model];
            }if (idx == [_arrContainer count] - 1)
                        {
                            [self.groupVC setSelectedPlayers:arrPlayer];
                        }

            
            
        }];
        
        
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"group_id":groupId,
                                @"group_member_list":arrSelectedPlayers,
                                @"version":@"2"
                                };
        NSLog(@"%@",param);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,addPlayerPostFix]
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
                                  
//                                  PT_CreateGroupViewController *groupVC = [[PT_CreateGroupViewController alloc] initWithNibName:@"PT_CreateGroupViewController" bundle:nil];
//                                  
//                                  [self presentViewController:groupVC animated:YES completion:nil];
                                  
                                  [self dismissViewControllerAnimated:YES completion:nil];
                                  
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




@end
