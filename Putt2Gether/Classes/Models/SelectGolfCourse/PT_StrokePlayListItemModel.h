//
//  PT_StrokePlayListItemModel.h
//  Putt2Gether
//
//  Created by Devashis on 23/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_StrokePlayListItemModel : NSObject

@property (strong, nonatomic) NSString *strokeName;
@property (assign, nonatomic) NSInteger strokeId;
@property(strong,nonatomic) NSMutableAttributedString *descriptionText;

@end
