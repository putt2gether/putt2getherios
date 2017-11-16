//
//  PT_PlayerIndividualCreationView.m
//  Putt2Gether
//
//  Created by Devashis on 26/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_PlayerIndividualCreationView.h"



@implementation PT_PlayerIndividualCreationView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.textEmail.layer.sublayerTransform = CATransform3DMakeTranslation(4, 0, 0);
    self.textDisplayName.layer.sublayerTransform = CATransform3DMakeTranslation(4, 0, 0);
    self.textHandicap.layer.sublayerTransform = CATransform3DMakeTranslation(4, 0, 0);

    [self numberPad];
    
}

-(void)numberPad
{
    UIColor *toolBarColor = [UIColor colorWithRed:(228/255.0f) green:(232/255.0f) blue:(239/255.0f) alpha:1.0];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
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
    
    self.textHandicap.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad{
    
    [self.textHandicap resignFirstResponder];
}





@end
