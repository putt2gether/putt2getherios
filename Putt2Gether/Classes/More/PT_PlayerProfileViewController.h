//
//  PT_PlayerProfileViewController.h
//  Putt2Gether
//
//  Created by Bunny on 9/27/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_PlayerProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *golfCourseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (weak, nonatomic) IBOutlet UILabel *averagescoreLabel;

@property(weak,nonatomic) IBOutlet UILabel *memberCountLabel;

@property(weak,nonatomic) IBOutlet UILabel*noeventLabel;

@property(weak,nonatomic) IBOutlet UILabel *handicapLabel,*addToGroup;

@property(weak,nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *popUpBackView;
@property (weak, nonatomic) IBOutlet UIView *popbackView,*mainView;

@property(weak,nonatomic) IBOutlet UIButton *doneBtn,*coveredBtn;


@property(weak,nonatomic) IBOutlet UIView *popBackUpView,*popUpView;

@property(weak,nonatomic) IBOutlet UIImageView *standingImage,*postionImageView;

@property(weak,nonatomic) IBOutlet UILabel *standingLabel,*rankingLabel;

- (IBAction)actionDonepopUp:(id)sender;

- (void)fetchUserDetails:(NSString *)userId;
- (void)fetchMyScores:(NSString *)userId;



@end
