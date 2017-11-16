//
//  PT_MoreViewController.h
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface PT_MoreViewController : UIViewController
{
    
    IBOutlet UIView *tapView;
}
@property (weak, nonatomic) IBOutlet UIImageView *myImageview;
@property (strong, nonatomic) IBOutlet UIButton *profileBtn;
- (IBAction)profieBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)editBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *groupButton;
- (IBAction)grupBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *scoreButton;
- (IBAction)scoreBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *faqsbutton;
- (IBAction)faqsBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *feedbackButtn;
- (IBAction)feedbckBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *lagoutButton;
- (IBAction)logoutBtnClicked:(id)sender;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end
