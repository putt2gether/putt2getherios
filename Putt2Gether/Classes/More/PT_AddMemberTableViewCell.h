//
//  PT_AddMemberTableViewCell.h
//  Putt2Gether
//
//  Created by Bunny on 9/15/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_AddMemberTableViewCell : UITableViewCell


@property(strong,nonatomic) IBOutlet UIImageView *playerImage;

@property(strong,nonatomic) IBOutlet UILabel*nameLabel;

@property (strong,nonatomic) IBOutlet UIButton *addBtn;

@end
