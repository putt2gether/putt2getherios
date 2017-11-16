//
//  MGMainDAO.m
//  MyGrid
//
//  Created by Devashis on 13/06/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGMainDAO.h"

#import "AFHTTPRequestOperationManager.h"


@implementation MGMainDAO


- (void)postRequest:(NSString *)requestURL
     withParameters:(NSDictionary *)param
withCompletionBlock:(CompletionBlock )completionBlock
{
    
    NSString *encoded = [[requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                     stringByReplacingOccurrencesOfString:@"%20"
                                     withString:@""] ;
    encoded = [encoded stringByReplacingOccurrencesOfString:@"%E2%80%8B" withString:@""];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //[manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];

    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    [manager POST:encoded parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
    
        completionBlock(responseObject,NULL);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error:%@",[error localizedDescription]);
        completionBlock(NULL,error);
        
    }];
}

@end
