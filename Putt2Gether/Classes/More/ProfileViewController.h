//
//  ProfileViewController.h
//  Putt2Gether
//
//  Created by Bunny on 8/11/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_PlayerItemModel.h"

@interface ProfileViewController : UIViewController
@property(strong,nonatomic) IBOutlet UIImageView *profileImg;
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

@property(strong,nonatomic) IBOutlet UITextField *homeCourseText,*emailText;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *profileEditBtn;
- (IBAction)profileEditBtnClicked:(id)sender;

//MArk:-for displsying of countries

@property(weak,nonatomic) IBOutlet UIView *popUpView,*countrytableView;

//MARK:-Array for getting Home Course
@property(strong,nonatomic) NSMutableArray *arrGolflist;

@property(strong,nonatomic) NSArray *sortedArray;

@property(assign,nonatomic) NSInteger golfCourseID;

//Country List
@property (strong, nonatomic) NSMutableArray *arrCountryList;
@property (weak, nonatomic) IBOutlet UITableView *tableCountries,*tableHomeCourses;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeLabel;

//FB Sign up
@property (assign) BOOL isFBLoginEnabled;
- (void)updateFBData:(PT_PlayerItemModel *)playerModel;


//layout Contraint setting properties
@property(weak,nonatomic) IBOutlet UIView *displayNameView,*countryView,*emailView,*mobileView,*passwordView,*handicapView,*homeCourseView;

@property(strong,nonatomic) IBOutlet NSLayoutConstraint *heightDisplay,*heightCcountry,*heightEmail,*heightMobile,*heightPass,*heightHandicap,*heightHomeCourseV,*heightProfileView;

@end
