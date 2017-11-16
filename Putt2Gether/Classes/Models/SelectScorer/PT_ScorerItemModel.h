//
//  PT_ScorerItemModel.h
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_ScorerItemModel : NSObject

@property (assign, nonatomic) NSInteger scorerId;

@property (strong, nonatomic) NSString *scorerName;

@property (strong, nonatomic) NSString *selectedScorerName;

@property (assign, nonatomic) BOOL isSelected;

@end
