//
//  PT_ScoreView.h
//  Putt2Gether
//
//  Created by Bunny on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_StatsViewController.h"

@interface PT_ScoreView : UIView

@property(strong,nonatomic) IBOutlet UILabel *scoreLabel;

@property(strong,nonatomic) IBOutlet UIButton *changeBtn,*par3sBtn,*par4sBtn,*par5sBtn,*inBtn,*outBtn;

-(IBAction)actionChangeBtn:(id)sender;

-(IBAction)actionPar3sBtn:(id)sender;

-(IBAction)actionPar4sBtn:(id)sender;

-(IBAction)actionpar5sBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *grossScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *par3SLabel;
@property (weak, nonatomic) IBOutlet UILabel *par4SLabel;
@property (weak, nonatomic) IBOutlet UILabel *par5SLabel;
@property (weak, nonatomic) IBOutlet UILabel *inLabel;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;

@property (strong, nonatomic) UIColor *grossChangeColor;
@property (strong, nonatomic) UIColor *par3SChangeColor;
@property (strong, nonatomic) UIColor *par4SChangeColor;
@property (strong, nonatomic) UIColor *par5SChangeColor;
@property (strong, nonatomic) UIColor *inChangeColor;
@property (strong, nonatomic) UIColor *outChangeColor;


//Mark:-String for setting over button
@property (weak, nonatomic) NSString *grossScoreStr;
@property (weak, nonatomic) NSString *par3Sstr;
@property (weak, nonatomic) NSString *par4Sstr;
@property (weak, nonatomic) NSString *par5Sstr;
@property (weak, nonatomic) NSString *inStr;
@property (weak, nonatomic) NSString *outStr;

@property (assign, nonatomic) float DgrossScoreStr;
@property (assign, nonatomic) float Dpar3Sstr;
@property (assign, nonatomic) float Dpar4Sstr;
@property (assign, nonatomic) float Dpar5Sstr;
@property (assign, nonatomic) float DinStr;
@property (assign, nonatomic) float DoutStr;




@property(weak,nonatomic) IBOutlet UILabel *changeLabelTop;

@property (strong, nonatomic) PT_StatsViewController *parentVC;

- (void)setBasicElements;

@end
