//
//  PT_SelectScorerMoreOptViewController.m
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_SelectScorerMoreOptViewController.h"

#import "PT_SelectScorerMoreMainTableViewCell.h"

#import "PT_ScorerItemModel.h"

#import "PT_ScorerViewController.h"

#import "PT_EventPreviewViewController.h"

@interface PT_SelectScorerMoreOptViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_arrScorers;
    IBOutlet UITableView *tableScorers;
}

@end

@implementation PT_SelectScorerMoreOptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _arrScorers = [NSMutableArray new];
    
    [self createStub];
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
    model4.scorerId = 60;
    model4.scorerName = @"TOM AARON";
    model4.selectedScorerName = @"BASANT";
    [_arrScorers addObject:model4];
    
    PT_ScorerItemModel *model5 = [PT_ScorerItemModel new];
    model5.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model5.scorerName = @"Sachin";
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
    model8.scorerId = 60;
    model8.scorerName = @"PAT ABBOTT";
    model8.selectedScorerName = @"SACHIN";
    [_arrScorers addObject:model8];
    
    PT_ScorerItemModel *model9 = [PT_ScorerItemModel new];
    model9.scorerId = [[MGUserDefaults sharedDefault] getUserId];
    model9.scorerName = @"WARREN ABEY";
    model9.selectedScorerName = @"SELF";
    [_arrScorers addObject:model9];
    
    PT_ScorerItemModel *model10 = [PT_ScorerItemModel new];
    model10.scorerId = 60;
    model10.scorerName = @"TOMMY AARON";
    model10.selectedScorerName = @"VIKAS";
    [_arrScorers addObject:model10];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    float height = 83.5;
//    
//    return height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrScorers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_SelectScorerMoreMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_SelectScorerMoreMainTableViewCell"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UIColor *blueBGColor = [UIColor colorWithRed:(10/255.0f) green:(51/255.0f) blue:(96/255.0f) alpha:1.0];
    
    PT_ScorerItemModel *model = _arrScorers[indexPath.row];
    
    cell.name.text = model.scorerName;
    
    cell.scorerButton.tag = indexPath.row;
    
    if (model.scorerId == [[MGUserDefaults sharedDefault] getUserId])
    {
        cell.scorerButton.layer.borderColor = [blueBGColor CGColor];
        cell.scorerButton.layer.borderWidth = 1.0;
        cell.scorerButton.layer.cornerRadius = 13.0;
        cell.scorerButton.layer.masksToBounds = YES;
        [cell.scorerButton setTitleColor:blueBGColor forState:UIControlStateNormal];
        cell.scorerButton.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.scorerButton.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.scorerButton.layer.borderWidth = 1.0;
        cell.scorerButton.layer.cornerRadius = 13.0;
        cell.scorerButton.layer.masksToBounds = YES;
        [cell.scorerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.scorerButton.backgroundColor = blueBGColor;
    }
    
    [cell.scorerButton addTarget:self action:@selector(actionScorer:) forControlEvents:UIControlEventTouchUpInside];
    [cell.scorerButton setTitle:model.selectedScorerName forState:UIControlStateNormal];
    
    return cell;
}


- (void)actionScorer:(UIButton *)sender
{
    //_currentSelectedIndex = sender.tag;
    
    PT_ScorerViewController *sVC = [[PT_ScorerViewController alloc] initWithNibName:@"PT_ScorerViewController" bundle:nil];
    sVC.updatedIndex = sender.tag;
    sVC.parentVC = self;
    [self presentViewController:sVC animated:YES completion:nil];
    
}

- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSeletedScorerForIndex:(NSInteger)index withScorer:(NSString *)scorerName
{
    PT_ScorerItemModel *model = _arrScorers[index];
    model.selectedScorerName = scorerName;
    model.scorerId = [[MGUserDefaults sharedDefault] getUserId] + 10;
    
    [tableScorers reloadData];
}

- (IBAction)actionContinue
{
    PT_EventPreviewViewController *createVC = [[PT_EventPreviewViewController alloc]initWithModel:self.createventModel andIsRequestToParticipate:NO];
    
    [self presentViewController:createVC animated:YES completion:nil];
}

@end
