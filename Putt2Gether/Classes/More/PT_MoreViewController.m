//
//  PT_MoreViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_MoreViewController.h"

#import "PT_StatsViewController.h"

#import "PT_MyGroupsViewController.h"

#import "PT_MyScoresViewController.h"

#import <MessageUI/MessageUI.h>

#import "PT_MyProfileViewController.h"

#import "PT_PlayerItemModel.h"

#import "UIImageView+AFNetworking.h"

static NSString *const GetUserDetailsPostfix = @"getuserdetail";

static NSString *const logoutPostFix = @"logout";

@interface PT_MoreViewController ()<MFMailComposeViewControllerDelegate>


@property(weak,nonatomic) IBOutlet UILabel *handicapLabel,*nameLabel;

@end

@implementation PT_MoreViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customdesign];
    
    
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired=1;
    [tapView setUserInteractionEnabled:YES];
    [tapView addGestureRecognizer:singleTap];
    

   _handicapLabel.text = [[MGUserDefaults sharedDefault] getHandicap] ;
    
    _nameLabel.text = [[MGUserDefaults sharedDefault] getDisplayName] ;
    
//    _handicapLabel.layer.cornerRadius = _handicapLabel.frame.size.width/2;
//    _handicapLabel.layer.borderColor = [UIColor clearColor].CGColor;
//    _handicapLabel.layer.borderWidth = 1.0;
//    _handicapLabel.layer.masksToBounds = YES;
}

-(void)customdesign{
    
    _profileBtn.layer.cornerRadius = 1;
    _profileBtn.clipsToBounds = YES;
    [_profileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *userName = [[MGUserDefaults sharedDefault] getDisplayName];
    [_profileBtn setTitle:userName forState:UIControlStateNormal];
    [_profileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _editBtn.layer.cornerRadius = 7;
    _editBtn.clipsToBounds = YES;
    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editBtn setTitle:@"edit profile" forState:UIControlStateNormal];
    
    
    
    //tapEnabled on uiimage
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fetchUserDetails];
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [delegate.tabBarController.tabBar setHidden:YES];
    [self performSelector:@selector(setstyleCircleForImage:) withObject:_myImageview afterDelay:0];
    
    if ([[MGUserDefaults sharedDefault] isvaluePresentForKey:USER_IMAGE])
    {
        _myImageview.image = [UIImage imageWithData:[[MGUserDefaults sharedDefault] getUserImage]];
    }
    
    [_profileBtn setTitle:[[MGUserDefaults sharedDefault] getDisplayName] forState:UIControlStateNormal];
}
-(void) setstyleCircleForImage:(UIImageView *)Imageview{
    _myImageview.layer.cornerRadius = _myImageview.frame.size.width/2;
    _myImageview.clipsToBounds = YES;
    _myImageview.layer.borderColor = [UIColor blackColor].CGColor;
    _myImageview.layer.borderWidth = 2.0;
    
}

-(void)tapDetected:(id)sender{
    [self loadProfile];
}

- (void)loadProfile
{
    PT_MyProfileViewController *profileViewController = [[PT_MyProfileViewController alloc] initWithNibName:@"PT_MyProfileViewController" bundle:nil];
    [self presentViewController:profileViewController animated:YES completion:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == _myImageview)
    {
        
        //add your code for image touch here
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)profieBtnClicked:(id)sender {
    //[_profileBtn setBackgroundColor:[UIColor greenColor]];
    PT_MyProfileViewController *profileViewController = [[PT_MyProfileViewController alloc] initWithNibName:@"PT_MyProfileViewController" bundle:nil];
    [self presentViewController:profileViewController animated:YES completion:nil];
    
}
- (IBAction)editBtnClicked:(id)sender
{
    [self loadProfile];
}
- (IBAction)grupBtnClicked:(id)sender {
    
    PT_MyGroupsViewController *groupVC = [[PT_MyGroupsViewController alloc] initWithNibName:@"PT_MyGroupsViewController"
                                                                               bundle:nil];
    
    [self presentViewController:groupVC animated:YES completion:nil];

}
- (IBAction)scoreBtnClicked:(id)sender {
    PT_MyScoresViewController *statsVC = [PT_MyScoresViewController new];
    //PT_StatsViewController *statsVC = [[PT_StatsViewController alloc] initWithNibName:@"PT_StatsViewController" bundle:nil];
    
    [self presentViewController:statsVC animated:YES completion:nil];
}
- (IBAction)faqsBtnClicked:(id)sender
{
    NSURL *myURL = [NSURL URLWithString:@"http://putt2gether.com/#faq"];
    [[UIApplication sharedApplication] openURL:myURL];
}
- (IBAction)feedbckBtnClicked:(id)sender {
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        
        NSString *emailTitle = @"putt2gether Feedback";
        
        // Email Content
        
        NSString *messageBody = @"";
        
        // To address
        
        NSArray *toRecipents = [NSArray arrayWithObject:@"feedback@putt2gether.com"];
        
        
        
        MFMailComposeViewController *mc = [MFMailComposeViewController new];
        
        mc.mailComposeDelegate = self;
        
        [mc setSubject:emailTitle];
        
        [mc setMessageBody:messageBody isHTML:NO];
        
        [mc setToRecipients:toRecipents];
        
        
        
        // Present mail view controller on screen
        
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
    
}



- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error

{
    
    switch (result)
    
    {
            
        case MFMailComposeResultCancelled:
            
            NSLog(@"Mail cancelled");
            
            break;
            
        case MFMailComposeResultSaved:
            
            NSLog(@"Mail saved");
            
            break;
            
        case MFMailComposeResultSent:
            
            NSLog(@"Mail sent");
            
            break;
            
        case MFMailComposeResultFailed:
            
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            
            break;
            
        default:
            
            break;
            
    }
    
    
    
    // Close the Mail Interface
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    
}
- (IBAction)logoutBtnClicked:(id)sender {
    
    [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:NO];
    //[[MGUserDefaults sharedDefault] resetDefaults];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SIGNUP_LOGIN_DONE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DISPLAY_NAME];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EMAIL_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FULL_NAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_IMAGE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBanner"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bannerPath"];

    //   [self resetDefaults];
    // [[FIRMessaging messaging] unsubscribeFromTopic:@"topics"];
    
    
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    [self logoutUser];
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    NSMutableArray * vcs = [NSMutableArray
//                            arrayWithArray:[delegate.tabBarController viewControllers]];
//    if ([vcs count] > 0)
//    {
//        [vcs removeAllObjects ];//ObjectAtIndex:4];
//        [delegate.tabBarController setViewControllers:vcs];
//    }
//    
//    [delegate changeRootViewControllerToLogin];
    
}

- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate addTabBarAsRootViewController];
}
- (void)fetchUserDetails
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        //[self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //_loadingView.hidden = NO;
        });
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"};
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,GetUserDetailsPostfix] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
            
            if (!error)
            {
                if (responseData != nil)
                {
                    if ([responseData isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dicOutPut = responseData[@"output"];
                        
                        NSDictionary *dicInfo = dicOutPut[@"data"];
                      /*  modelPlayer = [PT_PlayerItemModel new];
                        modelPlayer.playerId = [dicInfo[@"user_id"] integerValue];
                        modelPlayer.playerName = dicInfo[@"display_name"];
                        modelPlayer.handicap = [dicInfo[@"handicap_value"] integerValue];
                        modelPlayer.mobile = [NSString stringWithFormat:@"%@",dicInfo[@"contact_no"]];
                        modelPlayer.country = dicInfo[@"country"];
                        modelPlayer.countryCode = dicInfo[@"country_code"];
                        modelPlayer.playerImageURL = dicInfo[@"photo_url"];
                        modelPlayer.email = dicInfo[@"user_name"];
                        
                        //Update UI
                        self.nameLabel.text = [modelPlayer.playerName uppercaseString];
                        
                        self.handicapLabel.text = [NSString stringWithFormat:@"%li",(long)modelPlayer.handicap];
                        
                        [_myImageview setImageWithURL:[NSURL URLWithString:modelPlayer.playerImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
                        */
 			            PT_PlayerItemModel *model = [PT_PlayerItemModel new];
                        model.playerName = dicInfo[@"display_name"];
                        model.handicap = [dicInfo[@"handicap_value"] integerValue];
                        model.playerImageURL = dicInfo[@"photo_url"];
                        
                        NSString *imagePath = dicInfo[@"photo_url"];
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
                        
                        [[MGUserDefaults sharedDefault] setUserImage:data];
                       // [_profileBtn setTitle:model.playerName forState:UIControlStateNormal];

                        _handicapLabel.text = [NSString stringWithFormat:@"%li",(long)model.handicap ];
                        
                        _nameLabel.text = model.playerName ;
                        
                       [_myImageview setImageWithURL:[NSURL URLWithString:model.playerImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
                        
                        //_golfCourseID = modelPlayer.countryID;
                        //[self nearByGolfCourse];
                    }
                }
            }
        }];
    }
}

//LogOut User
-(void)logoutUser
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }else{
        
        NSString *fcmtoken = [[MGUserDefaults sharedDefault] getDeviceToken];

        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2",
                                @"device_token":fcmtoken,
                                @"device_os":@"1"};
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,logoutPostFix] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
           
            if (!error) {
                
                if (responseData != nil) {
                    
                    NSDictionary *dicResponse = responseData;
                    
                    if ([dicResponse[@"status"] integerValue] == 1) {
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID];

                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        
                        NSMutableArray * vcs = [NSMutableArray
                                                arrayWithArray:[delegate.tabBarController viewControllers]];
                        if ([vcs count] > 0)
                        {
                            [vcs removeAllObjects ];//ObjectAtIndex:4];
                            //[delegate.tabBarController setViewControllers:vcs];
                        }
                        
                        [delegate changeRootViewControllerToLogin];
                        
                    }
                }
            }
            
        }];
        
        
    }
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




@end
