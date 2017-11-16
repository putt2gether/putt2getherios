//
//  PT_DelegateTableViewCell.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_DelegateTableViewCell : UITableViewCell


@property(nonatomic,strong) IBOutlet UILabel *nameLabel, *DelegateLabel;


@property(nonatomic,strong)IBOutlet UIImageView *downBtn;

@property(weak,nonatomic) IBOutlet UIButton *delegateBtn;

@property(strong,nonatomic) NSString *ButtonId;

@end
