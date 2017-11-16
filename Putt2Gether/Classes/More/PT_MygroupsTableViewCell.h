//
//  PT_MygroupsTableViewCell.h
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_MygroupsTableViewCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UIImageView *playerImage;
@property(strong,nonatomic) IBOutlet UILabel *nameLabel;
@property(strong,nonatomic) IBOutlet UIButton *arrowBtn;

@end
