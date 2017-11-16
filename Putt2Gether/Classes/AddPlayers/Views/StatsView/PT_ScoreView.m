//
//  PT_ScoreView.m
//  Putt2Gether
//
//  Created by Bunny on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ScoreView.h"

static NSInteger const DefaultGrossScoreTag = 1000;
static NSInteger const ChangedGrossScoreTag = 1001;

@interface PT_ScoreView ()
{
    UIColor *commonButtonColor;
}

@end

@implementation PT_ScoreView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setBasicElements
{
    commonButtonColor = [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0f];
   // _changeBtn.tag = DefaultGrossScoreTag;
    [self setCommonColors];
}

- (IBAction)actionInBtn:(id)sender
{
    //[_inBtn setBackgroundColor:_inChangeColor];
    [self setCommonColors];
}

- (IBAction)actionOutBtn:(id)sender
{
    //[_outBtn setBackgroundColor:_outChangeColor];
    [self setCommonColors];
}


-(IBAction)actionChangeBtn:(id)sender{
    
    
    //[_changeBtn setBackgroundColor:_grossChangeColor];
    [self setCommonColors];
    
}

-(IBAction)actionPar3sBtn:(id)sender{
    
    //[_par3sBtn setBackgroundColor:_par3SChangeColor];
    [self setCommonColors];
    
}

-(IBAction)actionPar4sBtn:(id)sender{
    
    
    //[_par4sBtn setBackgroundColor:_par4SChangeColor];
    [self setCommonColors];
    
}

-(IBAction)actionpar5sBtn:(id)sender{
    
    //[_par5sBtn setBackgroundColor:_par5SChangeColor];
    [self setCommonColors];
    
}

- (void)setCommonColors
{
    if (_changeBtn.tag == DefaultGrossScoreTag)
    {
        _changeLabelTop.text = @"CHANGE";
        [_changeBtn setTitle:_grossScoreStr forState:UIControlStateNormal];
        [_par3sBtn setTitle:_par3Sstr forState:UIControlStateNormal];
        [_par4sBtn setTitle:_par4Sstr forState:UIControlStateNormal];
        [_par5sBtn setTitle:_par5Sstr forState:UIControlStateNormal];
        [_inBtn setTitle:_inStr forState:UIControlStateNormal];
        [_outBtn setTitle:_outStr forState:UIControlStateNormal];
        [_inBtn setBackgroundColor:_inChangeColor];
        [_outBtn setBackgroundColor:_outChangeColor];
        [_changeBtn setBackgroundColor:_grossChangeColor];
        [_par3sBtn setBackgroundColor:_par3SChangeColor];
        [_par4sBtn setBackgroundColor:_par4SChangeColor];
        [_par5sBtn setBackgroundColor:_par5SChangeColor];
        _changeBtn.tag = ChangedGrossScoreTag;
    }
    else
    {
        _changeLabelTop.text = @"AVERAGE";

        NSString *grossstr = [NSString stringWithFormat:@"%0.1f",_DgrossScoreStr];

        [_changeBtn setTitle:grossstr forState:UIControlStateNormal];
        NSString *str = [NSString stringWithFormat:@"%0.1f",_Dpar3Sstr];
        
        [_par3sBtn setTitle:str forState:UIControlStateNormal];
        NSString *str2 = [NSString stringWithFormat:@"%0.1f",_Dpar4Sstr];

        
        [_par4sBtn setTitle:str2 forState:UIControlStateNormal];
        NSString *str5 = [NSString stringWithFormat:@"%0.1f",_Dpar5Sstr];

        
        [_par5sBtn setTitle:str5 forState:UIControlStateNormal];
        NSString *str3 = [NSString stringWithFormat:@"%0.1f",_DinStr];

        [_inBtn setTitle:str3 forState:UIControlStateNormal];
        NSString *str4 = [NSString stringWithFormat:@"%0.1f",_DoutStr];

        [_outBtn setTitle:str4 forState:UIControlStateNormal];
        [_inBtn setBackgroundColor:commonButtonColor];
        [_outBtn setBackgroundColor:commonButtonColor];
        [_changeBtn setBackgroundColor:commonButtonColor];
        [_par3sBtn setBackgroundColor:commonButtonColor];
        [_par4sBtn setBackgroundColor:commonButtonColor];
        [_par5sBtn setBackgroundColor:commonButtonColor];
        _changeBtn.tag = DefaultGrossScoreTag;
    }
}

@end
