//
//  PT_TeeView.h
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

static int const MenTeeTag = 5000;
static int const WomenTeeTag = 6000;
static int const JuniorTeeTag = 7000;

@protocol PT_TeeViewDelegate <NSObject>

@optional
- (void)didPressTeeButtonWithTag:(NSInteger)tag;

@end

@interface PT_TeeView : UIView

@property (weak, nonatomic) id <PT_TeeViewDelegate> delegate;


- (void)hideView;

- (void)makeOptionsRound;

- (void)setTeeWithMenArray:(NSArray *)arrMen
             andWomenArray:(NSArray *)arrWomen
            andJuniorArray:(NSArray *)arrJunior;

@end
