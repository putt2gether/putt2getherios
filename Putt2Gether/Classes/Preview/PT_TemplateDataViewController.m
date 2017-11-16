//
//  PT_TemplateDataViewController.m
//  Putt2Gether
//
//  Created by Nivesh on 25/06/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_TemplateDataViewController.h"

#import "PT_MyScoresViewController.h"


@interface PT_TemplateDataViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;


@end

@implementation PT_TemplateDataViewController

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    self.createdEventModel = model;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.backgroundColor = [UIColor clearColor];
    [self privacyPolicy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionBack{
    
    PT_MyScoresViewController *scoreVC = [[PT_MyScoresViewController alloc] initWithNibName:@"PT_MyScoresViewController" bundle:nil];
    
    [self presentViewController:scoreVC animated:YES completion:nil];
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
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{
                                @"version":@"2",
                                @"event_id":[NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId],
                                @"player_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]]
                                };
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,@"sendscorecardmail"]
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
                                  
                                  
                               NSString*   _privacyData = dicOutput[@"message"];
                                  
                                  
                                  
                                  [_webView loadHTMLString:_privacyData baseURL:nil];
                                  
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

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = theWebView.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
    
    _webView.scrollView.maximumZoomScale = 20; // set as you want.
    _webView.scrollView.minimumZoomScale = 1;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



@end
