//
//  PT_SelectScorerMoreOptViewController.h
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreatedEventModel.h"

@interface PT_SelectScorerMoreOptViewController : UIViewController

@property (strong, nonatomic) PT_CreatedEventModel *createventModel;

- (void)setSeletedScorerForIndex:(NSInteger)index withScorer:(NSString *)scorerName;

@end
