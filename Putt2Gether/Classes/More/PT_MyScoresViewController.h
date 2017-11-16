//
//  PT_MyScoresViewController.h
//  Putt2Gether
//
//  Created by Devashis on 13/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_MyScoresViewController : UIViewController

@property(weak,nonatomic) IBOutlet UIView *popBackUpView,*popUpView;

@property(weak,nonatomic) IBOutlet UIImageView *standingImage,*postionImageView;

@property(weak,nonatomic) IBOutlet UILabel *standingLabel,*rankingLabel;

@property(weak,nonatomic) IBOutlet UIImageView *bannerImage;

@property(weak,nonatomic) IBOutlet UIButton *bannerButton;

@end
