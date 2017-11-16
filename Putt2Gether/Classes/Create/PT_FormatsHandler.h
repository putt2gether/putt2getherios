//
//  PT_FormatsHandler.h
//  Putt2Gether
//
//  Created by Devashis on 22/04/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PT_FormatsHandler : NSObject

- (NSMutableArray *)get1PlayerFormats;

- (NSMutableArray *)get2PlayerFormats;

- (NSMutableArray *)get3PlayerFormats;

- (NSMutableArray *)get4PlayerNoTeamFormats;

- (NSMutableArray *)get4PlayerTeamFormats;

- (NSMutableArray *)get4PlusFormats;

@end
