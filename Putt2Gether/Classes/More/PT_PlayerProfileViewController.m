//
//  PT_PlayerProfileViewController.m
//  Putt2Gether
//
//  Created by Bunny on 9/27/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_PlayerProfileViewController.h"

#import "PT_MyScoresTableViewCell.h"

#import "PT_PlayerItemModel.h"

#import "UIImageView+AFNetworking.h"

#import "PT_MyScoresModel.h"

#import "PT_StartEventViewController.h"

#import "PT_ScoreCardSplFormatViewController.h"

#import "PT_LeaderBoardViewController.h"

#import "PT_GroupItemModel.h"

#import "PT_CreateGroupTableViewCell.h"



static const NSString *getUserProfilePostFix = @"viewuserprofile";
static NSString *const FetchMyScorePostfix = @"myeventhistory";
static const NSString *getgrouplistPostfix = @"getgrouplist";

static const NSString *AddmemberPostFix = @"addmembertomultiplegroup";


@interface PT_PlayerProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    
   
    NSMutableArray *arrDate;
    
    NSMutableArray *arrimage1;
    NSMutableArray *arrimage2;
    NSMutableArray *arrimage3;
    NSMutableArray *arrimage4;
    NSInteger userID;
}

@property(nonatomic,strong) IBOutlet UIImageView *profileImg;

@property(nonatomic,strong) IBOutlet UIView *headerView,*eventView,*noeventView;

@property(nonatomic,strong) IBOutlet UITableView *tableView ,*groupTableView;

@property(nonatomic,strong) IBOutlet UIButton *backbtn ,*addtogroupBtn,*addtoFriendBtn;

@property(strong,nonatomic) NSMutableArray *arrMyScores,*arrAddedGroups,*arrSelected;

//Mark:-Creating an array to store the ids Selected
@property(strong,nonatomic) NSMutableArray *arrRemoved;

@end

@implementation PT_PlayerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
   
    _coveredBtn.hidden = YES;
    self.popUpBackView.hidden = YES;
    self.popBackUpView.hidden = YES;
    _eventView.hidden = YES;
    
    _handicapLabel.layer.cornerRadius = _handicapLabel.frame.size.height/2;
    _handicapLabel.clipsToBounds = YES;
       
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_headerView.bounds];
    _headerView.layer.masksToBounds = NO;
    _headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _headerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    _headerView.layer.shadowOpacity = 2.0f;
    _headerView.layer.shadowPath = shadowPath.CGPath;
//    [_headerView.layer setShadowColor:[UIColor blackColor].CGColor];
//    
//    [_headerView.layer setShadowOpacity:0.8];
//    [_headerView.layer setShadowRadius:2.0];
//    
    _addtogroupBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _addtogroupBtn.titleLabel.numberOfLines = 2;
    _addtogroupBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_addtogroupBtn setTitle:@"ADD\nTO GROUP" forState:UIControlStateNormal];
    
    _golfCourseNameLabel.textAlignment = NSTextAlignmentLeft;
    _golfCourseNameLabel.numberOfLines = 2;
    _golfCourseNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _addtoFriendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _addtoFriendBtn.titleLabel.numberOfLines = 2;
     _addtogroupBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
 
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.popbackView addGestureRecognizer:tapped];
    [self.popUpView addGestureRecognizer:tapped];

    
    UIColor *backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
    self.groupTableView.backgroundView = [[UIView alloc]initWithFrame:self.groupTableView.bounds];
    self.groupTableView.backgroundView.backgroundColor = backgroundColor;
    //self.groupTableView.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _arrSelected = [NSMutableArray new ];
    _arrRemoved = [NSMutableArray new];

    
}

-(void)tapDetected:(UITapGestureRecognizer *)recongizer
{
    
    self.popUpBackView.hidden = YES;
    self.popBackUpView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self performSelector:@selector(setstyleCircleForImage:) withObject:_profileImg afterDelay:0];
}


-(void) setstyleCircleForImage:(UIImageView *)Imageview{
    _profileImg.layer.cornerRadius = _profileImg.frame.size.width/2;
    _profileImg.clipsToBounds = YES;
    _profileImg.layer.borderColor = [UIColor whiteColor].CGColor;
    _profileImg.layer.borderWidth = 2.0;
}



-(void)trophyBtnClicked:(UIButton *) sender{
    
    
}

-(IBAction)actionback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)actionAddtoGroups{
    
    [self.coveredBtn setHidden:NO];
    [self fetchGroupList];

    
}

-(IBAction)actionCoveredBtn{
    
    self.popUpBackView.hidden = YES;

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
                                 [self dismissViewControllerAnimated:YES completion:nil];

                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (IBAction)actionDonepopUp:(id)sender {
    
    [self addMembertoGroup];
    
    self.popUpBackView.hidden = YES;
    
}

- (void)fetchUserDetails:(NSString *)userId
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //_loadingView.hidden = NO;
        });
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":userId,
                                @"version":@"2"};
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,getUserProfilePostFix] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
            
            if (!error)
            {
                if (responseData != nil)
                {
                    if ([responseData isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dicOutPut = responseData[@"output"];
                        
                        if ([dicOutPut[@"status"] isEqualToString:@"1"])
                        {

                            NSDictionary *dicInfo = dicOutPut[@"data"];

                        PT_PlayerItemModel *model = [PT_PlayerItemModel new];
                        model.playerId = [dicInfo[@"user_id"] integerValue];
                        model.playerName = dicInfo[@"display_name"];
                        model.handicap = [dicInfo[@"average_score"] integerValue];
                        model.mobile = [NSString stringWithFormat:@"%@",dicInfo[@"contact_no"]];
                        model.country = dicInfo[@"country"];
                        model.countryCode = dicInfo[@"golf_course_name"];
                        model.playerImageURL = dicInfo[@"photo_url"];
                            model.homecourseID = [dicInfo[@"handicap_value"] integerValue];
                        model.counts = [dicInfo[@"total_group_member"] integerValue];
                        
                            [self updateUI:model];
                            
                            userID = model.playerId;
                            
                        //Update UI
                        
                        }else{
                            
                            [self showAlertWithMessage:dicOutPut[@"message"]];
                        }
                    }
                }
            }
        }];
    }
}


-(void)updateUI:(PT_PlayerItemModel *)model
{
    self.handicapLabel.text = [NSString stringWithFormat:@"%ld",(long)model.homecourseID];
    
    _headerLabel.text = [NSString stringWithFormat:@"%@'s Profile",model.playerName];
    self.nameLabel.text = [model.playerName uppercaseString];
    self.countryLabel.text = [model.country uppercaseString];
    self.golfCourseNameLabel.text = [model.countryCode uppercaseString];
    self.averagescoreLabel.text = [NSString stringWithFormat:@"%li",(long)model.handicap];
    
    [_profileImg setImageWithURL:[NSURL URLWithString:model.playerImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
    
    NSString *str = [NSString stringWithFormat:@"(MEMBER OF %@ GROUPS)",[NSString stringWithFormat:@"%li",(long)model.counts]];
    
    _memberCountLabel.text = str;
    
    
    
    NSString *str3 = [model.playerName uppercaseString];;
    NSString *str1 = [NSString stringWithFormat:@"%@ HAS NO RECENT EVENTS YET",str3];
    _noeventLabel.numberOfLines = 2;
    _noeventLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _noeventLabel.textAlignment = NSTextAlignmentCenter;
    _noeventLabel.text = str1;

    
}

- (void)fetchMyScores:(NSString *)userId
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
        
        
        NSDictionary *param = @{@"user_id":userId,
                                @"version":@"2"
                                };
        
        //[self showLoadingView:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchMyScorePostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  //[self showLoadingView:NO];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              if (_arrMyScores.count > 0) {
                                  
                                  [_arrMyScores removeAllObjects];
                                  
                              }else{
                              
                              _arrMyScores = [NSMutableArray new];
                              }
                              
                              NSArray *arrData = dicOutput[@"data"];
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  NSDictionary *dicAtIndex = obj;
                                  PT_MyScoresModel *model = [PT_MyScoresModel new];
                                  
                                  model.eventId = [dicAtIndex[@"event_id"] integerValue];
                                  model.formatId = [dicAtIndex[@"format_id"] integerValue];
                                  model.eventName = dicAtIndex[@"event_name"];
                                  model.golfCourseName = dicAtIndex[@"golf_course_name"];
                                  model.formatName = dicAtIndex[@"format_name"];
                                  model.total = [dicAtIndex[@"total"] integerValue];
                                  model.date = dicAtIndex[@"event_start_date"];
                                  model.currentPosition = dicAtIndex[@"current_position"];
                                  model.currentRanking = dicAtIndex[@"current_ranking"];
                                  model.eagle = [dicAtIndex[@"eagle"] integerValue];
                                  
                                  
                                  model.grossScore = [dicAtIndex[@"gross_score"] integerValue];
                                  model.birdie = [dicAtIndex[@"no_of_birdies"] integerValue];
                                  model.par = [dicAtIndex[@"no_of_pars"] integerValue];
                                  model.numberOfPlayers = dicAtIndex[@"no_of_player_ios"] ;
                                  model.numberOfPlayerAccepted = [dicAtIndex[@"no_of_player_accepted"] integerValue];
                                  
                                  [self.arrMyScores addObject:model];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      
                                      _eventView.hidden = NO;

                                      //reload table
                                      [_tableView reloadData];
                                  }
                              }];
                          }
                          else
                          {
                              //[self showAlertWithMessage:dicOutput[@"message"]];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        
        return [self.arrMyScores count];
    }else{
        
        return [self.arrAddedGroups count];

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier =@"cell";
    
    if (tableView == _groupTableView) {
        
        PT_CreateGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_CreateGroupTableViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
        
        [cell.handicapLabel removeFromSuperview];
        [cell.adminBtn removeFromSuperview];
        [cell.removeBtn removeFromSuperview];
        [cell.starImage removeFromSuperview];
        
        [cell.checkImage setHidden:NO];
         PT_GroupItemModel *model = _arrAddedGroups[indexPath.row];
        
        if (model.isAddedinGroup == YES)
        {
            [cell.checkImage setImage:[UIImage imageNamed:@"check"]];
        }
        else
        {
            [cell.checkImage setImage:[UIImage imageNamed:@"uncheck"]];
        }
        
        
        
        [cell.playerImage setImageWithURL:[NSURL URLWithString:model.groupImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
        cell.playerImage.layer.cornerRadius = cell.playerImage.frame.size.height/2;
        cell.playerImage.clipsToBounds = YES;
        cell.nameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0f];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.text = model.groupName;
        
        return cell;
    }
    else{

     static NSString *cellIdentifier2 =@"cell2";
    PT_MyScoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_MyScoresTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        PT_MyScoresModel *model = _arrMyScores[indexPath.row];
        
        
        
    UIColor *borderColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0f];
    
        
    cell.eventName.text = model.eventName;
    cell.total.text = [NSString stringWithFormat:@"%li",(long)model.total];
    cell.date.text = model.date;
    cell.venue.text = model.golfCourseName;
    
    cell.totalBgView.layer.borderColor = [borderColor CGColor];
    cell.totalBgView.layer.borderWidth = 2.0;
    cell.totalBgView.layer.cornerRadius = cell.totalBgView.frame.size.width/2;
    cell.totalBgView.layer.masksToBounds = YES;
        
        
        
    
        if ([model.currentRanking isEqualToString:@"Winner"])
        {
            [cell.ranking removeFromSuperview];
            cell.imageWinnerCentre.image = [UIImage imageNamed:@"winner_cup"];
        }
        else
        {
            cell.ranking.text = model.currentRanking;
            
            
            //        cell.winnerBgImage.layer.borderColor = [borderColor CGColor];
            //        cell.winnerBgImage.layer.borderWidth = 4.0;
            //        cell.winnerBgImage.layer.cornerRadius = cell.totalBgView.frame.size.width/2;
            //        cell.winnerBgImage.layer.masksToBounds = YES;
        }
        
        if ([model.numberOfPlayers isEqualToString:@"1"] ) {
            
            cell.winnerBgImage.image = [UIImage imageNamed:@"winner_circle1"];
            
        }else if ([model.numberOfPlayers isEqualToString:@"2"]){
            
            cell.winnerBgImage.image = [UIImage imageNamed:@"winner_circle2"];
            
        }else if([model.numberOfPlayers isEqualToString:@"3"]){
            
            cell.winnerBgImage.image = [UIImage imageNamed:@"winner_circle3"];
            
        }else if ([model.numberOfPlayers isEqualToString:@"4"]){
            
            cell.winnerBgImage.image = [UIImage imageNamed:@"winner_circle4"];
        }else{
            
            cell.winnerBgImage.image = [UIImage imageNamed:@"winner_circle5"];
            
        }
        
        // NSInteger count = 0;
        if (model.eagle > 0)
        {
            cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
        }
        if (model.grossScore > 0)
        {
            //count++;
            if (model.eagle > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
                cell.imageBadge2.image = [UIImage imageNamed:@"gross"];
                
            }
            else
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"gross"];
            }
        }
        if (model.birdie > 0)
        {
            if (model.eagle > 0 && model.grossScore > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
                cell.imageBadge2.image = [UIImage imageNamed:@"gross"];
                cell.imageBadge3.image = [UIImage imageNamed:@"birdie"];
                
                
            }
            else if (model.eagle > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
                
                cell.imageBadge2.image = [UIImage imageNamed:@"birdie"];
            }
            else if(model.grossScore > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"gross"];
                
                cell.imageBadge2.image = [UIImage imageNamed:@"birdie"];
            }else{
                
                cell.imageBadge1.image = [UIImage imageNamed:@"birdie"];
                
            }
            
        }
        if (model.par > 0)
        {
            if (model.birdie  && model.grossScore && model.eagle > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
                cell.imageBadge2.image = [UIImage imageNamed:@"gross"];
                cell.imageBadge3.image = [UIImage imageNamed:@"birdie"];
                cell.imageBadge4.image = [UIImage imageNamed:@"par"];
                
            }
            else if (model.grossScore && model.eagle > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
                cell.imageBadge2.image = [UIImage imageNamed:@"gross"];
                cell.imageBadge3.image = [UIImage imageNamed:@"par"];
            }
            else if (model.birdie  && model.grossScore > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"gross"];
                cell.imageBadge2.image = [UIImage imageNamed:@"birdie"];
                cell.imageBadge3.image = [UIImage imageNamed:@"par"];
            }
            else if(model.birdie  && model.eagle > 0)
            {
                cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
                cell.imageBadge2.image = [UIImage imageNamed:@"birdie"];
                cell.imageBadge3.image = [UIImage imageNamed:@"par"];
            }else if (model.eagle >0 ){
                
                cell.imageBadge1.image = [UIImage imageNamed:@"eagle"];
                cell.imageBadge2.image = [UIImage imageNamed:@"par"];
                
            }else if (model.grossScore > 0){
                
                cell.imageBadge1.image = [UIImage imageNamed:@"gross"];
                cell.imageBadge2.image = [UIImage imageNamed:@"par"];
            }else if(model.birdie > 0){
                
                cell.imageBadge1.image = [UIImage imageNamed:@"birdie"];
                cell.imageBadge2.image = [UIImage imageNamed:@"par"];
                
            }else{
                
                cell.imageBadge1.image = [UIImage imageNamed:@"par"];
                
            }
            
        }
        cell.popBtn.tag = indexPath.row;
        
        [cell.popBtn addTarget:self action:@selector(actionStanding:) forControlEvents:UIControlEventTouchUpInside];
        
    
    
    return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _groupTableView){
        
        PT_GroupItemModel *model = _arrAddedGroups[indexPath.row];
        
        if (model.isAddedinGroup == NO)
        {
            model.isAddedinGroup = YES;
        }
        else
        {
            model.isAddedinGroup = NO;
        }
       
        [self.groupTableView reloadData];
        
        
        
    }else{
    PT_MyScoresModel *model = _arrMyScores[indexPath.row];
    PT_CreatedEventModel *eventModel = [PT_CreatedEventModel new];
    eventModel.eventId = model.eventId;
    eventModel.numberOfPlayers = [NSString stringWithFormat:@"%li",(long)model.numberOfPlayers];
    eventModel.formatId = [NSString stringWithFormat:@"%li",(long)model.formatId];
        eventModel.golfCourseName = model.golfCourseName;
        eventModel.eventName = model.eventName;
    
    if (model.formatId == FormatMatchPlayId ||
        model.formatId == FormatAutoPressId ||
        model.formatId == Format420Id ||
        model.formatId == Format21Id ||
        model.formatId == FormatVegasId)
    {
        
        PT_ScoreCardSplFormatViewController *scorecardViewController = [[PT_ScoreCardSplFormatViewController alloc] initWithEvent:eventModel];
        [self presentViewController:scorecardViewController animated:YES completion:nil];
    }
    else
    {
        PT_LeaderBoardViewController *leaderboardViewController = [[PT_LeaderBoardViewController alloc] initWithEvent:eventModel];
        [self presentViewController:leaderboardViewController animated:YES completion:nil];
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _groupTableView){
        
        return 60.0f;

    }else{
    
         return 85.0f;
    }
}


//Mark:-Pop Up Group Service Call
- (void)fetchGroupList
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
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,getgrouplistPostfix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"output"])
                              {
                                  NSDictionary *dataOutput = responseData[@"output"];
                                  NSArray *suggestionList = dataOutput[@"data"];
                                  _arrAddedGroups = [NSMutableArray new];
                                  if (!(suggestionList == (id)[NSNull null]))
                                  {
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          
                                          NSDictionary *dataObj = obj;
                                          PT_GroupItemModel *groupModel = [PT_GroupItemModel new];
                                          groupModel.groupId = [dataObj[@"group_id"] integerValue];
                                          groupModel.groupName = dataObj[@"group_name"];
                                          groupModel.groupImageURL = dataObj[@"profile_img"];
                                          groupModel.arrGroupMembers = [NSMutableArray new];
                                          groupModel.arrGroupMembers = dataObj[@"group_member_id"];
                                       
                                          NSLog(@"%li",userID);
                                          if ([groupModel.arrGroupMembers containsObject:[NSString stringWithFormat:@"%ld",(long)userID]]) {
                                              
                                              groupModel.isAddedinGroup = YES;
                                              
                                          }else{
                                              
                                              groupModel.isAddedinGroup = NO;


                                          }
                                          
                                          [_arrAddedGroups addObject:groupModel];

  
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              self.popUpBackView.hidden = NO;

                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [self.groupTableView reloadData];
                                                  
                                              });
                                              
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
                  }
                  
                  
              }];
    }
}

//Mark:-add Member to group
- (void)addMembertoGroup
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        //Group Members
        NSMutableArray *arrSelectedPlayers = [NSMutableArray new];
        [_arrAddedGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PT_GroupItemModel *model = obj;
            if (model.isAddedinGroup == YES)
            {
                
                NSDictionary *dicAddedMember = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%li",model.groupId] forKey:@"group_id"];
                
                [arrSelectedPlayers addObject:dicAddedMember];
            }
            
            
            
        }];
       
        
        
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"member_id":[NSNumber numberWithInteger:userID],
                                @"group_list":arrSelectedPlayers,
                                @"version":@"2"
                                };
        NSLog(@"%@",param);
       // [self showLoadingView:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,AddmemberPostFix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                     // [self showLoadingView:NO];
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
                          
                         // [self showLoadingView:NO];
                          
                      }
                  }
                  else
                  {
                     // [self showLoadingView:NO];
                  }
                  
                  
              }];
    }
}


//Mark:-popUp Open
-(void)actionStanding:(UIButton *)sender
{
        
    
    PT_MyScoresModel *model = _arrMyScores[sender.tag];
    if ([model.numberOfPlayers isEqualToString:@"1"]) {
        
        _standingImage.image = [UIImage imageNamed:@"winner_circle1"];
        
    }else if ([model.numberOfPlayers isEqualToString:@"2"]){
        
        _standingImage.image = [UIImage imageNamed:@"winner_circle2"];
        
    }else if([model.numberOfPlayers isEqualToString:@"3"]){
        
        _standingImage.image = [UIImage imageNamed:@"winner_circle3"];
        
    }else if ([model.numberOfPlayers isEqualToString:@"4"]){
        
        _standingImage.image = [UIImage imageNamed:@"winner_circle4"];
    }else{
        
        _standingImage.image = [UIImage imageNamed:@"winner_circle5"];
        
    }
    
    
    
    if ([model.currentRanking isEqualToString:@"Winner"])
    {
        _postionImageView.image = [UIImage imageNamed:@"winner_cup"];
        _rankingLabel.hidden = YES;
        _postionImageView.hidden = NO;
        
    }
    else
    {
        _rankingLabel.text = model.currentRanking;
        _postionImageView.hidden = YES;
        _rankingLabel.hidden = NO;
        
        
    }
    
    if (model.numberOfPlayerAccepted == 1 && [model.currentRanking isEqualToString:@"Winner"]){
        NSString *winnerStr = [model.currentRanking uppercaseString];
        
        
        NSString *str2 = [NSString stringWithFormat:@"%ld",(long)model.numberOfPlayerAccepted];
        
        NSString *str = [NSString stringWithFormat:@"YOU ARE %@ FOR %@ PLAYER EVENT",winnerStr,str2];
        
        self.standingLabel.numberOfLines = 2;
        
        self.standingLabel.text = str;
        
    }else if (model.numberOfPlayerAccepted == 1) {
        
        NSString *str2 = [NSString stringWithFormat:@"%ld",(long)model.numberOfPlayerAccepted];
        
        NSString *str = [NSString stringWithFormat:@"YOU ARE %@ FOR %@ PLAYER EVENT",model.currentRanking,str2];
        
        self.standingLabel.numberOfLines = 2;
        
        self.standingLabel.text = str;
        
        
    }else if([model.currentRanking isEqualToString:@"Winner"]){
        
        NSString *winnerStr = [model.currentRanking uppercaseString];
        
        
        NSString *str2 = [NSString stringWithFormat:@"%ld",(long)model.numberOfPlayerAccepted];
        
        
        
        NSString *str = [NSString stringWithFormat:@"YOU ARE %@ FOR %@ PLAYERS EVENT",winnerStr,str2];
        
        self.standingLabel.numberOfLines = 2;
        
        self.standingLabel.text = str;
    }else{
        
        NSString *str2 = [NSString stringWithFormat:@"%ld",(long)model.numberOfPlayerAccepted];
        
        NSString *str = [NSString stringWithFormat:@"YOU ARE RANKED %@ FOR %@ PLAYERS EVENT",model.currentRanking,str2];
        
        self.standingLabel.numberOfLines = 2;
        
        self.standingLabel.text = str;
        
    }
    
    [self.popBackUpView setHidden:NO];
}




@end
