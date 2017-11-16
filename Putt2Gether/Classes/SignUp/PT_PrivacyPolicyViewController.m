//
//  PT_PrivacyPolicyViewController.m
//  Putt2Gether
//
//  Created by Nivesh on 03/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_PrivacyPolicyViewController.h"

#import "MGMainDAO.h"

@interface PT_PrivacyPolicyViewController ()

@property(strong,nonatomic) NSString *privacyData;

@property(weak,nonatomic) IBOutlet UIWebView *privacyWebView;

@end

@implementation PT_PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self privacyPolicy];
    
    
    _privacyWebView.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Mark:-service calls for privacy
-(void)privacyPolicy
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    }else{
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{
                                @"version":@"2"
                                };
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,@"privacypolicy"]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if ([responseData isKindOfClass:[NSDictionary class]])
                              {
                                  NSDictionary *dicOutput = responseData[@"output"];
                                  //Check Success
                                  
                                      
                                  _privacyData = dicOutput[@"data"];
                                  
                                      
                                  NSLog(@"%@",_privacyData);
                                  
                                  [_privacyWebView loadHTMLString:_privacyData baseURL:nil];
                                  
                              }
                                  
                              
                                  
                                  
                              
                              else
                              {
                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
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
                  }
                  
                  
              }];
        
        
        
    }
    
}


-(IBAction)actionBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
