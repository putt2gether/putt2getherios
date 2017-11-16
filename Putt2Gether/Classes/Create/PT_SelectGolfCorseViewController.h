//
//  PT_SelectGolfCorseViewController.h
//  Putt2Gether
//
//  Created by Devashis on 18/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_CreateViewController.h"

@protocol PT_SelectGolfCourseDelegate <NSObject>

@optional

- (void)didSelectGolfCourse:(PT_SelectGolfCourseModel *)golfCourseModel;

@end

@interface PT_SelectGolfCorseViewController : UIViewController

@property (weak, nonatomic) id <PT_SelectGolfCourseDelegate> delegate;

- (instancetype)initWithDelegate:(PT_CreateViewController *)parent andGolfCourseList:(NSArray *)list;

- (instancetype)initWithGolfCourseList:(NSArray *)list;

@end
