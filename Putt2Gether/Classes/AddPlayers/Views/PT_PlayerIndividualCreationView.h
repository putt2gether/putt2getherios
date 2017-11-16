//
//  PT_PlayerIndividualCreationView.h
//  Putt2Gether
//
//  Created by Devashis on 26/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_PlayerIndividualCreationView : UIView

@property (weak, nonatomic) IBOutlet UIView *roundCornerView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *playerButton;

@property (weak, nonatomic) IBOutlet UITextField *textDisplayName;
@property (weak, nonatomic) IBOutlet UITextField *textHandicap;

@property (weak, nonatomic) IBOutlet UITextField *textEmail;

@end
