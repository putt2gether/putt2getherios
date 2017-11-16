//
//  UITextField+Padding.m
//  Putt2Gether
//
//  Created by Devashis on 12/01/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)

-(void) setLeftPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}


@end
