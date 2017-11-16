//
//  PT_SpotPrizeSelectionView.m
//  Putt2Gether
//
//  Created by Devashis on 27/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_SpotPrizeSelectionView.h"
#import "PT_SoptPrizeCollectionViewCell.h"

@interface PT_SpotPrizeSelectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger totalSelected;
    
    BOOL isClosestToPin1Selected;
    BOOL isClosestToPin2Selected;
    BOOL isClosestToPin3Selected;
    BOOL isClosestToPin4Selected;
    
    BOOL isLongDrive1Selected;
    BOOL isLongDrive2Selected;
    BOOL isLongDrive3Selected;
    BOOL isLongDrive4Selected;
    
    BOOL isStraightDrive1Selected;
    BOOL isStraightDrive2Selected;
    BOOL isStraightDrive3Selected;
    BOOL isStraightDrive4Selected;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrHoles;
@property (strong, nonatomic) PT_SoptPrizeCollectionViewCell *selectedCell;
@property (strong, nonatomic) NSMutableArray *arrSelectedHoles;


@end

@implementation PT_SpotPrizeSelectionView

- (void)setHolesWithArray:(NSArray *)list
{
    _arrHoles = nil;
    _arrSelectedHoles = [NSMutableArray new];
    [self setElemetsToArray];
    _arrHoles = [NSArray arrayWithArray:list];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView reloadData];
}

- (void)setElemetsToArray
{
    if ([self isClosestToPinSelected])
    {
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1]];
            totalSelected++;
            isClosestToPin1Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2]];
            totalSelected++;
            isClosestToPin2Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3]];
            totalSelected++;
            isClosestToPin3Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4]];
            totalSelected++;
            isClosestToPin4Selected = YES;
        }
    }
    else if ([self isLongDriveSelected])
    {
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1]];
            totalSelected++;
            isLongDrive1Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2]];
            totalSelected++;
            isLongDrive2Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3]];
            totalSelected++;
            isLongDrive3Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4]];
            totalSelected++;
            isLongDrive4Selected = YES;
        }
    }
    else if ([self isStraightDriveSelected])
    {
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1]];
            totalSelected++;
            isStraightDrive1Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2]];
            totalSelected++;
            isStraightDrive2Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3]];
            totalSelected++;
            isStraightDrive3Selected = YES;
        }
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] length] > 0)
        {
            [_arrSelectedHoles addObject:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4]];
            totalSelected++;
            isStraightDrive4Selected = YES;
        }
    }
}

- (BOOL)isClosestToPinSelected
{
    if (self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_ClosestToPin1 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_ClosestToPin2 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_ClosestToPin3 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_ClosestToPin4)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isLongDriveSelected
{
    if (self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_LongDrive1 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_LongDrive2 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_LongDrive3 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_LongDrive4)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isStraightDriveSelected
{
    if (self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_StraightDrive1 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_StraightDrive2 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_StraightDrive3 ||
        self.parentController.currentSpotPrizeButton.tag == SpotPrizeType_StraightDrive4)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)setSelectedHoleNumbers
{
    if ([self isClosestToPinSelected])
    {
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData1:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData2:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData3:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData4:nil];
        
        NSLog(@"ClosestToPinData1 : %@",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1]);
        NSLog(@"ClosestToPinData2 : %@",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2]);
        NSLog(@"ClosestToPinData3 : %@",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3]);
        NSLog(@"ClosestToPinData4 : %@",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4]);
    }
    if ([self isLongDriveSelected])
    {
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive1:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive2:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive3:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive4:nil];
    }
    if ([self isStraightDriveSelected])
    {
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive1:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive2:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive3:nil];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive4:nil];
    }
    for (NSInteger counter = 0; counter < [_arrSelectedHoles count]; counter++)
    {
        
        if ([self isClosestToPinSelected])
        {
            
            switch (counter) {
                case 0:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData1:_arrSelectedHoles[counter]];
                }
                    break;
                case 1:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData2:_arrSelectedHoles[counter]];
                }
                    break;
                case 2:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData3:_arrSelectedHoles[counter]];
                }
                    break;
                case 3:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData4:_arrSelectedHoles[counter]];
                }
                    break;
            }
        }
        if ([self isLongDriveSelected])
        {
            switch (counter) {
                case 0:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive1:_arrSelectedHoles[counter]];
                }
                    break;
                case 1:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive2:_arrSelectedHoles[counter]];
                }
                    break;
                case 2:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive3:_arrSelectedHoles[counter]];
                }
                    break;
                case 3:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive4:_arrSelectedHoles[counter]];
                }
                    break;
            }
        }
        if ([self isStraightDriveSelected])
        {
            switch (counter) {
                case 0:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive1:_arrSelectedHoles[counter]];
                }
                    break;
                case 1:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive2:_arrSelectedHoles[counter]];
                }
                    break;
                case 2:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive3:_arrSelectedHoles[counter]];
                }
                    break;
                case 3:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive4:_arrSelectedHoles[counter]];
                }
                    break;
            }
        }
        
    }
}
- (IBAction)actionDone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setSelectedHoleNumbers];
        [self.parentController refreshTableView];
        [self removeFromSuperview];
        
    });
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    
    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.arrHoles count];
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static BOOL nibMyCellloaded = NO;
    static NSString *identifier = @"CellIdentifier";
    
    //if(!nibMyCellloaded)
    {
        
        UINib *nib = [UINib nibWithNibName:@"PT_SoptPrizeCollectionViewCell" bundle: nil];
        
        [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        
        //nibMyCellloaded = YES;
        
    }
    
    PT_SoptPrizeCollectionViewCell *cell = (PT_SoptPrizeCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *dicData = [self.arrHoles objectAtIndex:indexPath.item];

    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0f;
    //cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height/2;
    cell.contentView.layer.masksToBounds = YES;
    cell.isSelected = NO;
//    for (NSInteger counter = 0; counter < [_arrHoles count]; counter++)
//    {
//        NSString *value = [_arrHoles[counter] objectForKey:@"hole"];
//        for (NSInteger count = 0; count < [_arrSelectedHoles count]; count++)
//        {
//            NSString *valueExisting = _arrSelectedHoles[count];
//            NSLog(@"%@ at index %li",valueExisting,count);
//            if ([value isEqualToString:valueExisting])
//            {
//                cell.isSelected = YES;
//                
//            }
//        }
//    }
   
    NSString *valueAtIndex = dicData[@"hole"];
    for (int count1 = 0; count1 < [_arrSelectedHoles count]; count1++) {
        NSString *valueSelectedAtIndex = _arrSelectedHoles[count1];
        if ([valueAtIndex isEqualToString:valueSelectedAtIndex])
        {
            cell.isSelected = YES;
        }
    }
    
    if (cell.isSelected == YES)
    {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.titleLabel.text = dicData[@"hole"];
    
    [cell setNeedsLayout];
    return cell;
    
}

- (BOOL)checkClosestToPinValuePresent:(NSString *)selectedHole
{
    NSInteger cp1 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] integerValue];
    NSInteger cp2 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] integerValue];
    NSInteger cp3 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] integerValue];
    NSInteger cp4 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] integerValue];
    
    NSInteger selectedValue = [selectedHole integerValue];
    BOOL valueToReturn = NO;
    if (selectedValue == cp1 || selectedValue == cp2 || selectedValue == cp3 || selectedValue == cp4)
    {
        valueToReturn = YES;
    }
    
    return valueToReturn;
    
}

- (BOOL)checkLongDriveValuePresent:(NSString *)selectedHole
{
    NSInteger ld1 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] integerValue];
    NSInteger ld2 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] integerValue];
    NSInteger ld3 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] integerValue];
    NSInteger ld4 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] integerValue];
    
    NSInteger selectedValue = [selectedHole integerValue];
    BOOL valueToReturn = NO;
    if (selectedValue == ld1 || selectedValue == ld2 || selectedValue == ld3 || selectedValue == ld4)
    {
        valueToReturn = YES;
    }
    
    return valueToReturn;
}

- (BOOL)checkStraightDriveValuePresent:(NSString *)selectedHole
{
    NSInteger sd1 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] integerValue];
    NSInteger sd2 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] integerValue];
    NSInteger sd3 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] integerValue];
    NSInteger sd4 = [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] integerValue];
    
    NSInteger selectedValue = [selectedHole integerValue];
    BOOL valueToReturn = NO;
    if (selectedValue == sd1 || selectedValue == sd2 || selectedValue == sd3 || selectedValue == sd4)
    {
        valueToReturn = YES;
    }
    
    return valueToReturn;
}

#pragma mark - Collection view delegate

/*- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicData = self.arrHoles[indexPath.item];
    
    switch (self.parentController.currentSpotPrizeButton.tag) {
        case SpotPrizeType_ClosestToPin1:
        {
            if ([self checkValueAlreadySetInClosestToPin:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData1:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_ClosestToPin2:
        {
            if ([self checkValueAlreadySetInClosestToPin:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData2:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_ClosestToPin3:
        {
            if ([self checkValueAlreadySetInClosestToPin:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData3:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_ClosestToPin4:
        {
            if ([self checkValueAlreadySetInClosestToPin:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData4:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_LongDrive1:
        {
            if ([self checkValueAlreadySetInLongDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive1:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_LongDrive2:
        {
            if ([self checkValueAlreadySetInLongDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive2:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_LongDrive3:
        {
            if ([self checkValueAlreadySetInLongDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive3:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_LongDrive4:
        {
            if ([self checkValueAlreadySetInLongDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive4:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_StraightDrive1:
        {
            if ([self checkValueAlreadySetInStraightDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive1:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_StraightDrive2:
        {
            if ([self checkValueAlreadySetInStraightDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive2:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_StraightDrive3:
        {
            if ([self checkValueAlreadySetInStraightDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive3:dicData[@"hole"]];
            }
        }
            break;
        case SpotPrizeType_StraightDrive4:
        {
            if ([self checkValueAlreadySetInStraightDrive:dicData[@"hole"]] == NO)
            {
                [self.parentController.currentSpotPrizeButton setTitle:dicData[@"hole"] forState:UIControlStateNormal];
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive4:dicData[@"hole"]];
            }
        }
            break;
        
    }
    //[self removeFromSuperview];
}
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicData = self.arrHoles[indexPath.item];
    
    PT_SoptPrizeCollectionViewCell *cell = (PT_SoptPrizeCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isSelected == YES)
    {
        cell.isSelected = NO;
        cell.backgroundColor = [UIColor whiteColor];
        NSString *value = cell.titleLabel.text;
        
        for (NSInteger count = 0; count < [_arrSelectedHoles count]; count++)
        {
            NSString *valueAtIndex = _arrSelectedHoles[count];
            if ([valueAtIndex isEqualToString:value])
            {
                [_arrSelectedHoles removeObjectAtIndex:count];
            }
        }
        totalSelected--;
    }
    else
    {
        if (totalSelected == self.totalHolesToBeSelected)
        {
            
        }
        else
        {
            NSString *value = dicData[@"hole"];
            if ([self isClosestToPinSelected])
            {
                if ([self checkLongDriveValuePresent:value] || [self checkStraightDriveValuePresent:value])
                {
                    return;
                }
            }
            else if ([self isStraightDriveSelected])
            {
                if ([self checkLongDriveValuePresent:value] || [self checkClosestToPinValuePresent:value])
                {
                    return;
                }
            }
            else if ([self isLongDriveSelected])
            {
                if ([self checkStraightDriveValuePresent:value] || [self checkClosestToPinValuePresent:value])
                {
                    return;
                }
            }
            
            //if (indexPath.item )
            
            totalSelected++;
            BOOL isValuePresent = NO;
            for (NSInteger counter = 0; counter < [_arrSelectedHoles count]; counter++)
            {
                NSString *valeExisting = _arrSelectedHoles[counter];
                if ([valeExisting isEqualToString:value])
                {
                    isValuePresent = YES;
                    [_arrSelectedHoles replaceObjectAtIndex:counter withObject:value];
                }
            }
            if (isValuePresent)
            {
                
            }
            else
            {
                [_arrSelectedHoles addObject:dicData[@"hole"]];
            }
            
            cell.isSelected = YES;
            cell.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    
    
}


- (BOOL)checkValueAlreadySetInClosestToPin:(NSString *)value
{
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] isEqualToString:value] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)checkValueAlreadySetInLongDrive:(NSString *)value
{
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] isEqualToString:value] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)checkValueAlreadySetInStraightDrive:(NSString *)value
{
    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] isEqualToString:value] ||
        [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] isEqualToString:value] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
