//
//  PT_TempGolfCourseItemModel.h
//  Putt2Gether
//
//  Created by Devashis on 24/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_TempGolfCourseItemModel : NSObject

@property (strong, nonatomic) NSString *parKey;
@property (strong, nonatomic) NSString *parValue;

@property (strong, nonatomic) NSString *indexKey;
@property (strong, nonatomic) NSString *indexValue;

@property (assign, nonatomic) BOOL isParAssigned;
@property (assign, nonatomic) BOOL isIndexAssigned;



@end
