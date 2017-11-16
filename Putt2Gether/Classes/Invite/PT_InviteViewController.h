//
//  PT_InviteViewController.h
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PT_CreateViewController.h"
#import "PT_HomeViewController.h"
#import "addPatcipantsVCViewController.h"
#import "CustomCell.h"
#import "PT_SelectGolfCourseModel.h"

#import "PT_SelectGolfCourseTableViewCell.h"
#import "PT_GolfCourceTableViewCell.h"
//#import "CustomCell2.h"

@interface PT_InviteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@property (strong, nonatomic) NSMutableArray *arrGolfCourseList;
@property (strong, nonatomic) PT_SelectGolfCourseModel *currentGolfCourseModel;
@property (strong, nonatomic) NSMutableArray *arrGolfCoursesList;

@property (strong, nonatomic) IBOutlet UIButton *editButton,*bannerBtn;
- (IBAction)editBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)declineBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *myscrollView;

@property (strong, nonatomic) IBOutlet UIButton *accptButton;
- (IBAction)accptBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *evnt1View;

@property (strong, nonatomic) IBOutlet UIButton *view1detBtn;
- (IBAction)vw1detBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *evntView;
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;
- (IBAction)homeBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIButton *view1declBtn;
- (IBAction)vw1declBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *view1accpBtn;
- (IBAction)vw1accpBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *evnt2View;
@property (strong, nonatomic) IBOutlet UIButton *view2editBtn;
- (IBAction)view2editBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *view2declineBtn;
- (IBAction)view2decBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *view2accpBtn;
- (IBAction)view2accpBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *accpview4Btn;
- (IBAction)addBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBTN;
@property (strong, nonatomic) IBOutlet UIButton *decview4Btn;
- (IBAction)backBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editview4Btn;

@property(weak,nonatomic) IBOutlet UIImageView *bannerImage;


- (instancetype)initWithDate:(NSString *)date
               andGolfCourse:(NSString *)golfCourseId;

@end
