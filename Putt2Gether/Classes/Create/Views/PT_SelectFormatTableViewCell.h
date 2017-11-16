//
//  PT_SelectFormatTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_SelectFormatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *formatButton;

- (void)setSychronizationValueforButton;

@end
