//
//  UIColor+Compare.h
//  Putt2Gether
//
//  Created by Devashis on 17/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Compare)

- (BOOL)isEqualToColor:(UIColor *)otherColor;

- (BOOL)color:(UIColor *)color1
isEqualToColor:(UIColor *)color2
withTolerance:(CGFloat)tolerance;

@end
