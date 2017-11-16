//
//  PT_SpotPrizeModel.h
//  Putt2Gether
//
//  Created by Devashis on 25/10/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_SpotPrizeModel : NSObject

@property (strong, nonatomic) NSString *closestToPin1;
@property (strong, nonatomic) NSString *closestToPin2;
@property (strong, nonatomic) NSString *closestToPin3;
@property (strong, nonatomic) NSString *closestToPin4;

@property (strong, nonatomic) NSString *longDrive1;
@property (strong, nonatomic) NSString *longDrive2;
@property (strong, nonatomic) NSString *longDrive3;
@property (strong, nonatomic) NSString *longDrive4;

@property (strong, nonatomic) NSString *straightDrive1;
@property (strong, nonatomic) NSString *straightDrive2;
@property (strong, nonatomic) NSString *straightDrive3;
@property (strong, nonatomic) NSString *straightDrive4;

@end
