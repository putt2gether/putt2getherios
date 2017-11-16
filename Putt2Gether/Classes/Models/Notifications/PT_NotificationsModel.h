//
//  PT_NotificationsModel.h
//  Putt2Gether
//
//  Created by Devashis on 13/02/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_NotificationsModel : NSObject

@property (strong, nonatomic) NSString *subject;

@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) NSString *send_date;

@property(assign,nonatomic) NSInteger pushType;

@property(assign,nonatomic) NSInteger readStatus;

@property(assign,nonatomic) NSInteger alertID;

@property(assign,nonatomic) NSInteger eventID;

@property(assign,nonatomic) NSInteger adminID;

@property(nonatomic) BOOL isreadStatus;


@end
