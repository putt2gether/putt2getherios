//
//  PT_CreateViewController.m
//  Putt2Gether
//
//  Created by Devashis on 16/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_CreateViewController.h"

#import "PT_GolfCourceTableViewCell.h"

#import "PT_EventNameTableViewCell.h"

#import "PT_NumOfPlayersTableViewCell.h"

#import "PT_SelectFormatTableViewCell.h"

#import "PT_SelectTeeTableViewCell.h"

#import "PT_EventTimeTableViewCell.h"

#import "PT_NumOfHolesTableViewCell.h"

#import "PT_EventTypeTableViewCell.h"

#import "PT_SelectHolesTableViewCell.h"

#import "PT_TeeView.h"

#import "PT_SelectGolfCorseViewController.h"

#import "PT_AddPlayerMainViewController.h"

#import "PT_AddPlayerOptionsViewController.h"

#import "MGMainDAO.h"

#import "PT_StrokePlayListItemModel.h"

#import "UIView+Hierarchy.h"

#import "PT_SpotPrizeTableViewCell.h"

#import "PT_TeeItemModel.h"

#import "PT_SpotPrizeSelectionView.h"

#import "PT_CreateGolfCorseViewController.h"

#import "PT_StrokesTableViewCell.h"

#import "PT_EventTypeInfo.h"

#import "PT_EnterScoreTableViewCell.h"

#import "PT_AddPlayerIntermediateViewController.h"

#import "PT_StartEventViewController.h"

#import "PT_FormatsHandler.h"

#import "PT_FormatInfo.h"


static NSString *const GetGolfCoursePostFix = @"getnearestgolfcourse";
static NSString *const GetStrokePlayList = @"getstrokeplaylist";
static NSString *const ShowHoleNumbersPostfix = @"showholenumbers";

static NSInteger const ClosestPin1Tag = 0;
static NSInteger const ClosestPin2Tag = 1;
static NSInteger const ClosestPin3Tag = 2;
static NSInteger const ClosestPin4Tag = 3;

static NSInteger const LongDrive1Tag = 4;
static NSInteger const LongDrive2Tag = 5;
static NSInteger const LongDrive3Tag = 6;
static NSInteger const LongDrive4Tag = 7;

static NSInteger const StraightDrive1Tag = 8;
static NSInteger const StraightDrive2Tag = 9;
static NSInteger const StraightDrive3Tag = 10;
static NSInteger const StraightDrive4Tag = 11;


@interface PT_CreateViewController ()<UITableViewDataSource,
                                      UITableViewDelegate,
                                      UITextFieldDelegate,
                                      UIGestureRecognizerDelegate,
                                      PT_TeeViewDelegate>
{
}


@property (weak, nonatomic) IBOutlet UIView *createEventfooterView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIView *datePickerBGView;

@property (weak, nonatomic) IBOutlet UIButton *datePickerDoneButton;

@property (strong, nonatomic) UIButton *eventTimeCurrentButton;

@property (weak, nonatomic) IBOutlet UITableView *tableOptions;

@property (strong, nonatomic) PT_TeeView *teeView;

@property (assign, nonatomic) BOOL isRequestToParticipate;


//Number of players
@property (strong, nonatomic) PT_NumOfPlayersTableViewCell *cellNumberOfPlayers;

//Footer View
@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;
@property (weak, nonatomic) IBOutlet UILabel *addPlayerLabel;

//Event Name
@property (strong, nonatomic) UITextField *textEventName;

//Event Type
@property (weak, nonatomic) IBOutlet UIView *eventTypeInfoBGView;
@property (weak, nonatomic) IBOutlet UIView *eventTypeInfoView;

//Select format cell
@property (strong, nonatomic) PT_SelectFormatTableViewCell *cellFormat;
@property (assign, nonatomic) float cellFormatTableWidth;

//Golf Courses
@property (strong, nonatomic) NSMutableArray *arrGolfCoursesList;
@property (strong, nonatomic) PT_SelectGolfCourseModel *currentGolfCourseModel;

//StrokePlayList
@property (strong, nonatomic) NSMutableArray *arrStrokePlayList;
@property (strong, nonatomic) UITableView *tableStrokes;
@property (strong, nonatomic) UIView *viewStroke;
@property (strong, nonatomic) UIButton *buttonStrokePlay;

//Tee List
@property (strong, nonatomic) NSMutableArray *arrMenTeeList;
@property (strong, nonatomic) NSMutableArray *arrWomenTeeList;
@property (strong, nonatomic) NSMutableArray *arrJuniorTeeList;

@property (strong, nonatomic) UIButton *menTeeButton;
@property (strong, nonatomic) UIButton *womenTeeButton;
@property (strong, nonatomic) UIButton *juniorTeeButton;

//Spot Prize
@property (assign, nonatomic) NSInteger spotPrizeOption;

@property (assign, nonatomic) BOOL isDefaultSpotPrizeOptionsShow;

@property (strong, nonatomic) PT_SpotPrizeTableViewCell *cellSpotPrizes;

//selected time
@property (strong, nonatomic) NSString *selectedDateTime;
//Selected Event
@property (strong, nonatomic) NSString *selectedEvent;

@property (assign, nonatomic) BOOL isLoadedFirstTime;



//Edit Event

@property (weak, nonatomic) IBOutlet UIView *editEventFooterView;

@property (strong, nonatomic) PT_CreatedEventModel *createventModel;

//Event Info
@property (strong, nonnull) PT_EventTypeInfo *info ;

@property (strong, nonatomic) PT_EnterScoreTableViewCell *scorerCell;

//Format Info
@property(strong,nonatomic) PT_FormatInfo *formatInfo;

@end

@implementation PT_CreateViewController


- (instancetype)initWithCreateEventModel:(PT_CreatedEventModel *)createEventmodel
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    self.isEditMode = YES;
    self.createventModel = createEventmodel;
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBasicElements];
    
    //Using Tap Gesture as UITableView is inherited from UIScrollView and scroll View wont allow TouchesBegan callbacks
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.tableOptions addGestureRecognizer:tapGestureRecognizer];
    UITapGestureRecognizer *tapGestureRecognizerEventType = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.eventTypeInfoBGView addGestureRecognizer:tapGestureRecognizerEventType];
}

- (void)setBasicElements
{
    
    
    
    self.isLoadedFirstTime = YES;
    
    if (self.isEditMode == YES)
    {
        
        NSLog(@"%@",self.createventModel);
        
        PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
        model.golfCourseName = [self.createventModel.golfCourseName uppercaseString];
        model.golfCourseId = self.createventModel.golfCourseId;
        self.isGolfCourseExplicitlySelected = YES;            //Changes
        [self setSelectedGolfCourse:model];
        
        PT_StrokePlayListItemModel *strokeModel = [PT_StrokePlayListItemModel new];
        strokeModel.strokeId = [self.createventModel.formatId integerValue];
        strokeModel.strokeName = self.createventModel.formatName;
        [self.cellFormat.formatButton setTitle:strokeModel.strokeName forState:UIControlStateNormal];
        [self setFormatForPreviewEvent:strokeModel];
        
        [self spotPrizedataForEditMode];
        
        [self setTeeValuesForEditOption];
        
        self.createEventfooterView.hidden = YES;
        self.editEventFooterView.hidden = NO;
        self.selectedEvent = self.createventModel.eventName;
        self.titleLabel.text = @"EDIT EVENT";
        self.selectedDateTime = self.createventModel.eventstartDateTime;
        self.isNumOfPlayersCellLowerHalfVisible = NO;
        if (self.createventModel.totalHoleNumber == 18)
        {
            self.isNumberOfHole18Selected = YES;
        }
        else
        {
            self.isNumberOfHole18Selected = NO;
        }
        if ([self.createventModel.playersInGame isEqualToString:@"1"])
        {
            [self setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_1];
            self.isTeamGame = NO;
        }
        else if ([self.createventModel.playersInGame isEqualToString:@"2"])
        {
            [self setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_2];
            self.isTeamGame = NO;
        }
        else if ([self.createventModel.playersInGame isEqualToString:@"3"])
        {
            [self setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_3];
            self.isTeamGame = NO;
        }
        else if ([self.createventModel.playersInGame isEqualToString:@"4"])
        {
            if ([self.createventModel.isIndividual isEqualToString:@"Individual"])
            {
                self.isTeamGame = NO;
            }
            else
            {
                [[PT_PreviewEventSingletonModel sharedPreviewEvent] setindividualOrTeam:TEAM];
                self.isTeamGame = YES;
            }
            
            [self setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_4];

        }
        else
        {
            [self setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_MoreThan4];
            self.isTeamGame = NO;
        }
        
        if (self.createventModel.isSpot == YES)
        {
            self.isSpotPrizeSelected = YES;
        }
        else
        {
            self.isSpotPrizeSelected = NO;                 //Changes
        }
    }
    else
    {
        
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultSpotPrize];
        self.isDefaultSpotPrizeOptionsShow = YES;
        self.isGolfCourseExplicitlySelected = YES;
        [self setIndividualOrTeamForPreviewEvent:INDIVIDUAL];
        self.isNumOfPlayersCellLowerHalfVisible = NO;
        [self setStrokePlayListWithNumberOfPlayers:NumberOfPlayers_1];
        self.isTeamGame = YES;
        
        self.selectedEvent = nil;
        
        [self setScorerTypeForPreviewEvent:singleScorerStatic];
        [self setIsScorerTypeForPreviewEvent:YES];
        
        //Number Of Holes property
        self.isNumberOfHole18Selected = YES;
        [self setIs18HolesSelectedForPreviewEvent:YES];
        [self setNoOfHolesForPreviewEvent:@"18"];
        self.isFront9Selected = YES;
        [self setFRontOrBack9ForPreviewEvent:FRONT9];
        self.spotPrizeOption = 0;
        [self setIsSpotPrizeForPreviewEvent:NO];
        
        [self setEventTypeForPreviewevent:PUBLIC];           //Changes
        
    }
    //Fetch Golf Course
    [self fetchGolfCourses];
    
    if (_viewStroke == nil)
    {
        _viewStroke =[[UIView alloc] initWithFrame:self.view.bounds];
    }
    self.viewStroke.hidden = YES;
    //Fetch Stroke Play List
    
    if (_tableStrokes == nil)
    {
        _tableStrokes = [[UITableView alloc] init];
        [self.view addSubview:self.tableStrokes];
    }
    _tableStrokes.delegate = self;
    _tableStrokes.dataSource  =self;
    
    
    
    //[self.view addSubview:self.tableStrokes];
    self.tableStrokes.hidden = YES;
    
    [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [self.datePicker setMinimumDate: [NSDate date]];
    self.datePickerDoneButton.layer.cornerRadius = 2.0;
    [self.datePicker sendAction:@selector(setHighlightsToday:) to:nil forEvent:nil];
    
    self.datePicker.date = [NSDate date];
    
    if (_teeView == nil)
    {
        _teeView = [[[NSBundle mainBundle] loadNibNamed:@"PT_TeeView"
                                                  owner:self options:nil] objectAtIndex:0];
    }
    
    CGRect teeViewFrame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height - 180);
    [self.teeView makeOptionsRound];
    self.teeView.frame = teeViewFrame;
    self.teeView.hidden = YES;
    self.teeView.delegate = self;
    [self.view addSubview:self.teeView];
    
    self.cellFormatTableWidth = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableOptions reloadData];
    });
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.isEditMode = NO;
    //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultValues];
}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.eventTypeInfoBGView.hidden = YES;
        [self actionDatePickerDone];
        self.teeView.hidden = YES;
        self.viewStroke.hidden = YES;
        [self.textEventName resignFirstResponder];
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = YES;
    CGRect mainFrame = delegate.window.bounds;
    self.view.frame = mainFrame;
    
    
}

-(void)spotPrizedataForEditMode{
    
    
    
    if ([self.createventModel.closestPin count] > 0)
    {
        for (NSInteger counter = 0; counter < [self.createventModel.closestPin count]; counter++) {
            NSDictionary *dicSpot = self.createventModel.closestPin[counter];
            switch (counter) {
                    
                case 0:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData1:dicSpot[@"hole_number"]];
                }
                    break;
                case 1:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData2:dicSpot[@"hole_number"]];
                }
                    break;
                case 2:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData3:dicSpot[@"hole_number"]];
                }
                    break;
                case 3:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeClosestToPinData4:dicSpot[@"hole_number"]];
                }
                    break;
                    
            }
        }
    }
    else
    {
        NSLog(@"Closet To pin Data not Found");
    }
    
    if ([self.createventModel.longDrive count] > 0)
    {
        for (NSInteger counter = 0; counter < [self.createventModel.longDrive count]; counter++) {
            NSDictionary *dicSpot = self.createventModel.longDrive[counter];
            switch (counter) {
                    
                case 0:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive1:dicSpot[@"hole_number"]];
                }
                    break;
                case 1:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive2:dicSpot[@"hole_number"]];
                }
                    break;
                case 2:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive3:dicSpot[@"hole_number"]];                }
                    break;
                case 3:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeLongDrive4:dicSpot[@"hole_number"]];
                }
                    break;
                    
            }
        }
    }
    else
    {
        NSLog(@"Long Dirve not found.");
    }
    if ([self.createventModel.straightDrive count] > 0)
    {
        for (NSInteger counter = 0; counter < [self.createventModel.straightDrive count]; counter++) {
            NSDictionary *dicSpot = self.createventModel.straightDrive[counter];
            switch (counter) {
                    
                case 0:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive1:dicSpot[@"hole_number"]];
                }
                    break;
                case 1:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive2:dicSpot[@"hole_number"]];
                }
                    break;
                case 2:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive3:dicSpot[@"hole_number"]];
                }
                    break;
                case 3:
                {
                    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive4:dicSpot[@"hole_number"]];
                }
                    break;
                    
            }
        }
    }
    else
    {
        NSLog(@"Straight Drive data not found.");
    }
    
    
    
}


- (void)setTeeValuesForEditOption
{
    NSDictionary *dicEditEventTee = self.createventModel.teeId;
    NSLog(@"%@",dicEditEventTee);
    NSDictionary *dicMen = dicEditEventTee[@"MenColor"];
    NSString *mHex = nil;
    NSNull *n=[NSNull null];
    if ( dicMen != n )
    {
        CGFloat r = [dicMen[@"r"] floatValue];
        CGFloat g = [dicMen[@"g"] floatValue];
        CGFloat b = [dicMen[@"b"] floatValue];
        UIColor *mColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
        mHex = [self hexStringFromColor:mColor];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForMen:[UIColor colorFromHexString:mHex]];
    }
    else
    {
        mHex = @"#FFFFFF";
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForMen:[UIColor colorFromHexString:mHex]];
    }
    
    PT_TeeItemModel *modelMen = [PT_TeeItemModel new];
    modelMen.teeColor = mHex;
    modelMen.teeId = [self.createventModel.teeId[@"men_tee_id"] integerValue];
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setMenTeeModel:modelMen];
    
    
    NSDictionary *dicLadies = dicEditEventTee[@"LadiesColor"];
    NSString *lHex = nil;
    
    if ( dicLadies != n )
    {
        CGFloat r = [dicLadies[@"r"] floatValue];
        CGFloat g = [dicLadies[@"g"] floatValue];
        CGFloat b = [dicLadies[@"b"] floatValue];
        UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
        lHex = [self hexStringFromColor:jColor];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForWomen:[UIColor colorFromHexString:lHex]];
    }
    else
    {
        lHex = @"#FFFFFF";
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForWomen:[UIColor colorFromHexString:lHex]];
    }
    PT_TeeItemModel *modelWomen = [PT_TeeItemModel new];
    modelWomen.teeColor = lHex;
    modelWomen.teeId = [self.createventModel.teeId[@"lady_tee_id"] integerValue];
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setWomenTeeModel:modelWomen];
    
   
    NSDictionary *dicJunior = dicEditEventTee[@"JuniorColor"];
    NSString *jHex = nil;
    
    if ( dicJunior != n )
    {
        CGFloat r = [dicJunior[@"r"] floatValue];
        CGFloat g = [dicJunior[@"g"] floatValue];
        CGFloat b = [dicJunior[@"b"] floatValue];
        UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
        jHex = [self hexStringFromColor:jColor];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForJunior:[UIColor colorFromHexString:jHex]];
    }
    else
    {
        jHex = @"#FFFFFF";
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForJunior:[UIColor colorFromHexString:jHex]];
    }
    PT_TeeItemModel *modelJunior = [PT_TeeItemModel new];
    modelJunior.teeColor = jHex;
    modelJunior.teeId = [self.createventModel.teeId[@"junior_tee_id"] integerValue];
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setJuniorTeeModel:modelJunior];
    //[self.tableOptions reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
   
}





- (void)setStrokePlayListWithNumberOfPlayers:(NumberOfPlayers)numOfPlayers
{
    if (self.tableStrokes.hidden == NO)
    {
        self.tableStrokes.hidden = YES;
        self.viewStroke.hidden = YES;
    }
    self.currentNumOfPlayersSelected = numOfPlayers;
    if (self.arrStrokePlayList == nil)
    {
        _arrStrokePlayList = [NSMutableArray new];
    }
    switch (numOfPlayers) {
        case NumberOfPlayers_1:
        {
            
            [self actionSetInvitePlayerOptionForNumberOfPlayers:NumberOfPlayers_1];
            [self fetchStrokesForNumberOfPlayers:@"1"];
            [self setNumberOfPlayerForPreviewEvent:@"1"];
        }
            break;
        case NumberOfPlayers_2:
        {
            [self actionSetInvitePlayerOptionForNumberOfPlayers:NumberOfPlayers_2];
            [self fetchStrokesForNumberOfPlayers:@"2"];
            [self setNumberOfPlayerForPreviewEvent:@"2"];
        }
            break;
        case NumberOfPlayers_3:
        {
            [self actionSetInvitePlayerOptionForNumberOfPlayers:NumberOfPlayers_3];
            [self fetchStrokesForNumberOfPlayers:@"3"];
            [self setNumberOfPlayerForPreviewEvent:@"3"];
        }
            break;
        case NumberOfPlayers_4:
        {
            [self actionSetInvitePlayerOptionForNumberOfPlayers:NumberOfPlayers_4];
            [self fetchStrokesForNumberOfPlayers:@"4"];
            [self setNumberOfPlayerForPreviewEvent:@"4"];
        }
            break;
        case NumberOfPlayers_MoreThan4:
        {
            [self actionSetInvitePlayerOptionForNumberOfPlayers:NumberOfPlayers_MoreThan4];
            [self fetchStrokesForNumberOfPlayers:@"4+"];
            [self setNumberOfPlayerForPreviewEvent:@"4+"];
        }
            break;
            
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableStrokes)
    {
        return 44.0f;
    }
    else{
        if (indexPath.row == CreateEventCellType_SelectHoles)
        {
            if (self.isNumberOfHole18Selected == NO)
            {
                return 44.0f;
            }
            else
            {
                return 0.0f;
            }
        }
        if (indexPath.row == 2)
        {
            
            if (self.isNumOfPlayersCellLowerHalfVisible == YES)
            {
                return 88.0f;
            }
            else
            {
                return 44.0f;
            }
        }
        if (indexPath.row == CreateEventCellType_SpotPrize)
        {
            if (self.isEditMode == YES)
            {
                if (self.createventModel.isSpot == NO)
                {
                    return 0.0;
                }
                else
                {
                    return 214.0f;
                }
            }
            else
            {
                if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"4+"])
                {
                    if (self.isSpotPrizeSelected == YES)
                    {
                        return 214.0f;
                    }
                    else
                    {
                        return 45.0f;
                    }
                }
                else
                {
                    return 0.0;
                }
            }
            
        }
        if (indexPath.row == CreateEventCellType_EventType)
        {
            if (self.isEditMode == YES)
            {
                if ([self.createventModel.numberOfPlayers isEqualToString:@"1"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"2"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"3"] ||
                    [self.createventModel.numberOfPlayers isEqualToString:@"4"])
                {
                    return 0.0;
                }
                else
                {
                    return 45.0f;
                }
            }
            else
            {
                if([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
                {
                    return 45.0f;
                }
                else
                {
                    return 0.0f;
                }
                {
                    return 45.0f;
                }
            }
            
            
        }
        if (indexPath.row == CreateEventCellType_ScoreScreen)
        {
            PT_StrokePlayListItemModel *model = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFormat];
            if (self.isEditMode == NO)
            {
                if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"1"] ||
                    [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
                {
                    return 0;
                }
                else
                {
                    return 44.0f;
                }
            }
            else if (model.strokeId == Format21Id || model.strokeId == Format420Id || model.strokeId == FormatVegasId || model.strokeId == FormatAutoPressId || model.strokeId == FormatMatchPlayId)
            {
                
                return 0.0f;
            }
            else
            {
                if ([self.createventModel.numberOfPlayers isEqualToString:@"2"]||
                    [self.createventModel.numberOfPlayers isEqualToString:@"3"]||
                    [self.createventModel.numberOfPlayers isEqualToString:@"4"])
                {
                    return 44.0;
                }
                else
                {
                    return 0.0f;
                }
            }
            
        }
        
        else
        {
            return 44.0f;
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableStrokes)
    {
        return [self.arrStrokePlayList count];
    }
    else
    {
        return 11;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.tableOptions)
    {
        UITableViewCell *cell;
        switch (indexPath.row) {
            case CreateEventCellType_GolfCource:
            {
                PT_GolfCourceTableViewCell *cellGolf = [tableView dequeueReusableCellWithIdentifier:@"GolfCourse"];
                
                if (cellGolf == nil)
                {
                    cellGolf = [[[NSBundle mainBundle] loadNibNamed:@"PT_GolfCourceTableViewCell"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
                    
                    cellGolf.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                [cellGolf setSychronizationValueforButton];
                cellGolf.golfCourseButton.layer.cornerRadius = 2.0;
                cellGolf.golfCourseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                cellGolf.golfCourseButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
                [cellGolf.golfCourseButton addTarget:self action:@selector(actionSelectGolfCourse) forControlEvents:UIControlEventTouchUpInside];
                if (_currentGolfCourseModel)
                {
                    [cellGolf.golfCourseButton setTitle:_currentGolfCourseModel.golfCourseName forState:UIControlStateNormal];
                    [cellGolf.golfCourseButton setTitle:cellGolf.golfCourseButton.titleLabel.text.uppercaseString forState:UIControlStateSelected];
                    [cellGolf.golfCourseButton setTitle:cellGolf.golfCourseButton.titleLabel.text.uppercaseString forState:UIControlStateNormal];
                    
                    [cellGolf.golfCourseButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                }
                
                cell = cellGolf;
                
            }
                break;
            case CreateEventCellType_EventName:
            {
                PT_EventNameTableViewCell *cellEventName = [tableView dequeueReusableCellWithIdentifier:@"EventName"];
                
                if (cellEventName == nil)
                {
                    cellEventName = [[[NSBundle mainBundle] loadNibNamed:@"PT_EventNameTableViewCell"
                                                                   owner:self
                                                                 options:nil] objectAtIndex:0];
                    
                    cellEventName.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                [cellEventName setSychronizationValueforButton];
                self.textEventName = cellEventName.eventName;
                UIColor *color = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                if (self.selectedEvent.length ==  0)
                {
                    NSString *displayName = [[MGUserDefaults sharedDefault] getDisplayName];
                    displayName = [[displayName stringByAppendingString:@"'s Event"] uppercaseString];
                cellEventName.eventName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:displayName attributes:@{NSForegroundColorAttributeName: color}];
                    [self setEventNameForPreviewEvent:displayName];
                }
                else
                {
                    cellEventName.eventName.text = self.selectedEvent;
                }
                
                cellEventName.eventName.delegate = self;
                
                cell = cellEventName;
                
            }
                break;
            case CreateEventCellType_NumOfPlayers:
            {
                PT_NumOfPlayersTableViewCell *cellNumOfPlayers = [tableView dequeueReusableCellWithIdentifier:@"NumOfPlayers"];
                cellNumOfPlayers = self.cellNumberOfPlayers;
                if (cellNumOfPlayers == nil)
                {
                    cellNumOfPlayers = [[[NSBundle mainBundle] loadNibNamed:@"PT_NumOfPlayersTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellNumOfPlayers.selectionStyle = UITableViewCellSelectionStyleNone;
                    _cellNumberOfPlayers = cellNumOfPlayers;
                }
                
                cellNumOfPlayers.parentController = self;
                UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                if (self.isEditMode == YES)
                {
                    cellNumOfPlayers.plusButton.hidden = YES;
                    cellNumOfPlayers.twoButton.hidden = YES;
                    cellNumOfPlayers.threeButton.hidden = YES;
                    cellNumOfPlayers.fourButton.hidden = YES;
                    cellNumOfPlayers.oneButton.hidden = NO;
                    cellNumOfPlayers.oneButton.layer.cornerRadius = cellNumOfPlayers.oneButton.frame.size.width/2;
                    cellNumOfPlayers.oneButton.layer.borderColor = borderColor.CGColor;
                    cellNumOfPlayers.oneButton.layer.masksToBounds = YES;
                    cellNumOfPlayers.oneButton.layer.borderWidth = 1.0f;
                    [cellNumOfPlayers.oneButton setTitle:[NSString stringWithFormat:@"%@",self.createventModel.numberOfPlayers] forState:UIControlStateNormal];
                }
                else
                {
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"1"])
                    {
                        UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                        UIColor *whiteBGColor = [UIColor whiteColor];
                        cellNumOfPlayers.oneButton.backgroundColor = blueBGColor;
                        [cellNumOfPlayers.oneButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
                        cellNumOfPlayers.oneButton.titleLabel.text = @"1";
                        cellNumOfPlayers.twoButton.backgroundColor = whiteBGColor;
                        cellNumOfPlayers.twoButton.layer.borderColor = blueBGColor.CGColor;
                        cellNumOfPlayers.twoButton.titleLabel.textColor = blueBGColor;
                        cellNumOfPlayers.threeButton.backgroundColor = whiteBGColor;
                        cellNumOfPlayers.threeButton.layer.borderColor = blueBGColor.CGColor;
                        cellNumOfPlayers.threeButton.titleLabel.textColor = blueBGColor;
                        cellNumOfPlayers.fourButton.backgroundColor = whiteBGColor;
                        cellNumOfPlayers.fourButton.layer.borderColor = blueBGColor.CGColor;
                        cellNumOfPlayers.fourButton.titleLabel.textColor = blueBGColor;
                        cellNumOfPlayers.plusButton.backgroundColor = whiteBGColor;
                        cellNumOfPlayers.plusButton.layer.borderColor = blueBGColor.CGColor;
                        [cellNumOfPlayers.plusButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                        cellNumOfPlayers.plusButton.titleLabel.text = @"+";
                    }
                    cellNumOfPlayers.plusButton.layer.cornerRadius = cellNumOfPlayers.plusButton.frame.size.width/2;
                    cellNumOfPlayers.plusButton.layer.borderColor = borderColor.CGColor;
                    cellNumOfPlayers.plusButton.layer.borderWidth = 1.0f;
                    cellNumOfPlayers.plusButton.layer.masksToBounds = YES;
                    [cellNumOfPlayers.plusButton addTarget:cellNumOfPlayers action:@selector(actionNumberOfPlayersSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    if (cellNumOfPlayers.isOneSelected == NO)
                    {
                        cellNumOfPlayers.oneButton.layer.cornerRadius = cellNumOfPlayers.oneButton.frame.size.width/2;
                        cellNumOfPlayers.oneButton.layer.borderColor = borderColor.CGColor;
                        cellNumOfPlayers.oneButton.layer.masksToBounds = YES;
                        cellNumOfPlayers.oneButton.layer.borderWidth = 1.0f;
                    }
                    //if ()
                    [cellNumOfPlayers.oneButton addTarget:cellNumOfPlayers action:@selector(actionNumberOfPlayersSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cellNumOfPlayers.twoButton.layer.borderColor = borderColor.CGColor;
                    cellNumOfPlayers.twoButton.layer.cornerRadius = cellNumOfPlayers.twoButton.frame.size.width/2;
                    cellNumOfPlayers.twoButton.layer.masksToBounds = YES;
                    cellNumOfPlayers.twoButton.layer.borderWidth = 1.0f;
                    [cellNumOfPlayers.twoButton addTarget:cellNumOfPlayers action:@selector(actionNumberOfPlayersSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cellNumOfPlayers.threeButton.layer.borderColor = borderColor.CGColor;
                    cellNumOfPlayers.threeButton.layer.cornerRadius = cellNumOfPlayers.threeButton.frame.size.width/2;
                    cellNumOfPlayers.threeButton.layer.masksToBounds = YES;
                    cellNumOfPlayers.threeButton.layer.borderWidth = 1.0f;
                    [cellNumOfPlayers.threeButton addTarget:cellNumOfPlayers action:@selector(actionNumberOfPlayersSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cellNumOfPlayers.fourButton.layer.borderColor = borderColor.CGColor;
                    cellNumOfPlayers.fourButton.layer.cornerRadius = cellNumOfPlayers.fourButton.frame.size.width/2;
                    cellNumOfPlayers.fourButton.layer.masksToBounds = YES;
                    cellNumOfPlayers.fourButton.layer.borderWidth = 1.0f;
                    [cellNumOfPlayers.fourButton addTarget:cellNumOfPlayers action:@selector(actionNumberOfPlayersSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM])
                    {
                        [cellNumOfPlayers.yesButton setBackgroundColor:borderColor];
                        [cellNumOfPlayers.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cellNumOfPlayers.noButton setBackgroundColor:[UIColor whiteColor]];
                        [cellNumOfPlayers.noButton setTitleColor:borderColor forState:UIControlStateNormal];
                    }
                    else
                    {
                        [cellNumOfPlayers.noButton setBackgroundColor:borderColor];
                        [cellNumOfPlayers.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cellNumOfPlayers.yesButton setBackgroundColor:[UIColor whiteColor]];
                        [cellNumOfPlayers.yesButton setTitleColor:borderColor forState:UIControlStateNormal];
                    }
                    cellNumOfPlayers.yesButton.layer.borderWidth = 1.0f;
                    cellNumOfPlayers.yesButton.layer.cornerRadius = 9.0f;
                    cellNumOfPlayers.yesButton.layer.masksToBounds = YES;
                    [cellNumOfPlayers.yesButton addTarget:cellNumOfPlayers action:@selector(actionTeamSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cellNumOfPlayers.noButton.layer.borderWidth = 1.0f;
                    cellNumOfPlayers.noButton.layer.cornerRadius = 9.0f;
                    cellNumOfPlayers.noButton.layer.masksToBounds = YES;
                    [cellNumOfPlayers.noButton addTarget:cellNumOfPlayers action:@selector(actionTeamSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                if (self.isNumOfPlayersCellLowerHalfVisible == YES)
                {
                    cellNumOfPlayers.lowerHalfView.hidden = NO;
                }
                else
                {
                    cellNumOfPlayers.lowerHalfView.hidden = YES;
                }
                
                cell = cellNumOfPlayers;
            }
                break;
            case CreateEventCellType_SelectFormat:
            {
                PT_SelectFormatTableViewCell *cellSelectFormat = [tableView dequeueReusableCellWithIdentifier:@"SelectFormat"];
                cellSelectFormat = self.cellFormat;
                if (cellSelectFormat == nil)
                {
                    cellSelectFormat = [[[NSBundle mainBundle] loadNibNamed:@"PT_SelectFormatTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellSelectFormat.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.cellFormat = cellSelectFormat;
                    [cellSelectFormat.formatButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                }
                
                [cellSelectFormat setSychronizationValueforButton];
                cellSelectFormat.formatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                cellSelectFormat.formatButton.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
                
                cellSelectFormat.formatButton.layer.cornerRadius = 2.0;
                
                if (_isEditMode == YES) {
                    
                    PT_StrokePlayListItemModel *model = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFormat];
                    
                    [cellSelectFormat.formatButton setTitle:model.strokeName forState:UIControlStateNormal];
                    
                }else{
               
                self.buttonStrokePlay = cellSelectFormat.formatButton;
                }

                CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
                CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
                
                float x = 0;
                //float w = 0;
                if (self.view.frame.size.height == 480)
                {
                    x = self.view.bounds.size.width/2 + 8;
                }
                else if (self.view.frame.size.height == 568)
                {
                   x = self.view.bounds.size.width/2 + 5;
                   if (self.cellFormatTableWidth == 0)
                   {
                       self.cellFormatTableWidth = cellSelectFormat.formatButton.frame.size.width - 25;
                   }
                }
                else if (self.view.frame.size.height == 667)
                {
                    x = self.view.bounds.size.width/2 + 8;
                    if (self.cellFormatTableWidth == 0)
                    {
                        self.cellFormatTableWidth = cellSelectFormat.formatButton.frame.size.width;
                    }
                }
                else if (self.view.frame.size.height == 736 )
                {
                    x = self.view.bounds.size.width/2 + 8;
                    if (self.cellFormatTableWidth == 0)
                    {
                        self.cellFormatTableWidth = cellSelectFormat.formatButton.frame.size.width;
                    }
                }
                
                float estimatedHeight = [self.arrStrokePlayList count] * 44;
                float actualHeight = 0.0;
                if (estimatedHeight >= (self.view.frame.size.height - 80))
                {
                    actualHeight = self.view.frame.size.height - 80;
                    self.tableStrokes.scrollEnabled = YES;
                }
                else
                {
                    actualHeight = estimatedHeight;
                    self.tableStrokes.scrollEnabled = NO;
                }
                //_viewStroke.frame = CGRectMake(x, rectInSuperview.origin.y + 37, self.cellFormatTableWidth, 180);
                _viewStroke.frame = CGRectMake(0, self.view.frame.size.height - actualHeight, self.view.frame.size.width, actualHeight);
                
                [self.view addSubview:_viewStroke];
                self.tableStrokes.frame = _viewStroke.bounds;
                [_viewStroke addSubview:self.tableStrokes];
                
                [cellSelectFormat.formatButton addTarget:self action:@selector(selectFormatStrokes:) forControlEvents:UIControlEventTouchUpInside];
                
            
                [self.tableStrokes bringToFront];
                cell = cellSelectFormat;
            }
                break;
            case CreateEventCellType_SelectTee:
            {
                PT_SelectTeeTableViewCell *cellSelectTee = [tableView dequeueReusableCellWithIdentifier:@"SelectTee"];
                
                if (cellSelectTee == nil)
                {
                    cellSelectTee = [[[NSBundle mainBundle] loadNibNamed:@"PT_SelectTeeTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellSelectTee.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                 UIColor *blackBGColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0];
                
                if (self.isEditMode == YES)
                {
                    {
                        NSDictionary *dicEditEventTee = self.createventModel.teeId;
                        
                        //MEN
                        NSDictionary *dicMen = dicEditEventTee[@"MenColor"];
                        NSString *mHex = nil;
                        //NSNull *n=[NSNull null];
                        //if ( dicMen == n )
                        {
                            CGFloat r = [dicMen[@"r"] floatValue];
                            CGFloat g = [dicMen[@"g"] floatValue];
                            CGFloat b = [dicMen[@"b"] floatValue];
                            UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                            mHex = [self hexStringFromColor:jColor];
                            
                        }
                        if ([mHex isEqualToString:@"#FFFFFF"])
                        {
                            [cellSelectTee.mButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                            cellSelectTee.mButton.layer.borderColor = blueBGColor.CGColor;
                            
                        }else if ([mHex isEqualToString:@"#C0C0C0"] || [mHex isEqualToString:@"#FFD700"] || [mHex isEqualToString:@"#FFFF00"]){
                            
                            [cellSelectTee.mButton setTitleColor:blackBGColor forState:UIControlStateNormal];
                            cellSelectTee.mButton.layer.borderColor = blackBGColor.CGColor;
                        }
                        else
                        {
                            [cellSelectTee.mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            cellSelectTee.mButton.layer.borderColor = [UIColor clearColor].CGColor;
                        }
                        
                        cellSelectTee.mButton.backgroundColor = [UIColor colorFromHexString:mHex];
                        cellSelectTee.mButton.layer.cornerRadius = cellSelectTee.mButton.frame.size.width/2;
                        cellSelectTee.mButton.layer.borderWidth = 1.0;
                        cellSelectTee.mButton.layer.masksToBounds = YES;
                        [cellSelectTee.mButton setTitle:@"M" forState:UIControlStateNormal];
                        
                        //WOMEN
                        NSLog(@"%@",dicEditEventTee);
                        NSDictionary *dicLadies = dicEditEventTee[@"LadiesColor"];
                        NSString *wHex = nil;
                        //if ( dicLadies == n )
                        {
                            CGFloat r = [dicLadies[@"r"] floatValue];
                            CGFloat g = [dicLadies[@"g"] floatValue];
                            CGFloat b = [dicLadies[@"b"] floatValue];
                            UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                            wHex = [self hexStringFromColor:jColor];
                            
                        }
                        if ([wHex isEqualToString:@"#FFFFFF"])
                        {
                            [cellSelectTee.wButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                            cellSelectTee.wButton.layer.borderColor = blueBGColor.CGColor;
                        }else if ([wHex isEqualToString:@"#C0C0C0"] || [mHex isEqualToString:@"#FFD700"] || [mHex isEqualToString:@"#FFFF00"]){
                            
                            [cellSelectTee.wButton setTitleColor:blackBGColor forState:UIControlStateNormal];
                            cellSelectTee.wButton.layer.borderColor = blackBGColor.CGColor;
                        }

                        else
                        {
                            [cellSelectTee.wButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            cellSelectTee.wButton.layer.borderColor = [UIColor clearColor].CGColor;
                        }
                        cellSelectTee.wButton.backgroundColor = [UIColor colorFromHexString:wHex];
                        cellSelectTee.wButton.layer.cornerRadius = cellSelectTee.wButton.frame.size.width/2;
                        cellSelectTee.wButton.layer.borderWidth = 1.0;
                        cellSelectTee.wButton.layer.masksToBounds = YES;
                        [cellSelectTee.wButton setTitle:@"W" forState:UIControlStateNormal];
                        
                        //JUNIOR
                        NSDictionary *dicJunior = dicEditEventTee[@"JuniorColor"];
                        NSString *jHex = nil;
                        //if ( dicJunior == n )
                        //{
                        CGFloat r = [dicJunior[@"r"] floatValue];
                        CGFloat g = [dicJunior[@"g"] floatValue];
                        CGFloat b = [dicJunior[@"b"] floatValue];
                        UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                        jHex = [self hexStringFromColor:jColor];
                        //}
                        if ([jHex isEqualToString:@"#FFFFFF"])
                        {
                            [cellSelectTee.jButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                            cellSelectTee.jButton.layer.borderColor = blueBGColor.CGColor;
                            
                        }else if ([jHex isEqualToString:@"#C0C0C0"] || [mHex isEqualToString:@"#FFD700"] || [mHex isEqualToString:@"#FFFF00"]){
                            
                            [cellSelectTee.jButton setTitleColor:blackBGColor forState:UIControlStateNormal];
                            cellSelectTee.jButton.layer.borderColor = blackBGColor.CGColor;
                        }

                        else
                        {
                            [cellSelectTee.jButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            cellSelectTee.jButton.layer.borderColor = [UIColor clearColor].CGColor;
                        }
                        cellSelectTee.jButton.backgroundColor = [UIColor colorFromHexString:jHex];
                        cellSelectTee.jButton.layer.cornerRadius = cellSelectTee.jButton.frame.size.width/2;
                        cellSelectTee.jButton.layer.borderWidth = 1.0;
                        cellSelectTee.jButton.layer.masksToBounds = YES;
                        [cellSelectTee.jButton setTitle:@"J" forState:UIControlStateNormal];
                        
                        
                    }
                }
                else
                {
                    cellSelectTee.mButton.layer.cornerRadius = cellSelectTee.mButton.frame.size.width/2;
                    cellSelectTee.mButton.layer.masksToBounds = YES;
                    cellSelectTee.mButton.layer.borderWidth = 1.0f;
                    cellSelectTee.mButton.layer.borderColor = [UIColor clearColor].CGColor;
                    self.menTeeButton = cellSelectTee.mButton;
                    
                    PT_TeeItemModel *modelMen = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getMenTeeModel];
                    if (modelMen != nil &&modelMen.teeColor.length > 0)
                    {
                        [cellSelectTee.mButton setBackgroundColor:[UIColor colorFromHexString:modelMen.teeColor]];
                    }
                    //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForMen:self.menTeeButton.backgroundColor];
                    
                    cellSelectTee.jButton.layer.cornerRadius = cellSelectTee.jButton.frame.size.width/2;
                    cellSelectTee.jButton.layer.masksToBounds = YES;
                    cellSelectTee.jButton.layer.borderWidth = 1.0f;
                    if ([modelMen.teeColor isEqualToString:@"#FFFFFF"])
                    {
                        cellSelectTee.mButton.layer.borderColor = blueBGColor.CGColor;
                        [cellSelectTee.mButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                    }else if ([modelMen.teeColor isEqualToString:@"#C0C0C0"] || [modelMen.teeColor isEqualToString:@"#FFD700"] || [modelMen.teeColor isEqualToString:@"#FFFF00"]){
                        
                        [cellSelectTee.mButton setTitleColor:blackBGColor forState:UIControlStateNormal];
                        cellSelectTee.mButton.layer.borderColor = blackBGColor.CGColor;
                    }

                    else
                    {
                        cellSelectTee.mButton.layer.borderColor = [UIColor clearColor].CGColor;
                        [cellSelectTee.mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                    self.juniorTeeButton = cellSelectTee.jButton;
                    PT_TeeItemModel *modelJunior = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getJuniorTeeModel];
                    if (modelJunior != nil &&modelJunior.teeColor.length > 0)
                    {
                        [cellSelectTee.jButton setBackgroundColor:[UIColor colorFromHexString:modelJunior.teeColor]];
                    }
                    if ([modelJunior.teeColor isEqualToString:@"#FFFFFF"])
                    {
                        cellSelectTee.jButton.layer.borderColor = blueBGColor.CGColor;
                        [cellSelectTee.jButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                    }else if ([modelMen.teeColor isEqualToString:@"#C0C0C0"] || [modelMen.teeColor isEqualToString:@"#FFD700"] || [modelMen.teeColor isEqualToString:@"#FFFF00"]){
                        
                        [cellSelectTee.jButton setTitleColor:blackBGColor forState:UIControlStateNormal];
                        cellSelectTee.jButton.layer.borderColor = blackBGColor.CGColor;
                    }

                    else
                    {
                        cellSelectTee.jButton.layer.borderColor = [UIColor clearColor].CGColor;
                        [cellSelectTee.jButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                    cellSelectTee.wButton.layer.cornerRadius = cellSelectTee.wButton.frame.size.width/2;
                    cellSelectTee.wButton.layer.masksToBounds = YES;
                    cellSelectTee.wButton.layer.borderWidth = 1.0f;
                    self.womenTeeButton = cellSelectTee.wButton;
                    PT_TeeItemModel *modelWomen = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getWomenTeeModel];
                    if (modelWomen != nil &&modelWomen.teeColor.length > 0)
                    {
                        [cellSelectTee.wButton setBackgroundColor:[UIColor colorFromHexString:modelWomen.teeColor]];
                        
                    }
                    if ([modelWomen.teeColor isEqualToString:@"#FFFFFF"])
                    {
                        cellSelectTee.wButton.layer.borderColor = blueBGColor.CGColor;
                        [cellSelectTee.wButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                    }else if ([modelWomen.teeColor isEqualToString:@"#C0C0C0"] || [modelWomen.teeColor isEqualToString:@"#FFD700"] || [modelWomen.teeColor isEqualToString:@"#FFFF00"]){
                        
                        [cellSelectTee.wButton setTitleColor:blackBGColor forState:UIControlStateNormal];
                        cellSelectTee.wButton.layer.borderColor = blackBGColor.CGColor;
                    }
                    else
                    {
                        cellSelectTee.wButton.layer.borderColor = [UIColor clearColor].CGColor;
                        [cellSelectTee.wButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                }
                    [cellSelectTee.mButton addTarget:self action:@selector(actionTeeButtonOptionShow:) forControlEvents:UIControlEventTouchUpInside];
                    [cellSelectTee.jButton addTarget:self action:@selector(actionTeeButtonOptionShow:) forControlEvents:UIControlEventTouchUpInside];
                    [cellSelectTee.wButton addTarget:self action:@selector(actionTeeButtonOptionShow:) forControlEvents:UIControlEventTouchUpInside];

                
                
                cell = cellSelectTee;
            }
                break;
            case CreateEventCellType_EventTime:
            {
                PT_EventTimeTableViewCell *cellEventTime = [tableView dequeueReusableCellWithIdentifier:@"EventTime"];
                
                if (cellEventTime == nil)
                {
                    cellEventTime = [[[NSBundle mainBundle] loadNibNamed:@"PT_EventTimeTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellEventTime.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                [cellEventTime setSychronizationValueforButton];
                cellEventTime.eventTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                //cellEventTime.eventTimeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
                [cellEventTime.eventTimeButton addTarget:self action:@selector(actionSelectTime:) forControlEvents:UIControlEventTouchUpInside];
                if (self.selectedDateTime.length != 0)
                {
                    [cellEventTime.eventTimeButton setTitle:self.selectedDateTime forState:UIControlStateNormal];
                    [self setEventTimeForPreviewEvent:self.selectedDateTime];

                }
                else
                {
                    NSDateFormatter *dateFormatter = [NSDateFormatter new];
                    [dateFormatter setDateFormat:@"dd MMM yyyy - HH:mm"];
                    //[dateFormatter setDateFormat:@"yyyy MM dd - HH:mm"];
                    NSDate *currentDate = [NSDate date];
                    self.selectedDateTime = [[dateFormatter stringFromDate:currentDate] uppercaseString];
                    [cellEventTime.eventTimeButton setTitle:self.selectedDateTime forState:UIControlStateNormal];
                    [self setEventTimeForPreviewEvent:self.selectedDateTime];
                }
                
                cell = cellEventTime;
            }
                break;
            case CreateEventCellType_NoOfHoles:
            {
                PT_NumOfHolesTableViewCell *cellNoOfHoles = [tableView dequeueReusableCellWithIdentifier:@"NoOfHoles"];
                
                if (cellNoOfHoles == nil)
                {
                    cellNoOfHoles = [[[NSBundle mainBundle] loadNibNamed:@"PT_NumOfHolesTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellNoOfHoles.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                cellNoOfHoles.parentController = self;
                
                UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
            
                if (self.isEditMode == YES)
                {
                    cellNoOfHoles.userInteractionEnabled = NO;
                    cellNoOfHoles.nineButton.layer.cornerRadius = cellNoOfHoles.nineButton.frame.size.width/2;
                    cellNoOfHoles.nineButton.layer.borderColor = borderColor.CGColor;
                    [cellNoOfHoles.nineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cellNoOfHoles.nineButton.backgroundColor = borderColor;
                    cellNoOfHoles.nineButton.layer.borderWidth = 1.0;
                    cellNoOfHoles.nineButton.layer.masksToBounds = YES;
                    [cellNoOfHoles.nineButton setTitle:[NSString stringWithFormat:@"%li",self.createventModel.totalHoleNumber] forState:UIControlStateNormal];
                    
                    cellNoOfHoles.eighteenButton.hidden = YES;
                }
                else
                {
                    if (self.isNumberOfHole18Selected == NO)
                    {
                        cellNoOfHoles.nineButton.layer.cornerRadius = cellNoOfHoles.nineButton.frame.size.width/2;
                        cellNoOfHoles.nineButton.layer.borderColor = borderColor.CGColor;
                        [cellNoOfHoles.nineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cellNoOfHoles.nineButton.backgroundColor = borderColor;
                        cellNoOfHoles.nineButton.layer.borderWidth = 1.0;
                        cellNoOfHoles.nineButton.layer.masksToBounds = YES;
                        [cellNoOfHoles.nineButton addTarget:cellNoOfHoles action:@selector(actionNumberOfHolesSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cellNoOfHoles.eighteenButton.layer.cornerRadius = cellNoOfHoles.eighteenButton.frame.size.width/2;
                        cellNoOfHoles.eighteenButton.layer.borderColor = borderColor.CGColor;
                        cellNoOfHoles.eighteenButton.backgroundColor = [UIColor whiteColor];
                        [cellNoOfHoles.eighteenButton setTitleColor:borderColor forState:UIControlStateNormal];
                        cellNoOfHoles.eighteenButton.layer.masksToBounds = YES;
                        cellNoOfHoles.eighteenButton.layer.borderWidth = 1.0f;
                        [cellNoOfHoles.eighteenButton addTarget:cellNoOfHoles action:@selector(actionNumberOfHolesSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else
                    {
                        cellNoOfHoles.nineButton.layer.cornerRadius = cellNoOfHoles.nineButton.frame.size.width/2;
                        cellNoOfHoles.nineButton.layer.borderColor = borderColor.CGColor;
                        [cellNoOfHoles.nineButton setTitleColor:borderColor forState:UIControlStateNormal];
                        cellNoOfHoles.nineButton.backgroundColor = [UIColor whiteColor];
                        cellNoOfHoles.nineButton.layer.borderWidth = 1.0;
                        cellNoOfHoles.nineButton.layer.masksToBounds = YES;
                        [cellNoOfHoles.nineButton addTarget:cellNoOfHoles action:@selector(actionNumberOfHolesSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                        
                        cellNoOfHoles.eighteenButton.layer.cornerRadius = cellNoOfHoles.eighteenButton.frame.size.width/2;
                        cellNoOfHoles.eighteenButton.layer.borderColor = borderColor.CGColor;
                        cellNoOfHoles.eighteenButton.backgroundColor = borderColor;
                        [cellNoOfHoles.eighteenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cellNoOfHoles.eighteenButton.layer.masksToBounds = YES;
                        cellNoOfHoles.eighteenButton.layer.borderWidth = 1.0f;
                        [cellNoOfHoles.eighteenButton addTarget:cellNoOfHoles action:@selector(actionNumberOfHolesSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                }
                
                cellNoOfHoles.parentController = self;
                
                cell = cellNoOfHoles;
            }
                break;
            case CreateEventCellType_EventType:
            {
                PT_EventTypeTableViewCell *cellEventType = [tableView dequeueReusableCellWithIdentifier:@"EventType"];
                
                if (cellEventType == nil)
                {
                    cellEventType = [[[NSBundle mainBundle] loadNibNamed:@"PT_EventTypeTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellEventType.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                UIColor *whiteBGColor = [UIColor whiteColor];
                
                cellEventType.parentVieController = self;
                
                cellEventType.publicButton.layer.cornerRadius = 9.2;
                cellEventType.publicButton.layer.borderColor = borderColor.CGColor;
                cellEventType.publicButton.layer.borderWidth = 1.0;
                [cellEventType.publicButton addTarget:cellEventType action:@selector(actionEventTypeSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                
                cellEventType.privateButton.layer.cornerRadius = 9.2;
                cellEventType.privateButton.layer.borderColor = borderColor.CGColor;
                cellEventType.privateButton.layer.borderWidth = 1.0;
                [cellEventType.privateButton addTarget:cellEventType action:@selector(actionEventTypeSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                
                cellEventType.iButton.layer.cornerRadius = cellEventType.iButton.frame.size.width/2;
                cellEventType.iButton.layer.borderWidth = 1.0;
                cellEventType.iButton.layer.borderColor = borderColor.CGColor;
                cellEventType.iButton.layer.masksToBounds = YES;
                
                if (self.isEditMode == YES)
                {
                    if ([self.createventModel.numberOfPlayers isEqualToString:@"1"] ||
                        [self.createventModel.numberOfPlayers isEqualToString:@"2"] ||
                        [self.createventModel.numberOfPlayers isEqualToString:@"3"] ||
                        [self.createventModel.numberOfPlayers isEqualToString:@"4"])
                    {
                        cellEventType.hidden = YES;
                    }
                    if ([self.createventModel.eventType isEqualToString:@"Public"])
                    {
                        [cellEventType actionEventTypeSelectedForCell:cellEventType.publicButton];
                        [cellEventType.publicButton setTitle:@"PUBLIC" forState:UIControlStateNormal];
                        [cellEventType.privateButton setTitle:@"PRIVATE" forState:UIControlStateNormal];
                        [cellEventType.privateButton setTitleColor:borderColor forState:UIControlStateNormal];
                    }
                    else
                    {
                        [cellEventType actionEventTypeSelectedForCell:cellEventType.privateButton];
                        [cellEventType.publicButton setTitle:@"PUBLIC" forState:UIControlStateNormal];
                        [cellEventType.privateButton setTitle:@"PRIVATE" forState:UIControlStateNormal];
                        [cellEventType.publicButton setTitleColor:borderColor forState:UIControlStateNormal];
                    }
                }
                else{
                    if([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4+"])
                    {
                        [cellEventType.contentView setHidden:NO];
                    }
                    else
                    {
                        [cellEventType.contentView setHidden:YES];
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventType] isEqualToString:PUBLIC])
                    {
                        cellEventType.publicButton.backgroundColor = borderColor;
                        [cellEventType.publicButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
                        cellEventType.privateButton.backgroundColor = whiteBGColor;
                        cellEventType.privateButton.layer.borderColor = borderColor.CGColor;
                        [cellEventType.privateButton setTitleColor:borderColor forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        cellEventType.privateButton.backgroundColor = borderColor;
                        [cellEventType.privateButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
                        cellEventType.publicButton.backgroundColor = whiteBGColor;
                        cellEventType.publicButton.layer.borderColor = borderColor.CGColor;
                        [cellEventType.publicButton setTitleColor:borderColor forState:UIControlStateNormal];
                    }

                }
                //else
                {
                    [cellEventType.iButton addTarget:self action:@selector(actionEventTypeInfo) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                cell = cellEventType;
            }
                break;
            case CreateEventCellType_SelectHoles:
            {
                PT_SelectHolesTableViewCell *cellSelectHoles = [tableView dequeueReusableCellWithIdentifier:@"SelectHoles"];
                
                if (cellSelectHoles == nil)
                {
                    cellSelectHoles = [[[NSBundle mainBundle] loadNibNamed:@"PT_SelectHolesTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellSelectHoles.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                
                if (self.isEditMode == YES)
                {
                    cellSelectHoles.userInteractionEnabled = NO;
                    float width = cellSelectHoles.front9Button.frame.size.width + 5;
                    cellSelectHoles.constraintFront9Width.constant = width;
                    cellSelectHoles.front9Button.layer.cornerRadius = 9.2;
                    cellSelectHoles.front9Button.layer.borderColor = borderColor.CGColor;
                    cellSelectHoles.front9Button.layer.borderWidth = 1.0;
                    [cellSelectHoles.front9Button setTitle:[self.createventModel.holes uppercaseString] forState:UIControlStateNormal];
                    cellSelectHoles.back9Button.hidden = YES;
                    
                }
                else
                {
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getFrontOrBack9 ]isEqualToString:FRONT9]) {
                        
                        cellSelectHoles.front9Button.backgroundColor = borderColor;
                        [cellSelectHoles.front9Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cellSelectHoles.back9Button.backgroundColor = [UIColor whiteColor];
                        cellSelectHoles.back9Button.layer.borderColor = borderColor.CGColor;
                        [cellSelectHoles.back9Button setTitleColor:borderColor forState:UIControlStateNormal];

                    }else{
                        
                        cellSelectHoles.back9Button.backgroundColor = borderColor;
                        [cellSelectHoles.back9Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cellSelectHoles.front9Button.backgroundColor = [UIColor whiteColor];
                        cellSelectHoles.front9Button.layer.borderColor = borderColor.CGColor;
                        [cellSelectHoles.front9Button setTitleColor:borderColor forState:UIControlStateNormal];
                        
                    }
                    
                    cellSelectHoles.front9Button.layer.cornerRadius = 9.2;
                    cellSelectHoles.front9Button.layer.borderColor = borderColor.CGColor;
                    cellSelectHoles.front9Button.layer.borderWidth = 1.0;
                    [cellSelectHoles.front9Button addTarget:cellSelectHoles action:@selector(actionHoleTypeSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    cellSelectHoles.back9Button.layer.cornerRadius = 9.2;
                    cellSelectHoles.back9Button.layer.borderColor = borderColor.CGColor;
                    cellSelectHoles.back9Button.layer.borderWidth = 1.0;
                    [cellSelectHoles.back9Button addTarget:cellSelectHoles action:@selector(actionHoleTypeSelectedForCell:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cellSelectHoles.parentViewController = self;
                }
                
                if (self.isNumberOfHole18Selected == YES)
                {
                    cellSelectHoles.contentView.hidden = YES;
                }
                else
                {
                    cellSelectHoles.contentView.hidden = NO;
                }
                
                cell = cellSelectHoles;
            }
                break;
            case CreateEventCellType_SpotPrize:
            {
                PT_SpotPrizeTableViewCell *cellSpotPrize = [tableView dequeueReusableCellWithIdentifier:@"SelectFormat"];
                cellSpotPrize = self.cellSpotPrizes;
                if (cellSpotPrize == nil)
                {
                    cellSpotPrize = [[[NSBundle mainBundle] loadNibNamed:@"PT_SpotPrizeTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellSpotPrize.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.cellSpotPrizes = cellSpotPrize;
                }
                else
                {
                    
                }
                cellSpotPrize.parentController = self;
                cellSpotPrize.yesButton.layer.borderWidth = 1.0;
                cellSpotPrize.yesButton.layer.cornerRadius = 9.0;
                cellSpotPrize.yesButton.layer.masksToBounds = YES;
                
                cellSpotPrize.noButton.layer.borderWidth = 1.0;
                cellSpotPrize.noButton.layer.cornerRadius = 9.0;
                cellSpotPrize.noButton.layer.masksToBounds = YES;
                
                cellSpotPrize.spotPrizeView.layer.cornerRadius = 3.0;
                cellSpotPrize.spotPrizeView.layer.borderWidth = 0.0;
                cellSpotPrize.spotPrizeView.layer.masksToBounds = YES;
                
                
                
                if (self.isEditMode == YES)
                {
                    cellSpotPrize.userInteractionEnabled = YES;      //Added

                    cellSpotPrize.spotPrizeView.hidden = YES;
                    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                    if (self.createventModel.isSpot == YES )   //Changes
                    {
                        [cellSpotPrize showSpotOptionsForNumberOfHoles:self.createventModel.totalHoleNumber];
                        cellSpotPrize.lineView.hidden = YES;
                        cellSpotPrize.isEditMode = YES;
                        //cellSpotPrize.spotPrizeView.hidden = NO;
                        cellSpotPrize.yesButton.backgroundColor = blueBGColor;
                        [cellSpotPrize.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cellSpotPrize.noButton.hidden = NO;        //Changes
                        
                        
                        //Added
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"4+"])
                        {
                            if (self.isSpotPrizeSelected == YES)
                            {
                                cellSpotPrize.spotPrizeView.hidden = NO;
                            }
                            else
                            {
                                cellSpotPrize.spotPrizeView.hidden = YES;
                            }
                            [cellSpotPrize.contentView setHidden:NO];
                        }
                        else
                        {
                            [cellSpotPrize.contentView setHidden:YES];
                        }
                        
                        NSInteger countClosestToPin = 0;
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] length] > 0)
                        {
                            
                            countClosestToPin++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] length] > 0)
                        {
                            
                            countClosestToPin++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] length] > 0)
                        {
                            countClosestToPin++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] length] > 0)
                        {
                            
                            countClosestToPin++;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            switch (countClosestToPin) {
                                case 0:
                                {
                                    cellSpotPrize.closestToPinButton3.hidden = NO;
                                    [cellSpotPrize.closestToPinButton3 setTitle:@"-" forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton4.hidden = YES;
                                    cellSpotPrize.closestToPinButton2.hidden = YES;
                                    cellSpotPrize.closestToPinButton1.hidden = YES;
                                }
                                    break;
                                    
                                case 1:
                                {
                                    
                                    cellSpotPrize.closestToPinButton3.hidden = NO;
                                    [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton4.hidden = YES;
                                    cellSpotPrize.closestToPinButton2.hidden = YES;
                                    cellSpotPrize.closestToPinButton1.hidden = YES;
                                }
                                    break;
                                case 2:
                                {
                                    cellSpotPrize.closestToPinButton4.hidden = NO;
                                    [cellSpotPrize.closestToPinButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton3.hidden = NO;
                                    [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton2.hidden = YES;
                                    cellSpotPrize.closestToPinButton1.hidden = YES;
                                }
                                    break;
                                case 3:
                                {
                                    cellSpotPrize.closestToPinButton4.hidden = NO;
                                    [cellSpotPrize.closestToPinButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton3.hidden = NO;
                                    [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton2.hidden = NO;
                                    [cellSpotPrize.closestToPinButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton1.hidden = YES;
                                }
                                    break;
                                case 4:
                                {
                                    cellSpotPrize.closestToPinButton4.hidden = NO;
                                    [cellSpotPrize.closestToPinButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton3.hidden = NO;
                                    [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton2.hidden = NO;
                                    [cellSpotPrize.closestToPinButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.closestToPinButton1.hidden = NO;
                                    [cellSpotPrize.closestToPinButton1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                                }
                                    break;
                            }
                        });
                        
                        NSInteger countLongDrive = 0;
                        //Long Drive
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] length] > 0)
                        {
                            
                            countLongDrive++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] length] > 0)
                        {
                            
                            countLongDrive++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] length] > 0)
                        {
                            
                            countLongDrive++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] length] > 0)
                        {
                            
                            countLongDrive++;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            switch (countLongDrive) {
                                case 0:
                                {
                                    cellSpotPrize.longDriveButton3.hidden = NO;
                                    [cellSpotPrize.longDriveButton3 setTitle:@"-" forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton4.hidden = YES;
                                    cellSpotPrize.longDriveButton2.hidden = YES;
                                    cellSpotPrize.longDriveButton1.hidden = YES;
                                }
                                    break;
                                    
                                case 1:
                                {
                                    
                                    cellSpotPrize.longDriveButton3.hidden = NO;
                                    [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton4.hidden = YES;
                                    cellSpotPrize.longDriveButton2.hidden = YES;
                                    cellSpotPrize.longDriveButton1.hidden = YES;
                                }
                                    break;
                                case 2:
                                {
                                    cellSpotPrize.longDriveButton4.hidden = NO;
                                    [cellSpotPrize.longDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton3.hidden = NO;
                                    [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton2.hidden = YES;
                                    cellSpotPrize.longDriveButton1.hidden = YES;
                                }
                                    break;
                                case 3:
                                {
                                    cellSpotPrize.longDriveButton4.hidden = NO;
                                    [cellSpotPrize.longDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton3.hidden = NO;
                                    [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton2.hidden = NO;
                                    [cellSpotPrize.longDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton1.hidden = YES;
                                }
                                    break;
                                case 4:
                                {
                                    cellSpotPrize.longDriveButton4.hidden = NO;
                                    [cellSpotPrize.longDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton3.hidden = NO;
                                    [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton2.hidden = NO;
                                    [cellSpotPrize.longDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.longDriveButton1.hidden = NO;
                                    [cellSpotPrize.longDriveButton1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                                }
                                    break;
                            }
                        });
                        
                        NSInteger countStraightDrive = 0;
                        //Straight Drive
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] length] > 0)
                        {
                            
                            countStraightDrive++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] length] > 0)
                        {
                            countStraightDrive++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] length] > 0)
                        {
                            countStraightDrive++;
                        }
                        
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] length] > 0)
                        {
                            countStraightDrive++;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            switch (countStraightDrive) {
                                case 0:
                                {
                                    cellSpotPrize.straightDriveButton3.hidden = NO;
                                    [cellSpotPrize.straightDriveButton3 setTitle:@"-" forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton4.hidden = YES;
                                    cellSpotPrize.straightDriveButton2.hidden = YES;
                                    cellSpotPrize.straightDriveButton1.hidden = YES;
                                }
                                    break;
                                    
                                case 1:
                                {
                                    
                                    cellSpotPrize.straightDriveButton3.hidden = NO;
                                    [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton4.hidden = YES;
                                    cellSpotPrize.straightDriveButton2.hidden = YES;
                                    cellSpotPrize.straightDriveButton1.hidden = YES;
                                }
                                    break;
                                case 2:
                                {
                                    cellSpotPrize.straightDriveButton4.hidden = NO;
                                    [cellSpotPrize.straightDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton3.hidden = NO;
                                    [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton2.hidden = YES;
                                    cellSpotPrize.straightDriveButton1.hidden = YES;
                                }
                                    break;
                                case 3:
                                {
                                    cellSpotPrize.straightDriveButton4.hidden = NO;
                                    [cellSpotPrize.straightDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton3.hidden = NO;
                                    [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton2.hidden = NO;
                                    [cellSpotPrize.straightDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton1.hidden = YES;
                                }
                                    break;
                                case 4:
                                {
                                    cellSpotPrize.straightDriveButton4.hidden = NO;
                                    [cellSpotPrize.straightDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton3.hidden = NO;
                                    [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton2.hidden = NO;
                                    [cellSpotPrize.straightDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] forState:UIControlStateNormal];
                                    
                                    cellSpotPrize.straightDriveButton1.hidden = NO;
                                    [cellSpotPrize.straightDriveButton1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                                }
                                    break;
                            }
                        });
                        

                        
                        /*
                        if ([self.createventModel.closestPin count] > 0)
                        {
                            for (NSInteger counter = 0; counter < [self.createventModel.closestPin count]; counter++) {
                                NSDictionary *dicSpot = self.createventModel.closestPin[counter];
                                switch (counter) {
                                        
                                    case 0:
                                    {
                                        [cellSpotPrize.closestToPinButton4 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.closestToPinButton3.hidden = YES;
                                        cellSpotPrize.closestToPinButton2.hidden = YES;
                                        cellSpotPrize.closestToPinButton1.hidden = YES;
                                    }
                                        break;
                                    case 1:
                                    {
                                        [cellSpotPrize.closestToPinButton3 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.closestToPinButton3.hidden = NO;
                                        cellSpotPrize.closestToPinButton2.hidden = YES;
                                        cellSpotPrize.closestToPinButton1.hidden = YES;
                                    }
                                        break;
                                    case 2:
                                    {
                                        [cellSpotPrize.closestToPinButton2 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.closestToPinButton2.hidden = NO;
                                        cellSpotPrize.closestToPinButton1.hidden = YES;
                                    }
                                        break;
                                    case 4:
                                    {
                                        [cellSpotPrize.closestToPinButton1 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        
                                        cellSpotPrize.closestToPinButton1.hidden = NO;
                                    }
                                        break;
                                        
                                }
                            }
                        }
                        else
                        {
                            [cellSpotPrize hideClosestToPin];
                        }
                        
                        if ([self.createventModel.longDrive count] > 0)
                        {
                            for (NSInteger counter = 0; counter < [self.createventModel.longDrive count]; counter++) {
                                NSDictionary *dicSpot = self.createventModel.longDrive[counter];
                                switch (counter) {
                                        
                                    case 0:
                                    {
                                        [cellSpotPrize.longDriveButton4 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.longDriveButton3.hidden = YES;
                                        cellSpotPrize.longDriveButton2.hidden = YES;
                                        cellSpotPrize.longDriveButton1.hidden = YES;
                                    }
                                        break;
                                    case 1:
                                    {
                                        [cellSpotPrize.longDriveButton3 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.longDriveButton3.hidden = NO;
                                        cellSpotPrize.longDriveButton2.hidden = YES;
                                        cellSpotPrize.longDriveButton1.hidden = YES;
                                    }
                                        break;
                                    case 2:
                                    {
                                        [cellSpotPrize.longDriveButton2 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.longDriveButton2.hidden = NO;
                                        cellSpotPrize.longDriveButton1.hidden = YES;
                                    }
                                        break;
                                    case 4:
                                    {
                                        [cellSpotPrize.longDriveButton1 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        
                                        cellSpotPrize.longDriveButton1.hidden = NO;
                                    }
                                        break;
                                        
                                }
                            }
                        }
                        else
                        {
                            [cellSpotPrize hideLongDrive];
                        }
                        if ([self.createventModel.straightDrive count] > 0)
                        {
                            for (NSInteger counter = 0; counter < [self.createventModel.straightDrive count]; counter++) {
                                NSDictionary *dicSpot = self.createventModel.straightDrive[counter];
                                switch (counter) {
                                        
                                    case 0:
                                    {
                                        [cellSpotPrize.straightDriveButton4 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.straightDriveButton3.hidden = YES;
                                        cellSpotPrize.straightDriveButton2.hidden = YES;
                                        cellSpotPrize.straightDriveButton1.hidden = YES;
                                    }
                                        break;
                                    case 1:
                                    {
                                        [cellSpotPrize.straightDriveButton3 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.straightDriveButton3.hidden = NO;
                                        cellSpotPrize.straightDriveButton2.hidden = YES;
                                        cellSpotPrize.straightDriveButton1.hidden = YES;
                                    }
                                        break;
                                    case 2:
                                    {
                                        [cellSpotPrize.straightDriveButton2 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        cellSpotPrize.straightDriveButton2.hidden = NO;
                                        cellSpotPrize.straightDriveButton1.hidden = YES;
                                    }
                                        break;
                                    case 4:
                                    {
                                        [cellSpotPrize.straightDriveButton1 setTitle:[NSString stringWithFormat:@"%@",dicSpot[@"hole_number"]] forState:UIControlStateNormal];
                                        
                                        cellSpotPrize.straightDriveButton1.hidden = NO;
                                    }
                                        break;
                                        
                                }
                            }
                        }
                        else
                        {
                            [cellSpotPrize hideStraightDrive];
                        }
                        */
                        
                    }
                    else
                    {
                        cellSpotPrize.contentView.hidden = YES;
                        cellSpotPrize.spotPrizeView.hidden = YES;
                        cellSpotPrize.yesButton.backgroundColor = blueBGColor;
                        [cellSpotPrize.yesButton setTitle:@"NO" forState:UIControlStateNormal];
                        [cellSpotPrize.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cellSpotPrize.noButton.hidden = YES;
                        cellSpotPrize.lineView.hidden = YES;
                    }
                }
                else{
                    
                    cellSpotPrize.userInteractionEnabled = YES;
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers]isEqualToString:@"4+"])
                    {
                        if (self.isSpotPrizeSelected == YES)
                        {
                            cellSpotPrize.spotPrizeView.hidden = NO;
                        }
                        else
                        {
                            cellSpotPrize.spotPrizeView.hidden = YES;
                        }
                        [cellSpotPrize.contentView setHidden:NO];
                    }
                    else
                    {
                        [cellSpotPrize.contentView setHidden:YES];
                    }
                    
                    NSInteger countClosestToPin = 0;
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] length] > 0)
                    {
                        
                        countClosestToPin++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] length] > 0)
                    {
                        
                        countClosestToPin++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] length] > 0)
                    {
                        countClosestToPin++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] length] > 0)
                    {
                        
                        countClosestToPin++;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        switch (countClosestToPin) {
                            case 0:
                            {
                                cellSpotPrize.closestToPinButton3.hidden = NO;
                                [cellSpotPrize.closestToPinButton3 setTitle:@"-" forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton4.hidden = YES;
                                cellSpotPrize.closestToPinButton2.hidden = YES;
                                cellSpotPrize.closestToPinButton1.hidden = YES;
                            }
                                break;
                                
                            case 1:
                            {
                                
                                cellSpotPrize.closestToPinButton3.hidden = NO;
                                [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton4.hidden = YES;
                                cellSpotPrize.closestToPinButton2.hidden = YES;
                                cellSpotPrize.closestToPinButton1.hidden = YES;
                            }
                                break;
                            case 2:
                            {
                                cellSpotPrize.closestToPinButton4.hidden = NO;
                                [cellSpotPrize.closestToPinButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton3.hidden = NO;
                                [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton2.hidden = YES;
                                cellSpotPrize.closestToPinButton1.hidden = YES;
                            }
                                break;
                            case 3:
                            {
                                cellSpotPrize.closestToPinButton4.hidden = NO;
                                [cellSpotPrize.closestToPinButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton3.hidden = NO;
                                [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton2.hidden = NO;
                                [cellSpotPrize.closestToPinButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton1.hidden = YES;
                            }
                                break;
                            case 4:
                            {
                                cellSpotPrize.closestToPinButton4.hidden = NO;
                                [cellSpotPrize.closestToPinButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData4] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton3.hidden = NO;
                                [cellSpotPrize.closestToPinButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData3] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton2.hidden = NO;
                                [cellSpotPrize.closestToPinButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.closestToPinButton1.hidden = NO;
                                [cellSpotPrize.closestToPinButton1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData1] forState:UIControlStateNormal];
                            }
                                break;
                        }
                    });
                    
                    NSInteger countLongDrive = 0;
                    //Long Drive
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] length] > 0)
                    {
                        
                        countLongDrive++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] length] > 0)
                    {
                        
                        countLongDrive++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] length] > 0)
                    {
                        
                        countLongDrive++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] length] > 0)
                    {
                        
                        countLongDrive++;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        switch (countLongDrive) {
                            case 0:
                            {
                                cellSpotPrize.longDriveButton3.hidden = NO;
                                [cellSpotPrize.longDriveButton3 setTitle:@"-" forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton4.hidden = YES;
                                cellSpotPrize.longDriveButton2.hidden = YES;
                                cellSpotPrize.longDriveButton1.hidden = YES;
                            }
                                break;
                                
                            case 1:
                            {
                                
                                cellSpotPrize.longDriveButton3.hidden = NO;
                                [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton4.hidden = YES;
                                cellSpotPrize.longDriveButton2.hidden = YES;
                                cellSpotPrize.longDriveButton1.hidden = YES;
                            }
                                break;
                            case 2:
                            {
                                cellSpotPrize.longDriveButton4.hidden = NO;
                                [cellSpotPrize.longDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton3.hidden = NO;
                                [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton2.hidden = YES;
                                cellSpotPrize.longDriveButton1.hidden = YES;
                            }
                                break;
                            case 3:
                            {
                                cellSpotPrize.longDriveButton4.hidden = NO;
                                [cellSpotPrize.longDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton3.hidden = NO;
                                [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton2.hidden = NO;
                                [cellSpotPrize.longDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton1.hidden = YES;
                            }
                                break;
                            case 4:
                            {
                                cellSpotPrize.longDriveButton4.hidden = NO;
                                [cellSpotPrize.longDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive4] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton3.hidden = NO;
                                [cellSpotPrize.longDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive3] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton2.hidden = NO;
                                [cellSpotPrize.longDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.longDriveButton1.hidden = NO;
                                [cellSpotPrize.longDriveButton1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeLongDrive1] forState:UIControlStateNormal];
                            }
                                break;
                        }
                    });
                    
                    NSInteger countStraightDrive = 0;
                    //Straight Drive
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] length] > 0)
                    {
                        
                        countStraightDrive++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] length] > 0)
                    {
                        countStraightDrive++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] length] > 0)
                    {
                        countStraightDrive++;
                    }
                    
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] length] > 0)
                    {
                        countStraightDrive++;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        switch (countStraightDrive) {
                            case 0:
                            {
                                cellSpotPrize.straightDriveButton3.hidden = NO;
                                [cellSpotPrize.straightDriveButton3 setTitle:@"-" forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton4.hidden = YES;
                                cellSpotPrize.straightDriveButton2.hidden = YES;
                                cellSpotPrize.straightDriveButton1.hidden = YES;
                            }
                                break;
                                
                            case 1:
                            {
                                
                                cellSpotPrize.straightDriveButton3.hidden = NO;
                                [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton4.hidden = YES;
                                cellSpotPrize.straightDriveButton2.hidden = YES;
                                cellSpotPrize.straightDriveButton1.hidden = YES;
                            }
                                break;
                            case 2:
                            {
                                cellSpotPrize.straightDriveButton4.hidden = NO;
                                [cellSpotPrize.straightDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton3.hidden = NO;
                                [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton2.hidden = YES;
                                cellSpotPrize.straightDriveButton1.hidden = YES;
                            }
                                break;
                            case 3:
                            {
                                cellSpotPrize.straightDriveButton4.hidden = NO;
                                [cellSpotPrize.straightDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton3.hidden = NO;
                                [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton2.hidden = NO;
                                [cellSpotPrize.straightDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton1.hidden = YES;
                            }
                                break;
                            case 4:
                            {
                                cellSpotPrize.straightDriveButton4.hidden = NO;
                                [cellSpotPrize.straightDriveButton4 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive4] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton3.hidden = NO;
                                [cellSpotPrize.straightDriveButton3 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive3] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton2.hidden = NO;
                                [cellSpotPrize.straightDriveButton2 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive2] forState:UIControlStateNormal];
                                
                                cellSpotPrize.straightDriveButton1.hidden = NO;
                                [cellSpotPrize.straightDriveButton1 setTitle:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeStraightDrive1] forState:UIControlStateNormal];
                            }
                                break;
                        }
                    });
                    
                }
                
                if (self.isNumberOfHole18Selected == NO)
                {
                    [cellSpotPrize showSpotOptionsForNumberOfHoles:9];
                }
                else
                {
                    [cellSpotPrize showSpotOptionsForNumberOfHoles:18];
                }
                
                cellSpotPrize.closestToPinButton1.tag = ClosestPin1Tag;
                cellSpotPrize.closestToPinButton2.tag = ClosestPin2Tag;
                cellSpotPrize.closestToPinButton3.tag = ClosestPin3Tag;
                cellSpotPrize.closestToPinButton4.tag = ClosestPin4Tag;
                
                [cellSpotPrize.closestToPinButton1 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.closestToPinButton2 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.closestToPinButton3 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.closestToPinButton4 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                
                cellSpotPrize.longDriveButton1.tag = LongDrive1Tag;
                cellSpotPrize.longDriveButton2.tag = LongDrive2Tag;
                cellSpotPrize.longDriveButton3.tag = LongDrive3Tag;
                cellSpotPrize.longDriveButton4.tag = LongDrive4Tag;
                
                [cellSpotPrize.longDriveButton1 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.longDriveButton2 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.longDriveButton3 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.longDriveButton4 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                
                cellSpotPrize.straightDriveButton1.tag = StraightDrive1Tag;
                cellSpotPrize.straightDriveButton2.tag = StraightDrive2Tag;
                cellSpotPrize.straightDriveButton3.tag = StraightDrive3Tag;
                cellSpotPrize.straightDriveButton4.tag = StraightDrive4Tag;
                
                [cellSpotPrize.straightDriveButton1 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.straightDriveButton2 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.straightDriveButton3 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                [cellSpotPrize.straightDriveButton4 addTarget:self action:@selector(actionSpotPrizeButton:) forControlEvents:UIControlEventTouchUpInside];
                //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setSpotPrizeStraightDrive:cellSpotPrize.straightDriveButton.titleLabel.text];
                
                
                cell = cellSpotPrize;
            }
                break;
            case CreateEventCellType_ScoreScreen:
            {
                UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                UIColor *whiteBGColor = [UIColor whiteColor];
                PT_EnterScoreTableViewCell *cellEnterScoreScreen = [tableView dequeueReusableCellWithIdentifier:@"SelectFormat"];
                cellEnterScoreScreen = _scorerCell;
                
                if (cellEnterScoreScreen == nil)
                {
                    cellEnterScoreScreen = [[[NSBundle mainBundle] loadNibNamed:@"PT_EnterScoreTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cellEnterScoreScreen.selectionStyle = UITableViewCellSelectionStyleNone;
                    _scorerCell = cellEnterScoreScreen;
                }
                cell = cellEnterScoreScreen;
                if (self.isEditMode == NO)
                {
                    cellEnterScoreScreen.parentController = self;
                    if ([[PT_PreviewEventSingletonModel sharedPreviewEvent] getIsScorerTypeRequired] == YES)
                    {
                        [cellEnterScoreScreen.contentView setHidden:NO];
                    }
                    else
                    {
                        [cellEnterScoreScreen.contentView setHidden:YES];
                    }
                    if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getScorerEntryType] isEqualToString:singleScorerStatic])
                    {
                        cellEnterScoreScreen.singleButton.backgroundColor = blueBGColor;
                        [cellEnterScoreScreen.singleButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
                        cellEnterScoreScreen.singleButton.titleLabel.textColor = [UIColor whiteColor];
                        cellEnterScoreScreen.multiButton.backgroundColor = whiteBGColor;
                        cellEnterScoreScreen.multiButton.layer.borderColor = blueBGColor.CGColor;
                        [cellEnterScoreScreen.multiButton setTitleColor:blueBGColor forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                        cellEnterScoreScreen.multiButton.backgroundColor = blueBGColor;
                        [cellEnterScoreScreen.multiButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
                        cellEnterScoreScreen.singleButton.backgroundColor = whiteBGColor;
                        cellEnterScoreScreen.singleButton.layer.borderColor = blueBGColor.CGColor;
                        cellEnterScoreScreen.singleButton.titleLabel.textColor = blueBGColor;
                    }
                    cellEnterScoreScreen.singleButton.layer.borderWidth = 1.0;
                    cellEnterScoreScreen.singleButton.layer.cornerRadius = 9.0;
                    cellEnterScoreScreen.singleButton.layer.masksToBounds = YES;
                    
                    cellEnterScoreScreen.multiButton.layer.borderWidth = 1.0;
                    cellEnterScoreScreen.multiButton.layer.cornerRadius = 9.0;
                    cellEnterScoreScreen.multiButton.layer.masksToBounds = YES;
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"1"])
                        {
                            cell.hidden = YES;
                            cell.contentView.hidden = YES;
                            _scorerCell.hidden = YES;
                        }
                        //else if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4"] &&
                          //      [[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam]isEqualToString:TEAM])
                        PT_StrokePlayListItemModel *strokeModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFormat];
                        NSInteger formatId = strokeModel.strokeId;
                        if (formatId == FormatAutoPressId ||
                            formatId == Format420Id||
                            formatId == FormatMatchPlayId ||
                            formatId == Format21Id ||
                            formatId == FormatVegasId)
                        {
                            cell.hidden = YES;
                            cell.contentView.hidden = YES;
                            _scorerCell.hidden = YES;
                            [self setScorerTypeForPreviewEvent:singleScorerStatic];
                        }
                        
                        else
                        {
                            cell.hidden = NO;
                            _scorerCell.hidden = NO;
                        }

                    });
                }
                else
                {
                    
                    if ([self.createventModel.numberOfPlayers isEqualToString:@"2"]||
                        [self.createventModel.numberOfPlayers isEqualToString:@"3"]||
                        [self.createventModel.numberOfPlayers isEqualToString:@"4"])
                    {
                        cell.hidden = YES;
                        _scorerCell.hidden = YES;
                    }
                    else
                    {
                        cell.hidden = YES;
                        _scorerCell.hidden = YES;
                        
                    }
                    
                    cellEnterScoreScreen.singleButton.layer.borderWidth = 1.0;
                    cellEnterScoreScreen.singleButton.layer.cornerRadius = 9.0;
                    cellEnterScoreScreen.singleButton.layer.masksToBounds = YES;
                    
                    cellEnterScoreScreen.multiButton.layer.borderWidth = 1.0;
                    cellEnterScoreScreen.multiButton.layer.cornerRadius = 9.0;
                    cellEnterScoreScreen.multiButton.layer.masksToBounds = YES;
                    
                    if (self.createventModel.isSingleScreen == YES)
                    {
                        cellEnterScoreScreen.multiButton.hidden = YES;
                        cellEnterScoreScreen.singleButton.userInteractionEnabled = NO;
                        
                    }
                    else
                    {
                        cellEnterScoreScreen.multiButton.hidden = YES;
                        cellEnterScoreScreen.singleButton.userInteractionEnabled = NO;
                        [cellEnterScoreScreen.singleButton setTitle:@"MULTI" forState:UIControlStateNormal];
                    }
                    if ([self.createventModel.numberOfPlayers isEqualToString:@"4+"] ||
                        [self.createventModel.numberOfPlayers isEqualToString:@"1"])
                    {
                        cellEnterScoreScreen.hidden = YES;
                    }
                }
                
                
                
            }
                break;
                
        }
        //    separator.frame = CGRectMake(4, cell.contentView.frame.size.height - 2, cell.contentView.frame.size.width-4, 1);
        //    [cell.contentView addSubview:separator];
        return cell;

    }
    else
    {
        
        static NSString *identifierStrokes = @"StrokesIdentifier";
        
        __block PT_StrokesTableViewCell *cellStrokes = [tableView dequeueReusableCellWithIdentifier:identifierStrokes];
        
        if (cellStrokes == nil)
        {
            cellStrokes = [[[NSBundle mainBundle] loadNibNamed:@"PT_StrokesTableViewCell" owner:self options:nil] objectAtIndex:0];
            cellStrokes.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.arrStrokePlayList count] > 0)
            {
                PT_StrokePlayListItemModel *model = self.arrStrokePlayList[indexPath.row];
                cellStrokes.strokeName.text = model.strokeName;
                
                
                //i Button
                //UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                UIColor *borderColor = [UIColor whiteColor];
                cellStrokes.iButton.tag = indexPath.row;
                cellStrokes.iButton.layer.borderColor = borderColor.CGColor;
                cellStrokes.iButton.layer.borderWidth = 1.0;
                cellStrokes.iButton.layer.cornerRadius = cellStrokes.iButton.frame.size.width/2;
                cellStrokes.iButton.layer.masksToBounds = YES;
                [cellStrokes.iButton setTitleColor:borderColor forState:UIControlStateNormal];
                [cellStrokes.iButton addTarget:self action:@selector(formatInfo:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cellStrokes setNeedsDisplay];
        });
        
        
        return cellStrokes;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableStrokes)
    {
        self.viewStroke.hidden = YES;
        
        PT_StrokePlayListItemModel *model = self.arrStrokePlayList[indexPath.row];
        [self.cellFormat.formatButton setTitle:model.strokeName forState:UIControlStateNormal];
        [self setFormatForPreviewEvent:model];
        
        if (model.strokeId == Format21Id || model.strokeId == Format420Id || model.strokeId == FormatVegasId || model.strokeId == FormatAutoPressId || model.strokeId == FormatMatchPlayId)
        {
            [self setScorerTypeForPreviewEvent:singleScorerStatic];
        }
        
        [self.tableOptions reloadData];
    }
}

#pragma mark - TExtField Delegate

-(void)formatInfo:(UIButton *)sender
{
    
    PT_StrokePlayListItemModel *model = self.arrStrokePlayList[sender.tag];

    for (UIView *views in self.eventTypeInfoView.subviews)
    {
        [views removeFromSuperview];
    }
    
   // if (_formatInfo == nil)
    {
        _formatInfo = [[[NSBundle mainBundle] loadNibNamed:@"PT_FormatInfo" owner:self options:nil] firstObject];
        _formatInfo.formatNameLbl.text = model.strokeName;
        _formatInfo.descriptionLbl.attributedText = model.descriptionText;
         [_formatInfo.closeBtn addTarget:self action:@selector(closeFormatInfo) forControlEvents:UIControlEventTouchUpInside];
        _formatInfo.frame = self.eventTypeInfoView.bounds;
        [self.eventTypeInfoView addSubview:_formatInfo];
        
       
    }
    self.eventTypeInfoView.layer.cornerRadius = 3.0;
    self.eventTypeInfoView.layer.borderWidth = 1.0;
    self.eventTypeInfoView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.eventTypeInfoView.layer.masksToBounds = YES;
    
    self.eventTypeInfoBGView.hidden = NO;
    self.viewStroke.hidden = YES;


}
-(void)closeFormatInfo
{
    self.eventTypeInfoBGView.hidden = YES;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.placeholder = nil;
    [self actionDatePickerDone];
    self.teeView.hidden = YES;
    self.viewStroke.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        UIColor *color = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
        NSString *displayName = [[MGUserDefaults sharedDefault] getDisplayName];
        displayName = [[displayName stringByAppendingString:@"'s Event"] uppercaseString];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:displayName attributes:@{NSForegroundColorAttributeName: color}];
        self.selectedEvent = [displayName uppercaseString];
         textField.text = self.selectedEvent;
        [self setEventNameForPreviewEvent:displayName];
    }
    else
    {
        self.selectedEvent = [textField.text uppercaseString];
        textField.text = self.selectedEvent;
        [self setEventNameForPreviewEvent:[textField.text uppercaseString]];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length != 0)
    {
        [self setEventNameForPreviewEvent:textField.text];
    }
    self.selectedEvent = [textField.text uppercaseString];
    textField.text = self.selectedEvent;
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Preview Event Actions

- (void)setEventNameForPreviewEvent:(NSString *)eventName
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setEventName:eventName];

}

- (void)setGolfCourseForPreviewEvent:(PT_SelectGolfCourseModel *)golfCourse
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setGolfCourse:golfCourse];
}

- (void)setNumberOfPlayerForPreviewEvent:(NSString *)numberOfPlayers
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfPlayers:numberOfPlayers];
}

- (void)setIndividualOrTeamForPreviewEvent:(NSString *)individualOrTeam
{
    
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setindividualOrTeam:individualOrTeam];
    if (self.isLoadedFirstTime == NO)
    {
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getNumberOfPlayers] isEqualToString:@"4"])
        {
            [self fetchStrokesForNumberOfPlayers:@"4"];
        }
        
        
        self.isLoadedFirstTime = NO;
    }
    
    self.isLoadedFirstTime = NO;
    
}

- (void)setFormatForPreviewEvent:(PT_StrokePlayListItemModel *)format
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setFormat:format];
}

- (void)setEventTimeForPreviewEvent:(NSString *)time
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setEventTime:time];
}

- (void)setNoOfHolesForPreviewEvent:(NSString *)holes
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setNumberOfHoles:holes];
}

- (void)setEventTypeForPreviewevent:(NSString *)type
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setEventType:type];
}

- (void)setIs18HolesSelectedForPreviewEvent:(BOOL)isSelected
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setIs18HolesSelected:isSelected];
}

- (void)setPublicOrPrivateForPreviewEvent:(NSString *)type
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setPublicOrPrivate:type];
}

- (void)setFRontOrBack9ForPreviewEvent:(NSString *)type
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setFrontOrBack9:type];
}

- (void)setIsSpotPrizeForPreviewEvent:(BOOL)isSelected
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setIsSpotPrize:isSelected];
    [self.tableOptions reloadData];
}

- (void)setScorerTypeForPreviewEvent:(NSString *)type
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setScorerEntryType:type];
    //[self.tableOptions reloadData];
}

- (void)setIsScorerTypeForPreviewEvent:(BOOL)type
{
    [[PT_PreviewEventSingletonModel sharedPreviewEvent] setIsScorerTypeRequired:type];
}

#pragma mark action events of buttons

- (void)actionEventTypeInfo
{
    for (UIView *views in self.eventTypeInfoView.subviews)
    {
        [views removeFromSuperview];
    }
    //if (_info == nil)
    {
        _info = [[[NSBundle mainBundle] loadNibNamed:@"PT_EventTypeInfo" owner:self options:nil] firstObject];
        _info.frame = self.eventTypeInfoView.bounds;
        [self.eventTypeInfoView addSubview:_info];
    }
    self.eventTypeInfoView.layer.cornerRadius = 3.0;
    self.eventTypeInfoView.layer.borderWidth = 1.0;
    self.eventTypeInfoView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.eventTypeInfoView.layer.masksToBounds = YES;

    self.eventTypeInfoBGView.hidden = NO;
}

- (void)actionSelectTime:(UIButton*)sender
{
    self.datePicker.hidden = NO;
    self.toolBar.hidden = NO;
    self.datePickerBGView.hidden = NO;
    self.teeView.hidden = YES;
    self.viewStroke.hidden = YES;
    
    [self.textEventName resignFirstResponder];
    
    self.eventTimeCurrentButton = sender;
}

- (IBAction)actionDatePickerDone
{
    self.datePicker.hidden = YES;
    self.toolBar.hidden = YES;
    self.datePickerBGView.hidden = YES;
    
    if (_isEditMode == YES) {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        //[dateFormatter setDateFormat:@"yyyy MM dd - HH:mm"];
        [dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm"];
        
        NSLog(@"DOB selected: %@",[dateFormatter stringFromDate:_datePicker.date]);
        NSString *selectedDate = [dateFormatter stringFromDate:_datePicker.date];
        
        if (selectedDate.length > 0)
        {
            self.selectedDateTime = [selectedDate uppercaseString];
            [self setEventTimeForPreviewEvent:self.selectedDateTime];
            [self.eventTimeCurrentButton setTitle:selectedDate forState:UIControlStateNormal];
        }

        
    }else{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //[dateFormatter setDateFormat:@"yyyy MM dd - HH:mm"];
    [dateFormatter setDateFormat:@"dd MMM yyyy - HH:mm"];
    
    NSLog(@"DOB selected: %@",[dateFormatter stringFromDate:_datePicker.date]);
    NSString *selectedDate = [dateFormatter stringFromDate:_datePicker.date];
    
    if (selectedDate.length > 0)
    {
        self.selectedDateTime = [selectedDate uppercaseString];
        [self setEventTimeForPreviewEvent:self.selectedDateTime];
        [self.eventTimeCurrentButton setTitle:selectedDate forState:UIControlStateNormal];
    }
    }
    //[self setEventNameForPreviewEvent:self.selectedDateTime];
    
}


- (void)actionTeeButtonOptionShow:(UIButton *)sender
{
    self.viewStroke.hidden = YES;
    [self actionDatePickerDone];
    [self.textEventName resignFirstResponder];
    if (self.currentGolfCourseModel == nil)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please select a golf course to get list of tee."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        float height = [self getTeeViewHeight];
        CGRect teeViewFrame = CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width, height);
        self.teeView.frame = teeViewFrame;
        [self.teeView setTeeWithMenArray:self.arrMenTeeList andWomenArray:self.arrWomenTeeList andJuniorArray:self.arrJuniorTeeList];
        self.teeView.hidden = NO;
    }

}

- (float)getTeeViewHeight
{
    
    float height = 0;
    float topDistance = 140;
    float men = self.arrMenTeeList.count;
    float women = self.arrWomenTeeList.count;
    float junior = self.arrJuniorTeeList.count;
    float max1 = fminf( men,  women);
    float max2 = fminf(max1, junior);
    
    height = topDistance + 30 + max2 * TeeDefaultIconSize + max2 * 12 ;
    
    return height;
}

- (IBAction)actionHome:(id)sender
{
    if (self.isEditMode == YES)
    {
        self.previewVC.isEditMode = YES;
        [self actionCancel];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate addTabBarAsRootViewController];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultValues];
        [[PT_PreviewEventSingletonModel sharedPreviewEvent] setDefaultSpotPrize];
    }
}


- (IBAction)actionCancel
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    PT_EventPreviewViewController *createVC = [[PT_EventPreviewViewController alloc]initWithModel:_createventModel andIsRequestToParticipate:self.isRequestToParticipate];
    
    [self presentViewController:createVC animated:YES completion:nil];
}

- (void)actionSelectGolfCourse
{
    if ([self.arrGolfCoursesList count]>0)
    {
        PT_SelectGolfCorseViewController *selctGC = [[PT_SelectGolfCorseViewController alloc] initWithDelegate:self andGolfCourseList:self.arrGolfCoursesList];
        
        [self presentViewController:selctGC animated:YES completion:nil];
    }
}

- (IBAction)actionAddPlayer
{
    if (self.currentNumOfPlayersSelected == NumberOfPlayers_1)
    {
        PT_EventPreviewViewController *previewVC = [PT_EventPreviewViewController new];
        previewVC.isEditMode = NO;
        [self presentViewController:previewVC animated:YES completion:nil];
    }
    else
    {
        //if (self.isTeamGame == YES)
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM])
        {
            PT_AddPlayerMainViewController *addPlayerVC = [[PT_AddPlayerMainViewController alloc] initWithDelegate:self];
            [self presentViewController:addPlayerVC animated:YES completion:nil];
        }
        else if (self.currentNumOfPlayersSelected == NumberOfPlayers_MoreThan4)
        {
            PT_AddPlayerOptionsViewController *addPlayersOptionsVC = [[PT_AddPlayerOptionsViewController alloc] initWithNibName:@"PT_AddPlayerOptionsViewController" bundle:nil];
            addPlayersOptionsVC.numberOfPlayers = self.currentNumOfPlayersSelected;
            [self presentViewController:addPlayersOptionsVC animated:YES completion:nil];
        }
        else
        {
            
            PT_AddPlayerIntermediateViewController *addPlayer = [[PT_AddPlayerIntermediateViewController alloc] initWithNumberOfPlayers:self.currentNumOfPlayersSelected];
            
            [self presentViewController:addPlayer animated:YES completion:nil];
        }
 
    }
    
}

- (void)setSelectedGolfCourse:(PT_SelectGolfCourseModel *)golfCourseModel
{
    _currentGolfCourseModel = golfCourseModel;
    [self setGolfCourseForPreviewEvent:golfCourseModel];
    //get tee based on selected
    [self fetchTeeForGolfcourse];
    [self.tableOptions reloadData];
}

- (void)fetchTeeForGolfcourse
{
    __block AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please check the internet connection and try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        self.previewBtn.userInteractionEnabled = NO;

        //[MBProgressHUD showHUDAddedTo:self.tableOptions animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"golfcourseid":[NSString stringWithFormat:@"%li", (long)_currentGolfCourseModel.golfCourseId],
                                @"version":@"2",
                                };
        
        NSString *urlString = @"getgolfcoursetee";
        
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"output"])
                              {
                                  NSDictionary *dicOutput = responseData[@"output"];
                                  if (dicOutput[@"GolfCourseTee"])
                                  {
                                      NSDictionary *dicGolfCourseTee = dicOutput[@"GolfCourseTee"];
                                      if (dicGolfCourseTee[@"Men"] && (dicGolfCourseTee[@"Men"] != nil))
                                      {
                                          _arrMenTeeList = [NSMutableArray new];
                                          NSArray *arrMenTees = dicGolfCourseTee[@"Men"];
                                          [arrMenTees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                              PT_TeeItemModel *model = [PT_TeeItemModel new];
                                              NSDictionary *dicMenTee = obj;
                                              model.teeId = [[dicMenTee objectForKey:@"tee_id"] integerValue];
                                              model.teeName = [dicMenTee objectForKey:@"tee_name"];
                                              model.teeColor = [dicMenTee objectForKey:@"tee_color"];
                                              [_arrMenTeeList addObject:model];
                                              if (idx == 0)
                                              {
                                                  if (self.isEditMode == YES)
                                                  {
                                                      NSDictionary *dicEditEventTee = self.createventModel.teeId;
                                                      NSLog(@"%@",dicEditEventTee);
                                                      NSDictionary *dicMen = dicEditEventTee[@"MenColor"];
                                                      NSString *jHex = nil;
                                                      NSNull *n=[NSNull null];
                                                      //if ( dicMen == n )
                                                      {
                                                          CGFloat r = [dicMen[@"r"] floatValue];
                                                          CGFloat g = [dicMen[@"g"] floatValue];
                                                          CGFloat b = [dicMen[@"b"] floatValue];
                                                          UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                                                          jHex = [self hexStringFromColor:jColor];
                                                          [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForMen:[UIColor colorFromHexString:jHex]];
                                                      }
                                                      //else
                                                      //{
                                                          //jHex = @"#FFFFFF";
                                                          //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForMen:[UIColor colorFromHexString:jHex]];
                                                      //}
                                                      
                                                      PT_TeeItemModel *modelMen = [PT_TeeItemModel new];
                                                      modelMen.teeColor = jHex;
                                                      modelMen.teeId = [self.createventModel.teeId[@"men_tee_id"] integerValue];
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setMenTeeModel:modelMen];

                                                  }
                                                  else
                                                  {
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setMenTeeModel:model];
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForMen:[UIColor colorFromHexString:model.teeColor]];
                                                      [self.tableOptions reloadData];
                                                  }
                                                  
                                                  
                                              }
                                          }];
                                      }
                                      
                                      if (dicGolfCourseTee[@"Ladies"] && (dicGolfCourseTee[@"Ladies"] != nil))
                                      {
                                          _arrWomenTeeList = [NSMutableArray new];
                                          NSArray *arrMenTees = dicGolfCourseTee[@"Ladies"];
                                          [arrMenTees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                              PT_TeeItemModel *model = [PT_TeeItemModel new];
                                              NSDictionary *dicMenTee = obj;
                                              model.teeId = [[dicMenTee objectForKey:@"tee_id"] integerValue];
                                              model.teeName = [dicMenTee objectForKey:@"tee_name"];
                                              model.teeColor = [dicMenTee objectForKey:@"tee_color"];
                                              [_arrWomenTeeList addObject:model];
                                              if (idx == 0)
                                              {
                                                  if (self.isEditMode == YES)
                                                  {
                                                      NSDictionary *dicEditEventTee = self.createventModel.teeId;
                                                      NSLog(@"%@",dicEditEventTee);
                                                      NSDictionary *dicLadies = dicEditEventTee[@"LadiesColor"];
                                                      NSString *jHex = nil;
                                                      NSNull *n=[NSNull null];
                                                      //if ( dicLadies == n )
                                                      {
                                                          CGFloat r = [dicLadies[@"r"] floatValue];
                                                          CGFloat g = [dicLadies[@"g"] floatValue];
                                                          CGFloat b = [dicLadies[@"b"] floatValue];
                                                          UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                                                          jHex = [self hexStringFromColor:jColor];
                                                          [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForWomen:[UIColor colorFromHexString:jHex]];
                                                      }
                                                      //else
                                                      //{
                                                          //jHex = @"#FFFFFF";
                                                          //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForWomen:[UIColor colorFromHexString:jHex]];
                                                      //}
                                                      PT_TeeItemModel *modelWomen = [PT_TeeItemModel new];
                                                      modelWomen.teeColor = jHex;
                                                      modelWomen.teeId = [self.createventModel.teeId[@"lady_tee_id"] integerValue];
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setWomenTeeModel:modelWomen];

                                                  }
                                                  else{
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setWomenTeeModel:model];
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForWomen:[UIColor colorFromHexString:model.teeColor]];
                                                  }
                                                  
                                              }
                                          }];
                                      }
                                      if (dicGolfCourseTee[@"Junior"] && (dicGolfCourseTee[@"Junior"] != nil))
                                      {
                                          _arrJuniorTeeList = [NSMutableArray new];
                                          NSArray *arrMenTees = dicGolfCourseTee[@"Junior"];
                                          [arrMenTees enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                              PT_TeeItemModel *model = [PT_TeeItemModel new];
                                              NSDictionary *dicMenTee = obj;
                                              model.teeId = [[dicMenTee objectForKey:@"tee_id"] integerValue];
                                              model.teeName = [dicMenTee objectForKey:@"tee_name"];
                                              model.teeColor = [dicMenTee objectForKey:@"tee_color"];
                                              [_arrJuniorTeeList addObject:model];
                                              if (idx == 0)
                                              {
                                                  if (self.isEditMode == YES)
                                                  {
                                                      NSDictionary *dicEditEventTee = self.createventModel.teeId;
                                                      NSLog(@"%@",dicEditEventTee);
                                                      NSDictionary *dicJunior = dicEditEventTee[@"JuniorColor"];
                                                      NSString *jHex = nil;
                                                      NSNull *n=[NSNull null];
                                                      if ( dicJunior == n )
                                                      {
                                                          CGFloat r = [dicJunior[@"r"] floatValue];
                                                          CGFloat g = [dicJunior[@"g"] floatValue];
                                                          CGFloat b = [dicJunior[@"b"] floatValue];
                                                          UIColor *jColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0];
                                                          jHex = [self hexStringFromColor:jColor];
                                                          [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForJunior:[UIColor colorFromHexString:jHex]];
                                                      }
                                                      //else
                                                      //{
                                                          //jHex = @"#FFFFFF";
                                                          //[[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForJunior:[UIColor colorFromHexString:jHex]];
                                                      //}
                                                      PT_TeeItemModel *modelJunior = [PT_TeeItemModel new];
                                                      modelJunior.teeColor = jHex;
                                                      modelJunior.teeId = [self.createventModel.teeId[@"junior_tee_id"] integerValue];
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setJuniorTeeModel:modelJunior];

                                                  }
                                                  else
                                                  {
                                                      [[PT_PreviewEventSingletonModel sharedPreviewEvent] setJuniorTeeModel:model];[[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForJunior:[UIColor colorFromHexString:model.teeColor]];
                                                      [self.tableOptions reloadData];
                                                  }
                                                  
                                              }
                                          }];
                                      }
                                      
                                      
                                  }
                                  self.previewBtn.userInteractionEnabled = YES;

                                  [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];                              }
                              else
                              {
                                  [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                              
                          }
                      }
                      
                      else
                      {
                          
                           [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                          
                      }
                  }
                  else
                  {
                       [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                      [self fetchTeeForGolfcourse];
                  }
                  
                  
              }];
    }

}

- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

- (void)refreshTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableOptions reloadData];
    });
    
}

- (void)selectFormatStrokes:(UIButton *)sender
{
    [self.teeView hideView];
    [self actionDatePickerDone];
    [self.textEventName resignFirstResponder];
    
    if (self.viewStroke.hidden == YES)
    {
        //CATransition *transition = [CATransition animation];
        //transition.type = kCATransitionPush;
        //transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //transition.fillMode = kCAFillModeForwards;
        //transition.duration = 0.5;
        //transition.subtype = kCATransitionFromTop;
        
        //[[self.tableStrokes layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableStrokes.hidden = NO;
            self.viewStroke.hidden = NO;
            [self.tableStrokes reloadData];
        });
        
    }
    else
    {
        /*CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeForwards;
        transition.duration = 0.5;
        transition.subtype = kCATransitionFromBottom;*/
        self.viewStroke.hidden = YES;
    }
    
}

- (IBAction)actionCreateNewGolfCourse
{
    PT_CreateGolfCorseViewController *createGF = [[PT_CreateGolfCorseViewController alloc] initWithDelegate:self];
    createGF.createVC = self;
    [self presentViewController:createGF animated:YES completion:nil];
}

- (void)actionSetInvitePlayerOptionForNumberOfPlayers:(NumberOfPlayers)numOfPlayers
{
    switch (numOfPlayers) {
        case NumberOfPlayers_1:
        {
            [self.addPlayerButton setBackgroundImage:[UIImage imageNamed:@"previewevent"] forState:UIControlStateNormal];
            self.addPlayerLabel.text = @"PREVIEW EVENT";
        }
            break;
       
        case NumberOfPlayers_2:
        {
            [self.addPlayerButton setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
            self.addPlayerLabel.text = @"ADD PLAYERS";
        }
            break;
        case NumberOfPlayers_3:
        {
            [self.addPlayerButton setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
            self.addPlayerLabel.text = @"ADD PLAYERS";
        }
            break;
        case NumberOfPlayers_4:
        {
            [self.addPlayerButton setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
            self.addPlayerLabel.text = @"ADD PLAYERS";
        }
            break;
        case NumberOfPlayers_MoreThan4:
        {
            [self.addPlayerButton setBackgroundImage:[UIImage imageNamed:@"invite"] forState:UIControlStateNormal];
            self.addPlayerLabel.text = @"ADD PLAYERS";
        }
            break;
    }
}


- (void)actionSpotPrizeButton:(UIButton *)sender
{
    self.currentSpotPrizeButton = sender;
    NSString *keyForData;
    switch (sender.tag) {
        case SpotPrizeType_ClosestToPin1:
        {
            keyForData = @"par3_holes";
        }
            break;
        case SpotPrizeType_ClosestToPin2:
        {
            keyForData = @"par3_holes";
        }
            break;
        case SpotPrizeType_ClosestToPin3:
        {
            keyForData = @"par3_holes";
        }
            break;
        case SpotPrizeType_ClosestToPin4:
        {
            keyForData = @"par3_holes";
        }
            break;
            
        case SpotPrizeType_LongDrive1:
        {
            keyForData = @"par4n5_holes";
        }
            break;
        case SpotPrizeType_LongDrive2:
        {
            keyForData = @"par4n5_holes";
        }
            break;
        case SpotPrizeType_LongDrive3:
        {
            keyForData = @"par4n5_holes";
        }
            break;
        case SpotPrizeType_LongDrive4:
        {
            keyForData = @"par4n5_holes";
        }
            break;
        case SpotPrizeType_StraightDrive1:
        {
            keyForData = @"par4n5_holes";
        }
            break;
        case SpotPrizeType_StraightDrive2:
        {
            keyForData = @"par4n5_holes";
        }
        case SpotPrizeType_StraightDrive3:
        {
            keyForData = @"par4n5_holes";
        }
        case SpotPrizeType_StraightDrive4:
        {
            keyForData = @"par4n5_holes";
        }
    }
    NSString *option;
    if (self.isNumberOfHole18Selected == YES)
    {
        option = @"";
    }
    else
    {
        if (self.isFront9Selected == YES)
        {
            option = @"1";
        }
        else
        {
            option = @"2";
        }
    }
    
    if (self.currentGolfCourseModel.golfCourseName.length > 0)
    {
        __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"PUTT2GETHER"
                                          message:@"Please check the internet connection and try again."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Dismiss"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            
            MGMainDAO *mainDAO = [MGMainDAO new];
            NSDictionary *param = @{@"golf_course_id":[NSString stringWithFormat:@"%li",self.currentGolfCourseModel.golfCourseId],
                                    @"option":option,
                                    @"version":@"2"
                                    };
            
            [MBProgressHUD showHUDAddedTo:self.tableOptions animated:YES];
            [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,ShowHoleNumbersPostfix]
                  withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                      
                      if (!error)
                      {
                          [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];                          if (responseData != nil)
                          {
                              if ([responseData isKindOfClass:[NSDictionary class]])
                              {
                                  if (responseData[@"output"])
                                  {
                                      NSDictionary *dataOutput = responseData[@"output"];
                                      NSDictionary *dicSuggestion = dataOutput[@"data"];
                                      
                                      NSArray *holesList = dicSuggestion[keyForData];
                                      
                                      PT_SpotPrizeSelectionView *selectView = [[[NSBundle mainBundle] loadNibNamed:@"PT_SpotPrizeSelectionView" owner:self options:nil] objectAtIndex:0];
                                      selectView.parentController = self;
                                      if (self.isNumberOfHole18Selected == YES)
                                      {
                                          selectView.totalHolesToBeSelected = 4;
                                      }
                                      else
                                      {
                                          selectView.totalHolesToBeSelected = 2;
                                      }
                                      float heightDelta = 0;
                                      if ([holesList count] <= 3)
                                      {
                                          heightDelta = 120;
                                      }
                                      else if ([holesList count] <= 6)
                                      {
                                          heightDelta = 200;
                                      }
                                      else
                                      {
                                          heightDelta = 240;
                                      }
                                      selectView.frame = CGRectMake(0, self.view.frame.size.height - heightDelta, self.view.frame.size.width, heightDelta);
                                      
                                      [selectView setHolesWithArray:holesList];
                                      
                                      [self.view addSubview:selectView];
                                  }
                                  else
                                  {
                                      NSDictionary *dicData = responseData;
                                      NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                      NSString *messageError = [dictError objectForKey:@"message"];
                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                                    message:messageError
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      
                                      
                                      UIAlertAction* cancel = [UIAlertAction
                                                               actionWithTitle:@"Dismiss"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   
                                                               }];
                                      
                                      [alert addAction:cancel];
                                      
                                      [self presentViewController:alert animated:YES completion:nil];
                                  }
                                  
                              }
                          }
                          
                          else
                          {
                              
                              [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                          }
                      }
                      else
                      {
                          //[MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                          UIAlertController * alert=   [UIAlertController
                                                        alertControllerWithTitle:@"PUTT2GETHER"
                                                        message:@"Connection Lost."
                                                        preferredStyle:UIAlertControllerStyleAlert];
                          
                          
                          
                          UIAlertAction* cancel = [UIAlertAction
                                                   actionWithTitle:@"Dismiss"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                                                   {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
                          
                          [alert addAction:cancel];
                          
                          [self presentViewController:alert animated:YES completion:nil];}
                      
                      
                  }];
        }

    }
    else{
        //Alert
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please Select a Golf Course."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)actionUpdateEvent
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please check the internet connection and try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        PT_SelectGolfCourseModel *golfCoursemodel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getGolfCourse];
        NSString *golfCourseId = [NSString stringWithFormat:@"%li",(long)golfCoursemodel.golfCourseId];
        //NSString *golfCourseId = [NSString stringWithFormat:@"%i",10];
        
        PT_StrokePlayListItemModel *modelStroke = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getFormat];
        NSString *formatId = [NSString stringWithFormat:@"%li",(long)modelStroke.strokeId];
        
        PT_TeeItemModel *teeMenModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getMenTeeModel];
        PT_TeeItemModel *teeWomenModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getWomenTeeModel];
        PT_TeeItemModel *teeJuniorModel = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getJuniorTeeModel];
        NSMutableDictionary *dicTee = [NSMutableDictionary new];
        [dicTee setObject:[NSString stringWithFormat:@"%li",(long)teeMenModel.teeId] forKey:@"men"];
        [dicTee setObject:[NSString stringWithFormat:@"%li",(long)teeWomenModel.teeId] forKey:@"ladies"];
        [dicTee setObject:[NSString stringWithFormat:@"%li",(long)teeJuniorModel.teeId] forKey:@"junior"];
        NSArray *arrTee = [NSArray arrayWithObject:dicTee];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MMM-dd HH:mm"];
        NSDate *dateMain = [formatter dateFromString:[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventTime]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //NSDate *dateSelected = [formatter dateFromString:self.selectedDateTime];
        NSString *date = [formatter stringFromDate:dateMain];
        [formatter setDateFormat:@"HH:mm"];
        NSString *time = [formatter stringFromDate:dateMain];
        NSNumber *spotNumber = [NSNumber numberWithBool:self.createventModel.isSpot];
        
        NSString *public = nil;
        if ([self.createventModel.eventType isEqualToString:PUBLIC])
        {
            public = @"1";
        }
        else
        {
            public = @"0";
        }
        
        NSString *eventName = self.selectedEvent; //[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventName];

        
        //NSDictionary *dicClosestToPin = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getSpotPrizeClosestToPinData];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"event_admin_id":[NSString stringWithFormat:@"%li",(long)self.createventModel.adminId],
                                @"event_id":[NSString stringWithFormat:@"%li",(long)self.createventModel.eventId],
                                @"version":@"2",
                                @"event_golf_course_id":golfCourseId,
                                @"event_name":eventName,
                                @"event_format_id":formatId,
                                @"event_tee_id":arrTee,
                                @"event_start_date":date,
                                @"event_start_time":time,
                                @"event_is_public":public,
                                @"event_is_spot":[NSString stringWithFormat:@"%li",(long)spotNumber.integerValue],
                                @"closest_pin":[NSString stringWithFormat:@"%@",self.createventModel.closestPin],
                                @"long_drive":[NSString stringWithFormat:@"%@",self.createventModel.longDrive],
                                @"straight_drive":[NSString stringWithFormat:@"%@",self.createventModel.straightDrive]
                                };
        [MBProgressHUD showHUDAddedTo:self.tableOptions animated:YES];
        //http://clients.vfactor.in/puttdemo/editevent
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"editevent"];
        NSLog(@"%@",urlString);
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSDictionary *dicData = responseData;
                              if ([[dicData[@"output"] objectForKey:@"status"] isEqualToString:@"1"])
                              {
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:@"Event Successfully updated"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [self fetchEventwithType:InviteType_Detail];
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                              else
                              {
                                  
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                              
                          }
                      }
                      
                      else
                      {
                          
                          [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                  }
                  
                  
              }];
    }

}
- (void)fetchEventwithType:(InviteType)type
{
    NSString *eventId = [NSString stringWithFormat:@"%li",(long)self.createventModel.eventId];
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please check the internet connection and try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
#if (TARGET_OS_SIMULATOR)
        
        delegate.latestLocation = [[CLLocation alloc] initWithLatitude:28.5922729 longitude:77.33453080000004];
        
#endif
        //[self showLoadingView:YES];
        NSString *requestToPraticipate = @"";
        if (self.isRequestToParticipate == YES)
        {
            requestToPraticipate = @"1";
        }
        else
        {
            requestToPraticipate = @"0";
        }
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"user_id":userId,
                                @"event_id":eventId,
                                @"request_to_participate":requestToPraticipate,
                                @"version":@"2"
                                };
        
        NSString *urlString = @"eventdetail";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              NSDictionary *dicOutput = responseData[@"output"];
                              //Check Success
                              if ([dicOutput[@"status"] isEqualToString:@"1"])
                              {
                                  NSArray *arrData = dicOutput[@"data"];
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicData = obj;
                                      PT_CreatedEventModel *model = [PT_CreatedEventModel new];
                                      model.eventId = [eventId integerValue];
                                      model.adminId = [dicData[@"admin_id"] integerValue];
                                      model.closestPin = dicData[@"closest_pin"];
                                      model.eventName = [dicData[@"event_name"] uppercaseString];
                                      model.eventstartDateTime = [dicData[@"event_start_date_time"] uppercaseString];
                                      model.formatName = [dicData[@"format_name"] uppercaseString];
                                      model.formatId = dicData[@"format_id"];
                                      model.golfCourseId = [dicData[@"golf_course_id"] integerValue];
                                      model.golfCourseName = dicData[@"golf_course_name"];
                                      model.holes = [dicData[@"holes"] uppercaseString];
                                      model.isAdmin = [dicData[@"is_admin"] boolValue];
                                      model.isIndividual = dicData[@"is_individual"];
                                      model.isSpot = [dicData[@"is_spot"] boolValue];
                                      model.longDrive = dicData[@"long_drive"];
                                      model.numberOfPlayers = [NSString stringWithFormat:@"%@",dicData[@"no_of_player"]] ;
                                      model.playersInGame = dicData[@"players_in_game"];
                                      model.straightDrive = dicData[@"straight_drive"];
                                      model.teeId = dicData[@"tee_id"];
                                      model.totalHoleNumber = [dicData[@"total_hole_num"] integerValue];
                                      model.eventType = [dicData[@"type"] uppercaseString];
                                      model.isEventStarted = dicData[@"start_round_status"] ;
                                      model.is_accepted = [NSString stringWithFormat:@"%@",dicData[@"is_accepted"]];
                                      model.scorerId = [dicData[@"scorere_id"] integerValue];
                                      model.isStarted = [dicData[@"is_started"] integerValue];
                                      if (dicData[@"holes"])
                                      {
                                          model.back9 = dicData[@"holes"];
                                      }
                                      NSString *is_singlescreen = [NSString stringWithFormat:@"%@",dicData[@"is_singlescreen"]];
                                      if ([is_singlescreen isEqualToString:@"1"])
                                      {
                                          model.isSingleScreen = YES;
                                      }
                                      else if ([is_singlescreen isEqualToString:@""])
                                      {
                                          model.isSingleScreen = NO;
                                      }
                                      //NSInteger count = [arrData count];
                                      if ([arrData count] == 1)
                                      {
                                          *stop = YES;
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                        PT_EventPreviewViewController *createVC = [[PT_EventPreviewViewController alloc]initWithModel:model andIsRequestToParticipate:self.isRequestToParticipate];
                                                  
                                                  [self presentViewController:createVC animated:YES completion:nil];
                                              
                                          });
                                      }
                                      
                                  }];
                              }
                              else
                              {
                                  //Pop up message
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:dicOutput[@"msg"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                          }
                      }
                      
                  }
                  else
                  {
                      //Error pop up
                      
                      [self fetchEventwithType:InviteType_Detail];
                      
                  }
                  
                  
              }];
    }
    
}

 
- (void)updateEventTypeForUpdateEvent:(NSString *)updatedValue
{
    self.createventModel.eventType = updatedValue;
}
#pragma mark - TeeButton Delegate
- (void)didPressTeeButtonWithTag:(NSInteger)tag
{
    //self.teeView.hidden = YES;
    
    NSString * allDigits = [NSString stringWithFormat:@"%li", tag];
    NSString * topDigits = [allDigits substringToIndex:1];
    
    UIColor *whiteColor = [UIColor whiteColor];
    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *blackColor = [UIColor blackColor];
    
    switch ([topDigits integerValue]) {
        case 5:
        {
            
            NSInteger index = tag - MenTeeTag;
            PT_TeeItemModel *modelMenTee = self.arrMenTeeList[index];
            self.menTeeButton.backgroundColor = [UIColor colorFromHexString:modelMenTee.teeColor];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForMen:self.menTeeButton.backgroundColor];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setMenTeeModel:modelMenTee];
           
            if ([modelMenTee.teeName isEqualToString:@"White"])
            {
                self.menTeeButton.layer.borderColor = borderColor.CGColor;
                [self.menTeeButton setTitleColor:borderColor forState:UIControlStateNormal];
                
            }else if ([modelMenTee.teeColor isEqualToString:@"#C0C0C0"] || [modelMenTee.teeColor isEqualToString:@"#FFD700"] || [modelMenTee.teeColor isEqualToString:@"#FFFF00"]){
                
               [self.menTeeButton setTitleColor:blackColor forState:UIControlStateNormal];
                self.menTeeButton.layer.borderColor = whiteColor.CGColor;
            }

            else
            {
                self.menTeeButton.layer.borderColor = [UIColor clearColor].CGColor;
                [self.menTeeButton setTitleColor:whiteColor forState:UIControlStateNormal];
            }
            
        }
            break;
        case 6:
        {
            NSInteger index = tag - WomenTeeTag;
            PT_TeeItemModel *modelWomenTee = self.arrWomenTeeList[index];
            self.womenTeeButton.backgroundColor = [UIColor colorFromHexString:modelWomenTee.teeColor];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForWomen:self.womenTeeButton.backgroundColor];
            if ([modelWomenTee.teeName isEqualToString:@"White"])
            {
                self.womenTeeButton.layer.borderColor = borderColor.CGColor;
                [self.womenTeeButton setTitleColor:borderColor forState:UIControlStateNormal];
                
            }else if ([modelWomenTee.teeColor isEqualToString:@"#C0C0C0"] || [modelWomenTee.teeColor isEqualToString:@"#FFD700"] || [modelWomenTee.teeColor isEqualToString:@"#FFFF00"]){
                
                [self.womenTeeButton setTitleColor:blackColor forState:UIControlStateNormal];
                self.womenTeeButton.layer.borderColor = whiteColor.CGColor;
            }
            else
            {
                self.womenTeeButton.layer.borderColor = [UIColor clearColor].CGColor;
                [self.womenTeeButton setTitleColor:whiteColor forState:UIControlStateNormal];
            }
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setWomenTeeModel:modelWomenTee];
        }
            break;
        case 7:
        {
            NSInteger index = tag - JuniorTeeTag;
            PT_TeeItemModel *modelJuniorTee = self.arrJuniorTeeList[index];
            self.juniorTeeButton.backgroundColor = [UIColor colorFromHexString:modelJuniorTee.teeColor];
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setTeeColorsForJunior:self.juniorTeeButton.backgroundColor];
            if ([modelJuniorTee.teeName isEqualToString:@"White"])
            {
                self.juniorTeeButton.layer.borderColor = borderColor.CGColor;
                [self.juniorTeeButton setTitleColor:borderColor forState:UIControlStateNormal];
                
            }else if ([modelJuniorTee.teeColor isEqualToString:@"#C0C0C0"] || [modelJuniorTee.teeColor isEqualToString:@"#FFD700"] || [modelJuniorTee.teeColor isEqualToString:@"#FFFF00"]){
                
                [self.juniorTeeButton setTitleColor:blackColor forState:UIControlStateNormal];
                self.juniorTeeButton.layer.borderColor = whiteColor.CGColor;
            }
            else
            {
                self.juniorTeeButton.layer.borderColor = [UIColor clearColor].CGColor;
                [self.juniorTeeButton setTitleColor:whiteColor forState:UIControlStateNormal];
            }
            [[PT_PreviewEventSingletonModel sharedPreviewEvent] setJuniorTeeModel:modelJuniorTee];
        }
            break;
            
        
    }
}


#pragma mark - Service call

- (void)fetchGolfCourses
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please check the internet connection and try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
#if (TARGET_OS_SIMULATOR)
        
        
        //self.latestLocation = [[CLLocation alloc] initWithLatitude:12.9716 longitude:77.5946];
        delegate.latestLocation = [[CLLocation alloc] initWithLatitude:28.5922729 longitude:77.33453080000004];
        
#endif
        self.previewBtn.userInteractionEnabled = NO;
        [MBProgressHUD showHUDAddedTo:self.tableOptions animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"latitude":[NSString stringWithFormat:@"%f", delegate.latestLocation.coordinate.latitude],
                                @"longitude":[NSString stringWithFormat:@"%f", delegate.latestLocation.coordinate.longitude],
                                @"version":@"2",
                                @"ip_address":@""
                                };
        
        NSString *urlString = @"getnearestgolfcourse";
        //[NSString stringWithFormat:@"%@%@",BASE_URL,GetGolfCoursePostFix]
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"GolfcourseNerabyDistance"])
                              {
                                  NSDictionary *data = responseData;
                                  id responseType = [data objectForKey:@"GolfcourseNerabyDistance"];
                                  if ([responseType isKindOfClass:[NSArray class]])
                                  {
                                      NSArray *arrData = [data objectForKey:@"GolfcourseNerabyDistance"];
                                      if ([arrData count] > 0)
                                      {
                                          _arrGolfCoursesList = [NSMutableArray new];
                                      }
                                      [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
                                          NSDictionary *dicGCData = obj;
                                          
                                          model.golfCourseName = [dicGCData[@"golf_course_name"] uppercaseString];
                                          model.golfCourseId = [dicGCData[@"golf_course_id"] integerValue];
                                          model.golfCourseLocation = dicGCData[@"city_name"];
                                          model.golfCourseLocationId = [dicGCData[@"city_id"] integerValue];
                                          model.distance = [dicGCData[@"Distance"] floatValue];
                                          model.golfCourseLatitude = [dicGCData[@"lat"] floatValue];
                                          model.golfCourseLongitude = [dicGCData[@"lon"] floatValue];
                                          model.golfCourseHasEvent = [dicGCData[@"has_event"] integerValue];
                                         
                                          //self.previewBtn.userInteractionEnabled = YES;
                                          
                                          [self.arrGolfCoursesList addObject:model];
                                          if (idx == 0)
                                          {
                                              if (self.isEditMode == NO && self.isGolfCourseExplicitlySelected == YES)
                                              {
                                                  [self setSelectedGolfCourse:model];
                                                  [self setGolfCourseForPreviewEvent:model];
                                              }
                                              else if (self.isEditMode == YES)
                                              {
                                                  PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
                                                  model.golfCourseId = self.createventModel.golfCourseId;
                                                  model.golfCourseName = self.createventModel.golfCourseName;
                                                  [self setSelectedGolfCourse:model];
                                                  [self setGolfCourseForPreviewEvent:model];
                                              }
                                          }
                                          
                                          //Call Stroke types
                                      }];
                                  }
                                  else
                                  {
                                      [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];                                      UIAlertController * alert=   [UIAlertController
                                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                                    message:@"No Golf Course data found. please try again later."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      
                                      
                                      UIAlertAction* cancel = [UIAlertAction
                                                               actionWithTitle:@"Dismiss"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                                               {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   
                                                               }];
                                      
                                      [alert addAction:cancel];
                                      
                                      [self presentViewController:alert animated:YES completion:nil];
                                  }
                                  
                              }
                              else
                              {
                                  [MBProgressHUD hideHUDForView:self.tableOptions
                                                       animated:YES];                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
                                  UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"PUTT2GETHER"
                                                                message:messageError
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  
                                  
                                  UIAlertAction* cancel = [UIAlertAction
                                                           actionWithTitle:@"Dismiss"
                                                           style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                  
                                  [alert addAction:cancel];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                              
                          }
                      }
                      
                      else
                      {
                          
                          
                          
                      }
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.tableOptions animated:YES];
                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                    message:@"Connection Lost."
                                                    preferredStyle:UIAlertControllerStyleAlert];
                      
                      
                      
                      UIAlertAction* cancel = [UIAlertAction
                                               actionWithTitle:@"Dismiss"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   
                                                  
                                                   [alert dismissViewControllerAnimated:YES completion:^{
                                                       
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];
                                                   
                                               }];
                      
                      [alert addAction:cancel];
                      
                      [self presentViewController:alert animated:YES completion:nil];
                  }
                  
                  
              }];
    }
}

- (void)fetchStrokesForNumberOfPlayers:(NSString *)numOfPlayers
{
    PT_FormatsHandler *formatHandler = [PT_FormatsHandler new];
    _arrStrokePlayList = nil;
    _arrStrokePlayList = [NSMutableArray new];
    
    if ([numOfPlayers isEqualToString:@"4+"])
    {
        _arrStrokePlayList = [formatHandler get4PlusFormats];
    }
    else if ([numOfPlayers integerValue] == 4)
    {
        if ([[[PT_PreviewEventSingletonModel sharedPreviewEvent] getIndividualOrTeam] isEqualToString:TEAM])
        {
            _arrStrokePlayList = [formatHandler get4PlayerTeamFormats];
            [self setScorerTypeForPreviewEvent:multiScorerStatic];
        }
        else
        {
            _arrStrokePlayList = [formatHandler get4PlayerNoTeamFormats];
        }
    }
    
    else if ([numOfPlayers integerValue] == 1)
    {
        _arrStrokePlayList = [formatHandler get1PlayerFormats];
    }
    else if ([numOfPlayers integerValue] == 2)
    {
        _arrStrokePlayList = [formatHandler get2PlayerFormats];
        [self setScorerTypeForPreviewEvent:multiScorerStatic];
    }
    else if ([numOfPlayers integerValue] == 3)
    {
        _arrStrokePlayList = [formatHandler get3PlayerFormats];
    }
    
    PT_StrokePlayListItemModel *model = [_arrStrokePlayList firstObject];
    if (self.isEditMode == YES)
    {
       // [self.buttonStrokePlay setTitle:self.createventModel.formatName forState:UIControlStateNormal];
        
        PT_StrokePlayListItemModel *modelStrokes = [PT_StrokePlayListItemModel new];
        modelStrokes.strokeId = [self.createventModel.formatId integerValue];
        modelStrokes.strokeName = self.createventModel.formatName;
        //[self.buttonStrokePlay setTitle:self.createventModel.formatName forState:UIControlStateNormal];
        [self.cellFormat.formatButton setTitle:self.createventModel.formatName forState:UIControlStateNormal];
        [self.tableOptions reloadData];

        [self setFormatForPreviewEvent:modelStrokes];

    }
    else
    {
        [self.buttonStrokePlay setTitle:model.strokeName forState:UIControlStateNormal];
        [self setFormatForPreviewEvent:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableStrokes reloadData];
        [self.tableOptions reloadData];
        
    });
    
    
}
@end
