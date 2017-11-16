//
//  PT_AddPlayerMainViewController.m
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

static int const BaseTagForTeamA = 500;

static int const BaseTagForTeamB = 600;

#import "PT_AddPlayerMainViewController.h"

#import "PT_AddPalyerTableViewCell.h"

#import "PT_AddPlayerOptionsViewController.h"

@interface PT_AddPlayerMainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablePlayers;

@property (strong, nonatomic) NSMutableArray *arrTeamB,*arrEmailTeamA,*mainArray;

@property (strong, nonatomic) NSMutableArray *arrTeamA,*arrEmailTeamB;

@end

@implementation PT_AddPlayerMainViewController

- (instancetype)initWithDelegate:(PT_CreateViewController *)parent
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    self.createVC = parent;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _arrTeamA = [NSMutableArray new];
    
    _arrTeamB = [NSMutableArray new];
    
    _arrEmailTeamA = [NSMutableArray new];
    
    _arrEmailTeamB = [NSMutableArray new];
    
    _mainArray = [NSMutableArray new];
    
    [self createStubForTeamA];
    [self createStubForTeamB];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tablePlayers reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createStubForTeamA
{
    PT_PlayerItemModel *player1 = [PT_PlayerItemModel new];
    player1.playerName = [[MGUserDefaults sharedDefault] getDisplayName];
    player1.playerId = [[MGUserDefaults sharedDefault] getUserId];
    player1.counts = [[[MGUserDefaults sharedDefault] getHandicap] integerValue];
    player1.isAdmin = YES;
    player1.isAddPlayerOption = NO;
    [self.arrTeamA addObject:player1];
    
    PT_PlayerItemModel *addUserTeamA = [PT_PlayerItemModel new];
    addUserTeamA.isAdmin = NO;
    addUserTeamA.playerName = @"ADD PLAYER";
    addUserTeamA.isAddPlayerOption = YES;
    [self.arrTeamA addObject:addUserTeamA];
}

- (void)createStubForTeamB
{
    
    PT_PlayerItemModel *addUser = [PT_PlayerItemModel new];
    addUser.playerName = @"ADD PLAYER";
    addUser.isAddPlayerOption = YES;
    [self.arrTeamB addObject:addUser];
    
    [self.tablePlayers reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 48);
        UIColor *bgColor = [UIColor colorWithRed:(221/255.0f) green:(221/255.0f) blue:(221/255.0f) alpha:1.0];
        headerView.backgroundColor = bgColor;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(6, headerView.frame.size.height/2 - 10, headerView.frame.size.width - 12, 20);
        titleLabel.text = @"TEAM A";
        titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17];
        [headerView addSubview:titleLabel];
        return headerView;
    }
    else
    {
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 48);
        UIColor *bgColor = [UIColor colorWithRed:(221/255.0f) green:(221/255.0f) blue:(221/255.0f) alpha:1.0];
        headerView.backgroundColor = bgColor;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(6, headerView.frame.size.height/2 - 10, headerView.frame.size.width - 12, 20);
        titleLabel.text = @"TEAM B";
        titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17];
        [headerView addSubview:titleLabel];
        return headerView;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.arrTeamA count];
    }
    else
    {
        return [self.arrTeamB count];
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    
    if (indexPath.section == 0)
    {
    
        PT_PlayerItemModel *model = self.arrTeamA[indexPath.row];
        
        PT_AddPalyerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_AddPalyerTableViewCell"
                                                  owner:self
                                                options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.addRemoveButton.tag = BaseTagForTeamA + indexPath.row;
        cell.removeButton.tag = BaseTagForTeamA + indexPath.row;
        cell.removeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cell.tag = BaseTagForTeamA;
        cell.addRemoveButton.layer.cornerRadius = cell.addRemoveButton.frame.size.width/2;
        cell.addRemoveButton.layer.borderWidth = 1.0;
        cell.addRemoveButton.layer.masksToBounds = YES;
        [cell.addRemoveButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
        [cell.removeButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
        
        if (model.isAdmin == YES)
        {
            NSString *title = [NSString stringWithFormat:@"%@ %li",model.playerName,model.counts];
            cell.playerName.font = [UIFont fontWithName:@"Lato-Bold" size:17];
            cell.adminLabel.hidden = NO;
            cell.addRemoveButton.hidden = YES;
            cell.playerName.text = title;
            cell.removeButton.hidden = YES;
        }
        else
        {
            
            cell.adminLabel.hidden = YES;
            NSString *title;
            if (model.isAddPlayerOption == YES)
            {
                cell.removeButton.hidden = YES;
                cell.addRemoveButton.hidden = YES;
                title = [NSString stringWithFormat:@"%@",model.playerName];
                [cell.addRemoveButton setTitle:@"+" forState:UIControlStateNormal];
            }
            else
            {
                title = [NSString stringWithFormat:@"%@ %li ",model.playerName,(long)model.counts];
                cell.addRemoveButton.titleLabel.text = @"-";
                cell.addRemoveButton.hidden = YES;
                cell.removeButton.hidden = NO;
            }
            
            cell.playerName.text = title;
            
            [cell.addRemoveButton setNeedsDisplay];
            
            
        }
        
        return cell;
    }
    else
    {
        PT_PlayerItemModel *model = self.arrTeamB[indexPath.row];
        
        PT_AddPalyerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamBCellIdentifier"];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_AddPalyerTableViewCell"
                                                  owner:self
                                                options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.tag = BaseTagForTeamB;
        cell.addRemoveButton.tag = BaseTagForTeamB + indexPath.row;
        cell.removeButton.tag = BaseTagForTeamB + indexPath.row;
        cell.removeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cell.addRemoveButton.layer.cornerRadius = cell.addRemoveButton.frame.size.width/2;
        cell.addRemoveButton.layer.borderWidth = 1.0;
        cell.addRemoveButton.layer.masksToBounds = YES;
        cell.addRemoveButton.hidden = YES;
        [cell.addRemoveButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
        [cell.removeButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
        
        if (model.isAddPlayerOption == YES)
        {
            //cell.playerName.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            cell.playerName.text = model.playerName;
            [cell.addRemoveButton setTitle:@"+" forState:UIControlStateNormal];
            cell.adminLabel.hidden = YES;
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"%@ %li",model.playerName,model.counts];
            cell.playerName.text = title;
            
            if (model.isAdmin == YES)
            {
                cell.addRemoveButton.hidden = YES;
                cell.removeButton.hidden = YES;
            }
            else
            {
                cell.adminLabel.hidden = YES;
                cell.removeButton.hidden = NO;
            }
        }
    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self checkForMaxPlayerForSection:indexPath.section])
    {
        return;
    }
    else
    {
        PT_AddPalyerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.tag == BaseTagForTeamA)
        {
            if (indexPath.row == 1)
            {
                self.selectedTeamType = TeamType_A;
                PT_AddPlayerOptionsViewController *addPlayersOptionsVC = [[PT_AddPlayerOptionsViewController alloc] initWithNibName:@"PT_AddPlayerOptionsViewController" bundle:nil];
                addPlayersOptionsVC.numberOfPlayers = self.createVC.currentNumOfPlayersSelected;
                addPlayersOptionsVC.TeamNum = 1;
                addPlayersOptionsVC.previousVC = self;
                [self presentViewController:addPlayersOptionsVC animated:YES completion:nil];
            }
        }
        else if (cell.tag == BaseTagForTeamB)
        {
            PT_PlayerItemModel *addUser = self.arrTeamB[indexPath.row];
            //addUser.playerName = @"ADD PLAYER";
            if (addUser.isAddPlayerOption == YES)
            //if (indexPath.row == 0)
            {
                self.selectedTeamType = TeamType_B;
                PT_AddPlayerOptionsViewController *addPlayersOptionsVC = [[PT_AddPlayerOptionsViewController alloc] initWithNibName:@"PT_AddPlayerOptionsViewController" bundle:nil];
                addPlayersOptionsVC.numberOfPlayers = self.createVC.currentNumOfPlayersSelected;
                addPlayersOptionsVC.TeamNum = 2;

                addPlayersOptionsVC.previousVC = self;
                [self presentViewController:addPlayersOptionsVC animated:YES completion:nil];
            }
            
        }

    }
    
}

- (BOOL)checkForMaxPlayerForSection:(NSInteger)section
{
    BOOL returnValue = NO;
    switch (section) {
        case 0:
        {
            if ([self.arrTeamA count] >= 3)
            {
                returnValue = YES;
            }
            
        }
            break;
        case 1:
        {
            if ([self.arrTeamB count] >= 3)
            {
                returnValue = YES;
            }
            
        }
            break;
    }
    return returnValue;
}

- (BOOL)checkForMaximumPlayers
{
    BOOL returnValue = NO;
    if (([self.arrTeamA count] + [self.arrTeamB count]) == 7)
    {
        returnValue = YES;
        
    }
    return returnValue;
}

- (IBAction)actionPreviewEvent
{
    PT_EventPreviewViewController *previewVC = [PT_EventPreviewViewController new];
    previewVC.isEditMode = NO;
    [self presentViewController:previewVC animated:YES completion:nil];
}

- (void)actionAddRemovePlayer:(UIButton *)sender
{
    NSString * allDigits = [NSString stringWithFormat:@"%li", (long)sender.tag];
    NSString * topDigits = [allDigits substringToIndex:1];
    if ([topDigits integerValue] == 5)
    {
        self.selectedTeamType = TeamType_A;
    }
    else if ([topDigits integerValue] == 6)
    {
        self.selectedTeamType = TeamType_B;
    }
    
    if ([sender.titleLabel.text isEqualToString:@"+"])
    {
        PT_AddPlayerOptionsViewController *addPlayersOptionsVC = [[PT_AddPlayerOptionsViewController alloc] initWithNibName:@"PT_AddPlayerOptionsViewController" bundle:nil];
        addPlayersOptionsVC.numberOfPlayers = self.createVC.currentNumOfPlayersSelected;
        addPlayersOptionsVC.previousVC = self;
        addPlayersOptionsVC.isIntermediateAddPlayer = YES;
        [self presentViewController:addPlayersOptionsVC animated:YES completion:nil];
    }
    else
    {
        //if (sender.tag - BaseTagForTeamA == 0 || sender.tag - BaseTagForTeamA == 1)
        if ([topDigits integerValue] == 5)
        {
            NSLog(@"Section 0 : %li",(long)sender.tag - BaseTagForTeamA);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.arrTeamA count] > 1)
                {
                    __block BOOL isToAddPlayer = NO;
                    if ([self.arrTeamA count] == 2)
                    {
                        [self.arrTeamA enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            PT_PlayerItemModel *addUser = obj;
                            if (addUser.isAddPlayerOption == YES)
                            {
                                isToAddPlayer = YES;
                            }
                        }];
                        
                    }
                    [self.arrTeamA removeObjectAtIndex:sender.tag - BaseTagForTeamA];
                    if (isToAddPlayer == NO)
                    {
                        PT_PlayerItemModel *addUser = [PT_PlayerItemModel new];
                        addUser.playerName = @"ADD PLAYER";
                        addUser.isAddPlayerOption = YES;
                        [self.arrTeamA insertObject:addUser atIndex:1];
                    }
                    [self.tablePlayers reloadData];
                }
            });
        }
        //else if (sender.tag - BaseTagForTeamB == 0 || sender.tag - BaseTagForTeamB == 1)
        else if ([topDigits integerValue] == 6)
        {
            NSLog(@"Section 0 : %li",(long)sender.tag - BaseTagForTeamB);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.arrTeamB count] >= 1)
                {
                   __block BOOL isToAddPlayer = NO;
                    if ([self.arrTeamB count] == 2)
                    {
                        [self.arrTeamB enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            PT_PlayerItemModel *addUser = obj;
                            if (addUser.isAddPlayerOption == YES)
                            {
                                isToAddPlayer = YES;
                            }
                        }];
                        
                    }
                    [self.arrTeamB removeObjectAtIndex:sender.tag - BaseTagForTeamB];
                    
                    if (isToAddPlayer == NO)
                    {
                        PT_PlayerItemModel *addUser = [PT_PlayerItemModel new];
                        addUser.playerName = @"ADD PLAYER";
                        addUser.isAddPlayerOption = YES;
                        [self.arrTeamB insertObject:addUser atIndex:1];
                    }
                    [self.tablePlayers reloadData];
                }
            });
            
        }
    }
}

- (IBAction)actionBack
{
    
    if (_isAddingThroughEmail == YES) {
        
        _isAddingThroughEmail =  NO;
        NSArray *arrAdded = [self.arrTeamA arrayByAddingObjectsFromArray:self.arrTeamB];
        
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setPlayerAddedThroughEmail:arrAdded];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeamA:self.arrTeamA];

        
    }else{
    
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeamA:self.arrTeamA];
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeamB:self.arrTeamB];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (NSArray *)getTeamPlayersArray
{
     //NSArray *arrExistingFriends = [self.intermediatePlayerVC getPlayersArray];
    NSArray *array = [_arrTeamA arrayByAddingObjectsFromArray:_arrTeamB];
    return array;
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

- (void)setDataForTeamWithArray:(NSArray *)playerList
{
    
    if (self.selectedTeamType == TeamType_A)
    {
        [playerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PT_PlayerItemModel *modelToAdd = obj;
            BOOL isAlreadyPresent = NO;
            for (int index = 0; index < self.arrTeamA.count; index++)
            {
                PT_PlayerItemModel *modelReceived = self.arrTeamA[index];
                if ([modelReceived.email isEqualToString:modelToAdd.email])
                {
                    isAlreadyPresent = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"PUTT2GETHER"
                                                      message:@"Player selected is already added in the team."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        
                        
                        UIAlertAction* cancel = [UIAlertAction
                                                 actionWithTitle:@"Dismiss"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action)
                                                 {
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 }];
                        
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:NO completion:nil];
                    });
                    
                }
                if ([self checkIfPlayerPresentInTeamB:modelToAdd])
                {
                    isAlreadyPresent = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"PUTT2GETHER"
                                                      message:@"Player selected is already present in the team B."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        
                        
                        UIAlertAction* cancel = [UIAlertAction
                                                 actionWithTitle:@"Dismiss"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action)
                                                 {
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 }];
                        
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:NO completion:nil];
                    });
                    
                    
                }
                
            }
            if (isAlreadyPresent == NO)
            {
                [self.arrTeamA insertObject:obj atIndex:1];
                [self.mainArray addObject:obj];
            }
            
            if (idx == [playerList count] - 1)
            {
                if([self.arrTeamA count] == 3)
                {
                    [self.arrTeamA removeLastObject];
                    [self.mainArray removeLastObject];
                }
                [self.tablePlayers reloadData];
            }
            
        }];
        
    }
    else if (self.selectedTeamType == TeamType_B)
    {
        [playerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PT_PlayerItemModel *modelToAdd = obj;
            BOOL isAlreadyPresent = NO;
            for (int index = 0; index < self.arrTeamB.count; index++)
            {
                PT_PlayerItemModel *modelReceived = self.arrTeamB[index];
                if ([modelReceived.email isEqualToString:modelToAdd.email])
                {
                    isAlreadyPresent = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"PUTT2GETHER"
                                                      message:@"Player selected is already added in the team."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        
                        
                        UIAlertAction* cancel = [UIAlertAction
                                                 actionWithTitle:@"Dismiss"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action)
                                                 {
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 }];
                        
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:NO completion:nil];
                    });
                    
                    
                }
                if ([self checkIfPlayerPresentInTeamA:modelToAdd])
                {
                    isAlreadyPresent = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"PUTT2GETHER"
                                                      message:@"Player selected is already present in team A."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        
                        
                        UIAlertAction* cancel = [UIAlertAction
                                                 actionWithTitle:@"Dismiss"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action)
                                                 {
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 }];
                        
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:NO completion:nil];
                    });
                    
                    
                }
                
            }
            if (isAlreadyPresent == NO)
            {
                //[self.arrTeamB addObject:obj];
                if ([self.arrTeamB count] == 1 || [self.arrEmailTeamB count] == 1 )
                {
                    [self.arrTeamB insertObject:obj atIndex:0];
                }
                else
                {
                    [self.arrTeamB insertObject:obj atIndex:1];
                }
                [self.mainArray addObject:obj];
            }
            
            if (idx == [playerList count] - 1)
            {
                if([self.arrTeamB count] == 3)
                {
                    [self.arrTeamB removeLastObject];
                    [self.mainArray removeLastObject];
                }
                [self.tablePlayers reloadData];
            }
            
        }];
    }
}

- (void)removeDataForTeamWithArray:(PT_PlayerItemModel *)playerModel
{
    if (self.selectedTeamType == TeamType_A)
    {
        [self.arrTeamA enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL found = NO;
            PT_PlayerItemModel *modelTeamA = obj;
            if ([playerModel.playerName isEqualToString:modelTeamA.playerName])
            {
                [self.arrTeamA removeObjectAtIndex:idx];
                [self.mainArray removeObjectAtIndex:idx];
                PT_PlayerItemModel *addUser = [PT_PlayerItemModel new];
                addUser.playerName = @"ADD PLAYER";
                addUser.isAddPlayerOption = YES;
                [self.arrTeamA insertObject:addUser atIndex:[self.arrTeamA count]];
                found = YES;
            }
            
            
            if (found == YES)
            {
                
                [self.tablePlayers reloadData];
            }
            
        }];
        
    }
    else if (self.selectedTeamType == TeamType_B)
    {
        [self.arrTeamB enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL found = NO;
            PT_PlayerItemModel *modelTeamB = obj;
            if ([playerModel.playerName isEqualToString:modelTeamB.playerName])
            {
               /* BOOL isToAddPlayer = NO;
                if ([self.arrTeamB count] == 2)
                {
                    isToAddPlayer = YES;
                }*/
                [self.arrTeamB removeObjectAtIndex:idx];
                [self.mainArray removeObjectAtIndex:idx];

                /*if (isToAddPlayer == YES)
                {
                    PT_PlayerItemModel *addUser = [PT_PlayerItemModel new];
                    addUser.playerName = @"ADD PLAYER";
                    addUser.isAddPlayerOption = YES;
                    [self.arrTeamB insertObject:addUser atIndex:2];
                }*/
                found = YES;
            }
            
            
            if (found == YES)
            {
                
                [self.tablePlayers reloadData];
            }
            
        }];
    }
}

- (BOOL)checkIfPlayerPresentInTeamB:(PT_PlayerItemModel *)player
{
    BOOL returnValue = NO;
    for (int index = 0; index < self.arrTeamB.count; index++)
    {
        PT_PlayerItemModel *model = self.arrTeamB[index];
        if ([model.email isEqualToString:player.email])
        {
            returnValue = YES;
            //[[NSNotificationCenter defaultCenter] postNotificationName:PLAYERPRESENTINTEAMB object:player];
            
        }
        else
        {
            returnValue = NO;
        }

    }
    return returnValue;
}

- (BOOL)checkIfPlayerPresentInTeamA:(PT_PlayerItemModel *)player
{
    BOOL returnValue = NO;
    for (int index = 0; index < self.arrTeamA.count; index++)
    {
        PT_PlayerItemModel *model = self.arrTeamA[index];
        if ([model.email isEqualToString:player.email])
        {
            returnValue = YES;
            //[[NSNotificationCenter defaultCenter] postNotificationName:PLAYERPRESENTINTEAMA object:player];
        }
        else
        {
            returnValue = NO;
        }
        
    }
    return returnValue;
}

@end
