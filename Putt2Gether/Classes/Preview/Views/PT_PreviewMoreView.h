//
//  PT_PreviewMoreView.h
//  Putt2Gether
//
//  Created by Devashis on 07/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PT_PreviewMoreDelegate <NSObject>

- (void)didSelectViewParticipants;

- (void)didSelectViewRequests;

- (void)didSelectEditEvent;

- (void)didSelectSelectScorer;

-(void)didCancelPreview;

@end

@interface PT_PreviewMoreView : UIView

@property (weak, nonatomic) id <PT_PreviewMoreDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLowerLeftViewX;

- (void)setDefaultUIProperties:(BOOL)isAdmin;

- (void)disableRequestButton:(BOOL)value;

@end
