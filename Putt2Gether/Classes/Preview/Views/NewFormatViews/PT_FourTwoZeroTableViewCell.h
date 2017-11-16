//
//  PT_FourTwoZeroTableViewCell.h
//  Putt2Gether
//
//  Created by Nivesh on 01/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_FourTwoZeroTableViewCell : UITableViewCell


@property(weak,nonatomic) IBOutlet UILabel *holenumberLabel;

@property(weak,nonatomic) IBOutlet UILabel *firstVFirstLabel;

@property(weak,nonatomic) IBOutlet UILabel *firstVSecondLabel;

@property(weak,nonatomic) IBOutlet UILabel *firstVThirdLabel;



@property(weak,nonatomic) IBOutlet UIView *firstView;

@property(weak,nonatomic) IBOutlet UIView *secondView;
@property(weak,nonatomic) IBOutlet UILabel *secondVFirstLabel;

@property(weak,nonatomic) IBOutlet UILabel *secondVSecondLabel;

@property(weak,nonatomic) IBOutlet UILabel *secondVThirdLabel;

@end
