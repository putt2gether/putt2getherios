//
//  ProfileViewController.m
//  Putt2Gether
//
//  Created by Bunny on 8/11/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "ProfileViewController.h"
#import "PT_CountryModel.h"
#import "MGMainDAO.h"
#import "PT_MoreViewController.h"
#import "PT_HomeViewController.h"

#import "UIKit+AFNetworking.h"
#import <AVFoundation/AVFoundation.h>

#import "PT_HomeCourseModel.h"

static NSString *const CountryListPostFix = @"getcountrylist";

static NSString *const GetUserDetailsPostfix = @"getuserdetail";

static NSString *const UpdateUserDetailsPostfix = @"updateprofile";

static NSString *const GetGolfCousreListpostFix = @"getcountrygolfcourselist";



@interface ProfileViewController ()<UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate>
{
    PT_PlayerItemModel *modelPlayer;
    IBOutlet UIScrollView *scrollView;
    NSInteger currentCountryIndex;
    UITextField *currentTextField;
    
    
}

@end
@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customdesign];
    if (self.isFBLoginEnabled == NO)
    {
        [self fetchUserDetails];
    }
    [self fetchCountryList];
    
    self.popUpView.hidden = YES;
    
    self.tableHomeCourses.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 78);
    
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
    
    self.mobilenumber.inputAccessoryView = numberToolbar;
    self.handicapField.inputAccessoryView = numberToolbar;
    self.countryCodeLabel.inputAccessoryView = numberToolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    self.psswrdvalue.text = [[MGUserDefaults sharedDefault] getPassword];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    
    if (screenHeight == 568) {
        
        self.heightDisplay.constant = 48;
        self.heightCcountry.constant = 48;
        self.heightEmail.constant = 48;
        self.heightProfileView.constant = 132;
        
        self.heightMobile.constant = 48;
        
        self.heightPass.constant = 48;
        self.heightHandicap.constant = 48;
        self.heightHomeCourseV.constant = 48;
        
    }

    
    //[self.popUpView addGestureRecognizer:tapGestureRecognizer];
    
    //Mark:-for getting suggestion table in HomeCourse
    [_homeCourseText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    scrollView.scrollEnabled = YES;
   // [self.view endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
    //yKeyboard = keyboardRect.origin.y;
    
    
    CGRect textFrame = [self.view convertRect:currentTextField.frame fromView:[currentTextField superview]];
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
        /*if (screenHeight == 568 && currentTextField == self.psswrdvalue)
     {
     CGPoint scrollPoint = CGPointMake(0.0, textFrame.origin.y-kbSize.height);
     [scrollView setContentOffset:scrollPoint animated:YES];
     }
     */
    if (!CGRectContainsPoint(aRect, textFrame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, textFrame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)viewDidLayoutSubviews
{
    dispatch_async (dispatch_get_main_queue(), ^
                    {
                        [scrollView setContentSize:CGSizeMake(0, self.view.frame.size.height -78 )];
                    });
}

- (void)doneWithNumberPad
{
    [self.mobilenumber resignFirstResponder];
    [self.countryCodeLabel resignFirstResponder];
    [self.handicapField resignFirstResponder];
    
}

-(void)customdesign{
//    [_profilename.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
//    _profilename.layer.borderWidth = 1;
//    [_profilename setText:@""];
//    [_profilename setLeftPadding:10];
//    
//    UIColor *color = [UIColor darkGrayColor];
//    [_countryname.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
//    _countryname.layer.borderWidth = 1;
//    [_countryname setText:@""];
//    [_countryname setLeftPadding:10];
//    self.countryname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"COUNTRY" attributes:@{NSForegroundColorAttributeName: color}];
//    
//    [_countryCodeLabel.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
//    _countryCodeLabel.layer.borderWidth = 1;
//    [_countryCodeLabel setText:@""];
//    
//    [_mobilenumber.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
//    [_mobilenumber setLeftPadding:10];
//    _mobilenumber.layer.borderWidth = 1;
//    [_mobilenumber setText:@""];
//    
//    [_psswrdvalue.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
//    [_psswrdvalue setLeftPadding:10];
//    _psswrdvalue.layer.borderWidth = 1;
//    [_psswrdvalue setText:@""];
//    
//    [_handicapField.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
//    [_handicapField setLeftPadding:10];
//    _handicapField.layer.borderWidth = 1;
//    [_handicapField setText:@""];
//    
//    [_saveButton setBackgroundColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1]];
    
    _profileEditBtn.layer.cornerRadius = _profileEditBtn.frame.size.width/2;
    _profileEditBtn.clipsToBounds = YES;
    _profileEditBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _profileEditBtn.layer.borderWidth = 0.30;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self performSelector:@selector(setstyleCircleForImage:) withObject:_profileImg afterDelay:0];
}
-(void) setstyleCircleForImage:(UIImageView *)Imageview{
    _profileImg.layer.cornerRadius = _profileImg.frame.size.width/2;
    _profileImg.clipsToBounds = YES;
    _profileImg.layer.borderColor = [UIColor grayColor].CGColor;
    _profileImg.layer.borderWidth = 1.0;
}


//country List
- (void)getCurrentCountryName
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:delegate.latestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error == nil && [placemarks count] > 0)
                       {
                           CLPlacemark *placemark = [placemarks lastObject];
                           
                           NSLog(@"Name:%@",placemark.country);
                           NSLog(@"ISO Country:%@",placemark.ISOcountryCode);
                           self.countryname.text = [placemark.country uppercaseString];
                           [self.arrCountryList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               
                               PT_CountryModel *model = obj;
                               currentCountryIndex = idx;
                               if ([placemark.country isEqualToString:model.countryName])
                               {
                                   self.countryCodeLabel.text = [NSString stringWithFormat:@"%li",(long)model.countryPhoneCode];
                                   
                                   _golfCourseID = model.countryId;
                                   modelPlayer.countryCode = self.countryCodeLabel.text;
                                   modelPlayer.country = model.countryName;
                                   [self nearByGolfCourse];

                               }
                           }];
                           
                           
                       }
                       
                   }];
}

#pragma mark - TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (textField == self.countryname)
    {
        
        if ([self.arrCountryList count] > 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                scrollView.scrollEnabled = NO;
                [currentTextField resignFirstResponder];
                
            });
            self.popUpView.hidden = NO;
            self.tableCountries.hidden = NO;
            [self.tableCountries reloadData];
        }
//        if ([self.arrCountryList count] > 0)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [currentTextField resignFirstResponder];
//            });
//            self.popUpView.hidden = NO;
//            scrollView.scrollEnabled = NO;
//            [self.tableCountries reloadData];
//        }
    }
    else
    {
        self.popUpView.hidden = YES;
    }
    currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTextField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mobilenumber)
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
    }
    else
    {
        return YES;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.popUpView.hidden = YES;
}

-(void)textFieldDidChange:(UITextField *)txtFld
{
    
    
    if (txtFld.text && txtFld.text.length == 0)
    {
        self.sortedArray = nil;
        self.tableHomeCourses.hidden = YES;
        
    }   else if(self.homeCourseText.text.length > 2){
        
        
        
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
    }else{
        
        self.tableHomeCourses.hidden = YES;
        
    }
    
    if ([_sortedArray count] == 0) {
        
        _tableHomeCourses.hidden = YES;
    }else{
        
        _tableHomeCourses.hidden =FALSE;
        [_tableHomeCourses reloadData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableHomeCourses reloadData];
        CGFloat tableHeight = 0.0f;
        for (int i = 0; i < [_sortedArray count]; i ++) {
            tableHeight += [self tableView:self.tableHomeCourses heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        self.tableHomeCourses.frame = CGRectMake(self.tableHomeCourses.frame.origin.x, self.tableHomeCourses.frame.origin.y, self.tableHomeCourses.frame.size.width, tableHeight);
    });

    
    currentTextField = txtFld;
    
    
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

- (void)updateFBData:(PT_PlayerItemModel *)playerModel
{
    modelPlayer = [PT_PlayerItemModel new];
    modelPlayer.playerId = playerModel.playerId;
    modelPlayer.playerName = playerModel.playerName;
    modelPlayer.handicap = 0;
    modelPlayer.mobile = @"";
    
    PT_CountryModel *countryModel = self.arrCountryList[currentCountryIndex];
    modelPlayer.country = countryModel.countryName;
    modelPlayer.countryCode = [NSString stringWithFormat:@"%li",(long)countryModel.countryId];
    
    
    
    modelPlayer.playerImageURL = playerModel.playerImageURL;
    modelPlayer.email = playerModel.email;
    
    
    
}

- (void)updateUI
{
    //Update UI
    self.profilename.text = [modelPlayer.playerName uppercaseString];
    self.countryname.text = [modelPlayer.country uppercaseString];
    self.countryCodeLabel.text = modelPlayer.countryCode;
    self.mobilenumber.text = modelPlayer.mobile;
    self.handicapField.text = [NSString stringWithFormat:@"%li",(long)modelPlayer.handicap];
    [_profileImg setImageWithURL:[NSURL URLWithString:modelPlayer.playerImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
    self.emailText.text = modelPlayer.email;
}

#pragma mark - Service Calls

- (void)fetchUserDetails
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //_loadingView.hidden = NO;
        });
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]],
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
                        modelPlayer = [PT_PlayerItemModel new];
                        modelPlayer.playerId = [dicInfo[@"user_id"] integerValue];
                        modelPlayer.playerName = dicInfo[@"display_name"];
                        modelPlayer.handicap = [dicInfo[@"handicap_value"] integerValue];
                        modelPlayer.mobile = [NSString stringWithFormat:@"%@",dicInfo[@"contact_no"]];
                        modelPlayer.country = dicInfo[@"country"];
                        modelPlayer.countryCode = dicInfo[@"country_code"];
                        modelPlayer.playerImageURL = dicInfo[@"photo_url"];
                        modelPlayer.email = dicInfo[@"user_name"];
                        
                        //Update UI
                        self.profilename.text = [modelPlayer.playerName uppercaseString];
                        self.countryname.text = [modelPlayer.country uppercaseString];
                        self.countryCodeLabel.text = modelPlayer.countryCode;
                        self.mobilenumber.text = modelPlayer.mobile;
                        self.handicapField.text = [NSString stringWithFormat:@"%li",(long)modelPlayer.handicap];
                        self.emailText.text = modelPlayer.email;
                        [_profileImg setImageWithURL:[NSURL URLWithString:modelPlayer.playerImageURL] placeholderImage:[UIImage imageNamed:@"add_player"]];
                    }
                }
            }
        }];
    }
}

- (void)fetchCountryList
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //_loadingView.hidden = NO;
        });
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"version":@"2"};
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,CountryListPostFix] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
            
            if (!error)
            {
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
                                    
                                    if (self.isFBLoginEnabled == YES)
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self updateUI];
                                        });
                                    }
                                }
                            }];
                            
                        }
                        else{
                            //Stop activity indicator
                            
                        }
                    }
                }
            }
        }];
    }
    
}

#pragma mark - TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableCountries) {
        return 40;
    }else if (tableView == _tableHomeCourses){
        
        return 40;
        
    }else{
        
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _tableCountries) {
        
        return [self.arrCountryList count];
    }
    else if(tableView == _tableHomeCourses) {
        
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
        
        
    }else if([_homeCourseText isFirstResponder]){
        
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
    self.mobilenumber.text = nil;
    self.countryname.text = model.countryName;
    modelPlayer.countryCode = [NSString stringWithFormat:@"%li",(long)model.countryPhoneCode];
        _golfCourseID = model.countryId;
        self.countryname.text = modelPlayer.country;
        model.countryId = modelPlayer.countryID;
    self.popUpView.hidden = YES;
    scrollView.scrollEnabled = YES;
        
        [self nearByGolfCourse];
    }
    else if(tableView == self.tableHomeCourses){
        [self.view endEditing:YES];
        
        PT_HomeCourseModel *model = self.sortedArray[indexPath.row];
        _golfCourseID = model.homeCourseID;
        modelPlayer.homecourseID = _golfCourseID;
        self.homeCourseText.text = [model.homeCourseName uppercaseString];
        self.tableHomeCourses.hidden = YES;
        
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)actionBack:(id)sender
{
    if (_isFBLoginEnabled == YES) {
        
        [currentTextField resignFirstResponder];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate addTabBarAsRootViewController];

        
    }else{
    
    [currentTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
        [delegate addTabBarAsRootViewController];
    }
}



- (IBAction)saveBtnClicked:(id)sender {
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //_loadingView.hidden = NO;
        });
//        if (self.isFBLoginEnabled == YES)
//        {
//            //Call FB Register function and return
//           // [self registerThroughFB];
//            return;
//        }
        NSData * base64Data = [UIImageJPEGRepresentation(_profileImg.image, 0.5) base64EncodedDataWithOptions:0];
        
        NSData *dataToSaveLocal = UIImagePNGRepresentation(_profileImg.image);
        
        NSString* str = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        if ([self checkDisplayNameBlank] && [self checkEmailBlank] && [self checkCountryBlank] && [self checkHandicapBlank] && [self checkMobileBlank] && [self checkPasswordBlank]){
            
            NSString *userID = [NSString stringWithFormat:@"%ld",(long)[[MGUserDefaults sharedDefault] getUserId]];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":userID,
                                @"full_name":modelPlayer.playerName,
                                @"email":modelPlayer.email,
                                @"contact_number":self.mobilenumber.text,
                                @"country_code":modelPlayer.countryCode,
                                @"country":modelPlayer.country,
                                @"password":[NSString stringWithFormat:@"%@",self.psswrdvalue.text],
                                @"handicap_value":self.handicapField.text,
                                @"profile_image":str,
                                @"golf_course_id":[NSString stringWithFormat:@"%li",(long)modelPlayer.homecourseID],
                                @"version":@"2"};
            
            NSLog(@"%@",param);
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,UpdateUserDetailsPostfix] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
            
            if (!error)
            {
                if (responseData != nil)
                {
                    if ([responseData isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *dicResponse = responseData;
                        NSDictionary *dicOutput = dicResponse[@"output"];
                        if ([dicOutput[@"status"] isEqualToString:@"1"])
                        {
                            [[MGUserDefaults sharedDefault] setUserImage:dataToSaveLocal];
                            [self actionBack:nil];
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
    }
    
}
//Mark:-Validations

- (BOOL)checkPasswordBlank
{
    if (self.psswrdvalue.text.length == 0)
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
    if (self.emailText.text.length == 0)
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
    if (self.profilename.text.length == 0)
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
    if (self.countryname.text.length == 0)
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
    if (self.handicapField.text.length == 0)
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
    if (self.mobilenumber.text.length == 0)
    {
        [self showAlertWithMessage:@"Please do not leave Mobile Number blank."];
        return NO;
    }
    else
    {
        return YES;
    }
}




- (void)registerThroughFB
{
    MGMainDAO *mainDAO = [MGMainDAO new];
    NSDictionary *param = @{@"facebook_id":[NSString stringWithFormat:@"%li",modelPlayer.playerId],
                            @"full_name":modelPlayer.playerName,
                            @"email_id":modelPlayer.email,
                            @"mobile_number":modelPlayer.mobile,
                            @"device_token":@"1111",
                            @"device_os":@"2",
                            @"photo_url":modelPlayer.playerImageURL,
                            @"version":@"2"};
    [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,@"sociallogin"] withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
        
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
                        
                        [[MGUserDefaults sharedDefault] setDisplayName:[dicFullName objectForKey:@"user_name"]];
                        [[MGUserDefaults sharedDefault] setAccessToken:[NSString stringWithFormat:@"%@",[dicFullName objectForKey:@"token"]]];
                        [[MGUserDefaults sharedDefault] setSignUpOrLoginDone:YES];
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [delegate addTabBarAsRootViewController];
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


- (IBAction)profileEditBtnClicked:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PUTT2GETHER" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camAcation = [UIAlertAction actionWithTitle:@"CAMERA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self requestCameraPermissionsIfNeeded];
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }];
    
    UIAlertAction *galAcation = [UIAlertAction actionWithTitle:@"GALLERY" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction *cancelAcation = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:camAcation];
    
    [alert addAction:galAcation];
    
    [alert addAction:cancelAcation];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImg.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestCameraPermissionsIfNeeded {
    
    // check camera authorization status
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusAuthorized: { // camera authorized
            // do camera intensive stuff
        }
            break;
        case AVAuthorizationStatusNotDetermined: { // request authorization
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(granted) {
                        // do camera intensive stuff
                    } else {
                        [self notifyUserOfCameraAccessDenial];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyUserOfCameraAccessDenial];
            });
        }
            break;
        default:
            break;
    }
}

- (void)notifyUserOfCameraAccessDenial {
    // display a useful message asking the user to grant permissions from within Settings > Privacy > Camera
}

//Mark:-Done Button action for HIde POpupView
-(IBAction)actionDone:(id)sender{
    
    _popUpView.hidden = YES;
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
                                              
                                              [self.tableHomeCourses reloadData];
                                          }
                                          
                                      }];
                                  }
                                  
                                  
                                  else
                                  {
                                      self.homeCourseText.text = nil;
                                      //_golfCourseID = 0;
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



@end
