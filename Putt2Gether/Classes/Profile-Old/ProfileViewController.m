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

static NSString *const CountryListPostFix = @"getcountrylist";


@interface ProfileViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end
@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customdesign];
    [self fetchCountryList];
    // Do any additional setup after loading the view from its nib.
}
-(void)customdesign{
    [_profilename.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
    _profilename.layer.borderWidth = 1;
    [_profilename setText:@""];
    
    UIColor *color = [UIColor darkGrayColor];
    [_countryname.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
    _countryname.layer.borderWidth = 1;
    [_countryname setText:@""];
     self.countryname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"COUNTRY" attributes:@{NSForegroundColorAttributeName: color}];

    [_countryCodeLabel.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
    _countryCodeLabel.layer.borderWidth = 1;
    [_countryCodeLabel setText:@""];
    
    [_mobilenumber.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
    _mobilenumber.layer.borderWidth = 1;
    [_mobilenumber setText:@""];
    
    [_psswrdvalue.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
    _psswrdvalue.layer.borderWidth = 1;
    [_psswrdvalue setText:@""];
    
    [_handicapField.layer setBorderColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1].CGColor];
    _handicapField.layer.borderWidth = 1;
    [_handicapField setText:@""];

    [_saveButton setBackgroundColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1]];
    
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
                           self.countryname.text = placemark.country;
                           [self.arrCountryList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               
                               PT_CountryModel *model = obj;
                               if ([placemark.country isEqualToString:model.countryName])
                               {
                                   self.countryCodeLabel.text = [NSString stringWithFormat:@"%li",(long)model.countryPhoneCode];
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
            [textField resignFirstResponder];
            self.tableCountries.hidden = NO;
            [self.tableCountries reloadData];
        }
    }
    
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
    self.tableCountries.hidden = YES;
}
#pragma mark - Service Calls

- (void)fetchCountryList
{
    __block AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrCountryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"COuntryIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    PT_CountryModel *model = self.arrCountryList[indexPath.row];
    cell.textLabel.text = model.countryName;
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Light" size:10];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_CountryModel *model = self.arrCountryList[indexPath.row];
    self.countryCodeLabel.text = [NSString stringWithFormat:@"%li",(long)model.countryPhoneCode];
    self.mobilenumber.text = nil;
    self.countryname.text = model.countryName;
    self.tableCountries.hidden = YES;
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

- (IBAction)saveBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate.tabBarController setSelectedIndex:0];

}

@end
