//
//  PT_CreateGroupTableViewCell.h
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_CreateGroupTableViewCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UIImageView *playerImage;

@property(weak,nonatomic) IBOutlet UILabel *nameLabel,*handicapLabel;

@property(weak,nonatomic) IBOutlet UIButton *adminBtn ,*removeBtn;

@property(weak,nonatomic) IBOutlet UIImageView *starImage,*checkImage;

@end
