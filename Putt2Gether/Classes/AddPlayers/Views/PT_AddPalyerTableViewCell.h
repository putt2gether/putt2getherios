//
//  PT_AddPalyerTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 18/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_AddPalyerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;

@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UIButton *addRemoveButton;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet UILabel *adminLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPlayerNameLeading;

@end
