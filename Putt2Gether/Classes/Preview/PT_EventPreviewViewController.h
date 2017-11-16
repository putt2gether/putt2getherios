//
//  PT_EventPreviewViewController.h
//  Putt2Gether
//
//  Created by Devashis on 07/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreatedEventModel.h"

@interface PT_EventPreviewViewController : UIViewController

- (instancetype)initWithModel:(PT_CreatedEventModel *)model andIsRequestToParticipate:(BOOL)requestToParticipate;

@property (assign, nonatomic) BOOL isEditMode;

//For Request to participate
@property (assign, nonatomic) BOOL isRequestToParticipate;

@property (assign, nonatomic) NSInteger totalCount4PlusPlayers;

- (IBAction)actionScorer:(id)sender;


//Mark:-property declration for banner Details
@property(weak,nonatomic) IBOutlet UIView *bannnerView;

@property(weak,nonatomic) IBOutlet UIImageView *bannnerImg;

@property(weak,nonatomic) IBOutlet UIButton *bannnercloseBtn;

@property(strong,nonatomic) NSMutableArray *arrBanner;

@property(assign,nonatomic) BOOL isComingAfterDelegate;

@property(weak,nonatomic) IBOutlet UIView *acceptRejectFooter;

-(IBAction)actionAccept:(id)sender;

-(IBAction)actionReject:(id)sender;

@property(weak,nonatomic) IBOutlet UIView *popupView,*popupInsideView,*popupaddParticipantView,*popUpMainView;

@property(weak,nonatomic) IBOutlet UILabel *popupLbl;

@property(assign,nonatomic) BOOL isViewScore;



@end
