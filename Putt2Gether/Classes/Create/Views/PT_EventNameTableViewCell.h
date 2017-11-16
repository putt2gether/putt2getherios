//
//  PT_EventNameTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_EventNameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *eventName;

- (void)setSychronizationValueforButton;

@end
