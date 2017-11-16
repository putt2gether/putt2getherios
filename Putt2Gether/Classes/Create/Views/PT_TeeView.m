//
//  PT_TeeView.m
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_TeeView.h"

#import "PT_TeeItemModel.h"


@interface PT_TeeView ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *arrMenTees;

@property (strong, nonatomic) NSArray *arrWomenTees;

@property (strong, nonatomic) NSArray *arrJuniorTees;

@property (weak, nonatomic) IBOutlet UITableView *tableMen;

@property (weak, nonatomic) IBOutlet UITableView *tableWomen;

@property (weak, nonatomic) IBOutlet UITableView *tableJunior;


@end

@implementation PT_TeeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)makeOptionsRound
{
 
}

- (void)setTeeWithMenArray:(NSArray *)arrMen
             andWomenArray:(NSArray *)arrWomen
            andJuniorArray:(NSArray *)arrJunior
{
    _arrMenTees = nil;
    _arrWomenTees = nil;
    _arrJuniorTees = nil;
    
    _arrMenTees = [NSArray arrayWithArray:arrMen];
    _arrWomenTees = [NSArray arrayWithArray:arrWomen];
    _arrJuniorTees = [NSArray arrayWithArray:arrJunior];
    
    [self.tableMen reloadData];
    [self.tableWomen reloadData];
    [self.tableJunior reloadData];
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableMen)
    {
        return self.arrMenTees.count;
    }
    else if (tableView == self.tableWomen)
    {
        return self.arrWomenTees.count;
    }
    else
    {
        return self.arrJuniorTees.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableMen)
    {
        static NSString *identifierMen = @"MenIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMen];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierMen];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        PT_TeeItemModel *model = self.arrMenTees[indexPath.row];
        
        UIButton *teeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        teeButton.frame = CGRectMake(0, 2, TeeDefaultIconSize, TeeDefaultIconSize);
        
        teeButton.backgroundColor = [UIColor colorFromHexString:model.teeColor];
        teeButton.tag = MenTeeTag + indexPath.row;
        teeButton.layer.cornerRadius = TeeDefaultIconSize/2;
        teeButton.layer.masksToBounds = YES;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        [teeButton addTarget:self action:@selector(actionTeeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:teeButton];
        
        return cell;
    }
    else if (tableView == self.tableWomen)
    {
        static NSString *identifierWomen = @"WomenIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierWomen];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierWomen];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        PT_TeeItemModel *model = self.arrWomenTees[indexPath.row];
        
        UIButton *teeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        teeButton.frame = CGRectMake(0, 2, TeeDefaultIconSize, TeeDefaultIconSize);
        
        teeButton.backgroundColor = [UIColor colorFromHexString:model.teeColor];
        
        teeButton.layer.cornerRadius = TeeDefaultIconSize/2;
        teeButton.layer.masksToBounds = YES;
        teeButton.tag = WomenTeeTag + indexPath.row;
        [teeButton addTarget:self action:@selector(actionTeeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:teeButton];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else
    {
        static NSString *identifierJunior = @"JuniorIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierJunior];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierJunior];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        PT_TeeItemModel *model = self.arrJuniorTees[indexPath.row];
        
        UIButton *teeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        teeButton.frame = CGRectMake(0, 2, TeeDefaultIconSize, TeeDefaultIconSize);
        
        teeButton.backgroundColor = [UIColor colorFromHexString:model.teeColor];
        [teeButton addTarget:self action:@selector(actionTeeSelected:) forControlEvents:UIControlEventTouchUpInside];
        teeButton.layer.cornerRadius = TeeDefaultIconSize/2;
        teeButton.layer.masksToBounds = YES;
        teeButton.tag = JuniorTeeTag + indexPath.row;
        [cell.contentView addSubview:teeButton];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
}


- (void)actionTeeSelected:(UIButton *)sender
{
    [self.delegate didPressTeeButtonWithTag:sender.tag];
}

- (IBAction)actionDoneButton
{
    [self hideView];
}

- (void)hideView
{
    [self setHidden:YES];
}


@end
