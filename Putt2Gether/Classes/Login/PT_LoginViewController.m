//
//  PT_LoginViewController.m
//  Putt2Gether
//
//  Created by Devashis on 15/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_LoginViewController.h"

#import "PT_SignUpViewController.h"

#import "AppDelegate.h"

#import "MGMainDAO.h"

#import "PT_ForgotPasswordViewController.h"

#import "PT_PlayerItemModel.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "ProfileViewController.h"


static const NSString *LoginPostFix = @"login";

@interface PT_LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLViewBG;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthSViewBG;

@property (weak, nonatomic) IBOutlet UIView *loginContentsBGView;

@property (weak, nonatomic) IBOutlet UIView *emailTextBGView;

@property (weak, nonatomic) IBOutlet UIView *passwordTextBGView;

@property (weak, nonatomic) IBOutlet UITextField *textEmail;

@property (weak, nonatomic) IBOutlet UITextField *textPassword;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;

@property(strong,nonatomic) NSMutableArray *arrFB;

@end

@implementation PT_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrFB = [NSMutableArray new];

    //[self loadLoadingView];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    switch (screenHeight) {
        case 480 :
        {
            
            
        }
            break;
            
        case 568:
        {
            self.constraintLViewBG.constant = 122;
            self.constraintWidthSViewBG.constant = 162;
        }
            break;
            
        case 667:
        {
            self.constraintLViewBG.constant = 122;
            self.constraintWidthSViewBG.constant = 162;
        }
            break;
            
        case 736:
        {
            //self.loginBoxHeight.constant = 220;
        }
            break;
            
    }
    
    [self setTextFieldPadding];
    [self setFonts];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextFieldPadding
{
    self.textEmail.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    self.textPassword.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    
    UIColor *color = [UIColor darkGrayColor];
    self.textEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.loginContentsBGView.layer.cornerRadius = 2.0;
    
    self.signInButton.layer.cornerRadius = 2.0;
    
    
}

- (void)setFonts
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSString *signInFont = self.signUpButton.titleLabel.font.fontName;
    UIFont *font1 = [UIFont fontWithName:signInFont size:10.0f];
    UIFont *font2 = [UIFont fontWithName:signInFont  size:14.0f];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            };
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2,
                            };
    
    NSMutableAttributedString *attStringSignUpButton = [[NSMutableAttributedString alloc] init];
    [attStringSignUpButton appendAttributedString:[[NSAttributedString alloc] initWithString:@"NEW USER!\n"    attributes:dict1]];
    [attStringSignUpButton appendAttributedString:[[NSAttributedString alloc] initWithString:@"SIGN UP"      attributes:dict2]];
    [self.signUpButton setAttributedTitle:attStringSignUpButton forState:UIControlStateNormal];
    [[self.signUpButton titleLabel] setNumberOfLines:0];
    [[self.signUpButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    self.signUpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSMutableAttributedString *attStringFBButton = [[NSMutableAttributedString alloc] init];
    
    [attStringFBButton appendAttributedString:[[NSAttributedString alloc] initWithString:@"SIGN IN WITH\n"
                                                                              attributes:dict1]];
    
    [attStringFBButton appendAttributedString:[[NSAttributedString alloc] initWithString:@"FACEBOOK"
                                                                              attributes:dict2]];
    
    [self.facebookButton setAttributedTitle:attStringFBButton
                                   forState:UIControlStateNormal];
    
    [[self.facebookButton titleLabel] setNumberOfLines:0];
    
    [[self.facebookButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    
    self.facebookButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.facebookButton.titleLabel.textColor = [UIColor whiteColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _textEmail)
    {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= 70;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }else if (textField == _textPassword){
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= 80;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textEmail)
    {
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y += 70;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }else if (textField == _textPassword){
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += 80;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)actionSignIn
{
    [self.view endEditing:YES];
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please check the internet connection and try again."
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
    else if (([self checkEmailBlank]) && ([self checkPasswordBlank]))
    {
        MGMainDAO *mainDAO = [MGMainDAO new];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *fcmtoken = [[MGUserDefaults sharedDefault] getDeviceToken];
        if (fcmtoken.length == 0)
        {
            fcmtoken = DemoDeviceToken;
        }
        NSLog(@" FCM :-%@",fcmtoken);
        if ([delegate.deviceToken length] == 0)
        {
            delegate.deviceToken = DemoDeviceToken;
        }
        
        
        NSDictionary *param = @{@"email":self.textEmail.text,
                                @"password":self.textPassword.text,
                                @"version":@"2",
                                @"device_os":@"1",
                                @"device_token":fcmtoken};
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,LoginPostFix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"data"])
                              {
                                  NSDictionary *dictionaryDataContainer = responseData[@"data"];
                                  NSDictionary *dicData = [[dictionaryDataContainer objectForKey:@"Full Name"] firstObject];
                                  if (dicData[USER_ID] &&
                                      dicData[@"token"] &&
                                      dicData[@"photo_url"])
                                  {
                                      [[MGUserDefaults sharedDefault] setUserId:[[dicData objectForKey:USER_ID] integerValue]];
                                      
                                      [[MGUserDefaults sharedDefault] setDisplayName:[dicData objectForKey:DISPLAY_NAME]];
                                      [[MGUserDefaults sharedDefault] setAccessToken:[dicData objectForKey:@"token"]];
                                      [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
                                      [[MGUserDefaults sharedDefault] setUserId:[[dicData objectForKey:@"user_id"] integerValue]];
                                      [[MGUserDefaults sharedDefault] synchronize];
                                      
                                      NSString *imagePath = [dicData[@"photo_url"]stringByReplacingOccurrencesOfString:@"images" withString:@"uploads"];
                                      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
                                      
                                      NSString *handicap = [NSString stringWithFormat:@"%@",dicData[@"self_handicap"]];
                                      
                                      [[MGUserDefaults sharedDefault] setHandicap:handicap];
                                          
                                      [[MGUserDefaults sharedDefault] setUserImage:data];
                                      
                                      [[MGUserDefaults sharedDefault] setPassword:self.textPassword.text];
                                      
                                      
                                      [delegate addTabBarAsRootViewController];
                                  }

                                  else
                                  {
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                                    message:[dicData objectForKey:@"message"]
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
                                  
                              }
                              else
                              {
                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"msg"];
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
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
                              
                          }
                      }
                      
                      else
                      {
                          
                      

                      }
                  }
                  else
                  {
                      NSDictionary *dicData = responseData;
                      NSDictionary *dictError = [dicData objectForKey:@"Error"];
                      NSString *messageError = [dictError objectForKey:@"msg"];
                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                    message:messageError
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
         
                  
              }];
        
        
        
    }

}


- (IBAction)actionSignUp
{
    PT_SignUpViewController *signUp = [[PT_SignUpViewController alloc] initWithNibName:@"PT_SignUpViewController" bundle:nil];
    [self presentViewController:signUp animated:YES completion:nil];
}

- (IBAction)actionForgotPasword
{
    PT_ForgotPasswordViewController *forgotVC = [PT_ForgotPasswordViewController new];
    
    [self presentViewController:forgotVC animated:YES completion:nil];
}
- (BOOL)checkEmailBlank
{
    if (self.textEmail.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave email blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkPasswordBlank
{
    if (self.textPassword.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave password blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}


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

- (IBAction)actionFBSignup:(id)sender
{
    [self.view endEditing:YES];

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_about_me"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        if (error) {
            // Process error
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else if (result.isCancelled) {
            // Handle cancellations
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            /*if ([FBSDKAccessToken currentAccessToken]) {
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:@{@"fields":@"email",@"fields":@"public_profile",@"fields":@"user_about_me"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
             NSLog(@"fetched user:%@", result);
             }
             }];
             }
             }*/
            
            //FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me?fields=first_name, last_name, picture, email" parameters:nil];
            FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, picture, name, first_name, last_name, email"} tokenString:[FBSDKAccessToken currentAccessToken].tokenString version:@"v2.3" HTTPMethod:nil];
            FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
            
            
            [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                if(result)
                {
                    NSString *name = nil;
                    PT_PlayerItemModel *modelPlayer = [PT_PlayerItemModel new];
                    
                    
                    modelPlayer.handicap = 0;
                    modelPlayer.mobile = nil;
                    //modelPlayer.country = dicInfo[@"country"];
                    //modelPlayer.countryCode = dicInfo[@"country_code"];
                    
                    if ([result objectForKey:@"id"]) {
                        
                        modelPlayer.playerId = [[result objectForKey:@"id"] integerValue];
                    }
                    
                    if ([result objectForKey:@"email"]) {
                        modelPlayer.email = [result objectForKey:@"email"];
                        
                        if (modelPlayer.email.length>0) {
                            
                            modelPlayer.email = [result objectForKey:@"email"];
                            
                            
                        }else{
                            
                            modelPlayer.email = @"";
                        }
                        
                    }
                    if ([result objectForKey:@"first_name"]) {
                        
                        NSLog(@"First Name : %@",[result objectForKey:@"first_name"]);
                        name = [result objectForKey:@"first_name"];
                        name = [NSString stringWithFormat:@"%@ %@",name,[result objectForKey:@"last_name"]];
                        modelPlayer.playerName = name;
                    }
                    if ([result objectForKey:@"id"])
                    {
                        
                        modelPlayer.playerId = [result[@"id"] integerValue];
                        
                    }
                    if ([result objectForKey:@"picture"])
                    {
                        NSDictionary *dicResuslt = (NSDictionary *)result;
                        NSDictionary *dicPicture = [dicResuslt objectForKey:@"picture"];
                        NSDictionary *dicData = [dicPicture objectForKey:@"data"];
                        modelPlayer.playerImageURL = [dicData objectForKey:@"url"];
                    }
                    
                    [_arrFB addObject:modelPlayer];
                    NSLog(@"%@",_arrFB);
                    
                    
                    [self registerThroughFB:modelPlayer];
//                    ProfileViewController *profileVC = [ProfileViewController new];
//                    profileVC.isFBLoginEnabled = YES;
//                    [profileVC updateFBData:modelPlayer];
//                    [self presentViewController:profileVC animated:YES completion:nil];
                    
                }
                
                
            }];
            [connection start];
        }
    }];
}

- (void)registerThroughFB:(PT_PlayerItemModel *)modelPlayer
{
    
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSLog(@"%ld%@%@%@%@",(long)modelPlayer.playerId,modelPlayer.playerName,modelPlayer.email,modelPlayer.playerImageURL,modelPlayer.mobile);
    
    modelPlayer.mobile = @"";
    
    NSString *fcmtoken = [[MGUserDefaults sharedDefault] getDeviceToken];
    NSLog(@" FCM :-%@",fcmtoken);
    
    if ([delegate.deviceToken length] == 0)
    {
        delegate.deviceToken = DemoDeviceToken;
    }
    
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"facebook_id":[NSString stringWithFormat:@"%li",(long)modelPlayer.playerId],
                            @"full_name":modelPlayer.playerName,
                            @"email_id":modelPlayer.email,
                            @"mobile_number":modelPlayer.mobile,
                            @"device_token":fcmtoken,
                            @"device_os":@"2",
                            @"photo_url":modelPlayer.playerImageURL,
                            @"version":@"2"};
    [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,@"sociallogin"] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            if (responseData != nil)
            {
                if ([responseData isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dicResponse = responseData;
                    NSDictionary *dicOutput = dicResponse[@"data"];
                    
                    if ([dicOutput[@"status"] isEqualToString:@"1"])
                    {
                        NSDictionary *dicFullName = [dicOutput[@"Full Name"] firstObject];
                        
                        NSData *dataToSaveLocal = [NSData dataWithContentsOfURL:[NSURL URLWithString:dicFullName[@"photo_url"]]];
                        [[MGUserDefaults sharedDefault] setUserImage:dataToSaveLocal];
                        //[self actionBack:nil];
                        NSString *userId = [NSString stringWithFormat:@"%@",[dicFullName objectForKey:USER_ID]];
                        [[MGUserDefaults sharedDefault] setUserId:[userId integerValue]];
                        
                       
                        
                        [[MGUserDefaults sharedDefault] setDisplayName:[dicFullName objectForKey:@"display_name"]];
                        
                        [[MGUserDefaults sharedDefault] setUserId:[[dicFullName objectForKey:@"user_id"] integerValue]];
                        
                        

                        [[MGUserDefaults sharedDefault] setAccessToken:[NSString stringWithFormat:@"%@",[dicFullName objectForKey:@"token"]]];
                        [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
                        
                        if ([dicFullName [@"new_user"] integerValue] == 1) {
                            
                            ProfileViewController *profileVC = [ProfileViewController new];
                                profileVC.isFBLoginEnabled = YES;
                                [profileVC updateFBData:modelPlayer];
                                [self presentViewController:profileVC animated:YES completion:nil];
                            
                        }else{
                        
                        
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [delegate addTabBarAsRootViewController];
                        }
                    }
                    else
                    {
                        [self showAlertWithMessage:dicOutput[@"message"]];
                    }
                    
                }
            }
        }
    }];
}




@end
