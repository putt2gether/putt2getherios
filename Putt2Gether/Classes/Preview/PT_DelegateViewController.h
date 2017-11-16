//
//  PT_DelegateViewController.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_ScoringIndividualPlayerModel.h"

@interface PT_DelegateViewController : UIViewController

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model andPlayerModel:(PT_ScoringIndividualPlayerModel *)playerModel;

@property(strong,nonatomic) IBOutlet UIButton *backBtn;
-(IBAction)actionBackBtn:(id)sender;

@end
