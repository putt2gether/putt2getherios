//
//  MGMainDAO.h
//  MyGrid
//
//  Created by Devashis on 13/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(id responseData, NSError* error);

@interface MGMainDAO : NSObject

//@property (copy, nonatomic) CompletionBlock completionBlock;

- (void)postRequest:(NSString *)requestURL
     withParameters:(NSDictionary *)param
withCompletionBlock:(CompletionBlock )completionBlock;


@end
