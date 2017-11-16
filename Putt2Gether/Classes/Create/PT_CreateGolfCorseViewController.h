//
//  PT_CreateGolfCorseViewController.h
//  Putt2Gether
//
//  Created by Devashis on 18/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_SelectGolfCorseViewController.h"

#import "PT_CreateViewController.h"

@interface PT_CreateGolfCorseViewController : UIViewController

@property (strong, nonatomic) PT_CreateViewController *createVC;

- (instancetype)initWithDelegate:(PT_SelectGolfCorseViewController *)parent;

@end
