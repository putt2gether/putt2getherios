//
//  PT_SuggestionsView.m
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_SuggestionsView.h"

#import "PT_SuggestionsTableViewCell.h"

#import "PT_PlayerItemModel.h"

#import "UIView+Hierarchy.h"

#import "UIImageView+AFNetworking.h"

@interface PT_SuggestionsView ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (strong, nonatomic) NSMutableArray *arrInviteGroup;

@property (strong, nonatomic) NSMutableArray *arrAddedGroup;

@property (assign, nonatomic) NSInteger totalSelectedPlayers;

@property(strong,nonatomic) NSMutableArray *sortedArray;

@property(assign,nonatomic)BOOL isSearching;

@end

@implementation PT_SuggestionsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)refreshTable
{
    [self.tableView reloadData];
}

- (void)setUpWithAddedGroup:(NSMutableArray *)added andInviteGroup:(NSMutableArray *)invite
{
    _arrNumberOfPlayers4Plus = [NSMutableArray new];
    
    self.arrAddedGroup = added;
    self.arrInviteGroup = invite;
    
    [self.tableView reloadData];
    
    [_searchText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

    //[[self tableView] registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerFooterReuseIdentifier"];
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, self.frame.size.width, 48);
        UIColor *bgColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(6, headerView.frame.size.height/2 - 10, headerView.frame.size.width - 12, 20);
        titleLabel.text = @"ADDED";
        titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
        [headerView addSubview:titleLabel];
        
        CGRect frameLine = CGRectMake(6, headerView.frame.size.height - 2, headerView.frame.size.width-12, 2);
        UIView *lineView = [[UIView alloc]initWithFrame:frameLine];
        lineView.backgroundColor = bgColor;
        [headerView addSubview:lineView];
        return headerView;
    }
    else
    {
        
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, self.frame.size.width, 48);
        UIColor *bgColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = CGRectMake(6, headerView.frame.size.height/2 - 10, headerView.frame.size.width - 12, 20);
        titleLabel.text = @"INVITE";
        titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
        [headerView addSubview:titleLabel];
        
        CGRect frameLine = CGRectMake(6, headerView.frame.size.height - 2, headerView.frame.size.width - 12, 2);
        UIView *lineView = [[UIView alloc]initWithFrame:frameLine];
        lineView.backgroundColor = bgColor;
        [headerView addSubview:lineView];
        return headerView;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.f;
}
*/
 
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_isSearching == YES) {
        
        return [_sortedArray count];
    }else
        
        return [_arrInviteGroup count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (_isSearching == YES){
        
        PT_SuggestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
        
        PT_PlayerItemModel *model = self.sortedArray[indexPath.row];
        
        
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_SuggestionsTableViewCell"
                                                  owner:self
                                                options:nil] objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.playerImage.layer.cornerRadius = cell.playerImage.frame.size.height/2;
            cell.playerImage.clipsToBounds = YES;
            
        }
        cell.tag = indexPath.row;
        cell.addRemoveButton.tag = indexPath.row;
        if (model.isAddPlayerOption == YES)
        {
            [cell.addRemoveButton setTitle:@"REMOVE" forState:UIControlStateNormal];
        }
        else
        {
            [cell.addRemoveButton setTitle:@"ADD" forState:UIControlStateNormal];
        }
        [cell.addRemoveButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.addRemoveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        
        [cell.playerImage setImageWithURL:[NSURL URLWithString:model.playerImageURL]placeholderImage:[UIImage imageNamed:@"add_player"]];
    
       
        
        cell.playerName.text = model.playerName;
        
        NSString *myString = [NSString stringWithFormat:@"%li", (long)model.counts];
        CGRect rect = [model.playerName boundingRectWithSize:CGSizeMake(cell.playerName.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.playerName.font} context:nil];
        rect.size.width = ceil(rect.size.width);
        rect.size.height = ceil(rect.size.height);
        cell.constraintWidthPlayerName.constant = rect.size.width;
        cell.playerNumebers.text = myString;
        
        
        /*
        if (indexPath.row == [self.sortedArray count]-1)
        {
            CGRect frameLine = CGRectMake(cell.playerImage.frame.origin.x + 8,
                                          cell.playerImage.frame.origin.y+cell.playerImage.frame.size.height + 5,
                                          cell.addRemoveButton.frame.origin.x+cell.addRemoveButton.frame.size.width+4,
                                          1);
            UIView *lineView = [[UIView alloc]initWithFrame:frameLine];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [lineView bringToFront];
            [cell.contentView addSubview:lineView];
            
        }
*/
        return cell;
        
    }else{
        
        PT_SuggestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
    
    PT_PlayerItemModel *model = self.arrInviteGroup[indexPath.row];
    
    
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_SuggestionsTableViewCell"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.playerImage.layer.cornerRadius = cell.playerImage.frame.size.height/2;
        cell.playerImage.clipsToBounds = YES;
    }
    cell.tag = indexPath.row;
    cell.addRemoveButton.tag = indexPath.row;
    if (model.isAddPlayerOption == YES)
    {
        [cell.addRemoveButton setTitle:@"REMOVE" forState:UIControlStateNormal];
    }
    else
    {
        [cell.addRemoveButton setTitle:@"ADD" forState:UIControlStateNormal];
    }
    [cell.addRemoveButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.addRemoveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
      
        
        [cell.playerImage setImageWithURL:[NSURL URLWithString:model.playerImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
        
    
    cell.playerName.text = model.playerName;
    
    NSString *myString = [NSString stringWithFormat:@"%li", (long)model.counts];
    CGRect rect = [model.playerName boundingRectWithSize:CGSizeMake(cell.playerName.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.playerName.font} context:nil];
    rect.size.width = ceil(rect.size.width);
    rect.size.height = ceil(rect.size.height);
    cell.constraintWidthPlayerName.constant = rect.size.width;
    cell.playerNumebers.text = myString;
    
    
    /*
    if (indexPath.row == [self.arrInviteGroup count]-1)
    {
        CGRect frameLine = CGRectMake(cell.playerImage.frame.origin.x + 8,
                                      cell.playerImage.frame.origin.y+cell.playerImage.frame.size.height + 5,
                                      cell.addRemoveButton.frame.origin.x+cell.addRemoveButton.frame.size.width+4,
                                      1);
        UIView *lineView = [[UIView alloc]initWithFrame:frameLine];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [lineView bringToFront];
        [cell.contentView addSubview:lineView];
        
    }
     */
         return cell;
    }
    
   
    
}

- (void)actionAddRemovePlayer:(UIButton *)sender
{
    if (_isSearching == YES) {
        
        PT_PlayerItemModel *model = self.sortedArray[sender.tag];
        BOOL hasAddPerformed = NO;
        BOOL hasRemovePerformed = NO;
        
        if (self.parentVC.isIntermediateAddPlayer == YES)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.parentVC.intermediatePlayerVC setSelectedPlayer:model];
                [self.parentVC dismissViewControllerAnimated:YES completion:nil];
                //return;
            });
            
        }
        else
        {
            if (model.isAddPlayerOption == YES)
            {
                if (self.parentVC.numberOfPlayers == NumberOfPlayers_MoreThan4)
                {
                    [self.arrNumberOfPlayers4Plus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        PT_PlayerItemModel *playerModel = obj;
                        if (playerModel.playerId == model.playerId)
                        {
                            [self.arrNumberOfPlayers4Plus removeObjectAtIndex:idx];
                            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:self.arrNumberOfPlayers4Plus];
                        }
                        
                    }];
                }
                
                model = self.sortedArray[sender.tag];
                model.isAddPlayerOption = NO;
                self.totalSelectedPlayers--;
                [self.arrInviteGroup removeObjectAtIndex:sender.tag];
                [self.arrInviteGroup insertObject:model atIndex:self.arrInviteGroup.count - 1];
                [self.tableView reloadData];
                
                hasRemovePerformed = YES;
            }
            else
            {
                if (self.parentVC.numberOfPlayers == NumberOfPlayers_MoreThan4)
                {
                    model = self.sortedArray[sender.tag];
                    model.isAddPlayerOption = YES;
                    self.totalSelectedPlayers++;
                    [self.arrInviteGroup removeObjectAtIndex:sender.tag];
                    [self.arrInviteGroup insertObject:model atIndex:0];
                    [self.tableView reloadData];
                    [self.arrNumberOfPlayers4Plus addObject:model];
                    
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:self.arrNumberOfPlayers4Plus];
                    
                    hasAddPerformed = YES;
                }
                else if (self.totalSelectedPlayers < (self.parentVC.numberOfPlayers - 1))
                {
                    model = self.sortedArray[sender.tag];
                    model.isAddPlayerOption = YES;
                    self.totalSelectedPlayers++;
                    [self.arrInviteGroup removeObjectAtIndex:sender.tag];
                    [self.arrInviteGroup insertObject:model atIndex:0];
                    [self.tableView reloadData];
                    
                    hasAddPerformed = YES;
                }
                else
                {
                    NSString *message = [NSString stringWithFormat:@"You can select maximum %li player(s).",self.parentVC.numberOfPlayers - 1];
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
                    
                    [self.parentVC presentViewController:alert animated:YES completion:nil];
                }
                
            }
            
            if (hasAddPerformed == YES)
            {
                NSMutableArray *arrSelections = [NSMutableArray new];
                
                [arrSelections addObject:model];
                
                [self.parentVC actionSuggestionPlayers:arrSelections];
            }
            else if (hasRemovePerformed == YES)
            {
                [self.parentVC actionRemoveSuggestionPlayer:model];
            }
        }
        
    }else{
    
    PT_PlayerItemModel *model = self.arrInviteGroup[sender.tag];
    BOOL hasAddPerformed = NO;
    BOOL hasRemovePerformed = NO;
    
    if (self.parentVC.isIntermediateAddPlayer == YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.parentVC.intermediatePlayerVC setSelectedPlayer:model];
            [self.parentVC dismissViewControllerAnimated:YES completion:nil];
            //return;
        });
        
    }
    else
    {
        if (model.isAddPlayerOption == YES)
        {
            if (self.parentVC.numberOfPlayers == NumberOfPlayers_MoreThan4)
            {
                [self.arrNumberOfPlayers4Plus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PT_PlayerItemModel *playerModel = obj;
                    if (playerModel.playerId == model.playerId)
                    {
                        [self.arrNumberOfPlayers4Plus removeObjectAtIndex:idx];
                        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:self.arrNumberOfPlayers4Plus];
                    }
                    
                }];
            }
            
            model = self.arrInviteGroup[sender.tag];
            model.isAddPlayerOption = NO;
            self.totalSelectedPlayers--;
            [self.arrInviteGroup removeObjectAtIndex:sender.tag];
            [self.arrInviteGroup insertObject:model atIndex:self.arrInviteGroup.count - 1];
            [self.tableView reloadData];
            
            hasRemovePerformed = YES;
        }
        else
        {
            if (self.parentVC.numberOfPlayers == NumberOfPlayers_MoreThan4)
            {
                model = self.arrInviteGroup[sender.tag];
                model.isAddPlayerOption = YES;
                self.totalSelectedPlayers++;
                [self.arrInviteGroup removeObjectAtIndex:sender.tag];
                [self.arrInviteGroup insertObject:model atIndex:0];
                [self.tableView reloadData];
                [self.arrNumberOfPlayers4Plus addObject:model];
                
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayersFor4Plus:self.arrNumberOfPlayers4Plus];
                
                hasAddPerformed = YES;
            }
            else if (self.totalSelectedPlayers < (self.parentVC.numberOfPlayers - 1))
            {
                model = self.arrInviteGroup[sender.tag];
                model.isAddPlayerOption = YES;
                self.totalSelectedPlayers++;
                [self.arrInviteGroup removeObjectAtIndex:sender.tag];
                [self.arrInviteGroup insertObject:model atIndex:0];
                [self.tableView reloadData];
                
                hasAddPerformed = YES;
            }
            else
            {
                NSString *message = [NSString stringWithFormat:@"You can select maximum %li player(s).",self.parentVC.numberOfPlayers - 1];
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
                
                [self.parentVC presentViewController:alert animated:YES completion:nil];
            }
            
        }
        
        if (hasAddPerformed == YES)
        {
            NSMutableArray *arrSelections = [NSMutableArray new];
            
            [arrSelections addObject:model];
            
            [self.parentVC actionSuggestionPlayers:arrSelections];
        }
        else if (hasRemovePerformed == YES)
        {
            [self.parentVC actionRemoveSuggestionPlayer:model];
        }
    }
    
    }
    
}

- (void)rearrangeContentsInPlayersList:(PT_PlayerItemModel *)model
{
    if (_isSearching == YES) {
        
        for (int index = 0; index < self.sortedArray.count; index++)
        {
            PT_PlayerItemModel *modelPlayer = self.sortedArray[index];
            if (model.playerId == modelPlayer.playerId)
            {
                
                if (self.totalSelectedPlayers != 0)
                {
                    if (self.totalSelectedPlayers == 1)
                    {
                        self.totalSelectedPlayers--;
                    }
                    else
                    {
                        [self.sortedArray removeObjectAtIndex:index];
                        [self.sortedArray insertObject:modelPlayer atIndex:self.totalSelectedPlayers+1];
                        self.totalSelectedPlayers--;
                    }
                    
                }
            }
        }

        
    }else{
    
    for (int index = 0; index < self.arrInviteGroup.count; index++)
    {
        PT_PlayerItemModel *modelPlayer = self.arrInviteGroup[index];
        if (model.playerId == modelPlayer.playerId)
        {
            
            if (self.totalSelectedPlayers != 0)
            {
                if (self.totalSelectedPlayers == 1)
                {
                    self.totalSelectedPlayers--;
                }
                else
                {
                    [self.arrInviteGroup removeObjectAtIndex:index];
                    [self.arrInviteGroup insertObject:modelPlayer atIndex:self.totalSelectedPlayers+1];
                    self.totalSelectedPlayers--;
                }
                
            }
        }
    }
    }
    
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
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.playerName CONTAINS[c] %@", match];
        
        //or use Name like %@ //”Name” is the Key we are searching
        _sortedArray = [_arrInviteGroup filteredArrayUsingPredicate:predicate];
        
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
        
    });
    
    
    
    
}

@end
