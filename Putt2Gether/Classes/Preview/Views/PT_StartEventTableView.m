//
//  PT_StartEventTableView.m
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_StartEventTableView.h"
#import "PT_StartEventTableViewCell.h"

#import "PT_SpecialFormatLeaderboardModel.h"

#import <QuartzCore/QuartzCore.h>

#import "PT_Front9Model.h"

@interface PT_StartEventTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(weak,nonatomic) PT_StartEventTableViewCell *tableViewcell;

@property (strong, nonatomic) NSArray *arrLeaderboard;

@property (weak, nonatomic) IBOutlet UITableView *tableLeaderboard;



@end

@implementation PT_StartEventTableView



//
//
//-(void)setindexarray:(NSArray *)arrIndex
//         andsetlabel:(NSArray *)arrvalues31
//       andsetvalues4:(NSArray *)arrvalues41;{
//    
//    arrSection = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
//    arrvalues3 = [[NSArray alloc] initWithObjects:@"21",@"24",@"25",@"30",@"45",@"50" ,nil];
//    arrSection = [NSArray arrayWithArray:arrIndex];
//    arrvalues31 = [NSArray arrayWithArray:arrvalues3];
//    
//    
//    
//}

-(IBAction)actioncloseBtn:(id)sender{
    
    [self hideview];
    
}
-(void)hideview
{
    [self setHidden:YES];
    [_backgroundView removeFromSuperview];
}


- (void)loadTableViewWithData:(NSMutableArray *)dataArray
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.arrLeaderboard = dataArray;
        
        /*self.tableLeaderboard.layer.borderWidth = 1.0;
        self.tableLeaderboard.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.tableLeaderboard.layer.cornerRadius = 2.0;
        self.tableLeaderboard.layer.masksToBounds = YES;
        */
        [self.tableLeaderboard reloadData];
    });
    
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrLeaderboard count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier =@"cell";
    
    SplFormatLeadershipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == Nil)
    {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SplFormatLeadershipTableViewCell" owner:self options:Nil] firstObject];
        cell.backgroundColor = [UIColor colorWithRed:233/255.0 green:237/255.0 blue:243/255.0 alpha:1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    PT_SpecialFormatLeaderboardModel *modelFormat = self.arrLeaderboard[indexPath.row];
    cell.holeNumber.text = [NSString stringWithFormat:@"%li", indexPath.row+1];
    [cell.winnerButton setTitle:@"W" forState:UIControlStateNormal];
    [cell.winnerButton setBackgroundColor:[UIColor colorFromHexString:modelFormat.colorWinner]];
    
    __block NSMutableAttributedString *score3rdColumn = [NSMutableAttributedString new];
    [modelFormat.arrScoreValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PT_Front9Model *model = obj;
            if ([model.color length] == 0)
            {
                
            }
            else
            {
                NSString *score = [NSString stringWithFormat:@"%@",model.score];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:score];
                [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:model.color] range:NSMakeRange(0,[attributeString length])];
                [score3rdColumn appendAttributedString:attributeString];
                
                if (idx== [modelFormat.arrScoreValue count] - 1)
                {
                    cell.label3rdColumn.attributedText = score3rdColumn;
                }
            }
            
            cell.label4thColumn.hidden = YES;
        });
    }];
    
    [modelFormat.arrBackto9Score enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PT_Front9Model *model = obj;
            NSString *score = [NSString stringWithFormat:@"%@",model.score];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:score];
            [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:model.color] range:NSMakeRange(0,[attributeString length])];
            [score3rdColumn appendAttributedString:attributeString];
            
            if (idx== [modelFormat.arrScoreValue count] - 1)
            {
                cell.label4thColumn.attributedText = score3rdColumn;
            }
            cell.label4thColumn.hidden = NO;
        });
    }];
    [cell setNeedsDisplay];
    
    
     return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
