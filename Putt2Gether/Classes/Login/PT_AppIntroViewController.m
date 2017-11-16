//
//  PT_AppIntroViewController.m
//  Putt2Gether
//
//  Created by Nivesh on 09/08/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_AppIntroViewController.h"

#import "EAIntroPage.h"

#import "EAIntroView.h"

#import "PT_LoginViewController.h"

@interface PT_AppIntroViewController ()<EAIntroDelegate>
{
    UIView *rootView;

}

@end

@implementation PT_AppIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    rootView = self.view;
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"launch-pageHome"]; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch-pageHome"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"launch-pageCreateEvent"]; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch-pageCreateEvent"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"launch-pageMyScores"]; //[[UIImageView alloc] initWithImage:];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"launch-pageLeaderBoard"];//[[UIImageView alloc] initWithImage:];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.bgImage = [UIImage imageNamed:@"launch-pageInvitePage"]; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch-pageInvitePage"]];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:frame andPages:@[page1,page2,page3,page4,page5]];
    
    intro.skipButton.alpha = 0.f;
    intro.skipButton.enabled = NO;
    page5.onPageDidAppear = ^{
        intro.skipButton.enabled = YES;
        [UIView animateWithDuration:0.3f animations:^{
            intro.skipButton.alpha = 1.f;
        }];
    };
    page5.onPageDidDisappear = ^{
        intro.skipButton.enabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            intro.skipButton.alpha = 0.f;
        }];
    };

    
    
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];



    
}

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    if(wasSkipped) {
        NSLog(@"Intro skipped");
        
        PT_LoginViewController *rVC = [[PT_LoginViewController alloc] initWithNibName:@"PT_LoginViewController" bundle:nil];
        [self presentViewController:rVC animated:YES completion:nil];
    } else {
        NSLog(@"Intro finished");
        
        PT_LoginViewController *rVC = [[PT_LoginViewController alloc] initWithNibName:@"PT_LoginViewController" bundle:nil];
        [self presentViewController:rVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
