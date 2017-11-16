//
//  PT_NumOfHolesTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PT_CreateViewController.h"


@interface PT_NumOfHolesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *nineButton;

@property (weak, nonatomic) IBOutlet UIButton *eighteenButton;

@property (strong, nonatomic) PT_CreateViewController *parentController;

- (void)actionNumberOfHolesSelectedForCell:(UIButton *)sender;

@end
