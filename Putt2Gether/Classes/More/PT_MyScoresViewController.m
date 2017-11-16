//
//  PT_MyScoresViewController.m
//  Putt2Gether
//
//  Created by Devashis on 13/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_MyScoresViewController.h"

#import "PT_MyScoresTableViewCell.h"

#import "PT_MyScoresModel.h"

#import "PT_StartEventViewController.h"

#import "PT_ScoreCardSplFormatViewController.h"

#import "PT_LeaderBoardViewController.h"

#import "UIImageView+AFNetworking.h"

static NSString *const FetchMyScorePostfix = @"myeventhistory";

static NSString *const FetchBannerPostFix = @"getadvbanner";


@interface PT_MyScoresViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray *arrMyScores,*arrBanner;

@property (weak, nonatomic) IBOutlet UITableView *tableScores;



@end

@implementation PT_MyScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _popBackUpView.hidden = YES;
    

    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.popUpView addGestureRecognizer:tapped];
    

    self.tableScores.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self fetchMyScores];
    
    [self fetchBannerDetail];
}





-(void)tapDetected:(UITapGestureRecognizer *)recon
{
    [self.popBackUpView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBack:(id)sender
{
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


- (void)fetchMyScores
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
       
        
        NSDictionary *param = @{
                                @"user_id":[NSString stringWithFormat:@"%li", [[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchMyScorePostfix];
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
                              
                              _arrMyScores = [NSMutableArray new];
                              
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
                                  
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  if (idx == [arrData count] - 1)
                                  {
                                      //reload table
                                      [_tableScores reloadData];
                                  }
                              }];
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];

                              [self showAlertWithMessage:@"Empty."];
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

                  }
                  
                  
              }];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrMyScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier =@"cell";
    
    
    PT_MyScoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_MyScoresTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIColor *borderColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0f];
    PT_MyScoresModel *model = _arrMyScores[indexPath.row];
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_MyScoresModel *model = _arrMyScores[indexPath.row];
    PT_CreatedEventModel *eventModel = [PT_CreatedEventModel new];
    eventModel.eventId = model.eventId;
    eventModel.numberOfPlayers = model.numberOfPlayers;
    eventModel.golfCourseName = model.golfCourseName;
    eventModel.eventName = model.eventName;
    eventModel.formatId = [NSString stringWithFormat:@"%li",(long)model.formatId];
  //  eventModel.formatName = model.formatName;
    
    //eventModel.formatId = [NSString stringWithFormat:@"%li",(long)model.formatId];
    
    if (model.formatId == FormatMatchPlayId ||
        model.formatId == FormatAutoPressId ||
        model.formatId == Format420Id ||
        model.formatId == Format21Id ||
        model.formatId == FormatVegasId)
    {
        
        PT_ScoreCardSplFormatViewController *scorecardViewController = [[PT_ScoreCardSplFormatViewController alloc] initWithEvent:eventModel];
        scorecardViewController.isComingFromMyscore = YES;
        [self presentViewController:scorecardViewController animated:YES completion:nil];
    }
    else
    {
        PT_LeaderBoardViewController *leaderboardViewController = [[PT_LeaderBoardViewController alloc] initWithEvent:eventModel];
        leaderboardViewController.isSeenAfterDelegate = YES;
        [self presentViewController:leaderboardViewController animated:YES completion:nil];
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
                                  [self.arrBanner addObject:model];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      [self.bannerImage setImageWithURL:[NSURL URLWithString:model.eventName]];
                                  }
                              }];
                          }
                          else
                          {
                              [self.bannerImage removeFromSuperview];
                              [self.bannerButton removeFromSuperview];
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
