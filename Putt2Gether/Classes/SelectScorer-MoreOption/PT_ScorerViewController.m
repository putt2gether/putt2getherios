//
//  PT_ScorerViewController.m
//  Putt2Gether
//
//  Created by Devashis on 10/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ScorerViewController.h"

#import "PT_ScorerItemModel.h"

#import "PT_ScorerTableViewCell.h"

@interface PT_ScorerViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_arrScorers;
    
    NSInteger _previousIndex;
    NSInteger _currentindex;
    BOOL _isSelected;
    IBOutlet UITableView *tableScorers;
}

@end

@implementation PT_ScorerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _arrScorers = [NSMutableArray new];
    
    [self createStub];
    
    _isSelected = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createStub
{
    
    PT_ScorerItemModel *model1 = [PT_ScorerItemModel new];
    model1.scorerId = 60;
    model1.scorerName = @"SACHIN";
    model1.selectedScorerName = @"VIKAS";
    [_arrScorers addObject:model1];
    
    PT_ScorerItemModel *model2 = [PT_ScorerItemModel new];
    model2.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model2.scorerName = @"PAT ABBOTT";
    model2.selectedScorerName = @"SELF";
    [_arrScorers addObject:model2];
    
    PT_ScorerItemModel *model3 = [PT_ScorerItemModel new];
    model3.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model3.scorerName = @"WARREN ABERY";
    model3.selectedScorerName = @"SELF";
    [_arrScorers addObject:model3];
    
    PT_ScorerItemModel *model4 = [PT_ScorerItemModel new];
    model4.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model4.scorerName = @"TOM AARON";
    model4.selectedScorerName = @"BASANT";
    [_arrScorers addObject:model4];
    
    PT_ScorerItemModel *model5 = [PT_ScorerItemModel new];
    model5.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model5.scorerName = @"SACHIN";
    model5.selectedScorerName = @"SELF";
    [_arrScorers addObject:model5];
    
    PT_ScorerItemModel *model6 = [PT_ScorerItemModel new];
    model6.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model6.scorerName = @"BASANT";
    model6.selectedScorerName = @"SELF";
    [_arrScorers addObject:model6];
    
    PT_ScorerItemModel *model7 = [PT_ScorerItemModel new];
    model7.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model7.scorerName = @"ABHINAV GUPTA";
    model7.selectedScorerName = @"SELF";
    [_arrScorers addObject:model7];
    
    PT_ScorerItemModel *model8 = [PT_ScorerItemModel new];
    model8.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model8.scorerName = @"PAT ABBOTT";
    model8.selectedScorerName = @"SACHIN";
    [_arrScorers addObject:model8];
    
    PT_ScorerItemModel *model9 = [PT_ScorerItemModel new];
    model9.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model9.scorerName = @"WARREN ABEY";
    model9.selectedScorerName = @"SELF";
    [_arrScorers addObject:model9];
    
    PT_ScorerItemModel *model10 = [PT_ScorerItemModel new];
    model10.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model10.scorerName = @"TOMMY AARON";
    model10.selectedScorerName = @"Vikas";
    [_arrScorers addObject:model10];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrScorers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_ScorerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ScorerTableViewCell"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UIColor *blueBGColor = [UIColor colorWithRed:(10/255.0f) green:(51/255.0f) blue:(96/255.0f) alpha:1.0];
    
    PT_ScorerItemModel *model = _arrScorers[indexPath.row];
    
    cell.name.text = model.scorerName;
    
    cell.scorerButton.layer.borderColor = [blueBGColor CGColor];
    cell.scorerButton.layer.borderWidth = 1.0;
    cell.scorerButton.layer.cornerRadius = cell.scorerButton.frame.size.width/2;
    cell.scorerButton.layer.masksToBounds = YES;
    
    
    if (model.isSelected == YES)
    {
        cell.scorerButton.backgroundColor = blueBGColor;
        [cell.scorerButton setBackgroundImage:[UIImage imageNamed:@"select-scorer-bg"] forState:UIControlStateNormal];
        
    }
    else
    {
        cell.scorerButton.backgroundColor = [UIColor whiteColor];
        [cell.scorerButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    cell.scorerButton.tag = indexPath.row;
    
    [cell.scorerButton addTarget:self action:@selector(actionSelectedScorer:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)actionSelectedScorer:(UIButton *)sender
{
    if (_isSelected == NO)
    {
        _previousIndex = sender.tag;
        _currentindex = sender.tag;
        PT_ScorerItemModel *modelPrevious = _arrScorers[_previousIndex];
        modelPrevious.isSelected = NO;
        
    }
    else
    {
        _previousIndex = _currentindex;
        _currentindex = sender.tag;
        PT_ScorerItemModel *modelPrevious = _arrScorers[_previousIndex];
        modelPrevious.isSelected = NO;
        
        PT_ScorerItemModel *modelCurrent = _arrScorers[_currentindex];
        modelCurrent.isSelected = YES;
    }
    
    
    _isSelected = YES;
    
    [tableScorers reloadData];
}

- (IBAction)actionContinue
{
    if (_isSelected == YES)
    {
        PT_ScorerItemModel *modelCurrent = _arrScorers[_currentindex];
        NSArray *arrName = [modelCurrent.scorerName componentsSeparatedByString:@" "];
        NSString *strName = [arrName firstObject];
        [self.parentVC setSeletedScorerForIndex:self.updatedIndex withScorer:strName];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
