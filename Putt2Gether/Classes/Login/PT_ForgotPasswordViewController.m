//
//  PT_ForgotPasswordViewController.m
//  Putt2Gether
//
//  Created by Devashis on 15/01/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_ForgotPasswordViewController.h"

#import "PT_SignUpViewController.h"

#import "PT_OTPViewController.h"

@interface PT_ForgotPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UITextField *textEmail;

@end

@implementation PT_ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _textEmail)
    {
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textEmail resignFirstResponder];
    
}


//- (void)keyboardWasShown:(NSNotification *)notification {
//    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
//    
//    
//    CGRect textFrame = [self.view convertRect:_textEmail.frame fromView:[_textEmail superview]];
//    NSDictionary* info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, textFrame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, textFrame.origin.y-kbSize.height);
//        self.view.frame = CGRectMake(0, -scrollPoint.y, self.view.frame.size.width, self.view.frame.size.height);
//    }
//    
//}
//
//// Called when the UIKeyboardWillHideNotification is sent
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)actionGetOTP
{
    [self.view endEditing:YES];
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else if ([self checkEmailBlank])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        if ([delegate.deviceToken length] == 0)
        {
            delegate.deviceToken = DemoDeviceToken;
        }
        NSDictionary *param = @{@"email":self.textEmail.text,
                                @"version":@"2"};
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@forgetpassword",BASE_URL]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      NSDictionary *dicResponseData = responseData;
                      
                      NSDictionary *dicOutput = dicResponseData[@"output"];
                      
                      if ([dicOutput[@"status"] isEqualToString:@"1"])
                      {
                          NSString *userId = dicOutput[@"user_id"];
                          
                          PT_OTPViewController *otpVC = [PT_OTPViewController new];
                          
                          otpVC.userId = userId;
                          
                          otpVC.email = self.textEmail.text;
                          
                          [self presentViewController:otpVC animated:YES completion:nil];
                      }
                      else
                      {
                          [self showAlertWithMessage:dicOutput[@"Error"]];
                      }
                  }
                  else
                  {
                      [self showAlertWithMessage:@"Problem in receiving data. Please try again."];
                  }
                  
                  
              }];
        
        
        
    }
    
    
}
- (BOOL)checkEmailBlank
{
    if (self.textEmail.text.length == 0)
    {
        [self showAlertWithMessage:@"Please enter email address."];
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


- (IBAction)actionSignUp
{
    PT_SignUpViewController *signUp = [[PT_SignUpViewController alloc] initWithNibName:@"PT_SignUpViewController" bundle:nil];
    [self presentViewController:signUp animated:YES completion:nil];
}

@end
