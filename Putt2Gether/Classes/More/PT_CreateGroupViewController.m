//
//  PT_CreateGroupViewController.m
//  Putt2Gether
//
//  Created by Bunny on 9/14/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_CreateGroupViewController.h"

#import "PT_CreateGroupTableViewCell.h"
#import "PT_MyGroupsViewController.h"

#import "PT_AddMembersViewController.h"

#import "PT_GroupMembersModel.h"

#import "UIKit+AFNetworking.h"

#import "PT_PlayerProfileViewController.h"

#import "NSMutableString+Color.h"


static NSString *const GroupDetailPostfix = @"getgroupdetail";

static NSString *const SuggestedFRiendPostfix = @"getsuggessionfriendlist";

static NSString *const CreateGroupPostfix = @"addnewgroup";

static NSString *const EditGroupPostfix = @"editgroup";

@interface PT_CreateGroupViewController ()<UITableViewDataSource,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UITextFieldDelegate>


{
    
    IBOutlet UIImageView *imgPicture;
    NSData *dataImage;
    NSMutableArray *arrContainer,*arrDeleteIDs;
    
    PT_GroupItemModel *modelGroup;
    
    GroupType groupType;
    
    IBOutlet UILabel *createdByLabel;
    
    IBOutlet UIButton *saveButton;
    
    NSString *createdByString;
    
    IBOutlet UIButton *addContactButton;
    
    BOOL isRemoved;
    
    
}


@property(nonatomic,assign) BOOL isgroupAdmin;

@end

@implementation PT_CreateGroupViewController

- (instancetype)initWithModel:(PT_GroupItemModel *)model andType:(GroupType)type
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    groupType = type;
    modelGroup = model;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _popupView.hidden = YES;
    _groupnameEditBtn.layer.cornerRadius = 13.0f;
    _groupnameEditBtn.clipsToBounds = YES;
    
   
    
    if (groupType == GroupType_Members)
    {
        [self fetchGroupDetails];
        NSString *groupNameText = [NSString stringWithFormat:@"%@",modelGroup.groupName];
        self.groupNameText.text = groupNameText;
    }
    else
    {
        [self fetchSuggestedMembers];
        //[self.groupNameText bringToFront];
        UIColor *color = [UIColor whiteColor];
        self.groupNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PLEASE ENTER GROUP NAME" attributes:@{NSForegroundColorAttributeName: color}];
        createdByLabel.hidden = YES;
    }
    //[saveButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = saveButton.imageView.image.size;
    saveButton.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [saveButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: saveButton.titleLabel.font}];
    saveButton.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = fabsf(titleSize.height - imageSize.height) / 2.0;
    saveButton.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    arrDeleteIDs = [NSMutableArray new];

    [self addGradientToView:imgPicture];
    
}

- (void)addGradientToView:(UIImageView *)view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] CGColor],
                        (id)[[UIColor clearColor] CGColor],
                        (id)[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7] CGColor]];
    [view.layer insertSublayer:gradient atIndex:0];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
       
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
        
    });
    [self.view setNeedsDisplay];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrContainer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier =@"cell";
    
    PT_CreateGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == Nil)
    {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_CreateGroupTableViewCell" owner:self options:Nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PT_GroupMembersModel *model = arrContainer[indexPath.row];
    
    NSString *name = [NSString stringWithFormat:@"%@  %@",model.memberName,model.memberHandicap];
    NSString *strHandicap = [NSString stringWithFormat:@"%@",model.memberHandicap];
    NSMutableAttributedString * stringName = [[NSMutableAttributedString alloc] initWithString:name];
    
    NSRange boldRange = [name rangeOfString:strHandicap];
    [stringName addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:boldRange];
    
    [stringName addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:boldRange];
    
    [stringName setColorForText:strHandicap withColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1]];
    
    cell.nameLabel.attributedText = stringName;
    if (model.playedBefore > 0) {
        
        cell.starImage.hidden = NO;
    }else{
        
        cell.starImage.hidden = YES;

    }
    
    cell.adminBtn.tag = indexPath.row;
    [cell.adminBtn addTarget:self action:@selector(adminBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.removeBtn.tag = indexPath.row;
    [cell.removeBtn addTarget:self action:@selector(removeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (groupType == GroupType_CreateGroup && model.isAddedToNewGroup == YES)
    {
        [cell.removeBtn setTitle:@"Remove" forState:UIControlStateNormal];
        cell.adminBtn.hidden = YES;

    }
    else if (groupType == GroupType_CreateGroup && model.isAddedToNewGroup == NO)
    {
        [cell.removeBtn setTitle:@"ADD" forState:UIControlStateNormal];
        cell.adminBtn.hidden = YES;

    }
    if (groupType == GroupType_Members ) {
        
        if (model.isAdmin > 0) {
            
            [cell.removeBtn removeFromSuperview];
            cell.adminBtn.hidden = NO;

        }else{
            [cell.removeBtn setTitle:@"Remove" forState:UIControlStateNormal];
            cell.adminBtn.hidden = YES;
        }
    }
    
    
    [cell.playerImage setImageWithURL:[NSURL URLWithString:model.memberImageUrl] placeholderImage:[UIImage imageNamed:@"add_player"]];
    
    

    
    
    cell.playerImage.layer.cornerRadius = cell.playerImage.frame.size.width/2;
    cell.playerImage.layer.borderColor = [UIColor clearColor].CGColor;
    cell.playerImage.layer.borderWidth = 1.0;
    cell.playerImage.layer.masksToBounds = YES;
    //cell.nameLabel.text = model.memberName;

   // cell.handicapLabel.text = model.memberHandicap;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PT_GroupMembersModel *model = arrContainer[indexPath.row];
    
    PT_PlayerProfileViewController *playerVC = [[PT_PlayerProfileViewController alloc] initWithNibName:@"PT_PlayerProfileViewController" bundle:nil];
    [playerVC fetchUserDetails:model.memberId];
    
    [playerVC fetchMyScores:model.memberId];
    [self presentViewController:playerVC animated:YES completion:nil];
    
}


-(void)adminBtnClicked:(UIButton *) sender{
    
    
}

-(void)removeBtnClicked:(UIButton *) sender{
    
    if (groupType == GroupType_Members)
    {
        PT_GroupMembersModel *model = arrContainer[sender.tag];

        
        NSString *str  = model.memberId;
        [arrDeleteIDs addObject:str];
        NSLog(@"%@",arrDeleteIDs);
//        if (model.isRemoved == YES)
//        {
//            model.isRemoved = NO;
//        }
//        else
//        {
//           model.isRemoved = YES;
//        }

        [arrContainer removeObjectAtIndex:sender.tag];
    
        [self.tableView reloadData];
    }
    else
    {
        PT_GroupMembersModel *model = arrContainer[sender.tag];
        if (model.isAddedToNewGroup == YES)
        {
            model.isAddedToNewGroup = NO;
        }
        else
        {
            model.isAddedToNewGroup = YES;
        }
        
        [self.tableView reloadData];
        
    }
}



-(IBAction)actionBack:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionGroupEdit:(id)sender{
    
    [_groupNameText becomeFirstResponder];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_groupNameText resignFirstResponder];
    [self.view endEditing:YES];
}

-(IBAction)actionImageEdit:(id)sender{
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture", @"Gallery", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    
//    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//    [background setFrame:CGRectMake(0, 0, 414, 250)];
//    background.contentMode = UIViewContentModeScaleToFill;
//    [actionSheet addSubview:background];

    //[actionSheet setBounds:CGRectMake(0, 0, 350, 200)];
    
    [actionSheet showInView:self.view];
    
//    _popupView.hidden = NO;
//    
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleSingleTap:)];
//    [self.popbackView addGestureRecognizer:singleFingerTap];
    

    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 1:
            switch (buttonIndex)
        {
            case 0:
            {
#if TARGET_IPHONE_SIMULATOR
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Camera not available." delegate:nil cancelButtonTitle:@"DISMISS" otherButtonTitles:nil];
                [alert show];
                
#elif TARGET_OS_IPHONE
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
               picker.allowsEditing = YES;
//                 [self presentViewController:picker animated:YES completion:nil];
                
               
            [self presentViewController:picker animated:YES completion:nil];

                
#endif
            }
                break;
            case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //picker.delegate = self;
                picker.allowsEditing = YES;

//                [self presentViewController:picker animated:YES completion:nil];
                
                
                //Create camera overlay
                
                 picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];

            }
                break;
        }
            break;
            
        default:
            break;
    }
}
/*
 
 //    if you want to edit selected image then use this delegate method.
 
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
 {
 imgPicture.image = image;
 [self.navigationController dismissModalViewControllerAnimated:YES];
 }
 */

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    //dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    //imgPicture.image = [[UIImage alloc] initWithData:dataImage];
   // [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *pickedImageEdited = [info objectForKey:UIImagePickerControllerEditedImage];

    
    [self imageByCroppingImage:pickedImageEdited toSize:CGSizeMake(600 ,600)];
    
        
    [picker dismissViewControllerAnimated:YES completion:nil];

    
//    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    CGSize destinationSize1 = CGSizeMake(imgPicture.frame.size.width, imgPicture.frame.size.height);
//    UIGraphicsBeginImageContext(destinationSize1);
//    [originalImage drawInRect:CGRectMake(0,0,destinationSize1.width,destinationSize1.height)];
//    UIImage *newImage1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    imgPicture.image = newImage1;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    NSLog(@"image width is %f",imgPicture.image.size.width);
//    NSLog(@"image height is %f",imgPicture.image.size.height);
}


- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    imgPicture.image = cropped;
    
    return cropped;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    _popupView.hidden = YES;
    
}

-(IBAction)actionHome:(id)sender{
    
    if (_isgroupAdmin == YES) {
        
        PT_AddMembersViewController *mygroupsViewController = [[PT_AddMembersViewController alloc] initWithGroupId:[NSString stringWithFormat:@"%li",(long)modelGroup.groupId]];
        mygroupsViewController.groupVC = self;
        [self presentViewController:mygroupsViewController animated:YES completion:nil];
    }else{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate addTabBarAsRootViewController];
        //[self actionBAck];
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:NULL];
    });

    }
    
}


-(IBAction)actionCancel:(id)sender{
    
    _popupView.hidden = YES;
    
    
    
}

-(IBAction)actionSave:(id)sender;{
    
    
    
    if ([self.groupNameText.text length] == 0)
    {
        return;
    }
    if (groupType == GroupType_CreateGroup)
    {
        [self createGroup];
    }
    else
    {
        [self updateGroup];
    }
    
    
}

- (IBAction)addPlayers:(id)sender
{
    PT_AddMembersViewController *mygroupsViewController = [[PT_AddMembersViewController alloc] initWithGroupId:[NSString stringWithFormat:@"%li",(long)modelGroup.groupId]];
    mygroupsViewController.groupVC = self;
    [self presentViewController:mygroupsViewController animated:YES completion:nil];
}
- (IBAction)actionGallery:(id)sender {
    
    
   
}

- (IBAction)actionTakepicture:(id)sender {
    
   }

#pragma mark - AlertView

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"PUTT2GETHER"
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Dismiss"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Web Service calls

- (void)fetchGroupDetails
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]],
                                @"group_id":[NSString stringWithFormat:@"%li",(long)modelGroup.groupId],
                                @"version":@"2"
                                };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,GroupDetailPostfix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"output"])
                              {
                                  NSDictionary *dataOutput = responseData[@"output"];
                                  createdByString = dataOutput[@"create_data"];
                                  [imgPicture setImageWithURL: [NSURL URLWithString:dataOutput[@"profile_image"]]];
                                  
                                  if ([dataOutput[@"is_group_admin"]integerValue] == 1  ) {
                                      
                                      [_homeLabel setText:@"Add Members"];
                                      
                                      _isgroupAdmin = YES;
                                  }

                                  createdByLabel.text = createdByString;
                                  NSArray *suggestionList = dataOutput[@"data"];
                                  
                                  if (!(suggestionList == (id)[NSNull null]))
                                  {
                                      arrContainer = [NSMutableArray new];
                                      [suggestionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                          
                                          NSDictionary *dataObj = obj;
                                          
                                          PT_GroupMembersModel *model = [PT_GroupMembersModel new];
                                          
                                          model.memberName = dataObj[@"display_name"];
                                          
                                          model.memberImageUrl = dataObj[@"photo_url"];
                                          
                                          model.memberHandicap = [NSString stringWithFormat:@"%@",dataObj[@"self_handicap"]];
                                          
                                          model.memberId = [NSString stringWithFormat:@"%@",dataObj[@"member_id"]];
                                          
                                          model.isAdmin = [dataObj[@"is_admin"] integerValue];
                                          
                                          [arrContainer addObject:model];
                                          
                                          
                                          
                                          if (idx == [suggestionList count] - 1)
                                          {
                                              //dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [self.tableView reloadData];
                                                  
                                              //});
                                              
                                          }
                                          
                                      }];
                                  }
                                  else
                                  {
                                      [self showAlertWithMessage:@"No data available. Please try again"];
                                  }
                                  
                                  
                                  
                              }
                              else
                              {
                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
                                  [self showAlertWithMessage:messageError];
                              }
                              
                          }
                      }
                      
                      else
                      {
                          
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}


- (void)fetchSuggestedMembers
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]],
                                @"searchkey":@"",
                                @"version":@"2"
                                };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,SuggestedFRiendPostfix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSDictionary *dicResponseData = responseData;
                              NSDictionary *dicOutput = dicResponseData[@"output"];
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  NSArray *arrFriendList = dicOutput[@"Suggestion List"];
                                  arrContainer = [NSMutableArray new];
                                  [arrFriendList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicAtIndex = obj;
                                      PT_GroupMembersModel *model = [PT_GroupMembersModel new];
                                      model.memberName = dicAtIndex[@"full_name"];
                                      model.memberId = [NSString stringWithFormat:@"%@",dicAtIndex[@"user_id"]];
                                      model.memberImageUrl = dicAtIndex[@"profile_image"];
                                      model.memberHandicap = [NSString stringWithFormat:@"%@",dicAtIndex[@"self_handicap"]];
                                      model.isAddedToNewGroup = NO;
                                      model.isRemoved = NO;
                                      model.playedBefore = [dicAtIndex[@"played"] integerValue];
                                      [arrContainer addObject:model];
                                      if (idx == [arrFriendList count] - 1)
                                      {
                                          [self.tableView reloadData];
                                      }
                                  }];
                              }
                              else
                              {
                                  [self showAlertWithMessage:@"PLese try again."];
                              }
                              
                          }
                      }
                      
                      else
                      {
                          
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

- (void)updateGroup
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        //Group Members
        NSMutableArray *arrMembers = [NSMutableArray new];
        for (NSInteger counter = 0; counter < [arrContainer count]; counter++)
        {
            PT_GroupMembersModel *model = arrContainer[counter];
            if (model.isRemoved == YES)
            {
                //NSDictionary *dicAddedMember = [NSDictionary dictionaryWithObject:model.memberId forKey:@"member_id"];
                [arrMembers addObject:model.memberId];
                NSLog(@"%@",arrMembers);
            }
        }
        
        //Group Image
        UIImage *image = imgPicture.image;
        //NSData *imageData = UIImagePNGRepresentation(image);
        //NSString *imageDataEncodedeString = [self base64forData:imageData];
        //NSString *base64String = [imageData base64EncodedDataWithOptions:0];
        NSData * base64Data = [UIImageJPEGRepresentation(image, 0.5) base64EncodedDataWithOptions:0];
        NSString* str = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"group_name":self.groupNameText.text,
                                @"profile_img":str,
                                @"group_id":[NSString stringWithFormat:@"%li",(long)modelGroup.groupId],
                                @"deleted_user_ids":arrDeleteIDs,
                                @"version":@"2"
                                };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,EditGroupPostfix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSDictionary *dicResponseData = responseData;
                              NSDictionary *dicOutput = dicResponseData[@"output"];
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  NSString *message = dicOutput[@"message"];
                                  
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                              
                              
                          }
                      }
                      
                      else
                      {
                          
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  }
                  
                  
              }];
    }
}

- (void)createGroup
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        //Group Members
        NSMutableArray *arrMembers = [NSMutableArray new];
        for (NSInteger counter = 0; counter < [arrContainer count]; counter++)
        {
            PT_GroupMembersModel *model = arrContainer[counter];
            if (model.isAddedToNewGroup == YES)
            {
                NSDictionary *dicAddedMember = [NSDictionary dictionaryWithObject:model.memberId forKey:@"member_id"];
                [arrMembers addObject:dicAddedMember];
            }
        }
        
        //Group Image
        UIImage *image = imgPicture.image;
        //NSData *imageData = UIImagePNGRepresentation(image);
        //NSString *imageDataEncodedeString = [self base64forData:imageData];
        //NSString *base64String = [imageData base64EncodedDataWithOptions:0];
        NSData * base64Data = [UIImageJPEGRepresentation(image, 0.5) base64EncodedDataWithOptions:0];
        NSString* str = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        
//        NSString *base64String = [UIImagePNGRepresentation(image)
//                                  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]],
                                @"group_name":self.groupNameText.text,
                                @"profile_img":str,
                                @"member_list":arrMembers,
                                @"version":@"2"
                                };
        NSLog(@"%@",param);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,CreateGroupPostfix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSDictionary *dicResponseData = responseData;
                              NSDictionary *dicOutput = dicResponseData[@"output"];
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  NSString *message = dicOutput[@"message"];
                                  
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                              
                              
                          }
                      }
                      
                      else
                      {
                          
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                  }
                  
                  
              }];
    }
}

-(NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (void)setSelectedPlayers:(NSArray *)selectedList
{
    [selectedList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PT_GroupMembersModel *modelMain = obj;
        BOOL isPresent = NO;
        for (NSInteger counter = 0; counter < [arrContainer count]; counter++)
        {
            PT_GroupMembersModel *modelAtIndex = arrContainer[counter];
            
            if ([modelAtIndex.memberId isEqualToString:modelMain.memberId])
            {
                isPresent = YES;
            }
        }
        if (isPresent == NO)
        {
            [arrContainer addObject:modelMain];
        }
        
        if (idx == [selectedList count] - 1)
        {
            [self.tableView reloadData];
        }
    }];
}

@end
