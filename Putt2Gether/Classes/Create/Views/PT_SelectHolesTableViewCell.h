//
//  PT_SelectHolesTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"

@interface PT_SelectHolesTableViewCell : UITableViewCell

@property (strong, nonatomic) PT_CreateViewController *parentViewController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFront9Width;

@property (weak, nonatomic) IBOutlet UIButton *front9Button;

@property (weak, nonatomic) IBOutlet UIButton *back9Button;

- (void)actionHoleTypeSelectedForCell:(UIButton *)sender;

@end
