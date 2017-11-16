//
//  PT_AddPlayerOptionsViewController.m
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_AddPlayerOptionsViewController.h"

#import "PT_PlayerItemModel.h"

#import "PT_SuggestionsView.h"

#import "PT_GroupsView.h"

#import "PT_WhatsAppOptionsView.h"

#import "PT_AddPlayerViaEmailView.h"

#import "PT_GroupItemModel.h"

#import "PT_PlayerIndividualCreationView.h"

#import "PT_CreateEventBusinessModel.h"

#import "PT_ViewParticipantsViewController.h"


//static int const BaseTagForAdded = 500;

//static int const BaseTagForInvite = 600;

static NSString *const SuggestionFriendListPostfix = @"getsuggessionfriendlist";

static NSString *const GroupListPostfix = @"getgrouplist";


@interface PT_AddPlayerOptionsViewController ()<UITextFieldDelegate>
{
    NSInteger totalCount4PlusPlayers;
    
    BOOL isAddPlayerThroughEmail;
     PT_CreatedEventModel *_createdEventModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;


@property (weak, nonatomic) IBOutlet UIButton *suggestionButton;
@property (weak, nonatomic) IBOutlet UIButton *groupsButton;
@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *whatsAppButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSelectImageX;

@property (strong, nonatomic) NSMutableArray *arrAddedGroups;
@property (strong, nonatomic) NSMutableArray *arrInviteGroups;

//Content views for Suggestions, groups
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) PT_SuggestionsView *suggestionView;
@property (strong, nonatomic) PT_GroupsView *groupsView;
@property (strong, nonatomic) PT_WhatsAppOptionsView *whatsAppOptionsView;
@property (strong, nonatomic) PT_AddPlayerViaEmailView *emailAddPlayerView;
@property(strong,nonatomic) PT_PlayerIndividualCreationView *playerView;
//Footer
@property (strong, nonatomic) PT_CreateEventBusinessModel *createEventModel;

@property (weak, nonatomic) IBOutlet UIView *footerView;

//Loader
@property(strong,nonatomic) MBProgressHUD *hud;


@end

@implementation PT_AddPlayerOptionsViewController

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
    
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.view.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.suggestionButton.frame.size.width * 5, self.scrollView.frame.size.height);
    
    _arrAddedGroups = [NSMutableArray new];
    _arrInviteGroups = [NSMutableArray new];
    
    self.addParticipantFooterView.hidden = YES;
    
    _createEventModel = [PT_CreateEventBusinessModel new];
    
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM]) {
        
        [self fetchSuggestedFriendListTeam];

    }else{
        
        if (_isComingFromAddParticipant == YES) {
            
            [self fetchSuggestedFriendListSuggestionsForAddparticipant];
        }else{

            [self fetchSuggestedFriendListSuggestions];
        }
    
    }
    
    [self fetchFriendsGoups];

   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotificationForAlreadyPresentInTeamA:) name:PLAYERPRESENTINTEAMA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotificationForAlreadyPresentInTeamB:) name:PLAYERPRESENTINTEAMB object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    if (_numberOfPlayers == NumberOfPlayers_MoreThan4)
    {
        self.groupsButton.userInteractionEnabled = YES;
    }
    else
    {
        self.groupsButton.userInteractionEnabled = NO;
        self.groupWidthConstraint.constant = 0;
    }
    
    if (_isComingFromAddParticipant == YES) {
        
        self.addParticipantFooterView.hidden = NO;
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(590, 47); }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications
- (void)receivedNotificationForAlreadyPresentInTeamA:(NSNotification *)notification
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"PUTT2GETHER"
                                  message:@"Player selected is already present in the team."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Dismiss"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    
    PT_PlayerItemModel *model = notification.object;
    for (int index = 0; index < self.arrInviteGroups.count; index++)
    {
        PT_PlayerItemModel *playerModel = self.arrInviteGroups[index];
        if (model.playerId == playerModel.playerId)
        {
            playerModel.isAddPlayerOption = NO;
            [self.suggestionView rearrangeContentsInPlayersList:model];
            [self.suggestionView refreshTable];
            
        }
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)receivedNotificationForAlreadyPresentInTeamB:(NSNotification *)notification
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"PUTT2GETHER"
                                  message:@"Player selected is already present in the team."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Dismiss"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    
    PT_PlayerItemModel *model = notification.object;
    for (int index = 0; index < self.arrInviteGroups.count; index++)
    {
        PT_PlayerItemModel *playerModel = self.arrInviteGroups[index];
        if (model.playerId == playerModel.playerId)
        {
            playerModel.isAddPlayerOption = NO;
            [self.suggestionView rearrangeContentsInPlayersList:model];
            [self.suggestionView refreshTable];
            
        }
    }

    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)actionSuggestions:(UIButton *)sender
{
    if (_hud != nil) {
        
        [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
        self.loaderView.hidden = YES;
    }
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    for (UIView *views in self.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    if (self.suggestionView == nil)
    {
        _suggestionView = [[[NSBundle mainBundle] loadNibNamed:@"PT_SuggestionsView" owner:self options:nil] firstObject];
        self.suggestionView.frame = self.contentView.bounds;
        _suggestionView.parentVC = self;
        [self.suggestionView setUpWithAddedGroup:self.arrAddedGroups andInviteGroup:self.arrInviteGroups];
    }
    
    self.constraintSelectImageX.constant = sender.center.x - (self.selectImageView.frame.size.width/2);
    
    
    [self.contentView addSubview:self.suggestionView];
    
    
}

- (IBAction)actionGroups:(UIButton *)sender
{
    for (UIView *views in self.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    if ([self.arrAddedGroups count] > 0)
    {
        if (_groupsView == nil)
        {
            _groupsView = [[[NSBundle mainBundle] loadNibNamed:@"PT_GroupsView" owner:self options:nil] firstObject];
            self.groupsView.frame = self.contentView.bounds;
        }
        
        [self.groupsView setUpWithAddedInviteGroup:self.arrAddedGroups];
        
        self.constraintSelectImageX.constant = sender.center.x - (self.selectImageView.frame.size.width/2);
        
        
        [self.contentView addSubview:self.groupsView];
    }
    else
    {
        [self fetchFriendsGoups];
    }
    
    
}

- (IBAction)actionAddPlayer:(UIButton *)sender
{
    
    
    isAddPlayerThroughEmail = YES;
    
    [self.scrollView setContentOffset:CGPointMake(100, 0) animated:YES];

    
    for (UIView *views in self.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    if (self.emailAddPlayerView == nil)
    {
        _emailAddPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"PT_AddPlayerViaEmailView" owner:self options:nil] objectAtIndex:0];
        self.emailAddPlayerView.frame = self.contentView.bounds;
        [self.emailAddPlayerView setBasicUI];
    }
    
    if (self.numberOfPlayers == NumberOfPlayers_MoreThan4)
    {
        
    }else{
        
        _emailAddPlayerView.addPlayerButton.hidden = YES;
    }

    
    self.constraintSelectImageX.constant = sender.center.x - (self.selectImageView.frame.size.width/2);
    [self.contentView addSubview:self.emailAddPlayerView];
}

- (IBAction)actionWhatsApp:(UIButton *)sender
{
    [self.scrollView setContentOffset:CGPointMake(150, 0) animated:YES];

    for (UIView *views in self.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    if (self.whatsAppOptionsView == nil)
    {
        _whatsAppOptionsView = [[[NSBundle mainBundle] loadNibNamed:@"PT_WhatsAppOptionsView" owner:self options:nil] firstObject];
        _whatsAppOptionsView.frame = self.contentView.bounds;
        _whatsAppOptionsView.inviteWhatsAppButton.layer.cornerRadius = 4.0;
        _whatsAppOptionsView.inviteWhatsAppButton.layer.borderWidth = 1.0;
        _whatsAppOptionsView.inviteWhatsAppButton.layer.masksToBounds = YES;
    }
    
    self.constraintSelectImageX.constant = sender.center.x - (self.selectImageView.frame.size.width/2);
    
    
    [self.contentView addSubview:self.whatsAppOptionsView];
}

- (IBAction)actionBack
{
    if (self.numberOfPlayers == NumberOfPlayers_MoreThan4)
    {
        
    }
    else
    {
       // NSLog(@"%@",self.suggestionView.arrInviteGroup);
        NSMutableArray *arrPlayers = [NSMutableArray new];
        [self.suggestionView.arrInviteGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PT_PlayerItemModel *playerModel = obj;
            if (playerModel.isAddPlayerOption == YES)
            {
                [arrPlayers addObject:obj];
                
            }
            if (idx == [self.suggestionView.arrInviteGroup count]-1)
            {
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setEventSuggestionFriends:arrPlayers];
            }
        }];
    }
    
    if (_isComingFromAddParticipant == YES) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate.tabBarController setSelectedIndex:1];
        //[self actionBAck];
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:NULL];
        
    }else{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)actionHome:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate addTabBarAsRootViewController];
    
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
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

- (void)calculateTotalNumberOfPlayersFor4PlusEvent
{
    //self.suggestionView.arrNumberOfPlayers4Plus
    NSInteger totalCount = 0;
    //NSMutableArray *groupArray = [[NSMutableArray alloc] initWithArray:self.groupsView.arrSelectedGroups];
    NSMutableArray *groupArray = self.groupsView.arrSelectedGroups;
    
    for (NSInteger counter = 0; counter < groupArray.count; counter++)
    {
        PT_GroupItemModel *groupModelAtIndex = groupArray[counter];
        NSMutableArray *arrGroupMembers = [[NSMutableArray alloc] initWithArray:groupModelAtIndex.arrGroupMembers];
        
        for (NSInteger countMembers = 0; countMembers < arrGroupMembers.count; countMembers++)
        {
            NSDictionary *dicGrpMember = arrGroupMembers[countMembers];
            NSInteger memberId = [dicGrpMember[@"user_id"] integerValue];
            for (NSInteger countSuggest = 0; countSuggest < self.suggestionView.arrNumberOfPlayers4Plus.count; countSuggest++)
            {
                PT_PlayerItemModel *model = self.suggestionView.arrNumberOfPlayers4Plus[countSuggest];
                if (model.playerId == memberId)
                {
                    [arrGroupMembers removeObjectAtIndex:countMembers];
                }
            }
        }
        
        totalCount = totalCount + arrGroupMembers.count;
    }
    
    //totalCount = totalCount + self.suggestionView.arrNumberOfPlayers4Plus.count;
    totalCount4PlusPlayers = totalCount;
}

- (IBAction)actionPreviewEvent
{
    
    if (isAddPlayerThroughEmail == YES) {
        
        if (self.numberOfPlayers == NumberOfPlayers_MoreThan4)
        {
            NSMutableArray *arrPlayers = [NSMutableArray new];

    for (int i = 0; i < [_emailAddPlayerView.arrViewContainers count]; i++) {
        NSLog(@"%@",_emailAddPlayerView.playerView.textEmail.text);

        _emailAddPlayerView.playerView = [_emailAddPlayerView.arrViewContainers objectAtIndex:i];
       
       PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
      playerModel.email = _emailAddPlayerView.playerView.textEmail.text;
       playerModel.playerName = _emailAddPlayerView.playerView.textDisplayName.text;
       
       playerModel.counts = [_emailAddPlayerView.playerView.textHandicap.text integerValue];

       [arrPlayers addObject:playerModel];
                
            }
            totalCount4PlusPlayers = totalCount4PlusPlayers + [self.emailAddPlayerView.arrViewContainers count];
       
       [[PT_PreviewEventSingletonModel sharedPreviewEvent] setPlayerAddedThroughEmail:arrPlayers];
    

            
        }
        
        else{
            
            if (self.isIntermediateAddPlayer == YES)
            {
                NSMutableArray *arrPlayers = [NSMutableArray new];

                PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
                playerModel.email = _emailAddPlayerView.playerView.textEmail.text;
                playerModel.playerName = _emailAddPlayerView.playerView.textDisplayName.text;
                
                playerModel.counts = [_emailAddPlayerView.playerView.textHandicap.text integerValue];
                
                [arrPlayers addObject:playerModel];
                
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self.intermediatePlayerVC.isAddingThroughEmail = YES;
                    [self.intermediatePlayerVC setSelectedPlayer:playerModel];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    //return;
                });
                
                return;
                
            }else{
                
                NSMutableArray *arrPlayers = [NSMutableArray new];
                
                PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
                playerModel.email = _emailAddPlayerView.playerView.textEmail.text;
                playerModel.playerName = _emailAddPlayerView.playerView.textDisplayName.text;
                playerModel.teamNum = _TeamNum;
                playerModel.counts = [_emailAddPlayerView.playerView.textHandicap.text integerValue];
                
                [arrPlayers addObject:playerModel];

                [self actionAddedEmailPlayers:arrPlayers];
                
                return;
            }
            
        }
        
    }
    
    if (self.numberOfPlayers == NumberOfPlayers_MoreThan4)
    {
        [self calculateTotalNumberOfPlayersFor4PlusEvent];
        totalCount4PlusPlayers = totalCount4PlusPlayers + [self.suggestionView.arrNumberOfPlayers4Plus count];
        //if ([self.suggestionView.arrNumberOfPlayers4Plus count] < 4)
        NSLog(@"%@",self.groupsView.arrSelectedGroups);
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setGroups:self.groupsView.arrSelectedGroups];
        
            PT_PlayerItemModel *model = [PT_PlayerItemModel new];
            model.playerName = [[MGUserDefaults sharedDefault] getDisplayName];
            model.playerId = [[MGUserDefaults sharedDefault] getUserId];
            model.isAdmin = YES;
            [self.suggestionView.arrNumberOfPlayers4Plus addObject:model];
        
    }
    else
    {
        if ([self.suggestionView.arrInviteGroup count] == self.numberOfPlayers)
        {
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setGroups:self.groupsView.arrSelectedGroups];
            NSMutableArray *arrPlayers = [NSMutableArray new];
            [self.suggestionView.arrInviteGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PT_PlayerItemModel *playerModel = obj;
                if (playerModel.isAddPlayerOption == YES)
                {
                    [arrPlayers addObject:obj];
                    
                }
                if (idx == [self.suggestionView.arrInviteGroup count]-1)
                {
                    
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setEventSuggestionFriends:arrPlayers];
                }
            }];
        }
        else
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Please select atleast %li players",(long)self.numberOfPlayers]];
        }
        
    }
    PT_EventPreviewViewController *previewVC = [PT_EventPreviewViewController new];
    previewVC.isEditMode = NO;
    previewVC.totalCount4PlusPlayers = totalCount4PlusPlayers;
    [self presentViewController:previewVC animated:YES completion:nil];
}

- (void)actionSuggestionPlayers:(NSArray *)players
{
    NSMutableArray *arrData = [NSMutableArray new];
    for (int index = 0; index < players.count; index ++)
    {
        PT_PlayerItemModel *model = players[index];
        PT_PlayerItemModel *modelToSend = [PT_PlayerItemModel new];
        modelToSend.playerName = model.playerName;
        modelToSend.playerImageURL = model.playerImageURL;
        modelToSend.email = model.email;
        modelToSend.playerId = model.playerId;
        modelToSend.counts = model.counts;
        modelToSend.isAdmin = NO;
        modelToSend.isAddPlayerOption = NO;                 //Changes
        [arrData addObject:modelToSend];
        
    }
    
    [self.previousVC setDataForTeamWithArray:arrData];
    [self.previousVC actionBack];
}

- (void)actionAddedEmailPlayers:(NSArray *)players
{
    NSMutableArray *arrData = [NSMutableArray new];
    for (int index = 0; index < players.count; index ++)
    {
        PT_PlayerItemModel *model = players[index];
        PT_PlayerItemModel *modelToSend = [PT_PlayerItemModel new];
        modelToSend.playerName = model.playerName;
        modelToSend.email = model.email;
        modelToSend.playerId = model.playerId;
        modelToSend.counts = model.counts;
        modelToSend.teamNum = model.teamNum;
        modelToSend.isAdmin = NO;
        modelToSend.isAddPlayerOption = NO;
        [arrData addObject:modelToSend];
        
    }
    
    self.previousVC.isAddingThroughEmail = YES;
    [self.previousVC setDataForTeamWithArray:arrData];
    [self.previousVC actionBack];
}

- (void)actionRemoveSuggestionPlayer:(PT_PlayerItemModel *)model
{
    [self.previousVC removeDataForTeamWithArray:model];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Service calls

- (void)fetchSuggestedFriendListSuggestions
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
                                @"searchkey":@"",
                                @"version":@"2"
                                };
        
      _hud =  [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,SuggestionFriendListPostfix]
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
                                  NSArray *suggestionList = dataOutput[@"Suggestion List"];
                                  if (!(suggestionList == (id)[NSNull null]))
                                  {
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
                                          NSDictionary *dataObj = obj;
                                          playerModel.playerName = dataObj[@"full_name"];
                                          playerModel.playerId = [dataObj[@"user_id"] integerValue];
                                          playerModel.playerImageURL = dataObj[@"thumb_image"];
                                          playerModel.counts = [dataObj[@"self_handicap"] integerValue];
                                          playerModel.email = dataObj[@"user_name"];
                                          playerModel.isAdmin = NO;
                                          BOOL isExisting = NO;
                                          NSArray *arrExistingFriends = [self.intermediatePlayerVC getPlayersArray];
                                          for (NSInteger count = 0; count < [arrExistingFriends count]; count++)
                                          {
                                              PT_PlayerItemModel *model = arrExistingFriends[count];
                                              if (model.playerId == playerModel.playerId)
                                              {
                                                  isExisting = YES;
                                              }
                                          }
                                          if (isExisting == NO)
                                          {
                                              [self.arrInviteGroups addObject:playerModel];
                                          }
                                          /*
                                          BOOL isTeamPlayerExist = NO;
                                          NSArray *arrTeamExistingPlayer = [self.previousVC getTeamPlayersArray];
                                          for (NSInteger count = 0; count < [arrTeamExistingPlayer count]; count++)
                                          {
                                              PT_PlayerItemModel *model = arrTeamExistingPlayer[count];
                                              if (model.playerId == playerModel.playerId)
                                              {
                                                  isTeamPlayerExist = YES;
                                              }
                                          }
                                          if (isTeamPlayerExist == NO)
                                          {
                                              [self.arrInviteGroups addObject:playerModel];
                                          }
                                          */
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              
                                              [self actionSuggestions:self.suggestionButton];
                                          }
                                          
                                      }];
                                  }
                                  else
                                  {
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                                    message:@"No data available. Please try again"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      
                                      
                                      UIAlertAction* cancel = [UIAlertAction
                                                               actionWithTitle:@"Dismiss"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   //[self dismissViewControllerAnimated:YES completion:nil];
                                                                   
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
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
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
                      
                      else
                      {
                          
                          
                      }
                  }
                  else
                  {
                      [self fetchSuggestedFriendListSuggestions];
                      //[self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }

}

- (void)fetchSuggestedFriendListTeam
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
                                @"searchkey":@"",
                                @"version":@"2"
                                };
        
      _hud =  [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,SuggestionFriendListPostfix]
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
                                  NSArray *suggestionList = dataOutput[@"Suggestion List"];
                                  if (!(suggestionList == (id)[NSNull null]))
                                  {
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
                                          NSDictionary *dataObj = obj;
                                          playerModel.playerName = dataObj[@"full_name"];
                                          playerModel.playerId = [dataObj[@"user_id"] integerValue];
                                          playerModel.playerImageURL = dataObj[@"thumb_image"];
                                          playerModel.counts = [dataObj[@"self_handicap"] integerValue];
                                          playerModel.email = dataObj[@"user_name"];
                                          playerModel.isAdmin = NO;
                                          BOOL isExisting = NO;
                                          NSArray *arrExistingFriends = [self.previousVC getTeamPlayersArray];
                                          for (NSInteger count = 0; count < [arrExistingFriends count]; count++)
                                          {
                                              PT_PlayerItemModel *model = arrExistingFriends[count];
                                              if (model.playerId == playerModel.playerId)
                                              {
                                                  isExisting = YES;
                                              }
                                          }
                                          if (isExisting == NO)
                                          {
                                              [self.arrInviteGroups addObject:playerModel];
                                          }
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              [self actionSuggestions:self.suggestionButton];
                                          }
                                          
                                      }];
                                  }
                                  else
                                  {
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                                    message:@"No data available. Please try again"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      
                                      
                                      UIAlertAction* cancel = [UIAlertAction
                                                               actionWithTitle:@"Dismiss"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   //[self dismissViewControllerAnimated:YES completion:nil];
                                                                   
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
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
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
                      
                      else
                      {
                          
                          
                      }
                  }
                  else
                  {
                      [self fetchSuggestedFriendListTeam];
                      //[self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

- (void)fetchFriendsGoups
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,GroupListPostfix]
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
                                  if (!(suggestionList == (id)[NSNull null]))
                                  {
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          
                                          NSDictionary *dataObj = obj;
                                          PT_GroupItemModel *groupModel = [PT_GroupItemModel new];
                                          groupModel.groupId = [dataObj[@"group_id"] integerValue];
                                          groupModel.groupName = dataObj[@"group_name"];
                                          groupModel.groupImageURL = dataObj[@"profile_img"];
                                          groupModel.arrGroupMembers = dataObj[@"group_member_id"];
                                          [self.arrAddedGroups addObject:groupModel];
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              //[self actionGroups:self.groupsButton];
                                          }
                                          
                                      }];
                                  }
                                  else
                                  {
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                                    message:@"No data available. Please try again"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      
                                      
                                      UIAlertAction* cancel = [UIAlertAction
                                                               actionWithTitle:@"Dismiss"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   //[self dismissViewControllerAnimated:YES completion:nil];
                                                                   
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
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
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
                      
                      else
                      {
                          
                          
                      }
                  }
                  else
                  {
                      [self fetchFriendsGoups];
                      //[self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}


-(IBAction)actionNext:(id)sender{
    
    if (isAddPlayerThroughEmail == YES) {
        
        if (self.numberOfPlayers == NumberOfPlayers_MoreThan4)
        {
            NSMutableArray *arrPlayers = [NSMutableArray new];
            
            for (int i = 0; i < [_emailAddPlayerView.arrViewContainers count]; i++) {
                NSLog(@"%@",_emailAddPlayerView.playerView.textEmail.text);
                
                _emailAddPlayerView.playerView = [_emailAddPlayerView.arrViewContainers objectAtIndex:i];
                
                PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
                playerModel.email = _emailAddPlayerView.playerView.textEmail.text;
                playerModel.playerName = _emailAddPlayerView.playerView.textDisplayName.text;
                
                playerModel.counts = [_emailAddPlayerView.playerView.textHandicap.text integerValue];
                
                [arrPlayers addObject:playerModel];
                
            }
            
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setPlayerAddedThroughEmail:arrPlayers];
        }
    }
    
    if (self.numberOfPlayers == NumberOfPlayers_MoreThan4)
    {
        [self calculateTotalNumberOfPlayersFor4PlusEvent];
        totalCount4PlusPlayers = totalCount4PlusPlayers + [self.suggestionView.arrNumberOfPlayers4Plus count];
        //if ([self.suggestionView.arrNumberOfPlayers4Plus count] < 4)
       
        /*
            PT_PlayerItemModel *model = [PT_PlayerItemModel new];
            model.playerName = [[MGUserDefaults sharedDefault] getDisplayName];
            model.playerId = [[MGUserDefaults sharedDefault] getUserId];
            model.isAdmin = YES;
            [self.suggestionView.arrNumberOfPlayers4Plus addObject:model];
        */
        
        
    }
    
    [self actionAddParticipant];

    
}


- (void)actionAddParticipant
{

    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayers:@"4+"];
        
        //Version
        NSString *version = @"2";
    
        
    
               //Event friend number
        NSString *eventNumberFriend = [NSString stringWithFormat:@"%li",(unsigned long)[[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventSuggestionFriends] count]];
        
    
        //Invite List
        NSArray *arrInviteList = [self.createEventModel getAddedThroughEmailList];//[[NSArray alloc] init];
        
        //group list
        NSArray *arrGroupList = [self.createEventModel getGroups];;
        
        //Event Suggestion Friend List
        NSArray *arrSuggestionFriends = [self.createEventModel getSuggestionFriendList];
    
        
        NSDictionary *param;
    
            param = @{@"version":version,
                      @"event_id":[NSString stringWithFormat:@"%li",(long)_createdEventModel.eventId],
                      @"event_admin_id":[NSString stringWithFormat:@"%li",(long)_createdEventModel.adminId],
                     @"event_friend_num":eventNumberFriend,
                      @"invited_email_list":arrInviteList,
                      @"event_group_list":arrGroupList,
                      @"event_friend_list":arrSuggestionFriends,
                      };
    
        
        
        NSLog(@"%@",param);
        [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        
        
    NSString *urlString = @"addparticipantinevent";
    
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
                  self.loaderView.hidden = YES;
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
                                                               
                                                               PT_ViewParticipantsViewController *viewParticipantVc = [[PT_ViewParticipantsViewController alloc] initWithEventModel:_createdEventModel];
                                                               
                                                               [self presentViewController:viewParticipantVc animated:YES completion:nil];
                                                              
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

- (void)fetchSuggestedFriendListSuggestionsForAddparticipant
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
                                @"searchkey":@"",
                                @"version":@"2",
                                @"event_id":[NSString stringWithFormat:@"%li",(long)_createdEventModel.eventId]
                                };
        
       _hud =  [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,SuggestionFriendListPostfix]
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
                                  NSArray *suggestionList = dataOutput[@"Suggestion List"];
                                  if (!(suggestionList == (id)[NSNull null]))
                                  {
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
                                          NSDictionary *dataObj = obj;
                                          playerModel.playerName = dataObj[@"full_name"];
                                          playerModel.playerId = [dataObj[@"user_id"] integerValue];
                                          playerModel.playerImageURL = dataObj[@"thumb_image"];
                                          playerModel.counts = [dataObj[@"self_handicap"] integerValue];
                                          playerModel.email = dataObj[@"user_name"];
                                          playerModel.isAdmin = NO;
                                          playerModel.isAdded = [dataObj[@"added"] integerValue];
                                          
                                          BOOL isExisting = NO;

                                          if (playerModel.isAdded == 1) {
                                              
                                              isExisting = YES;
                                          }
                                          if (isExisting == NO)
                                          {
                                              [self.arrInviteGroups addObject:playerModel];
                                          }
                                          /*
                                           BOOL isTeamPlayerExist = NO;
                                           NSArray *arrTeamExistingPlayer = [self.previousVC getTeamPlayersArray];
                                           for (NSInteger count = 0; count < [arrTeamExistingPlayer count]; count++)
                                           {
                                           PT_PlayerItemModel *model = arrTeamExistingPlayer[count];
                                           if (model.playerId == playerModel.playerId)
                                           {
                                           isTeamPlayerExist = YES;
                                           }
                                           }
                                           if (isTeamPlayerExist == NO)
                                           {
                                           [self.arrInviteGroups addObject:playerModel];
                                           }
                                           */
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              [self actionSuggestions:self.suggestionButton];
                                          }
                                          
                                      }];
                                  }
                                  else
                                  {
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                                    message:@"No data available. Please try again"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      
                                      
                                      UIAlertAction* cancel = [UIAlertAction
                                                               actionWithTitle:@"Dismiss"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   //[self dismissViewControllerAnimated:YES completion:nil];
                                                                   
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
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
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
                      
                      else
                      {
                          
                          
                      }
                  }
                  else
                  {
                      [self fetchSuggestedFriendListSuggestionsForAddparticipant];
                      //[self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}







@end
