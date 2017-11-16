//
//  PT_HomeViewController.h
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "PT_PopupViewController.h"



@interface PT_HomeViewController : UIViewController<XYPieChartDelegate, XYPieChartDataSource>


@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;

@property (strong, nonatomic)  UILabel *percentageLabel;

@property (strong, nonatomic)  UIView *percentBGView;
@property (weak, nonatomic) IBOutlet UIButton *upcomingBtn;
- (IBAction)upcominBtnClicked:(id)sender;

@property(nonatomic, strong) NSMutableArray *slices;

@property(nonatomic, strong) NSArray        *sliceColors;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *button2View;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *last10Btn;

@property (weak, nonatomic) IBOutlet UIView *upcomingEventView, *upcomingFaded;

-(IBAction)upcomingCloseBtn:(id)sender;

- (IBAction)last10Btn:(id)sender;

//Initialize Service calls for Number Of Events
- (void)initializeCallsForNumberOfEvents:(NSInteger)count;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end
