//
//  PT_VegasTableViewCell.h
//  Putt2Gether
//
//  Created by Nivesh on 02/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_VegasTableViewCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UIView *firstView;

@property(weak,nonatomic) IBOutlet UIView *seccondView;

@property(weak,nonatomic)IBOutlet UILabel*firstVlabel;

@property(weak,nonatomic) IBOutlet UILabel *secondVlabel;

@property(weak,nonatomic) IBOutlet UILabel *holeNumberLabel;


@end
