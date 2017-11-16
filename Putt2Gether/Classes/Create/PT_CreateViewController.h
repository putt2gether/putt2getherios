//
//  PT_CreateViewController.h
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PT_SelectGolfCourseModel.h"

#import "PT_CreatedEventModel.h"



@interface PT_CreateViewController : UIViewController

- (void)setSelectedGolfCourse:(PT_SelectGolfCourseModel *)golfCourseModel;

@property (assign, nonatomic) BOOL isEditMode;

//Number of players
@property (assign, nonatomic) NumberOfPlayers currentNumOfPlayersSelected;

@property (assign, nonatomic) BOOL isNumOfPlayersCellLowerHalfVisible;

@property (assign, nonatomic) BOOL isTeamGame;

@property (assign, nonatomic) BOOL isNumberOfHole18Selected;

@property (assign, nonatomic) BOOL isSpotPrizeSelected;

@property (assign, nonatomic) BOOL isFront9Selected;

@property (assign, nonatomic) BOOL isGolfCourseExplicitlySelected;

@property (strong, nonatomic) UIButton *currentSpotPrizeButton;

@property (strong, nonatomic) PT_EventPreviewViewController *previewVC;

@property(weak,nonatomic) IBOutlet UIButton *previewBtn;

- (instancetype)initWithCreateEventModel:(PT_CreatedEventModel *)createEventmodel;

- (void)setBasicElements;

- (void)setStrokePlayListWithNumberOfPlayers:(NumberOfPlayers)numOfPlayers;

- (void)setNoOfHolesForPreviewEvent:(NSString *)holes;



- (void)refreshTableView;

- (void)setIndividualOrTeamForPreviewEvent:(NSString *)individualOrTeam;

- (void)setEventTypeForPreviewevent:(NSString *)type;

- (void)setIs18HolesSelectedForPreviewEvent:(BOOL)isSelected;

- (void)setFRontOrBack9ForPreviewEvent:(NSString *)type;

- (void)setIsSpotPrizeForPreviewEvent:(BOOL)isSelected;

//Scorer type

- (void)setScorerTypeForPreviewEvent:(NSString *)type;
- (void)setIsScorerTypeForPreviewEvent:(BOOL)type;

- (void)updateEventTypeForUpdateEvent:(NSString *)updatedValue;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end
