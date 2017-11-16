//
//  PT_CreateGroupViewController.h
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_GroupItemModel.h"

@interface PT_CreateGroupViewController : UIViewController

@property(strong,nonatomic) IBOutlet UIButton *backBtn,*groupnameEditBtn,*imageEditBtn ,*cancelBtn;
@property(strong,nonatomic) IBOutlet UITextField *groupNameText;

- (instancetype)initWithModel:(PT_GroupItemModel *)model andType:(GroupType)type;

-(IBAction)actionImageEdit:(id)sender;

-(IBAction)actionBack:(id)sender;

-(IBAction)actionGroupEdit:(id)sender;


-(IBAction)actionHome:(id)sender;


-(IBAction)actionCancel:(id)sender;

-(IBAction)actionSave:(id)sender;

@property(strong,nonatomic) IBOutlet UITableView *tableView;

//@property(strong,nonatomic) IBOutlet UIImageView *imgView;

@property(strong,nonatomic) IBOutlet UIView *popupView ,*popbackView;
- (IBAction)actionGallery:(id)sender;


- (IBAction)actionTakepicture:(id)sender;

@property(weak,nonatomic) IBOutlet UILabel *saveLabel,*homeLabel;
@property(nonatomic,strong) UIPopoverController *customPopoverController;

@property (nonatomic , strong) NSArray *arrayImageUploadOption;

- (void)setSelectedPlayers:(NSArray *)selectedList;

-(void)fetchGroupDetails;

@end
