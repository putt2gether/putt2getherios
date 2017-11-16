//
//  PT_EventTypeTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"

@interface PT_EventTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) PT_CreateViewController *parentVieController;

@property (weak, nonatomic) IBOutlet UIButton *publicButton;

@property (weak, nonatomic) IBOutlet UIButton *privateButton;

@property (weak, nonatomic) IBOutlet UIButton *iButton;

- (void)actionEventTypeSelectedForCell:(UIButton *)sender;

@end
