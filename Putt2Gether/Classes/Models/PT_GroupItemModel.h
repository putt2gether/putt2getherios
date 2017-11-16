//
//  PT_GroupItemModel.h
//  Putt2Gether
//
//  Created by Devashis on 07/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_GroupItemModel : NSObject

@property (strong, nonatomic) NSString *groupName;

@property (assign, nonatomic) NSInteger groupId;

@property (strong, nonatomic) NSString *groupImageURL;

@property (assign, nonatomic) BOOL isAddGroupOption;

@property (strong, nonatomic) NSArray *arrGroupMembers;

@property(assign,nonatomic) BOOL isAddedinGroup;


@end
