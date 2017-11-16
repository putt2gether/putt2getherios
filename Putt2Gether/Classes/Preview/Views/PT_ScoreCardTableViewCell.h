//
//  PT_ScoreCardTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 13/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_ScoreCardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *c1;
@property (weak, nonatomic) IBOutlet UIView *c2;
@property (weak, nonatomic) IBOutlet UIView *c3;
@property (weak, nonatomic) IBOutlet UIView *c4;
@property (weak, nonatomic) IBOutlet UIView *c5;
@property (weak, nonatomic) IBOutlet UIView *c6;
@property (weak, nonatomic) IBOutlet UIView *c7;
@property (weak, nonatomic) IBOutlet UIView *c8;
@property (weak, nonatomic) IBOutlet UIView *c9;
@property (weak, nonatomic) IBOutlet UIView *l1;
@property (weak, nonatomic) IBOutlet UIView *l2;

@property (weak, nonatomic) IBOutlet UITextField *ct1;
@property (weak, nonatomic) IBOutlet UITextField *ct2;
@property (weak, nonatomic) IBOutlet UITextField *ct3;
@property (weak, nonatomic) IBOutlet UITextField *ct4;
@property (weak, nonatomic) IBOutlet UITextField *ct5;
@property (weak, nonatomic) IBOutlet UITextField *ct6;
@property (weak, nonatomic) IBOutlet UITextField *ct7;
@property (weak, nonatomic) IBOutlet UITextField *ct8;
@property (weak, nonatomic) IBOutlet UITextField *ct9;

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellValue;

- (void)setDefaultBodering;

- (void)setCBGColor;

@end
