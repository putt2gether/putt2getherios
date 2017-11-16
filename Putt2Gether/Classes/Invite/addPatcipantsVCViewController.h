//
//  addPatcipantsVCViewController.h
//  Putt2Gether
//
//  Created by Bunny on 8/19/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "ViewController.h"
#import "PT_InviteViewController.h"



@interface addPatcipantsVCViewController : ViewController
- (instancetype)initWithDelegate:(UIViewController *)parent andGolfCourseList:(NSArray *)list;





//@property (weak, nonatomic)PT_CreateViewControllertableOptions;

@property (strong, nonatomic) IBOutlet UIButton *selectgolfBtn;
- (IBAction)selecgolfBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nearBtn;
- (IBAction)nearBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *browseBtn;
- (IBAction)browseBtnclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recentbtn;
- (IBAction)recentBtnClicked:(id)sender;

@property(weak,nonatomic) IBOutlet UITextField *searchText;

@end
