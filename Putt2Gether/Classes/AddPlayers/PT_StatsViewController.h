//
//  PT_StatsViewController.h
//  Putt2Gether
//
//  Created by Bunny on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_HomeViewController.h"

@interface PT_StatsViewController : UIViewController

@property(weak,nonatomic) IBOutlet UIButton *scoreBtn ,*girBtn, *fairwayBtn, *puttingBtn, *recoveryBtn;

@property (strong, nonatomic) PT_HomeViewController *homeVC;

//Gir View Stats
@property (strong, nonatomic) NSString *girStatsHit;
@property (strong, nonatomic) NSString *girStatsMissed;

//Recovery Stats
@property (strong, nonatomic) NSString *recoveryStatsHit;
@property (strong, nonatomic) NSString *recoveryMissed;

//Fairway
@property (strong, nonatomic) NSString *fairwaysLeft;
@property (strong, nonatomic) NSString *fairwaysRight;
@property (strong, nonatomic) NSString *fairwaysCentre;

//Putting
@property (strong, nonatomic) NSString *puttLeft;
@property (strong, nonatomic) NSString *puttRight;
@property (strong, nonatomic) NSString *puttCentre;

//Scoring Average
@property (strong, nonatomic) NSString *scoringAverageLeft;
@property (strong, nonatomic) NSString *scoringRight;
@property (strong, nonatomic) NSString *scoringCentre;

//Score stats
@property (strong, nonatomic) NSDictionary *dictScoreStats;

-(IBAction)actionScore:(id)sender;

-(IBAction)actionGir:(id)sender;
-(IBAction)actionfairway:(id)sender;
-(IBAction)actionPutting:(id)sender;
-(IBAction)actionRecovery:(id)sender;

@property(weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)IBOutlet UIPageControl *pageControl;
@property(weak,nonatomic) IBOutlet UIView *lowerView;

- (void)setNumberOfEventsTitle:(NSString *)title;

- (void)updateCurrentView;

- (IBAction)actionBack;

@end
