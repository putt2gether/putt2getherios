//
//  PT_ScorerViewController.h
//  Putt2Gether
//
//  Created by Devashis on 10/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_SelectScorerMoreOptViewController.h"

@interface PT_ScorerViewController : UIViewController

@property (strong, nonatomic) PT_SelectScorerMoreOptViewController *parentVC;

@property (assign, nonatomic) NSInteger updatedIndex;

@end
