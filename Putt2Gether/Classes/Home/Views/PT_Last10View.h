//
//  PT_Last10View.h
//  Putt2Gether
//
//  Created by Bunny on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_HomeViewController.h"

/*@protocol LastNumberOfEventDelegate <NSObject>

@optional

- (void)didSelectNumberOfEvents:(NSInteger)numOfEvents;

@end
*/
@interface PT_Last10View : UIView

@property (strong, nonatomic) PT_HomeViewController *homeVC;

@property (strong,nonatomic) IBOutlet UIButton *lastBtn, *last5Btn,*last10Btn, *last20Btn, *overallBtn,*closeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYHitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYMissedButton;


@property(strong,nonatomic) IBOutlet UIView *backgroundView;

//@property (weak, nonatomic) id <LastNumberOfEventDelegate> delegate;

-(IBAction)actioncloseBtn:(id)sender;
/*-(IBAction)actionlastBtn:(id)sender;
-(IBAction)actionlast5Btn:(id)sender;
-(IBAction)actionlast10Btn:(id)sender;
-(IBAction)actionlast20Btn:(id)sender;
-(IBAction)actionoverallBtn:(id)sender;*/

@end
