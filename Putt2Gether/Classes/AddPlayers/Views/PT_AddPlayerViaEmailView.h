//
//  PT_AddPlayerViaEmailView.h
//  Putt2Gether
//
//  Created by Devashis on 26/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_PlayerIndividualCreationView.h"


@interface PT_AddPlayerViaEmailView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setBasicUI;

@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;


@property (strong, nonatomic) NSMutableArray *arrViewContainers;

@property(strong,nonatomic) PT_PlayerIndividualCreationView *playerView;

@end
