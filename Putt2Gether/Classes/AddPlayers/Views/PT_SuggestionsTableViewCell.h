//
//  PT_SuggestionsTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_SuggestionsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;

@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UILabel*playerNumebers;

@property (weak, nonatomic) IBOutlet UIButton *addRemoveButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthPlayerName;

@end
