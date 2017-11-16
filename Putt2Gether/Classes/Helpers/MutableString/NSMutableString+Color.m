//
//  NSMutableString+Color.m
//  Putt2Gether
//
//  Created by Devashis on 16/02/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "NSMutableString+Color.h"

@implementation NSMutableAttributedString (Color)

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color
{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

@end
