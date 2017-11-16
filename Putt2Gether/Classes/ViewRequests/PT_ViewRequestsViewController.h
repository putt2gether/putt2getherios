//
//  PT_ViewRequestsViewController.h
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_ViewRequestsViewController : UIViewController

- (instancetype)initWithEventModel:(PT_CreatedEventModel *)model;

@property (strong, nonatomic) PT_EventPreviewViewController *previewVC;

@end
