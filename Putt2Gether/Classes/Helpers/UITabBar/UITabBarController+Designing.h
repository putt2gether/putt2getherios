//
//  UITabBarController+Designing.h
//  MyGrid
//
//  Created by Devashis on 15/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Designing)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)setDefaultTabDesign;
-(void)setDeisgnForOrientaion;


@end
