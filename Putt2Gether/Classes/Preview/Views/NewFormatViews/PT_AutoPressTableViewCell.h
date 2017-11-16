//
//  PT_AutoPressTableViewCell.h
//  Putt2Gether
//
//  Created by Nivesh on 02/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_AutoPressTableViewCell : UITableViewCell

//Mark:-properties declaration
@property(weak,nonatomic) IBOutlet UILabel *holeNumberLabel;


//Mark:-for first View
@property(weak,nonatomic) IBOutlet UIView *firstView;

@property(weak,nonatomic) IBOutlet UILabel *firstV1stLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV2ndLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV3rdLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV4thLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV5thLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV6thLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV7thLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV8thLbl;

@property(weak,nonatomic) IBOutlet UILabel *firstV9thLbl;

//Mark:-for second View
@property(weak,nonatomic) IBOutlet UIView *secondView;

@property(weak,nonatomic) IBOutlet UILabel *secondV1stLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV2ndLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV3rdLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV4thLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV5thLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV6thLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV7thLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV8thLbl;

@property(weak,nonatomic) IBOutlet UILabel *secondV9thLbl;


@property(weak,nonatomic) IBOutlet UILabel *mpercentLbl;


@property(strong,nonatomic) IBOutlet NSLayoutConstraint *widthConsFirstView,*widthConsSecondView,*xConstFirstView;

@property(weak,nonatomic) IBOutlet UIView *containerView;


@end
