//
//  PT_GroupsView.h
//  Putt2Gether
//
//  Created by Devashis on 19/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_GroupsView : UIView

@property (strong, nonatomic) NSMutableArray *arrSelectedGroups;

- (void)setUpWithAddedInviteGroup:(NSMutableArray *)invite;

@property(strong,nonatomic) IBOutlet UITextField *searchText;


@end
