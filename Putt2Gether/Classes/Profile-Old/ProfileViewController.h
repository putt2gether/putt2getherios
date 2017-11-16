//
//  ProfileViewController.h
//  Putt2Gether
//
//  Created by Bunny on 8/11/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController@property(strong,nonatomic) IBOutlet UIImageView *profileImg;
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) IBOutlet UITextField *profilename;
@property (strong, nonatomic) IBOutlet UILabel *nameConstant;

@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UITextField *countryname;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;

@property (strong, nonatomic) IBOutlet UITextField *mobilenumber;
@property (strong, nonatomic) IBOutlet UILabel *psswrd;
@property (strong, nonatomic) IBOutlet UITextField *psswrdvalue;
@property (strong, nonatomic) IBOutlet UILabel *handicapLabel;
@property (strong, nonatomic) IBOutlet UITextField *handicapField;
@property (nonatomic, strong) LoadingView *loadingView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveBtnClicked:(id)sender;

//Country List
@property (strong, nonatomic) NSMutableArray *arrCountryList;
@property (weak, nonatomic) IBOutlet UITableView *tableCountries;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;


@end
