//
//  PT_ViewParticipantsViewController.h
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreatedEventModel.h"

@interface PT_ViewParticipantsViewController : UIViewController

@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;

@property (strong, nonatomic) PT_EventPreviewViewController *previewVC;

- (instancetype)initWithEventModel:(PT_CreatedEventModel *)model;

@end
