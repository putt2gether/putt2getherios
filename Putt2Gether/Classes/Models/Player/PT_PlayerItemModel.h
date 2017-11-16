//
//  PT_PlayerItemModel.h
//  Putt2Gether
//
//  Created by Devashis on 18/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_PlayerItemModel : NSObject

@property (strong, nonatomic) NSString *playerName;
@property (strong, nonatomic) NSString *playerImageURL;
@property (assign, nonatomic) NSInteger playerId;
@property (assign, nonatomic) NSInteger counts;
@property (assign, nonatomic) BOOL isAdmin;
@property (assign, nonatomic) BOOL isAddPlayerOption;
@property (assign, nonatomic) NSInteger handicap;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *country;
@property (assign, nonatomic) NSInteger countryID;

@property(assign,nonatomic) NSInteger isAdded;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *email;
@property(assign,nonatomic) NSInteger homecourseID;
@property(strong,nonatomic) NSString *homeCourseName;
@property(assign,nonatomic) NSInteger teamNum;
@end
