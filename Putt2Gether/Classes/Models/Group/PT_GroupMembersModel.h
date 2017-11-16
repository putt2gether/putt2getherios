//
//  PT_GroupMembersModel.h
//  Putt2Gether
//
//  Created by Devashis on 18/01/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_GroupMembersModel : NSObject

@property (strong, nonatomic) NSString *memberName;

@property (strong, nonatomic) NSString *memberId;

@property (strong, nonatomic) NSString *memberImageUrl;

@property (strong, nonatomic) NSString *memberHandicap;

@property (assign, nonatomic) NSInteger isAdmin;

@property (assign, nonatomic) BOOL isAddedToNewGroup;

@property(assign,nonatomic) BOOL isRemoved;

@property(assign,nonatomic) NSInteger playedBefore;

@property(strong,nonatomic) NSString *groupImageUrl;

@end
