//
//  PT_OTPViewController.m
//  Putt2Gether
//
//  Created by Devashis on 15/01/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_OTPViewController.h"

#import "PT_EnterPasswordViewController.h"

@interface PT_OTPViewController ()<UITextFieldDelegate>
{
}


@property (weak, nonatomic) IBOutlet UITextField *textOTP;

@end

@implementation PT_OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    UIColor *toolBarColor = [UIColor colorWithRed:(228/255.0f) green:(232/255.0f) blue:(239/255.0f) alpha:1.0];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [numberToolbar setBackgroundColor:toolBarColor/*[UIColor darkGrayColor]*/];
    numberToolbar.tintColor = toolBarColor;//[UIColor darkGrayColor];
    numberToolbar.barTintColor = toolBarColor;
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    [doneItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [doneItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
                                      [UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:1.0], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneItem] ;
    [numberToolbar sizeToFit];
    
    self.textOTP.inputAccessoryView = numberToolbar;
    
}

- (void)doneWithNumberPad
{
    [self.textOTP resignFirstResponder];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    }




- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _textOTP)
    {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= 130;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textOTP)
    {
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y += 130;
        
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
    [_textOTP resignFirstResponder];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)actionVerifyOTP:(id)sender
{
    [self verifyOTP];
}
- (void)verifyOTP
{
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else if ([self checkOTPBlank])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        if ([delegate.deviceToken length] == 0)
        {
            delegate.deviceToken = DemoDeviceToken;
        }
        NSDictionary *param = @{@"user_id":self.userId,
                                @"otp":self.textOTP.text,
                                @"version":@"2"};
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@verifyotp",BASE_URL]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      NSDictionary *dicResponseData = responseData;
                      
                      NSDictionary *dicOutput = dicResponseData[@"output"];
                      
                      if ([dicOutput[@"status"] isEqualToString:@"1"])
                      {
                          //write logic for password reset
                          PT_EnterPasswordViewController *enterPwdVC = [PT_EnterPasswordViewController new];
                          enterPwdVC.userId = self.userId;
                          enterPwdVC.otp = self.textOTP.text;
                          [self presentViewController:enterPwdVC animated:YES completion:nil];
                      }
                      else
                      {
                          //[self showAlertWithMessage:dicOutput[@"error"]];
                          [self showAlertWithMessage:@"Please enter OTP sent on your email."];
                      }
                  }
                  else
                  {
                      [self showAlertWithMessage:@"Problem in receiving data. Please try again."];
                  }
                  
                  
              }];
        
        
        
    }
}

- (IBAction)actionGetOTP
{
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        if ([delegate.deviceToken length] == 0)
        {
            delegate.deviceToken = DemoDeviceToken;
        }
        NSDictionary *param = @{@"email":self.email,
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
                          [self showAlertWithMessage:@"OTP sent on the registered email address."];
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


- (BOOL)checkOTPBlank
{
    if (self.textOTP.text.length == 0)
    {
        [self showAlertWithMessage:@"Please enter OTP sent on your email."];
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

@end
