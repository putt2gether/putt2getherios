//
//  PT_EnterPasswordViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/01/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_EnterPasswordViewController.h"

#import "PT_LoginViewController.h"

@interface PT_EnterPasswordViewController ()<UITextFieldDelegate>
{
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmPassword;
    UITextField *currentTextField;
}


@end

@implementation PT_EnterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    }






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == password)
    {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= 60;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }else{
        
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
    if (textField == password)
    {
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y += 60;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
        if([password.text length] <6)
            
            [self showAlertWithMessage:@"New and Confirm password must be greater than 6 characters"];
            //[password becomeFirstResponder];
                // this takes the focus back to the password field after alert dismiss.
                
    }else{
        
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y += 80;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [password resignFirstResponder];
    [confirmPassword resignFirstResponder];
    [self.view endEditing:YES];
}



- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionChangePassword:(id)sender
{
    [self updatePassword];
}

- (void)updatePassword
{
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else if ([self checkPassword] && [self checkConfirmPassword])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        if ([delegate.deviceToken length] == 0)
        {
            delegate.deviceToken = DemoDeviceToken;
        }
        NSDictionary *param = @{@"user_id":self.userId,
                                @"otp":self.otp,
                                @"new_password":password.text,
                                @"confirm_password":confirmPassword.text,
                                @"version":@"2"};
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@updatepassword",BASE_URL]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      NSDictionary *dicResponseData = responseData;
                      
                      NSDictionary *dicOutput = dicResponseData[@"output"];
                      
                      if ([dicOutput[@"status"] isEqualToString:@"1"])
                      {
                          //write logic for password reset
                          PT_LoginViewController *loginVC = [PT_LoginViewController new];
                          [self presentViewController:loginVC animated:YES completion:nil];
                      }
                      else
                      {
                          [self showAlertWithMessage:@"New Password and Confirm Password should be same"];
                      }
                  }
                  else
                  {
                      [self showAlertWithMessage:@"Problem in receiving data. Please try again."];
                  }
                  
                  
              }];
        
        
        
    }

}


- (BOOL)checkPassword
{
    if (password.text.length == 0)
    {
        [self showAlertWithMessage:@"Please provide New and Confirm password"];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkConfirmPassword
{
    if (confirmPassword.text.length == 0)
    {
        [self showAlertWithMessage:@"Please Confirm your password."];
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
