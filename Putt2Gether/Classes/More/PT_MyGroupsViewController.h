//
//  PT_MyGroupsViewController.h
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_MyGroupsViewController : UIViewController

@property(strong,nonatomic) IBOutlet UIButton *backBtn;



-(IBAction)actionBack:(id)sender;
@property(nonatomic,strong) IBOutlet UITableView *tableView;

@end
