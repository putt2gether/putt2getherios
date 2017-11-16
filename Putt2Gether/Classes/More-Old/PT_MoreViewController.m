//
//  PT_MoreViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_MoreViewController.h"

@interface PT_MoreViewController ()

@end

@implementation PT_MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customdesign];
    [self.tabBarController.tabBar setHidden:YES];
    [self.view addSubview:btnView ];
    // Do any additional setup after loading the view from its nib.
}
-(void)customdesign{
    
    _profileBtn.layer.cornerRadius = 1;
    _profileBtn.clipsToBounds = YES;
    [_profileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_profileBtn setTitle:@"PROFILE NAME" forState:UIControlStateNormal];
    
    _editBtn.layer.cornerRadius = 7;
    _editBtn.clipsToBounds = YES;
    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editBtn setTitle:@"edit profile" forState:UIControlStateNormal];
    
    [btnView setBackgroundColor:[UIColor clearColor]];
    
    
    //tapEnabled on uiimage
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self performSelector:@selector(setstyleCircleForImage:) withObject:myImageview afterDelay:0];
}
-(void) setstyleCircleForImage:(UIImageView *)Imageview{
    myImageview.layer.cornerRadius = myImageview.frame.size.width/2;
    myImageview.clipsToBounds = YES;
    myImageview.layer.borderColor = [UIColor colorWithRed:83/255.0 green:137/255.0 blue:215/255.0 alpha:1].CGColor;
    myImageview.layer.borderWidth = 2.0;
    
}

-(void)tapDetected:(id)sender{
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    [self presentViewController:profileViewController animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == myImageview)
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired=1;
        [myImageview setUserInteractionEnabled:YES];
        [myImageview addGestureRecognizer:singleTap];
        //add your code for image touch here
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

- (IBAction)profieBtnClicked:(id)sender {
    [_profileBtn setBackgroundColor:[UIColor greenColor]];
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    [self presentViewController:profileViewController animated:YES completion:nil];
    
}
- (IBAction)editBtnClicked:(id)sender {
}
- (IBAction)grupBtnClicked:(id)sender {
}
- (IBAction)scoreBtnClicked:(id)sender {
}
- (IBAction)faqsBtnClicked:(id)sender {
}
- (IBAction)feedbckBtnClicked:(id)sender {
}
- (IBAction)logoutBtnClicked:(id)sender {
}

- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate.tabBarController setSelectedIndex:0];
}
@end
