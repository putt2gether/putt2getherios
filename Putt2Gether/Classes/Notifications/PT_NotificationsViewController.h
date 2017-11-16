//
//  PT_NotificationsViewController.h
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_NotificationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray*tableData;
}

@property(strong,nonatomic) IBOutlet UITableView*myTableView;

@property(weak,nonatomic) IBOutlet UIImageView *bannerImage;


@property (strong, nonatomic) IBOutlet UIButton *notificationBtn;
- (IBAction)notifiBtnClicked:(id)sender;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end
