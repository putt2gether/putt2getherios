//
//  PT_EnterScoreSelectHoles.m
//  Putt2Gether
//
//  Created by Devashis on 05/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_EnterScoreSelectHoles.h"

#import "PT_SelectHolesCollectionViewCell.h"

#import "PT_SelectHoleCollectionViewCell.h"

#import "KTCenterFlowLayout.h"


@interface PT_EnterScoreSelectHoles ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger numberOfHoles;
    IBOutlet UICollectionView *collectionViewHoles;
    UIView *dotView;
    
    IBOutlet UIButton *holeNumberButton;
}

@end

@implementation PT_EnterScoreSelectHoles

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setNumberOfHoles:(NSInteger)holes andFront:(BOOL)isFrontEnabled
{
    self.isFrontHole = isFrontEnabled;
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = [self getSpacing];//8.f;
    layout.minimumLineSpacing = [self getSpacing];//8.f;
    
    self.userInteractionEnabled = YES;
    [collectionViewHoles setCollectionViewLayout:layout];
    numberOfHoles = holes;
    self.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(88/255.0f) blue:(149/255.0f) alpha:1.0f];
    if (numberOfHoles>0)
    [collectionViewHoles reloadData];
}

- (void)setCurrentHole:(NSInteger)currentHole
{
    holeNumberButton.layer.borderWidth = 1.0;
    holeNumberButton.layer.borderColor = [[UIColor clearColor] CGColor];
    holeNumberButton.layer.cornerRadius = holeNumberButton.frame.size.width/2;
    holeNumberButton.layer.masksToBounds = YES;
    if (currentHole == 0)
    {
        [holeNumberButton setTitle:[NSString stringWithFormat:@"%li",(long)1] forState:UIControlStateNormal];
    }
    else
    {
        [holeNumberButton setTitle:[NSString stringWithFormat:@"%li",(long)currentHole] forState:UIControlStateNormal];
    }
    
}

- (float)getSpacing
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    float returnVal = 0;
    switch (screenHeight) {
        case 568:
        {
            returnVal = 8.0f;
        }
            break;
            
        case 667:
        {
            returnVal = 10.2f;
        }
            break;
        case 736:
        {
            returnVal = 15.0f;
        }
            break;
    }
    
    return returnVal;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return numberOfHoles;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"CellIdentifier";
    
    //if(!nibMyCellloaded)
    {
        
        UINib *nib = [UINib nibWithNibName:@"PT_SelectHoleCollectionViewCell" bundle: nil];
        
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        
        //nibMyCellloaded = YES;
        
    }
    NSInteger compareValue = 0;
    if (self.isFrontHole == NO)
    {
        compareValue = indexPath.row+10;
    }
    else
    {
        compareValue = indexPath.row+1;
    }
    PT_SelectHoleCollectionViewCell *cell = (PT_SelectHoleCollectionViewCell *)[collectionViewHoles dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.holeLabel.text = [NSString stringWithFormat:@"%li",compareValue];
    
    cell.selectedHoleButton.hidden = YES;
    
    if (self.currentHole == compareValue)
    {
        cell.selectedHoleButton.hidden = NO;
    }
    cell.bgButton.tag = indexPath.item;
    [cell.bgButton addTarget:self action:@selector(actionCellSelection:) forControlEvents:UIControlEventTouchUpInside];
    
    //cell.selectedHoleButton.layer.cornerRadius = cell.bgButton.frame.size.width/2;
    //cell.selectedHoleButton.layer.borderColor = [[UIColor clearColor] CGColor];
    //cell.selectedHoleButton.layer.borderWidth = 1.0;
    //cell.selectedHoleButton.layer.masksToBounds = YES;
    
    
    
    return cell;
    
}

- (void)actionCellSelection:(UIButton *)sender
{
    if (self.isFrontHole == NO)
    {
        [self.delegate didSelectHole:sender.tag + 9];
    }
    else
    {
        [self.delegate didSelectHole:sender.tag];
    }
    //[self.delegate didSelectHole:sender.tag];
    self.hidden= YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFrontHole == NO)
    {
        [self.delegate didSelectHole:indexPath.item + 10];
    }
    else
    {
      [self.delegate didSelectHole:indexPath.item];
    }
}

- (IBAction)actionClose
{
    [self.delegate didSelectEndRound];
    self.hidden= YES;
}

- (void)updateHoles
{
    [collectionViewHoles reloadData];
    /*dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath  = [NSIndexPath indexPathForItem:_currentHole inSection:0];
        UICollectionViewCell *cell = [collectionViewHoles cellForItemAtIndexPath:indexPath];
        if (dotView == nil)
        {
            dotView = [UIView new];
        }
        [dotView removeFromSuperview];
        float width = 10;
        float x = cell.contentView.center.x - (width/2);
        float y = cell.contentView.frame.size.height - width;
        dotView.frame = CGRectMake(x, y, width, width);
        [cell.contentView addSubview:dotView];
    });*/
    
}

@end
