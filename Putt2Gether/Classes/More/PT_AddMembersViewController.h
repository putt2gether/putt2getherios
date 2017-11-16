//
//  PT_AddMembersViewController.h
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateGroupViewController.h"

@interface PT_AddMembersViewController : UIViewController

- (instancetype)initWithGroupId:(NSString *)groupId;

@property (strong, nonatomic) PT_CreateGroupViewController *groupVC;

@property(strong,nonatomic) IBOutlet UIButton *backBtn;
@property (strong,nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) IBOutlet UIButton *saveBtn;

-(IBAction)actionBack:(id)sender;

-(IBAction)actionSave:(id)sender;

@property(strong,nonatomic) IBOutlet UITextField *searchText;




@end
