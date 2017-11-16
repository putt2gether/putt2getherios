//
//  NSMutableString+Color.h
//  Putt2Gether
//
//  Created by Devashis on 16/02/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Color)

-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color;

@end
