//
//  PT_SpotPrizeSelectionView.h
//  Putt2Gether
//
//  Created by Devashis on 27/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"

@interface PT_SpotPrizeSelectionView : UIView

@property (strong, nonatomic) PT_CreateViewController *parentController;

@property (assign, nonatomic) NSInteger totalHolesToBeSelected;


- (void)setHolesWithArray:(NSArray *)list;

@end
