//
//  PT_AutopressSecTableViewCell.h
//  Putt2Gether
//
//  Created by Nivesh on 06/04/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_AutopressSecTableViewCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UILabel *holeNumberLabel;


//Mark:-for first View
@property(weak,nonatomic) IBOutlet UIView *firstView;

@property(weak,nonatomic) IBOutlet UILabel *firstV1stLbl;

@property(strong,nonatomic) IBOutlet NSLayoutConstraint *widthConsFirstView;

@end
