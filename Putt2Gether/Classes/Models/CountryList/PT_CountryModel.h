//
//  PT_CountryModel.h
//  Putt2Gether
//
//  Created by Devashis on 22/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_CountryModel : NSObject

@property (strong, nonatomic) NSString *countryName;
@property (assign, nonatomic) NSInteger countryId;
@property (assign, nonatomic) NSInteger countryPhoneCode;
@property (assign, nonatomic) NSInteger countryHasEvent;

@property(strong,nonatomic) NSString *cityName;

@end
