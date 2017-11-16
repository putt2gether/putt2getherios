//
//  PT_AddPlayerIntermediateViewController.m
//  Putt2Gether
//
//  Created by Devashis on 29/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_AddPlayerIntermediateViewController.h"

#import "PT_AddPlayerOptionsViewController.h"

#import "PT_AddPalyerTableViewCell.h"


@interface PT_AddPlayerIntermediateViewController ()<UITableViewDataSource,UITabBarDelegate>
{
    NSInteger totalNumberOfPlayers;
    
    NSMutableArray *_arrPlayers;
    
    NSMutableArray *_arrEmailPlayers;
    
    IBOutlet UITableView *tableAddPlayers;
    
}

@end

@implementation PT_AddPlayerIntermediateViewController

- (instancetype)initWithNumberOfPlayers:(NSInteger)numOfPlayers
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    totalNumberOfPlayers = numOfPlayers;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpPlayersList];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpPlayersList
{
    _arrPlayers = [NSMutableArray new];
    PT_PlayerItemModel *model = [PT_PlayerItemModel new];
    model.playerName = [[MGUserDefaults sharedDefault] getDisplayName];
    model.playerId = [[MGUserDefaults sharedDefault] getUserId];
    model.handicap = [[[MGUserDefaults sharedDefault] getHandicap] integerValue];
    model.isAdmin = YES;
    [_arrPlayers addObject:model];
    
    _arrEmailPlayers = [NSMutableArray new];
    
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




- (NSArray *)getPlayersArray
{
    return _arrPlayers;
}
- (IBAction)actionContinue
{
    if ([_arrPlayers count] < totalNumberOfPlayers)
    {
        NSString *message = [NSString stringWithFormat:@"Please select %li players.",totalNumberOfPlayers - 1];
        [self showAlertWithMessage:message];
    }
    else
    {
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setPlayerAddedThroughEmail:_arrEmailPlayers];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setEventSuggestionFriends:_arrPlayers];
        PT_EventPreviewViewController *previewVC = [PT_EventPreviewViewController new];
        previewVC.isEditMode = NO;
        [self presentViewController:previewVC animated:YES completion:nil];
    }
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalNumberOfPlayers;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    
    PT_AddPalyerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_AddPalyerTableViewCell"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.addRemoveButton setHidden:YES];
        [cell.adminLabel setHidden:NO];
        cell.adminLabel.textAlignment = NSTextAlignmentCenter;
        cell.constraintPlayerNameLeading.constant = 5;
        cell.adminLabel.font = [UIFont fontWithName:@"Lato" size:13];
        
    }
    
    if (indexPath.row == 0)
    {
        PT_PlayerItemModel *model = _arrPlayers[0];
        cell.playerName.text = [NSString stringWithFormat:@"%@ %li",model.playerName,model.handicap];
        cell.userInteractionEnabled = NO;
        
    }
    else
    {
        if (indexPath.row < [_arrPlayers count])
        {
            PT_PlayerItemModel *model = _arrPlayers[indexPath.row];
        cell.playerName.text = [NSString stringWithFormat:@"%@ %li",model.playerName,model.counts];
            cell.adminLabel.text = @"REMOVE";
            
        }
        else
        {
            
            cell.playerName.text = @"ADD PLAYER";
            cell.adminLabel.text = @"ADD";
            
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_arrPlayers count])
    {
        [_arrPlayers removeObjectAtIndex:indexPath.row];
        
        [tableAddPlayers reloadData];
    }
    else
    {
        
        PT_AddPlayerOptionsViewController *addPlayersOptionsVC = [[PT_AddPlayerOptionsViewController alloc] initWithNibName:@"PT_AddPlayerOptionsViewController" bundle:nil];
        addPlayersOptionsVC.isIntermediateAddPlayer = YES;
        addPlayersOptionsVC.intermediatePlayerVC = self;
        [self presentViewController:addPlayersOptionsVC animated:YES completion:nil];
        
    }
    
}

- (void)setSelectedPlayer:(PT_PlayerItemModel *)model
{
    BOOL isPlayerPresent = NO;
    for (NSInteger counter = 0; counter < [_arrPlayers count]; counter++) {
        PT_PlayerItemModel *modelIndex = _arrPlayers[counter];
        
        if ([model.email isEqualToString:modelIndex.email])
        {
            //Alert
            isPlayerPresent = YES;
        }
        
    }
    if (isPlayerPresent == NO)
    {
        model.isAddPlayerOption = NO;
        [_arrPlayers addObject:model];
        [tableAddPlayers reloadData];
        
        if (_isAddingThroughEmail == YES) {
            
            _isAddingThroughEmail = NO;
            model.isAddPlayerOption = NO;
            [_arrEmailPlayers addObject:model];
            [tableAddPlayers reloadData];
        }
        
    }
}

//- (void)setEmailSelectedPlayer:(PT_PlayerItemModel *)model
//{
//    BOOL isPlayerPresent = NO;
//    for (NSInteger counter = 0; counter < [_arrEmailPlayers count]; counter++) {
//        PT_PlayerItemModel *modelIndex = _arrEmailPlayers[counter];
//        
//        if (model.email == modelIndex.email)
//        {
//            //Alert
//            isPlayerPresent = YES;
//        }
//        
//    }
//    if (isPlayerPresent == NO)
//    {
//        model.isAddPlayerOption = NO;
//        [_arrEmailPlayers addObject:model];
//        [_arrPlayers addObject:model];
//        [tableAddPlayers reloadData];
//    }
//}


- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
