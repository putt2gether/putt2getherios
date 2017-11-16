//
//  PT_SignUpViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_SignUpViewController.h"

#import "MGMainDAO.h"

#import "PT_CountryModel.h"


#import "ProfileViewController.h"

#import "PT_PlayerItemModel.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "PT_HomeCourseModel.h"

#import "PT_PrivacyPolicyViewController.h"





static NSString *const CountryListPostFix = @"getcountrylist";

static NSString *const RegisterPostFix = @"register";

static NSString *const GetGolfCousreListpostFix = @"getcountrygolfcourselist";

@interface PT_SignUpViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate, FBSDKLoginButtonDelegate>
{
    float yKeyboard;
    BOOL isViewShifted;
    UITextField *currentTextField;
}
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSViewBG;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthSViewBG;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightSViewBG;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentViewHeight;


@property (weak, nonatomic) IBOutlet UIView *signUpContentsBGView;

@property (weak, nonatomic) IBOutlet UITextField *textDisplayName;

@property (weak, nonatomic) IBOutlet UITextField *textHandicap;

@property (weak, nonatomic) IBOutlet UITextField *textCountry;

@property (weak, nonatomic) IBOutlet UITextField *textMobile;

@property (weak, nonatomic) IBOutlet UITextField *textEmail;

@property (weak, nonatomic) IBOutlet UITextField *textPassword;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *backToLoginButton;

@property (weak, nonatomic) IBOutlet UIButton *facebookSignInButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;



//Mark:-for country list customView Properties
@property(weak,nonatomic) IBOutlet UIView *countryListView;

@property(weak,nonatomic) IBOutlet UIButton *DoneBtn;

//Mark:-HomeCourse Properties declaration
@property(assign,nonatomic) NSInteger golfCourseID;

@property(assign,nonatomic) NSInteger countryID;

@property (strong, nonatomic) NSArray *sortedArray;

@property(weak,nonatomic) IBOutlet UIImageView *homeCourseImg;

@property(weak,nonatomic) IBOutlet UITextField *textHomeCourse;

@property(strong,nonatomic) NSMutableArray *arrFB;


//Country List
@property (strong, nonatomic) NSMutableArray *arrCountryList,*arrGolflist;
@property (weak, nonatomic) IBOutlet UITableView *tableCountries,*tableHomeCourse;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;

//Mark:-properties for privacy policy
@property(weak,nonatomic) IBOutlet UILabel *privacyLabel;

@property(weak,nonatomic) IBOutlet NSLayoutConstraint *heightTableConstraint,*YposTableView;


@end

@implementation PT_SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//Mark:-for hiding tableview at starting
    self.countryListView.hidden = YES;
    
    _arrFB = [NSMutableArray new];
    
    self.tableHomeCourse.hidden = YES;
    
    //FB SDK
    [_loginButton setBackgroundImage:nil forState:UIControlStateNormal];
    _loginButton.delegate = self;
    //[_loginButton setBackgroundColor:[UIColor colorWithRed:(1/255.0f) green:(1/255.0f) blue:(1/255.0f) alpha:1.0f]];
    _loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_about_me"];
    
    self.tableCountries.delegate = self;
    //[self loadLoadingView];
    [self fetchCountryList];
    [self setDefaultConstraints];
    [self setTextFieldPadding];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
   // [self.tableHomeCourse addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginDidChange:) name:UITextFieldTextDidChangeNotification object:_textHomeCourse];

    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    
    if (screenHeight == 667) {
        
        _privacyLabel.font = [UIFont fontWithName:@"Lato-Regular" size:11.0f];
        
    }else if (screenHeight == 568){
        
        _privacyLabel.font = [UIFont fontWithName:@"Lato-Regular" size:8.4f];

        
    }
    
   
    


}




//Mark:-TableView height According to Sorted Data

- (void)dealloc {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch {
   /* if (touch.view == self.view) {
        
        return YES;
    } */
    if (touch.view == self.view){
        
        //self.tableCountries.hidden = NO;
        //self.countryListView.hidden = NO;
        self.textHomeCourse.hidden = YES;
        //_tableHomeCourse.hidden = YES;
    }
    if (self.countryListView.hidden == NO)
    {
       // self.tableCountries.hidden = YES;
        self.countryListView.hidden = NO;
    }
//    if (self.tableHomeCourse.hidden == NO)
//    {
//        self.tableHomeCourse.hidden = YES;
//    }
    return NO;
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    self.scrollView.scrollEnabled = YES;
    self.tableCountries.hidden = YES;
    self.countryListView.hidden = YES;
    self.tableHomeCourse.hidden = YES;

    
}
//Mark:-Action Method for Done Button
-(IBAction)actionDone{
    
    self.countryListView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
    yKeyboard = keyboardRect.origin.y;
    

    CGRect textFrame = [self.view convertRect:currentTextField.frame fromView:[currentTextField superview]];
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height +10;
    if (!CGRectContainsPoint(aRect, textFrame.origin) ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGPoint scrollPoint = CGPointMake(0.0, textFrame.origin.y-kbSize.height-5);
            [_scrollView setContentOffset:scrollPoint animated:YES];
        });
        
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}





- (void)getCurrentCountryName
{
    

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:delegate.latestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                       if (error == nil && [placemarks count] > 0)
                       {
                           CLPlacemark *placemark = [placemarks lastObject];
                           
                           NSLog(@"Name:%@",placemark.country);
                           NSLog(@"ISO Country:%@",placemark.ISOcountryCode);
                           self.textCountry.text = [placemark.country uppercaseString];
                           [self.arrCountryList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               
                               PT_CountryModel *model = obj;
                               if ([placemark.country isEqualToString:model.countryName])
                               {
                                   self.countryCodeLabel.text = [NSString stringWithFormat:@"%li",(long)model.countryPhoneCode];
                                   _golfCourseID = model.countryId;
                                   NSLog(@"%ld",(long)_countryID);
                                   
                                   [self nearByGolfCourse];
                               }
                           }];
                           
                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                       }
                       
                   }];
}

#pragma mark - TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _tableHomeCourse.hidden = TRUE;

    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.textCountry)
    {
        if ([self.arrCountryList count] > 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scrollView.scrollEnabled = NO;
                [currentTextField resignFirstResponder];
                
            });
            self.countryListView.hidden = NO;
            self.tableCountries.hidden = NO;
            [self.tableCountries reloadData];
        }
    }
    else
    {
        self.countryListView.hidden = YES;

        self.tableCountries.hidden = YES;
    }
    
    if (textField == self.textHomeCourse) {
        
        _tableHomeCourse.hidden = YES;
        
       // [self searchText:textField replacementString:@"Begin"];
        //[currentTextField resignFirstResponder];

    }
    currentTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == self.textHomeCourse) {
        
        _tableHomeCourse.hidden = YES;
    }
    currentTextField = nil;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    

    if (textField == self.textMobile)
    {
        
        if (range.length == 1) {
            return YES;
        }
        if (textField.text.length == 10)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }else if ( textField == _textHomeCourse){
        
       // [self searchText:textField replacementString:string];
        
        return YES;

    }
    else
    {
        return YES;
    }
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.tableCountries.hidden = YES;
    self.tableHomeCourse.hidden = YES;
    [_textHomeCourse resignFirstResponder];
}
//Mark:-Hide KeyBoard from anywhere

#pragma mark - Service Calls

- (void)fetchCountryList
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
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //_loadingView.hidden = NO;
        });
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"version":@"2",
                                @"show_all":@"1"};
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,CountryListPostFix] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
            
            if (!error)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                if (responseData != nil)
                {
                    if ([responseData isKindOfClass:[NSDictionary class]])
                    {
                        if (responseData[@"CountryList"])
                        {
                            NSArray *countryList = [responseData objectForKey:@"CountryList"];
                            if (self.arrCountryList == nil)
                            {
                                _arrCountryList = [NSMutableArray new];
                            }
                            
                            [countryList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSDictionary *country = obj;
                                
                                PT_CountryModel *model = [PT_CountryModel new];
                                model.countryName = [country objectForKey:@"country_name"];
                                model.countryId = [[country objectForKey:@"country_id"] integerValue];
                                model.countryPhoneCode = [[country objectForKey:@"phonecode"] integerValue];
                                [self.arrCountryList addObject:model];

                                if (idx == [countryList count] - 1)
                                {
                                    [self getCurrentCountryName];
                                }
                            }];
                            
                        }
                        else{
                            //Stop activity indicator
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
                    }
                }
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }
        }];
    }

}


#pragma mark - Action Methods


//- (void)  loginButton:(FBSDKLoginButton *)loginButton
//didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
//                error:(NSError *)error
//{
//    
//}

- (IBAction)actionFBSignup:(id)sender
{
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


- (IBAction)actionSignUp:(id)sender
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
    }
    else if ([self checkDisplayNameBlank] && [self checkEmailBlank] && [self checkCountryBlank] && [self checkHandicapBlank] && [self checkMobileBlank] && [self checkPasswordBlank])
    {
        if ([delegate.deviceToken length] == 0)
        {
            delegate.deviceToken = DemoDeviceToken;
        }
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"email":self.textEmail.text,
                                @"password":self.textPassword.text,
                                @"version":@"2",
                                @"fullname":self.textDisplayName.text,
                                @"handicap":self.textHandicap.text,
                                @"token":delegate.deviceToken,
                                @"country":self.textCountry.text,
                                @"country_code":self.countryCodeLabel.text,
                                @"phone":self.textMobile.text,
                                @"device_token":delegate.deviceToken,
                                @"device_os":@"1",
                                @"golf_course_id":[NSNumber numberWithInteger:_golfCourseID]
                                };
        NSLog(@"%@",param);
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,RegisterPostFix]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"User"])
                              {
                                  NSDictionary *data = responseData;
                                  NSDictionary *dicData = [data objectForKey:@"User"];
                                  if (dicData[USER_ID] &&
                                      dicData[@"token"] &&
                                      dicData[@"photo_url"] &&
                                      dicData[@"message"])
                                  {
                                      
                                      [[MGUserDefaults sharedDefault] setUserId:[[dicData objectForKey:USER_ID] integerValue]];
                                    
                                      [[MGUserDefaults sharedDefault] setDisplayName:[dicData objectForKey:DISPLAY_NAME]];
                                      [[MGUserDefaults sharedDefault] setAccessToken:[dicData objectForKey:@"token"]];
                                      [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
                                      [[MGUserDefaults sharedDefault] setUserId:[[dicData objectForKey:@"user_id"] integerValue]];
                                      
                                      NSString *handicap = [NSString stringWithFormat:@"%@",dicData[@"self_handicap"]];
                                      
                                      [[MGUserDefaults sharedDefault] setHandicap:handicap];
                                      
                                      NSString *imagePath = [dicData[@"photo_url"] stringByReplacingOccurrencesOfString:@"images" withString:@"uploads"];
                                      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
                                      
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
    
    //AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //[delegate addTabBarAsRootViewController];
}


- (IBAction)actionSignIn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTextFieldPadding
{
    self.textDisplayName.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    self.textHandicap.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    self.textCountry.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    self.textMobile.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    self.textEmail.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    self.textPassword.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
    self.textHomeCourse.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);

    
    UIColor *toolBarColor = [UIColor colorWithRed:(228/255.0f) green:(232/255.0f) blue:(239/255.0f) alpha:1.0];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [numberToolbar setBackgroundColor:toolBarColor/*[UIColor darkGrayColor]*/];
    numberToolbar.tintColor = toolBarColor;//[UIColor darkGrayColor];
    numberToolbar.barTintColor = toolBarColor;
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    [doneItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [doneItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
                                        [UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:1.0], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneItem] ;
    [numberToolbar sizeToFit];
    
    self.textHandicap.inputAccessoryView = numberToolbar;
    self.textMobile.inputAccessoryView = numberToolbar;
    
    UIColor *color = [UIColor darkGrayColor];
    
    self.textDisplayName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"DISPLAY NAME" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textHandicap.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"HANDICAP" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textCountry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"COUNTRY" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textMobile.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MOBILE NO" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textHomeCourse.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"HOMECOURSE" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.signUpContentsBGView.layer.cornerRadius = 2.0;
    
    self.signUpButton.layer.cornerRadius = 2.0;
    
    //Mark:-for getting suggestion table in HomeCourse
    [_textHomeCourse addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
}

- (void)doneWithNumberPad
{
    [self.textMobile resignFirstResponder];
    [self.textHandicap resignFirstResponder];
}
-(void)viewDidLayoutSubviews
{
    float height = 736;
    // self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    //self.constraintContentViewHeight.constant = height;
    
}

- (void)setDefaultConstraints
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    switch (screenHeight) {
        case 480 :
        {
            
            
        }
            break;
            
        case 568:
        {
            //self.constraintSViewBG.constant = 100;
            //self.constraintWidthSViewBG.constant = 128;
            //self.constraintContentViewHeight.constant = 500;
            self.constraintHeightSViewBG.constant = 300;
            
            //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        }
            break;
            
        case 667:
        {
            self.constraintSViewBG.constant = 122;
            self.constraintWidthSViewBG.constant = 162;
        }
            break;
            
        case 736:
        {
            //self.loginBoxHeight.constant = 220;
        }
            break;
            
    }
    
}


#pragma mark - TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableCountries) {
        return 40;
    }else if (tableView == _tableHomeCourse){
        
        return 25;
        
    }else{
        
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _tableCountries) {
        
        return [self.arrCountryList count];
    }
    else if(tableView == _tableHomeCourse) {
        
        return [self.sortedArray count];
    
    }else{
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"COuntryIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == _tableCountries) {
        PT_CountryModel *model = self.arrCountryList[indexPath.row];
        cell.textLabel.text = model.countryName;
        cell.textLabel.font = [UIFont fontWithName:@"Lato-Light" size:17];
        
        
    }else if([_textHomeCourse isFirstResponder]){
        
        cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
        
        PT_HomeCourseModel *model = self.sortedArray[indexPath.row];
        cell.textLabel.text = model.homeCourseName;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Lato-Light" size:12];

    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tableCountries) {
        
    
    PT_CountryModel *model = self.arrCountryList[indexPath.row];
    self.countryCodeLabel.text = [NSString stringWithFormat:@"%li",(long)model.countryPhoneCode];
    self.textMobile.text = nil;
    self.textCountry.text = [model.countryName uppercaseString];
    self.tableCountries.hidden = YES;
    self.countryListView.hidden = YES;
    self.scrollView.scrollEnabled = YES;
    
    _golfCourseID = model.countryId;
    NSLog(@"%ld",(long)_countryID);
    
    [self nearByGolfCourse];
        
        
    }else if(tableView == self.tableHomeCourse){
        [self.view endEditing:YES];

        PT_HomeCourseModel *model = self.sortedArray[indexPath.row];
        _golfCourseID = model.homeCourseID;
        self.textHomeCourse.text = [model.homeCourseName uppercaseString];
        self.tableHomeCourse.hidden = YES;
        
    }

}


-(void)textFieldDidChange:(UITextField *)txtFld
{
   
    
    if (txtFld.text && txtFld.text.length == 0)
    {
        self.sortedArray = nil;
        self.tableHomeCourse.hidden = YES;
    }
        
    else if(self.textHomeCourse.text.length > 2){
        
        
        
        NSString * match = txtFld.text;
        //sNSArray *listFiles = [[NSMutableArray alloc] init];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.homeCourseName BEGINSWITH[c] %@", match];
        
        //or use Name like %@ //”Name” is the Key we are searching
        _sortedArray = [_arrGolflist filteredArrayUsingPredicate:predicate];
        
        // Now if you want to sort search results Array
        //Sorting NSArray having NSDictionary as objects
        //_sortedArray = [[NSMutableArray alloc]initWithArray: [listFiles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        
        //Use sortedArray as your Table’s data source
       // NSLog(@"Array :%@",_arrGolflist);
    }
    if ([_sortedArray count] == 0) {
        
        _tableHomeCourse.hidden = YES;
    }else{
        
        _tableHomeCourse.hidden =FALSE;
        [_tableHomeCourse reloadData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableHomeCourse reloadData];
        CGFloat tableHeight = 0.0f;
        for (int i = 0; i < [_sortedArray count]; i ++) {
            tableHeight += [self tableView:self.tableHomeCourse heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        if ([_sortedArray count] > 1) {
            
            //self.heightTableConstraint.constant = 39;
            self.YposTableView.constant = 37 *2;
        }else
        {
            self.heightTableConstraint.constant = 2;
            self.YposTableView.constant = 37;
            
        }

        //self.tableHomeCourse.frame = CGRectMake(self.tableHomeCourse.frame.origin.x, self.tableHomeCourse.frame.origin.y, self.tableHomeCourse.frame.size.width, tableHeight);
    });
    currentTextField = txtFld;
    
    
}

//Srvice calls
- (void)registerThroughFB:(PT_PlayerItemModel *)modelPlayer
{
    
    __block AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"%ld%@%@%@%@",(long)modelPlayer.playerId,modelPlayer.playerName,modelPlayer.email,modelPlayer.playerImageURL,modelPlayer.mobile);
    
    modelPlayer.mobile = @"";
    
    if ([delegate.deviceToken length] == 0)
    {
        delegate.deviceToken = DemoDeviceToken;
    }
    
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"facebook_id":[NSString stringWithFormat:@"%li",(long)modelPlayer.playerId],
                            @"full_name":modelPlayer.playerName,
                            @"email_id":modelPlayer.email,
                            @"mobile_number":modelPlayer.mobile,
                            @"device_token":delegate.deviceToken,
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
                    NSData *dataToSaveLocal = [NSData dataWithContentsOfURL:[NSURL URLWithString:modelPlayer.playerImageURL]];
                    if ([dicOutput[@"status"] isEqualToString:@"1"])
                    {
                        NSDictionary *dicFullName = [dicOutput[@"Full Name"] firstObject];
                        [[MGUserDefaults sharedDefault] setUserImage:dataToSaveLocal];
                        //[self actionBack:nil];
                        NSString *userId = [NSString stringWithFormat:@"%@",[dicFullName objectForKey:USER_ID]];
                        [[MGUserDefaults sharedDefault] setUserId:[userId integerValue]];
                        
                        [[MGUserDefaults sharedDefault] setDisplayName:[dicFullName objectForKey:DISPLAY_NAME]];
                        // [[MGUserDefaults sharedDefault] setDisplayName:[dicFullName objectForKey:@"display_name"]];
                        //                        [[MGUserDefaults sharedDefault] setHandicap:[dicFullName objectForKey:@"self_handicap"]];
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






- (BOOL)checkPasswordBlank
{
    if (self.textPassword.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave Password blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkEmailBlank
{
    if (self.textEmail.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave Email blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkDisplayNameBlank
{
    if (self.textDisplayName.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave Display Name blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkCountryBlank
{
    if (self.textCountry.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave Country blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkHandicapBlank
{
    if (self.textHandicap.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave Handicap blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkMobileBlank
{
    if (self.textMobile.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave Mobile Number blank."];
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


//Mark:-service calls for HomeCourse
-(void)nearByGolfCourse
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
        NSDictionary *param = @{@"country_id":[NSNumber numberWithInteger:_golfCourseID],
                                @"version":@"2"
                                };
        
        NSLog(@"%@",param);
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,GetGolfCousreListpostFix]
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
                                  if ([dicOutput[@"status"] isEqualToString:@"1"])
                                  {
                                      

                                      
                                      NSArray *arrData = dicOutput[@"data"];
                                      
                                      _arrGolflist = [NSMutableArray new];

                                      [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          
                                        NSDictionary *dicData = obj;
                                          PT_HomeCourseModel *model = [PT_HomeCourseModel new];

                                          model.homeCourseID = [dicData[@"golf_course_id"] integerValue];
                                          model.homeCourseName = [dicData[@"golf_course_name"] uppercaseString];
                                          
                                          [_arrGolflist addObject:model];
                                          
                                          NSLog(@"%@",model.homeCourseName);
                                         // self.textHomeCourse.text = [[dicData objectForKey:@"golf_course_name"] uppercaseString];
                                          
                                          if (idx == [arrData count] -1) {
                                              
                                              [self.tableHomeCourse reloadData];
                                          }
                                      
                                      }];
                                  }

                                  
                                  else
                                  {
                                      self.textHomeCourse.text = nil;
                                      _golfCourseID = 0;
                                  }
                                          
                                  
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

//Mark:-for moving to web View
-(IBAction)actionPrivacy{
    
    PT_PrivacyPolicyViewController *ppVC = [[PT_PrivacyPolicyViewController alloc] initWithNibName:@"PT_PrivacyPolicyViewController" bundle:nil];
    
    [self presentViewController:ppVC animated:YES completion:nil];
    
    
}


@end
