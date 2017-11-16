//
//  PT_GroupTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 02/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_GroupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;

@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UILabel*playerNumebers;

@property (weak, nonatomic) IBOutlet UIButton *addRemoveButton;

@end
