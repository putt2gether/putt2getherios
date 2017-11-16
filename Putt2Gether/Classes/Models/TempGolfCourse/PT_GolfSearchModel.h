//
//  PT_GolfSearchModel.h
//  Putt2Gether
//
//  Created by Sachin on 18/02/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_GolfSearchModel : NSObject

@property(assign,nonatomic) NSInteger golfcourseId;

@property(strong,nonatomic) NSString *golfCourseName;

@property(assign) float latitude;

@property(assign) float longitude;

@property(strong,nonatomic) NSString *city_name;

@property(assign,nonatomic) NSInteger cityId;

@property (assign,nonatomic) NSInteger hasEvent;

@property (assign,nonatomic) NSInteger event_count;




@end
