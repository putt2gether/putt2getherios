//
//  NSDictionary+Contains.m
//  Putt2Gether
//
//  Created by Devashis on 15/04/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "NSDictionary+Contains.h"

@implementation NSDictionary (Contains)

- (BOOL)containsKey: (NSString *)key {
    BOOL retVal = 0;
    NSArray *allKeys = [self allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}

@end
