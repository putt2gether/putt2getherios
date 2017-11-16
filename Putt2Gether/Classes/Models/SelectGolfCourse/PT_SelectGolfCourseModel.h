//
//  PT_SelectGolfCourseModel.h
//  Putt2Gether
//
//  Created by Devashis on 18/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_SelectGolfCourseModel : NSObject

@property (strong, nonatomic) NSString *golfCourseName;
@property (strong, nonatomic) NSString *golfCourseLocation;
@property (assign, nonatomic) NSInteger golfCourseLocationId;
@property (assign, nonatomic) NSInteger golfCourseId;
@property (assign, nonatomic) float golfCourseLatitude;
@property (assign, nonatomic) float golfCourseLongitude;
@property (assign, nonatomic) float distance;
@property (assign, nonatomic) NSInteger golfCourseHasEvent;
@property (assign, nonatomic) NSInteger golfCourseEventcount;


@end
