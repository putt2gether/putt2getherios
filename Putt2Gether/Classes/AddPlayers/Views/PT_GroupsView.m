//
//  PT_GroupsView.m
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_GroupsView.h"

#import "PT_SuggestionsTableViewCell.h"

#import "PT_PlayerItemModel.h"

#import "PT_GroupTableViewCell.h"

#import "UIView+Hierarchy.h"

#import "PT_GroupItemModel.h"

#import "UIImageView+AFNetworking.h"

@interface PT_GroupsView ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrInviteGroup;

@property(strong,nonatomic) NSMutableArray *sortedArray;

@property(assign,nonatomic)BOOL isSearching;


@end

@implementation PT_GroupsView

- (void)setUpWithAddedInviteGroup:(NSMutableArray *)invite
{
   
    self.arrInviteGroup = invite;
    
    _arrSelectedGroups = [NSMutableArray new];
    
    [[self tableView] registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerFooterReuseIdentifier"];
    
    [_searchText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [self.tableView reloadData];
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.f;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_isSearching == YES) {
        
        return [_sortedArray count];
    }else

    return [self.arrInviteGroup count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     PT_SuggestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
    if (_isSearching == YES) {
        
        PT_GroupItemModel *model = self.sortedArray[indexPath.row];
        
        
        
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
        
        if (model.isAddGroupOption == NO)
        {
            [cell.addRemoveButton setTitle:@"ADD" forState:UIControlStateNormal];
        }
        else
        {
            [cell.addRemoveButton setTitle:@"REMOVE" forState:UIControlStateNormal];
        }
        
        cell.addRemoveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [cell.addRemoveButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.playerName.text = model.groupName;
        
        [cell.playerImage setImageWithURL:[NSURL URLWithString:model.groupImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
        
        NSString *myString = [NSString stringWithFormat:@"%li", (unsigned long)model.arrGroupMembers.count];
        CGRect rect = [model.groupName boundingRectWithSize:CGSizeMake(cell.playerName.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.playerName.font} context:nil];
        rect.size.width = ceil(rect.size.width);
        rect.size.height = ceil(rect.size.height);
        cell.constraintWidthPlayerName.constant = rect.size.width;
        cell.playerNumebers.text = myString;


    }else{
    PT_GroupItemModel *model = self.arrInviteGroup[indexPath.row];
    
   
    
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
    
    if (model.isAddGroupOption == NO)
    {
        [cell.addRemoveButton setTitle:@"ADD" forState:UIControlStateNormal];
    }
    else
    {
        [cell.addRemoveButton setTitle:@"REMOVE" forState:UIControlStateNormal];
    }

    cell.addRemoveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [cell.addRemoveButton addTarget:self action:@selector(actionAddRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.playerName.text = model.groupName;
    
    [cell.playerImage setImageWithURL:[NSURL URLWithString:model.groupImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
        
    
    NSString *myString = [NSString stringWithFormat:@"%li", (unsigned long)model.arrGroupMembers.count];
    CGRect rect = [model.groupName boundingRectWithSize:CGSizeMake(cell.playerName.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.playerName.font} context:nil];
    rect.size.width = ceil(rect.size.width);
    rect.size.height = ceil(rect.size.height);
    cell.constraintWidthPlayerName.constant = rect.size.width;
    cell.playerNumebers.text = myString;
    
    /*CGRect rect = [model.groupName boundingRectWithSize:CGSizeMake(cell.playerName.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.playerName.font} context:nil];
    rect.size.width = ceil(rect.size.width);
    rect.size.height = ceil(rect.size.height);
    cell.constraintWidthPlayerName.constant = rect.size.width;
    cell.playerNumebers.hidden = YES;*/
    }
    return cell;
}

- (void)actionAddRemovePlayer:(UIButton *)sender
{
    if (_isSearching == YES) {
        
        PT_GroupItemModel *model = self.sortedArray[sender.tag];
        BOOL isAdd = NO;
        if (model.isAddGroupOption == YES)
        {
            model.isAddGroupOption = NO;
            isAdd = NO;
        }
        else
        {
            model.isAddGroupOption = YES;
            isAdd = YES;
            [self.arrSelectedGroups addObject:model];
        }
        [self.arrSelectedGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PT_GroupItemModel *modelAtIndex = obj;
            if (model.groupId == modelAtIndex.groupId && isAdd == NO)
            {
                [self.arrSelectedGroups removeObjectAtIndex:idx];
                
            }
            
        }];

    }else{
    //[self.arrInviteGroup removeObjectAtIndex:sender.tag];
    PT_GroupItemModel *model = self.arrInviteGroup[sender.tag];
    BOOL isAdd = NO;
    if (model.isAddGroupOption == YES)
    {
        model.isAddGroupOption = NO;
        isAdd = NO;
    }
    else
    {
        model.isAddGroupOption = YES;
        isAdd = YES;
        [self.arrSelectedGroups addObject:model];
    }
    [self.arrSelectedGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        PT_GroupItemModel *modelAtIndex = obj;
        if (model.groupId == modelAtIndex.groupId && isAdd == NO)
        {
            [self.arrSelectedGroups removeObjectAtIndex:idx];
            
        }
        
    }];
        
    }
    [self.tableView reloadData];
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
