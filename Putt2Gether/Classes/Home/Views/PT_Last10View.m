//
//  PT_Last10View.m
//  Putt2Gether
//
//  Created by Bunny on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_Last10View.h"

@implementation PT_Last10View

//-(instancetype) initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super initWithCoder:aDecoder])
//    {
//         [self customdesign];
//        
//    } return self;
//    
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//   
//    if  (self = [super initWithFrame:frame]) {
//        
//        [self customdesign];
//        
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//-(void)customdesign{
//    
//    UIView *subViews = [[[NSBundle mainBundle] loadNibNamed:@"PT_Last10View" owner:self options:nil]firstObject];
//    [self addSubview:subViews];
//    
//    
////    self.lastBtn.layer.cornerRadius = 12.0f;
////    self.lastBtn.clipsToBounds = YES;
//   
//[_lastBtn setTitle:@"LAST BUTTON" forState:UIControlStateNormal];
//    
//}


-(IBAction)actioncloseBtn:(id)sender{
    
    
    
    [self hideview];
    
}
-(void)hideview
{
    [self setHidden:YES];
    [_backgroundView removeFromSuperview];
}

-(IBAction)actionOverall
{
    [self.homeVC initializeCallsForNumberOfEvents:0];
    [self hideview];

}

-(IBAction)actionlast20
{
    [self.homeVC initializeCallsForNumberOfEvents:20];
    [self hideview];
}

-(IBAction)actionlast10
{
    [self.homeVC initializeCallsForNumberOfEvents:10];
   [self hideview];
}
-(IBAction)actionlast5
{
    [self.homeVC initializeCallsForNumberOfEvents:5];
    [self hideview];
}

-(IBAction)actionlast1
{
    [self.homeVC initializeCallsForNumberOfEvents:1];
    [self hideview];
}

@end
