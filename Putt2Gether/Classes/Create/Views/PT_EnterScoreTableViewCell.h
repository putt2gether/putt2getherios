//
//  PT_EnterScoreTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 13/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"

@interface PT_EnterScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) PT_CreateViewController *parentController;

@property (weak, nonatomic) IBOutlet UIButton *singleButton;

@property (weak, nonatomic) IBOutlet UIButton *multiButton;

@end
