//
//  PT_GolfCourceTableViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_GolfCourceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *golfCourseButton;

- (void)setSychronizationValueforButton;

@end
