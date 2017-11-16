//
//  PT_DelegateViewController.m
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_DelegateViewController.h"
#import "PT_DelegateTableViewCell.h"

#import "PT_DelegateModel.h"

#import "PT_LeaderBoardViewController.h"

#import "PT_CreatedEventModel.h"

#import "PT_ScoreCardSplFormatViewController.h"

static NSString *const FetchDelegatePostfix = @"getdelegateuserlist";

static NSString *const MakeDelegatePostFix = @"makedelegate";


@interface PT_DelegateViewController ()<UITableViewDataSource,UITableViewDataSource>
{
    NSInteger selectedRow;
}


@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;

@property (strong, nonatomic) PT_ScoringIndividualPlayerModel *playerModel;

@property(strong,nonatomic) IBOutlet UITableView *tabledelegate,*tablePlayer;

//Mark:-properties declaration
@property(weak,nonatomic) IBOutlet UIView *popUpView,*popFrontView;

@property(strong,nonatomic)NSMutableArray *arrDelegate,*arrDelegateIds;

@property(strong,nonatomic)NSMutableArray *arrPlayer,*arrMakeDelegate,*arrGlobal;

@property(assign,nonatomic) NSInteger tabletapped;

//Maark:-properties for making Delegate
@property(strong,nonatomic) NSString *makeDplayerId,*playerID,*PlayerName;

@property(strong,nonatomic) NSString *makeDdelegateTo;

@property(strong,nonatomic) IBOutlet NSLayoutConstraint *tableYpos;

@property(strong,nonatomic) NSIndexPath *selectedIndex;
@property (assign, nonatomic) BOOL isRequestToParticipate;

@property(strong,nonatomic) NSMutableDictionary *dict;



@end

@implementation PT_DelegateViewController

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model andPlayerModel:(PT_ScoringIndividualPlayerModel *)playerModel
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    self.createdEventModel = model;
    self.playerModel = playerModel;
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    _arrDelegate = [NSMutableArray new];
    _arrPlayer = [NSMutableArray new];
    _arrMakeDelegate = [NSMutableArray new];
    _arrGlobal = [NSMutableArray new];
    _arrDelegateIds = [NSMutableArray new];
    
    _dict = [NSMutableDictionary new];

    
    [self fetchDelegatesData];
    _popUpView.hidden = YES;
    
    //Mark:-for checking which table tapped
    _tabletapped = 0;
    
    self.tabledelegate.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tablePlayer.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];;

    
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _tabledelegate) {
        
        return [_arrDelegate count];
    }else{
         return [_arrPlayer count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tabledelegate) {
        
        static NSString *CellIdentifier = @"Cell";
        
        
        
        PT_DelegateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == Nil)
        {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_DelegateTableViewCell" owner:self options:Nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.delegateBtn addTarget:self action:@selector(actionDelegateTo:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegateBtn.tag = indexPath.row;
            
        }
        
        PT_DelegateModel *model = [_arrDelegate objectAtIndex:indexPath.row];
        
        NSString *nameString = [NSString stringWithFormat:@"%@   ",model.playerName];
        
        
        //NSString *string2 = [NSString stringWithFormat:@"%@ ",model.message];
        
        nameString = [nameString stringByAppendingString:[NSString stringWithFormat:@"%@",model.handicapValue]];
        NSLog(@"%@",nameString);
        if (model.isDelegated == YES)
        {
            [cell.delegateBtn setTitle:model.delegatedToName forState:UIControlStateNormal];
        }
        else
        {
            [cell.delegateBtn setTitle:@"DELEGATE TO" forState:UIControlStateNormal];
        }
        
        cell.delegateBtn   =   [self.view viewWithTag:indexPath.row];
        cell.nameLabel.text = nameString;
        return cell;
        
    }
    else
    {
        
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == Nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        PT_DelegateModel *model = [_arrPlayer objectAtIndex:indexPath.row];
        
        NSString *nameString = [NSString stringWithFormat:@"%@   ",model.playerName];
        
        //NSString *string2 = [NSString stringWithFormat:@"%@ ",model.message];
        
        nameString = [nameString stringByAppendingString:[NSString stringWithFormat:@"%@",model.handicapValue]];
        NSLog(@"%@",nameString);
        
        cell.textLabel.text = nameString;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
        tableView.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
        //cell.downBtn.hidden = YES;
        
        //cell.delegateBtn.hidden = YES;
        return cell;
        
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tabledelegate) {
        
        return 50;
    }else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tabledelegate) {
        
        
        
//        [self fetchPlayerData];
//
//        
//        
//        UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdetected:)];
//        recongnizer.numberOfTapsRequired = 1;
//        [_popFrontView addGestureRecognizer:recongnizer];
//        
//         PT_DelegateModel *model = [_arrDelegate objectAtIndex:indexPath.row];
//       // PT_DelegateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        _tabletapped = 0;
//        
//        _makeDplayerId = [NSString stringWithFormat:@"%ld",(long)model.playerId];

        
        
    }else{
        
        [_tabledelegate deselectRowAtIndexPath:indexPath animated:NO];

        PT_DelegateModel *model2 = [_arrPlayer objectAtIndex:indexPath.row];
         PT_DelegateTableViewCell *cell = [_tabledelegate cellForRowAtIndexPath:indexPath];

        
            
           
            _PlayerName = model2.playerName  ;
            
        //cell.delegateBtn = [self.view viewWithTag:selectedRow] ;
        //[cell.delegateBtn setTitle:_PlayerName forState:UIControlStateNormal];// setTitle:_PlayerName forState:UIControlStateNormal];
        

        
        
        NSString *delegtaeId = [NSString stringWithFormat:@"%ld",(long)model2.playerId];
        NSLog(@"%@",delegtaeId);
        
        
            if ([_arrDelegateIds containsObject:_makeDplayerId]) {
                
                NSArray *filtered = [_arrGlobal filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(player_id == %@)", _makeDplayerId]];
                
                if (filtered.count > 0) {
                    
                    NSInteger anIndex = [_arrGlobal indexOfObject:[filtered objectAtIndex:0]];
                    
                    if(NSNotFound == anIndex) {
                        
                        
                        NSLog(@"not found");
                    }else{
                        
                        _dict = [NSMutableDictionary new];
                        [_dict setObject:delegtaeId forKey:@"delegated_to"];
                        [_dict setObject:_makeDplayerId forKey:@"player_id"];
                        
                        [_arrGlobal replaceObjectAtIndex:anIndex withObject:_dict];
                    }
                    
                }
               
                
            }else{
                
                _dict = [NSMutableDictionary new];
                [_dict setObject:delegtaeId forKey:@"delegated_to"];
                [_dict setObject:_makeDplayerId forKey:@"player_id"];
                
                [_arrDelegateIds addObject:_makeDplayerId];
                NSLog(@"%@",_arrDelegateIds);
                
                
                [_arrGlobal addObject:_dict];
                
                
            }

        NSLog(@"%@",_arrGlobal);
        
        _popUpView.hidden = YES;

        //MarK;-for making delegate
                //[self.tabledelegate reloadData];
        
        PT_DelegateModel *modelCurrentScorer = _arrDelegate[selectedRow];
        modelCurrentScorer.delegatedToId = model2.playerId;
        modelCurrentScorer.delegatedToName = model2.playerName;
        modelCurrentScorer.isDelegated = YES;
        [_tabledelegate reloadData];
    }
}



-(void)actionDelegateTo:(UIButton *)sender
{
    [self fetchPlayerData];

    PT_DelegateModel *model = [_arrDelegate objectAtIndex:sender.tag];
    
    _makeDplayerId = [NSString stringWithFormat:@"%ld",(long)model.playerId];
    
     selectedRow = sender.tag;
    
        UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdetected:)];
    recongnizer.numberOfTapsRequired = 1;
    [_popFrontView addGestureRecognizer:recongnizer];
    
    
}

-(void)actionWinner:(id)sender{
    
//    _popUpView.hidden = NO;
//    
//    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdetected:)];
//    recongnizer.numberOfTapsRequired = 1;
//    [_popFrontView addGestureRecognizer:recongnizer];
//    [self fetchPlayerData];
    
    
}
-(void)tapdetected:(UITapGestureRecognizer *)recong
{
    _popUpView.hidden = YES;
    
}
-(IBAction)actionBackBtn:(id)sender{
    
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


#pragma mark - Service calls

- (void)fetchDelegatesData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"user_id":[NSString stringWithFormat:@"%li", (long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        NSLog(@"%@",param);
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchDelegatePostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
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
                              
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  
                                  PT_DelegateModel *model = [PT_DelegateModel new];
                                  
                                  NSDictionary *dicData = obj;
                                  
                                  model.eventId = [dicData[@"event_id"] integerValue];
                                  model.playerId = [dicData[@"player_id"] integerValue];
                                  model.scorerCount = [dicData[@"scorer_count"] integerValue];
                                  model.handicapValue = dicData[@"handicap_value"];
                                  model.scorerId = [dicData[@"scorere_id"] integerValue];
                                  model.scorerName = dicData[@"scorer_name"];
                                  model.playerName = dicData[@"player_name"];
                                 
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      [_arrDelegate addObject:model];

                                 
                                  
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.tabledelegate reloadData];
                                      
                                      
                                  });

                              }];
                              
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [self showAlertWithMessage:@"You can not Delegate"];
                          }
                      }
                      
                      else
                      {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}



- (void)fetchPlayerData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"user_id":[NSString stringWithFormat:@"%li", (long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"player_id":[NSString stringWithFormat:@"%li", (long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        NSLog(@"%@",param);
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchDelegatePostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
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
                              
                              if (_arrPlayer == nil) {
                                  
                                  _arrPlayer = [NSMutableArray new];
                              }else{
                                  
                                  [_arrPlayer removeAllObjects];
                              }
                              
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  
                                  PT_DelegateModel *model = [PT_DelegateModel new];
                                  
                                  NSDictionary *dicData = obj;
                                  
                                  model.eventId = [dicData[@"event_id"] integerValue];
                                  model.playerId = [dicData[@"player_id"] integerValue];
                                  model.scorerCount = [dicData[@"scorer_count"] integerValue];
                                  model.handicapValue = dicData[@"handicap_value"];
                                  model.scorerId = [dicData[@"scorere_id"] integerValue];
                                  model.scorerName = dicData[@"scorer_name"];
                                  model.playerName = dicData[@"player_name"];
                                  
                                  [_arrPlayer addObject:model];
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  if (idx == [arrData count] -1) {
                                      
                                      _popUpView.hidden = NO;

                                  }
//                                  else{
//                                      
//                                      [self showAlertWithMessage:@"Freind list empty"];
//                                  }
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      
                                      //Mark:-for Y postion of
//                                      CGFloat tableYpostion = 60.0f;
//                                      for (int i = 0; i < [_arrPlayer count]; i ++) {
//                                          tableYpostion += [self tableView:self.tablePlayer heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//                                          
//                                          
//                                      }
//                                      CGRect screenRect = [[UIScreen mainScreen] bounds];
//                                      int screenHeight    = screenRect.size.height;
//                                      
//                                      CGFloat tableviewHeight = screenHeight - tableYpostion;
//                                      
//                                      self.tableYpos.constant = tableviewHeight;
//                                      _tablePlayer.scrollEnabled = NO;
//                                      
//                                      if (tableYpostion > screenHeight) {
//                                          
//                                          self.tableYpos.constant = 0;
//                                          _tablePlayer.scrollEnabled = YES;
//                                          
//                                      }
                                      //        self.table420format.frame = CGRectMake(self.table420format.frame.origin.x,tableviewHeight, self.table420format.frame.size.width, tableYpostion);
                                      
                                      /*self.tableLeaderboard.layer.borderWidth = 1.0;
                                       self.tableLeaderboard.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                                       self.tableLeaderboard.layer.cornerRadius = 2.0;
                                       self.tableLeaderboard.layer.masksToBounds = YES;
                                       */
                                      [self.tablePlayer reloadData];
                                  });

                              }];
                              
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [self showAlertWithMessage:@"Freind list empty"];
                          }
                      }
                      
                      else
                      {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

-(IBAction)actionContinue{
    
    [self makeDelegate];
}


- (void)makeDelegate
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"user_id":[NSString stringWithFormat:@"%li", (long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"delegate_player":_arrGlobal,
                                @"version":@"2"
                                };
        NSLog(@"%@",param);
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,MakeDelegatePostFix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  NSLog(@"%@",responseData);
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSString *message = [dicResponseData objectForKey:@"message"];
                              
                              NSLog(@"%@",message);
                              _popUpView.hidden = YES;
                              UIAlertController * alert=   [UIAlertController
                                                            alertControllerWithTitle:@"Putt2gether"
                                                            message:@"Delegate Created"
                                                            preferredStyle:UIAlertControllerStyleAlert];
                              
                              
                              
                              UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action) {
                                                                             
                                                                             [self fetchEvent:self.createdEventModel withType:InviteType_Detail];
                                                                             

                                                                             
                                                                         }];
                              
                              
                              [alert addAction:ok];
                              
                              
                              
                              
                              [self presentViewController:alert animated:YES completion:nil];
                                                        }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

//Mark:-for sending on event Listing
- (void)fetchEvent:(PT_CreatedEventModel *)model withType:(InviteType)type
{
    NSString *eventId = [NSString stringWithFormat:@"%li",model.eventId];
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
        
        NSString *urlString = @"http://clients.vfactor.in/puttdemo/eventdetail";
        //[self showLoadingView:YES];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                 // [self showLoadingView:NO];
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
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}






@end
