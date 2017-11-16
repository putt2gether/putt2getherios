//
//  PT_EnterScoreSelectHoles.h
//  Putt2Gether
//
//  Created by Devashis on 05/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PT_EnterScoreSelectHolesDelegate <NSObject>

@optional

- (void)didSelectHole:(NSInteger)selectedHole;

- (void)didSelectEndRound;

@end

@interface PT_EnterScoreSelectHoles : UIView

- (void)setNumberOfHoles:(NSInteger)holes andFront:(BOOL)isFrontEnabled;

@property (weak, nonatomic) id <PT_EnterScoreSelectHolesDelegate> delegate;

@property (assign, nonatomic) NSInteger currentHole;

@property (assign, nonatomic) BOOL isFrontHole;

- (void)updateHoles;

@end
