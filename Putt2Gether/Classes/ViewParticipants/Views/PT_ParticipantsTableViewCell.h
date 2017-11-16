//
//  PT_ParticipantsTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_ParticipantsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIButton *editHandicapButton;

@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UITextField *handicapText;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIView *lowerView;

@property(weak,nonatomic) IBOutlet UIView *buttonView;

@property(weak,nonatomic) IBOutlet UILabel *editHandicapLabel;

@property(weak,nonatomic) IBOutlet UIImageView *profileEditImage;

@property(weak,nonatomic) IBOutlet UILabel *singleLineStatus;

- (void)setDefaultUIProperties;

@end
