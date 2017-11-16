//
//  PT_StartEventViewController.m
//  Putt2Gether
//
//  Created by Nitin Chauhan on 31/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_StartEventViewController.h"
#import "PT_StartEventTableView.h"
#import "PT_StartEventTableViewCell.h"
#import "PT_DelegateViewController.h"
#import "PT_ScoreCardViewController.h"
#import "PT_LeaderBoardViewController.h"

#import "PT_ScoringIndividualPlayerModel.h"

#import "PT_ScoringModel.h"

#import "UIView+Hierarchy.h"

#import "PT_SpecialFormatLeaderboardModel.h"

#import "PT_Front9Model.h"

#import "PT_ScoreCardSplFormatViewController.h"

#import "PT_EnterScoreSelectHoles.h"

#import "PT_MyScoresViewController.h"

#import "PT_AutopressView.h"

#import "EnterScoreTableViewCell.h"

#import "PT_CacheHoleData.h"

#import "PT_420Formatmodel.h"

#import "PT_FourTwoZeroView.h"

#import "PT_VegasFormatView.h"

#import "PT_AutoPressFormatView.h"

#import "PT_MyScoresModel.h"

#import "UIImageView+AFNetworking.h"

#import "AFHTTPRequestOperationManager.h"


static NSString *const FetchParIndexPostfix = @"getparindexvalue";

static NSString *const FetScorecardDataPostfix = @"getscorecarddata";

static NSString *const SaveScorecardDataPostfix = @"savescorecard";

static NSString *const FetchSCoreboardDataPostfix = @"getscoreboard";

static NSString *const SaveRoundPostfix = @"submitscore";

static NSString *const EndRoundPostfix = @"endscore";

static NSString *const FetchBannerPostFix = @"getadvbanner";



typedef NS_ENUM(NSInteger, SpotPrize)
{
    SpotPrize_None,
    SpotPrize_ClosestToPin,
    SpotPrize_StraightDrive,
    SpotPrize_LongDrive
};

typedef NS_ENUM(NSInteger, IsCollapse)
{
    IsCollapse_Collapsed,
    IsCollapse_NotCollapsed
};

@interface PT_StartEventViewController ()<UITextFieldDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
PT_EnterScoreSelectHolesDelegate,
UITableViewDelegate,
UITableViewDataSource>
{
    IBOutlet UILabel *_title;
    
    IBOutlet UILabel *_loaderTitle;
    
    IBOutlet UILabel *_golfCourseName;
    
    NSInteger _currentSelectedPlayerIndex;
    
    NSInteger _currentHoleNumber;
    
    NSInteger _holeStartNumber;
    
    NSInteger _holeStartedfrom;
    
    NSInteger _numberOfHoles;
    
    NSInteger firstLeftClick;
    
    NSInteger firstRightClick;
    
    NSInteger grossVlaue;
    
    NSInteger puttValue;
    
    NSInteger sandMainValue;

    BOOL isFirstLaunch;
    
    NSInteger lastHolePlayed;
    
    SpotPrize spotPrizeType;
    
    //Mark;-for getting closet feet and inches from Api
    NSString *closetFeet;
    NSString *closetInch;
    
    IBOutlet UIView *splForMatSubView;
    
    NSInteger actionBottomBtn;
    NSInteger parholeInteraction;
    
    IBOutlet UIImageView *delegateImage;
    //IBOutlet UIButton *delegateButton;
    IBOutlet UIView *delegateView;
    IBOutlet NSLayoutConstraint *constraintEndRoundBottom;
    IBOutlet NSLayoutConstraint *constraintPopUpCancelX;
    
    //Spinner flag to avoid blocking the UIView after back from scopreboard is pressed
    BOOL isLoderLoded;
    BOOL isHolesViewShownForNewFormats;
    
    BOOL isSaveTapped;
    BOOL isUpdateScore;
}

//@property (assign, nonatomic) BOOL isCollapse;

@property (strong, nonatomic) NSNumber *collapseStatus;

@property (strong, nonatomic) PT_StartEventTableView *tableViewBtn;

@property (strong, nonatomic) PT_CreatedEventModel *createdEventModel;

//Mark:-prperties for 420Format View
@property(strong,nonatomic)PT_FourTwoZeroView *fourTwoZeroView;

//Mark:-Prop for Vegas Format
@property(strong,nonatomic)PT_VegasFormatView *vegasFormatView;

//Mark:-prop for AutoPress
@property(strong,nonatomic)PT_AutoPressFormatView *autoPressFormatView;



//@property (weak, nonatomic) IBOutlet UILabel *indexValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *parButton;

@property (weak, nonatomic) IBOutlet UILabel *holeNumberLabel;


@property (weak, nonatomic) IBOutlet UILabel *spotPrizeTypeTitleLabel;


@property (weak, nonatomic) IBOutlet UITextField *textFeet;
@property (weak, nonatomic) IBOutlet UITextField *textInches;
@property (weak, nonatomic) IBOutlet UILabel *feetTitle;
@property (weak, nonatomic) IBOutlet UILabel *inchesTitle;

@property (weak, nonatomic) IBOutlet UIView *fairwaysView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFairwaysViewHeight;

//@property (weak, nonatomic) IBOutlet UIButton *sButton;

//Players for Scoring
@property (strong, nonatomic) NSMutableArray *arrPlayersForScoring,*arrHolesPlayed;
@property (strong, nonatomic) IBOutlet UIView *playersOptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSelectImageX;
@property (weak, nonatomic) IBOutlet UIView *spotPrizeView;
@property (strong, nonatomic) PT_ScoringModel *scoringModel;

//Mark:-End Round PopUp
@property(weak,nonatomic) IBOutlet UIView *endRoundpopView,*endRoundpopBackView;

//Fields for entry
//@property (weak, nonatomic) IBOutlet UITextField *textGrossScore;

//Special format Leader Board
@property (weak, nonatomic) IBOutlet UIView *splFormatLeaderboardView;

@property (weak, nonatomic) IBOutlet UIButton *increamentPuttsButton;
@property (weak, nonatomic) IBOutlet UIButton *decreamentPuttsButton;
@property (weak, nonatomic) IBOutlet UIButton *decreamentGrossButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *speacialFormatLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *speacialFormatRightButton;
@property (weak, nonatomic) IBOutlet UIButton *speacialFormatCentreButton;
@property (weak, nonatomic) IBOutlet UIImageView *speacialFormatDirectionImage;

//End Round
@property (strong, nonatomic) UIAlertController * alertEndRound;

//Picker view for spot prize
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewMetrics;
@property (strong, nonatomic) NSMutableArray *arrFeets;
@property(strong,nonatomic)NSMutableArray *arrFeetValues,*arr420Format;
@property (strong, nonatomic) NSArray *arrInches,*arrfeetsForcloset;
@property (strong, nonatomic) NSArray *arrYards;
@property (weak, nonatomic) IBOutlet UIView *viewPickerBG;
@property (weak, nonatomic) IBOutlet UILabel *labelFeet;
@property (weak, nonatomic) IBOutlet UILabel *labelInches;

@property (strong, nonatomic) PT_EnterScoreSelectHoles *selectHolesView;

@property (strong, nonatomic) UIView *hidingView;

@property (weak, nonatomic) IBOutlet UIView *popUpLeaderboardView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopUpLeaderboardHeight;

@property (strong, nonatomic) PT_AutopressView *autopressView;

@property (weak, nonatomic) IBOutlet UITableView *tablePlayersOption;

@property (weak, nonatomic) IBOutlet UIView *tableContainerView;

@property (weak, nonatomic) IBOutlet UILabel *parValueLabel;

//Mark:-for implementing edit Score property declration here
@property(weak,nonatomic) IBOutlet UIView *editScoreNewView;

@property(weak,nonatomic) IBOutlet UIView *editscoreLeftarrow,*editScoreRightarrow;

@property(assign,nonatomic) NSInteger noOfholePlayed;

@property(assign,nonatomic) BOOL isButtonClicked;

@property(assign,nonatomic) BOOL isLeftClicked;

@property(assign,nonatomic) BOOL isRightClicked;

@property(assign,nonatomic) BOOL isDelegated;

@property(strong,nonatomic) MBProgressHUD *hud;


@end


@implementation PT_StartEventViewController

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    self.createdEventModel = model;
    [self fetchScoreCardData];

    //[self fetchSpecialFormatLeadershipData];
    return self;
}

- (void)viewDidLoad
{
  self.hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
    isFirstLaunch = YES;
    PT_CacheHoleData *cacheData = [PT_CacheHoleData new];
    [cacheData removeAllCachedHoleData];
                       
    //_popUpView.frame = self.view.bounds;
    _collapseStatus = [NSNumber numberWithInt:1];
    [self removeAllCacheData];
    _hidingView = [UIView new];
    _hidingView.frame = self.view.frame;
   // [self.view addSubview:_hidingView];
    _hidingView.hidden = NO;
    
    //_isCollapse  = YES;
    //[self fetchScoreCardData];
    
    _arrHolesPlayed = [NSMutableArray new];
    _arrPlayersForScoring = [NSMutableArray new];
    _arrfeetsForcloset = [NSArray new];
    
    _currentHoleNumber = 1;
    
    _isButtonClicked = NO;
    _isLeftClicked = NO;
    _isRightClicked = NO;
    
    _isDelegated = NO;
    
    [self.endRoundpopView setHidden:YES];
    
    [self setInitialValuesForUI];
    _number = [[NSNumber alloc] initWithInt:0];
    
    nbr =0;
    
    NSString * nbrStr=[NSString stringWithFormat:@"%d",nbr];
    
   
    //Hole Number
    [_holeNumberLabel setText:nbrStr];
    
    _popupView.hidden = YES;
    [self.endRoundpopView setHidden:YES];
    
    //if (_tableViewBtn == nil)
    {
        _tableViewBtn = [[[NSBundle mainBundle] loadNibNamed:@"PT_StartEventTableView"
                                                       owner:self
                                                     options:nil] objectAtIndex:0];
        [self.view addSubview:self.tableViewBtn];
    }
    
    self.tablePlayersOption.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.fourTwoZeroView.hidden = YES;
    self.tableViewBtn.hidden = YES;
    _clickImageView1.hidden = NO;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
    [super viewDidLoad];
    [self customdesign];
    
    // Do any additional setup after loading the view from its nib.
    
    [self actionBtn1:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGesture setDelegate:self];
    [_alertEndRound.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnViewReceived:)];
    [tapViewGesture setDelegate:self];
    [self.view addGestureRecognizer:tapViewGesture];
    
    UITapGestureRecognizer *splFormatGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOpenFormat)];
    [self.splFormatLeaderboardView addGestureRecognizer:splFormatGesture];
    [splForMatSubView addGestureRecognizer:splFormatGesture];
    [self.splFormatLeaderboardView bringToFront];
    
    
    [self createInchesData];

    [self createFeetData];
    
    //[self setSaveButtonEnabled:NO];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    if (screenHeight == 568) {
        
        //self.popupView.frame = CGRectMake(0, self.view.frame.origin.y - 160, self.view.bounds.size.width, self.view.frame.size.height);
        self.popupView.frame = CGRectMake(0, self.view.frame.origin.y - 160, self.view.bounds.size.width, self.view.frame.size.height);
        [self.view addSubview:self.popupView];
        [self.popupView setHidden:YES];
        
        [self.scoreCentreBtn setTitle:@"SCORECARD" forState:UIControlStateNormal];
        self.scoreCentreBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15.0f];
        self.scoreCentreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreCentreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        
        [self.saveCentreBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        self.saveCentreBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15.0f];
        self.saveCentreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.saveCentreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        

        
    }else if(screenHeight == 667 || screenHeight == 736){
        //self.popupView.frame = CGRectMake(0, self.view.frame.origin.y - 60, self.view.frame.size.width, self.view.frame.size.height);
        self.popupView.frame = CGRectMake(0, self.view.frame.origin.y - 60, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:self.popupView];
        [self.popupView setHidden:YES];
        
        [self.scoreCentreBtn setTitle:@"SCORECARD" forState:UIControlStateNormal];
        self.scoreCentreBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17.0f];
        self.scoreCentreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreCentreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        
        [self.saveCentreBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        self.saveCentreBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17.0f];
        self.saveCentreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.saveCentreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);

    }else{
        
        //self.popupView.frame = CGRectMake(0, 0, self.loaderView.frame.size.width, self.loaderView.frame.size.height);
        //self.popupView.frame = self.view.frame;
       // [self.view addSubview:self.popupView];
        [self.popupView setHidden:YES];
        
        [self.scoreCentreBtn setTitle:@"SCORECARD" forState:UIControlStateNormal];
        self.scoreCentreBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17.0f];
        self.scoreCentreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreCentreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        
        [self.saveCentreBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        self.saveCentreBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17.0f];
        self.saveCentreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.saveCentreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
    }
    //self.popupView.frame = self.view.bounds;
    //[self.view addSubview:self.popupView];
    //[self.popupView setHidden:YES];
    
    self.tablePlayersOption.dataSource = self;
    self.tablePlayersOption.delegate = self;
    
    
    //Hide Bottom Button
    self.editScoreNewView.hidden = YES;
    self.ScoreCardBottomBtn.hidden = YES;
    self.SaveBottomBtn.hidden = YES;
    self.scoreCentreBtn.hidden = YES;
    self.saveCentreBtn.hidden = YES;
    
    [self setUpBottomView];
    
    if ([self.createdEventModel.numberOfPlayers integerValue] == 1)
    {
        
        delegateView.hidden = YES;
        constraintEndRoundBottom.constant = constraintEndRoundBottom.constant - 58;
        constraintPopUpCancelX.constant = self.view.center.x ;
        
    }
    
    
    //MARK:- drag button anywher
    
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(wasDragged:)];
    // cancel touches so that touchUpInside touches are ignored
    panRecognizer.cancelsTouchesInView = YES;
    [_bottomBtn addGestureRecognizer:panRecognizer];
    //[_bottomBtn addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    [_bottomBtn addTarget:self action:@selector(actionBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    

    
}

- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIButton *button = (UIButton *)recognizer.view;
    CGPoint translation = [recognizer translationInView:button];
    
    button.center = CGPointMake(button.center.x + translation.x, button.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:button];
}

//- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
//{
//    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
//    UIControl *control = sender;
//    control.center = point;
//}

- (void)setSaveButtonEnabled:(BOOL)enable
{
    
    if (enable == NO)
    {
        [self.saveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [[self saveButton] setEnabled:NO];
    }
    else
    {
        [[self saveButton] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[self saveButton] setEnabled:YES];
    }
}

- (void)createFeetData
{
    self.arrfeetsForcloset = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                     @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                     @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                     @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"30",
                     @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",nil];
    
    
    
    self.arrFeets = [NSMutableArray new];
    
    self.arrInches = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",nil];
}
- (void)createInchesData
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _arrFeetValues = [NSMutableArray new];
        
        for (NSInteger i = 150; i < 451; i++)
            [_arrFeetValues addObject:[NSNumber numberWithInteger:i]];
        
        for (int j = 0; j<_arrFeetValues.count; j++) {
            
            NSString *str = [NSString stringWithFormat:@"%@",[_arrFeetValues objectAtIndex:j]];
            
            [_arrFeets addObject:str];
        }
       // _arrFeets = [_arrFeetValues componentsJoinedByString:@""];
    });
    
    //[self.pickerViewMetrics reloadAllComponents];
    
}


- (void)tapOnViewReceived:(UITapGestureRecognizer *)gestureRecognizer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _selectHolesView.hidden = YES;
        _viewPickerBG.hidden = YES;
    });
    
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.alertEndRound dismissViewControllerAnimated:YES completion:nil];
        
    });
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (spotPrizeType == SpotPrize_ClosestToPin || spotPrizeType == SpotPrize_StraightDrive)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        if (spotPrizeType == SpotPrize_ClosestToPin || spotPrizeType == SpotPrize_StraightDrive){
            
            return [_arrfeetsForcloset count];
            
        }else{
            
        return [_arrFeets count];
        }
    }
    else {
        return [_arrInches count];
    }
}

// Populate the rows of the Picker

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    // Component 0 should load the array1 values, Component 1 will have the array2 values
    if (component == 0) {
        if (spotPrizeType == SpotPrize_ClosestToPin || spotPrizeType == SpotPrize_StraightDrive){
            title = [_arrfeetsForcloset objectAtIndex:row];
        }else{
        title = [_arrFeets objectAtIndex:row];
        }
    }
    else if (component == 1) {
        //return [_arrInches objectAtIndex:row];
        title = [_arrInches objectAtIndex:row];
    }
    
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (spotPrizeType == SpotPrize_ClosestToPin || spotPrizeType == SpotPrize_StraightDrive)
    {
        NSString *feet = self.arrfeetsForcloset[[self.pickerViewMetrics selectedRowInComponent:0]];
        NSString *inches = self.arrInches[[self.pickerViewMetrics selectedRowInComponent:1]];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
        EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
        
        PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
        model.closestFeet = [[NSString stringWithFormat:@"%@'%@\"",feet,inches] floatValue];
        model.closestInch = [[NSString stringWithFormat:@"%@",inches] floatValue];
        cell.textFeet.text = [NSString stringWithFormat:@"%@'%@\"",feet,inches];
        
        NSLog(@"%ld",(long) model.closestInch);

    }
    else
    {
        self.textFeet.text = self.arrFeets[row];
        NSString *feet = self.arrFeets[[self.pickerViewMetrics selectedRowInComponent:0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
        EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
        
        PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
        model.closestFeet = [[NSString stringWithFormat:@"%@",feet] floatValue];
        
        cell.textFeet.text = [NSString stringWithFormat:@"%@",feet];
    }
}

-(IBAction)actionNotApplicableonPicker:(UIButton *)sender
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
     PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
     self.viewPickerBG.hidden = YES;
    model.closestFeet = -1;
    model.closestInch = 0;
    cell.textFeet.text = @"-";
    [cell.textFeet resignFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.bannnerView.hidden = YES;

    _popupView.hidden = YES;
    
    _hidingView.hidden = NO;
    
    if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId)
    {
        
        self.popUpLeaderboardView.hidden = YES;
        self.constraintPopUpLeaderboardHeight.constant = self.constraintPopUpLeaderboardHeight.constant - self.popUpLeaderboardView.frame.size.height - 5;
        // [self fetchSpecialFormatLeadershipData];
        
        //Mark:-fetching Data For 420Format
       // [self fourTwoZeroformatdata];
        
        self.leaderBoardBtn.hidden = YES;
        //self.splFormatLeaderboardView.hidden = YES;
        
        if ([self.createdEventModel.formatId integerValue] == Format420Id)
        {
            _speacialFormatDirectionImage.hidden = YES;
        }
        else
        {
            
        }
    }
    else
    {
        self.leaderBoardBtn.hidden = NO;
        self.splFormatLeaderboardView.hidden = YES;
        
    }
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    [_pickerViewMetrics setValue:[UIColor whiteColor] forKey:@"textColor"];
    
}


- (void)setInitialValuesForUI
{
    _title.text = self.createdEventModel.eventName;
    _loaderTitle.text = self.createdEventModel.eventName;
    _golfCourseName.text = [self.createdEventModel.golfCourseName uppercaseString];
    
}

- (void)setUpPlayerButtons
{
    
    float width = (self.playersOptionView.frame.size.width - (_parButton.frame.origin.x + _parButton.frame.size.width + 5)) / [self.arrPlayersForScoring count] - 1;
    __block float x = _parButton.frame.origin.x + _parButton.frame.size.width + 5;
    
    self.clickImageView3 = [UIImageView new];
    
    self.clickImageView3.backgroundColor = [UIColor colorWithRed:(16/255.0) green:(68/255.0) blue:(151/255.0) alpha:1.0];
    
    
    [self.arrPlayersForScoring enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PT_ScoringIndividualPlayerModel *model = obj;
            UIButton *btnPlayer = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString * name = [NSString stringWithFormat:@"%@(%li)",[model.shortName uppercaseString], (long)model.handicap];
            [btnPlayer setTitle:name forState:UIControlStateNormal];
            btnPlayer.frame = CGRectMake(x, _parButton.frame.origin.y + 8, width, self.playersOptionView.frame.size.height - 20);
            [btnPlayer.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:12]];
            [btnPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            x = x + width + 1;
            btnPlayer.tag = idx;
            if ([self.createdEventModel.isIndividual isEqualToString:@"Team"])
            {
                switch (idx) {
                    case 0:
                    {
                        btnPlayer.backgroundColor = SplFormatGrayColor;
                    }
                        break;
                        
                    case 1:
                    {
                        btnPlayer.backgroundColor = SplFormatGrayColor;
                    }
                        break;
                    case 2:
                    {
                        btnPlayer.backgroundColor = SplFormatRedTeamColor;
                    }
                        break;
                        
                    case 3:
                    {
                        btnPlayer.backgroundColor = SplFormatRedTeamColor;
                    }
                        break;
                }
            }
            else if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
            {
                if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                    [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                    [self.createdEventModel.formatId integerValue] == Format420Id ||
                    [self.createdEventModel.formatId integerValue] == Format21Id ||
                    [self.createdEventModel.formatId integerValue] == FormatVegasId)
                {
                    switch (idx) {
                        case 0:
                        {
                            btnPlayer.backgroundColor = SplFormatGrayColor;
                        }
                            break;
                            
                        case 1:
                        {
                            btnPlayer.backgroundColor = SplFormatRedTeamColor;
                        }
                            break;
                       
                    }
                }
                else
                {
                    btnPlayer.backgroundColor = SplFormatGrayColor;
                }
            }
            else
            {
                btnPlayer.backgroundColor = SplFormatGrayColor;
            }
            //btnPlayer.backgroundColor = bgColor;
            [btnPlayer addTarget:self action:@selector(actionSelectPlayerOption:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.playersOptionView addSubview:btnPlayer];
            
            if (idx == 0)
            {
                
                float width = btnPlayer.frame.size.width;
                /*self.clickImageView3.frame = CGRectMake((btnPlayer.frame.origin.x ), btnPlayer.frame.origin.y - 2 + btnPlayer.frame.size.height, width, 2);*/
                self.clickImageView3.frame = CGRectMake(btnPlayer.frame.origin.x, btnPlayer.frame.size.height - 2, width, 2);
                [btnPlayer addSubview:self.clickImageView3];
                
                if ([self.createdEventModel.formatId integerValue] == Format420Id)
                {
                    self.clickImageView3.backgroundColor = SplFormatRedColor;
                }
                
                
                //[self.playersOptionView addSubview:self.clickImageView3];
                //[btnPlayer addSubview:self.clickImageView3];
                [self.playersOptionView bringToFront];
                //[self.clickImageView3 bringToFront];
                
                _currentSelectedPlayerIndex = 0;
               // _currentHoleNumber = model.holeLastPlayed;
                if ([self.createdEventModel.back9 isEqualToString:@"Back 9"] && _holeStartedfrom == 1)
                {
                    _currentHoleNumber = 9;
                }
                
                //[self handleIncreamentHoleNumber];
                
                [self setScoresForModel:model];
                
            }
            else
            {
                
            }
            
            if (idx == [self.arrPlayersForScoring count] - 1)
            {
                
                float height = 0;
                if (self.createdEventModel.totalHoleNumber == 18)
                {
                    height = 360;
                }
                else
                {
                    height = 250;
                }
                NSLog(@"%ld",_currentHoleNumber);
                _selectHolesView = [[[NSBundle mainBundle] loadNibNamed:@"PT_EnterScoreSelectHoles" owner:self options:nil] firstObject];
                _selectHolesView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.frame.size.width, height);
                
                [self.view addSubview:_selectHolesView];
                //__block PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
                
                
                
                if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
                {
                    [_selectHolesView setNumberOfHoles:self.createdEventModel.totalHoleNumber andFront:NO];
                }
                else
                {
                    [_selectHolesView setNumberOfHoles:self.createdEventModel.totalHoleNumber andFront:YES];
                }
                
                if (_currentHoleNumber == 0) {
                    
                    _currentHoleNumber = 1;
                    
                }
                
                _selectHolesView.hidden = YES;
                _selectHolesView.delegate = self;
                [_selectHolesView setCurrentHole:_currentHoleNumber];
                
                if (lastHolePlayed == 0 || [self.createdEventModel.back9 isEqualToString:@"Back 9"] || [self.createdEventModel.back9 isEqualToString:@"Front 9"] ) {
                    
                    
               }else{
//                NSNumber *num = [NSNumber numberWithInteger:_currentHoleNumber];
//                
//                [model.arrplayedHole addObject:num];
                
                }
                [_selectHolesView bringToFront];
            }
            
        });
    }];

}
-(void)setInitialValue:(NSString *)value
{
    nbr = [value intValue];
}



-(void)setUpBottomView
{
    if ( [self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId ) {
        
        
        self.ScoreCardBottomBtn.hidden = NO;
        self.editScoreNewView.hidden = NO;
        
        [_bottomleftView removeFromSuperview ];
        [_bottomCentreView removeFromSuperview ];
        [_bottomrightView removeFromSuperview ];

        
        self.SaveBottomBtn.hidden = NO;
//        _SaveBottomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        _SaveBottomBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);

        
        
    }else {
        
        if ([self.createdEventModel.numberOfPlayers integerValue] == 1) {
            
            self.scoreCentreBtn.hidden = NO;
            self.saveCentreBtn.hidden = NO;
            [self.saveButton removeFromSuperview];
            
            [self.popUpLeaderboardView removeFromSuperview];
        }else{
        
        [self.scoreCentreBtn setTitle:@"LEADERBOARD" forState:UIControlStateNormal];

            actionBottomBtn = 1;
        self.scoreCentreBtn.hidden = NO;
        self.saveCentreBtn.hidden = NO;
            [self.saveButton removeFromSuperview];

        
        }

        
    }
}

-(void)customdesign{
    
    _parButton.layer.cornerRadius = 4.0;
    _parButton.layer.borderColor = [[UIColor clearColor] CGColor];
    _parButton.layer.borderWidth = 1.0;
    
    _bottomBtn.layer.cornerRadius = _bottomBtn.frame.size.width/2;
    _bottomBtn.layer.borderWidth = 1.0;
    _bottomBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    _bottomBtn.layer.masksToBounds = YES;
    
    [_incre1Btn setBackgroundColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1]];
    [_incre1Btn setTitle:@"+" forState:UIControlStateNormal];
    _incre1Btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);
    _closetLabel.layer.borderColor = [UIColor colorWithRed:173/255.0 green:213/255.0 blue:243/255.0 alpha:1].CGColor;
    _closetLabel.layer.borderWidth = 1.0f;
    
    _closet2Label.layer.borderColor = [UIColor colorWithRed:173/255.0 green:213/255.0 blue:243/255.0 alpha:1].CGColor;
    _closet2Label.layer.borderWidth =0.8f;
    
    _BTn1.layer.borderColor = [UIColor grayColor].CGColor;
    _BTn1.layer.borderWidth = 0.5f;
    
    _Btn2.layer.borderColor = [UIColor grayColor].CGColor;
    _Btn2.layer.borderWidth = 0.5f;

    _Btn3.layer.borderColor = [UIColor grayColor].CGColor;
    _Btn3.layer.borderWidth = 0.5f;

//    _bottomCentreView.layer.borderWidth = 0.5f;
//    _bottomCentreView.layer.borderColor = [UIColor blackColor].CGColor;
    
//    _bottomleftView.layer.borderWidth = 0.5f;
//    _bottomleftView.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    _bottomrightView.layer.borderWidth = 0.5f;
//    _bottomrightView.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionPickerDone
{
    _selectHolesView.hidden = YES;
    self.viewPickerBG.hidden = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    [cell.textFeet resignFirstResponder];
}

#pragma TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _selectHolesView.hidden = YES;
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //self.selectHolesView.hidden=YES;
    //[self.selectHolesView sendToBack];
    [self.pickerViewMetrics reloadAllComponents];
    if (spotPrizeType == SpotPrize_LongDrive){
        [self.pickerViewMetrics selectRow:150 inComponent:0 animated:YES];
        
        self.textFeet.text = self.arrFeets[15];
        NSString *feet = self.arrFeets[[self.pickerViewMetrics selectedRowInComponent:0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
        EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
        
        PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
        model.closestFeet = [[NSString stringWithFormat:@"%@",feet] floatValue];
        
        cell.textFeet.text = [NSString stringWithFormat:@"%@",feet];
        
        if ([self.createdEventModel.playersInGame isEqualToString:@"4+"]) {
            
           // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            //EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
            
            self.viewPickerBG.hidden = NO;
            [textField resignFirstResponder];

            
            
        }
        
    }
    //Mark:-Previsouly it is in Yards (changes made accordingly)
    else if (spotPrizeType == SpotPrize_StraightDrive){
        [self.pickerViewMetrics selectRow:15 inComponent:0 animated:YES];
        
        NSString *feet = self.arrfeetsForcloset[15];
        NSString *inches = self.arrInches[6];

        
        
       // self.textFeet.text = self.arrFeets[150];
        //NSString *feet = self.arrFeets[[self.pickerViewMetrics selectedRowInComponent:0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
        EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
        
        PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
//        model.closestFeet = [[NSString stringWithFormat:@"%@",feet] floatValue];
//        
//        cell.textFeet.text = [NSString stringWithFormat:@"%@",feet];
        
        model.closestFeet = [[NSString stringWithFormat:@"%@'%@\"",feet,inches] floatValue];
        model.closestInch = [[NSString stringWithFormat:@"%@",inches] floatValue];
        cell.textFeet.text = [NSString stringWithFormat:@"%@'%@\"",feet,inches];
        
        NSLog(@"%ld",(long)model.closestInch);
        
    }
    else
    {
        
        [self.pickerViewMetrics selectRow:15 inComponent:0 animated:YES];
        
        NSString *feet = self.arrfeetsForcloset[15];
        NSString *inches = self.arrInches[6];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
        EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
        
        PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
        model.closestFeet = [[NSString stringWithFormat:@"%@'%@\"",feet,inches] floatValue];
        model.closestInch = [[NSString stringWithFormat:@"%@",inches] floatValue];
        cell.textFeet.text = [NSString stringWithFormat:@"%@'%@\"",feet,inches];
    }
    

    /*float x = self.view.frame.origin.x;
    float y = self.view.frame.origin.y;
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    self.view.frame = CGRectMake(x, y - 80, width, height);
     */
    self.viewPickerBG.hidden = NO;
    [textField resignFirstResponder];
    
    


}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*float x = self.view.frame.origin.x;
    float y = self.view.frame.origin.y;
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    self.view.frame = CGRectMake(x, y + 80, width, height);
     */
}



- (void)setScoresForModel:(PT_ScoringIndividualPlayerModel *)model
{
    
    if (model.numberOfPuts == 0)
    {
        //self.putsLabel.text = @"-";
    }
    else
    {
        //self.putsLabel.text = [NSString stringWithFormat:@"%li", model.numberOfPuts];
    }
    if ([model.fairways isEqualToString:@"1"])
    {
        [self actionLeftBtn:self.saveButton];
    }
    else if ([model.fairways isEqualToString:@"2"])
    {
        [self actionHitBtn:self.saveButton];
    }
    else if ([model.fairways isEqualToString:@"3"])
    {
        [self actionRightBtn:self.saveButton];
    }
    else
    {
       //Fairways set images
    }
    
}

- (void)showSpotPrizeViewContents
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    __block EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
    if (spotPrizeType == SpotPrize_None)
    {
        //dispatch_async(dispatch_get_main_queue(), ^{
            cell.spotPrizeView.hidden = YES;
            
            cell.constraintContainerViewHeight.constant = cell.constraintContainerViewHeight.constant - 56;
            //NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            //[self.tablePlayersOption reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
       // });
        
        
    }
    else
    {
        cell.spotPrizeView.hidden = NO;
        
        NSInteger spot = spotPrizeType;
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (spot) {
                case SpotPrize_ClosestToPin:
                {
                    cell.spotPrizeLabel.text = @"    CLOSEST TO PIN";
                    cell.feetLabel.text = @"FEET";
                    //cell.feetLabel.hidden = YES;
                }
                    break;
                case SpotPrize_StraightDrive:
                {
                    cell.spotPrizeLabel.text = @"    STRAIGHT DRIVE";
                    cell.feetLabel.text = @"FEET";
                    //cell.feetLabel.hidden = NO;
                }
                    break;
                case SpotPrize_LongDrive:
                {
                    cell.spotPrizeLabel.text = @"    LONG DRIVE";
                    cell.feetLabel.text = @"YARDS";
                    //cell.feetLabel.hidden = NO;
                }
                    break;
                    
            }

        });
        
    }
}

#pragma mark - Action Methods

- (void)checkAndDisableOtherFieldsForEntry
{
    PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
    if ([[MGUserDefaults sharedDefault] getUserId] == self.createdEventModel.adminId)
    {
        if (model.playerId == [[MGUserDefaults sharedDefault] getUserId])
        {
            _hitBtn.userInteractionEnabled = YES;
            _rightBtn.userInteractionEnabled = YES;
            _leftBtn.userInteractionEnabled = YES;
            _increamentPuttsButton.userInteractionEnabled = YES;;
            _decreamentPuttsButton.userInteractionEnabled = YES;;
            _decreamentGrossButton.userInteractionEnabled = YES;;
            _incre1Btn.userInteractionEnabled = YES;
            _noBtn.userInteractionEnabled = YES;
            _yesBtn.userInteractionEnabled = YES;
            _saveButton.userInteractionEnabled = YES;
            
        }
        else
        {
            _hitBtn.userInteractionEnabled = NO;
            _rightBtn.userInteractionEnabled = NO;
            _leftBtn.userInteractionEnabled = NO;
            _increamentPuttsButton.userInteractionEnabled = NO;;
            _decreamentPuttsButton.userInteractionEnabled = NO;;
            _decreamentGrossButton.userInteractionEnabled = YES;;
            _incre1Btn.userInteractionEnabled = YES;
            _noBtn.userInteractionEnabled = NO;
            _yesBtn.userInteractionEnabled = NO;
            _saveButton.userInteractionEnabled = YES;
        }
    }
    else
    {
        if (model.playerId == [[MGUserDefaults sharedDefault] getUserId])
        {
            _hitBtn.userInteractionEnabled = YES;
            _rightBtn.userInteractionEnabled = YES;
            _leftBtn.userInteractionEnabled = YES;
            _increamentPuttsButton.userInteractionEnabled = YES;;
            _decreamentPuttsButton.userInteractionEnabled = YES;;
            _decreamentGrossButton.userInteractionEnabled = YES;;
            _incre1Btn.userInteractionEnabled = YES;
            _noBtn.userInteractionEnabled = YES;
            _yesBtn.userInteractionEnabled = YES;
            _saveButton.userInteractionEnabled = YES;
            
        }
        else
        {
            _hitBtn.userInteractionEnabled = NO;
            _rightBtn.userInteractionEnabled = NO;
            _leftBtn.userInteractionEnabled = NO;
            _increamentPuttsButton.userInteractionEnabled = NO;;
            _decreamentPuttsButton.userInteractionEnabled = NO;;
            _decreamentGrossButton.userInteractionEnabled = NO;;
            _incre1Btn.userInteractionEnabled = NO;
            _noBtn.userInteractionEnabled = NO;
            _yesBtn.userInteractionEnabled = NO;
            _saveButton.userInteractionEnabled = NO;
            
        }
    }
    
}

- (void)actionSelectPlayerOption:(UIButton *)sender
{
    NSLog(@"Selected Player tag: %li",sender.tag);
    self.constraintSelectImageX.constant = sender.center.x - (self.clickImageView3.frame.size.width/2);
    
    _currentSelectedPlayerIndex = sender.tag;
    
    [self checkAndDisableOtherFieldsForEntry];
    
   
        float width = sender.frame.size.width;
        /*self.clickImageView3.frame = CGRectMake((sender.frame.origin.x + sender.frame.size.width/2) - width/2, self.clickImageView3.frame.origin.y, width, 2);*/
    [self.clickImageView3 removeFromSuperview];
    self.clickImageView3.frame = CGRectMake(0 , sender.frame.size.height - 2, width, 2);
    [sender addSubview:self.clickImageView3];
        [self.clickImageView3 bringToFront];
        if ([self.createdEventModel.formatId integerValue] == Format420Id)
        {
        switch (sender.tag) {
            case 0:
            {
                self.clickImageView3.backgroundColor = SplFormatRedColor;
            }
                break;
                
            case 1:
            {
                self.clickImageView3.backgroundColor = SplFormatBlueColor;
            }
                break;
            case 2:
            {
                self.clickImageView3.backgroundColor = SplFormatGreenColor;
            }
                break;
        }
    }
    PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[sender.tag];
    [self setScoresForModel:model];
    
}

- (IBAction)actionSave:(UIButton *)sender
{
    PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        //[self showLoadingView:YES];
        NSString *fairway = nil;
        if (_scoringModel.parValue == 3)
        {
            
            model.fairways = @"0";
            fairway = model.fairways;
            
            NSLog(@"%@",model.fairways);
        }
        else if(model.playerId == _createdEventModel.scorerId){
            
            if ([model.fairways length] == 0) {
                
                model.fairways = @"0";
                fairway = model.fairways;
            }else{
            
            fairway = model.fairways;
            }
        }else{
            
            model.fairways = @"0";
            fairway = model.fairways;
        }
        
        
        NSString *sand = nil;
        if ([model.sand integerValue] == -1)
        {
            sand = @"-1";
        }
        else
        {
            sand = model.sand;
        }
        
        NSMutableArray *arrPlayerScore = [NSMutableArray new];
        for (NSInteger count = 0; count < [_arrPlayersForScoring count]; count++) {
            PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[count];
            NSString *sand = nil;
            if ([model.sand integerValue] == -1)
            {
                sand = @"-1";
            }
            else
            {
                NSLog(@"%li",(long)_createdEventModel.scorerId);
                if (model.playerId == _createdEventModel.scorerId  ) {
                    
                    sand = model.sand;
                }else{
                    
                    sand =@"-1";
                }
                
            }
            NSString *playerId = [NSString stringWithFormat:@"%li",(long)model.playerId];
            NSString *grossScore = [NSString stringWithFormat:@"%li",(long)model.grossScore];
            NSString *numOfPutts = [NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
            NSString *othersPutt;
             if (model.playerId == _createdEventModel.scorerId )
             {
                 
                 //numOfPutts = @"-1";
                 othersPutt = numOfPutts;
                 
             }else{
                 
                 othersPutt = @"-1";
             }
            
           
            
             NSString *feet = [NSString stringWithFormat:@"%li",(long)model.closestFeet];
            NSString *defaultFeet;
            if ([feet integerValue] == 0) {
                
               defaultFeet = @"0";
                
            }else if([feet integerValue] > 0){
                
                
                defaultFeet = feet;
                
            }else{
                
                defaultFeet = @"-1";

            }
            NSString *inches = [NSString stringWithFormat:@"%li",(long)model.closestInch];
            
            NSString *defaultInch;
            if ([inches integerValue] == 0) {
                
                defaultInch = @"0";
                
            }else{
                
                defaultInch = inches;
                
            }
            
            NSDictionary *dicPLayerScores = [NSDictionary dictionaryWithObjectsAndKeys:
                                             playerId,@"player_id",
                                             grossScore,@"score",
                                             othersPutt,@"no_of_putt",
                                             model.fairways,@"fairway",
                                             sand,@"sand",
                                             defaultFeet,@"closest_feet",
                                             inches,@"closest_inch",nil];
            
            [arrPlayerScore addObject:dicPLayerScores];
            NSLog(@"%@",dicPLayerScores);
        }
                
        //NSDictionary *dicPlayerScores = [NSDictionary dictionaryWithObject:arrPlayerScore forKey:@"player_score"];
        self.loaderView.hidden = NO;
       self.hud =  [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        NSLog(@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]);
        //MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.adminId],
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"hole_number":[NSString stringWithFormat:@"%li",(long)_currentHoleNumber],
                                @"version":@"2",
                                @"par":[NSString stringWithFormat:@"%li",(long)_scoringModel.parValue],
                                @"player_score":arrPlayerScore
                                };
        
          NSLog(@"%@",param);
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,SaveScorecardDataPostfix];
        
        NSString *encoded = [[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             stringByReplacingOccurrencesOfString:@"%20"
                             withString:@""] ;
        encoded = [encoded stringByReplacingOccurrencesOfString:@"%E2%80%8B" withString:@""];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        
        //[manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager setResponseSerializer:responseSerializer];
        
        [manager POST:encoded parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (responseObject != nil)
             {
                 NSDictionary *dicResponseData = responseObject;
                 
                 NSDictionary *dicOutput = dicResponseData[@"output"];
                 if ([dicOutput[@"status"] isEqualToString:@"1"])
                 {
                     
                     isSaveTapped = YES;
                     
                 }
                 
                 NSDictionary *arrData;
                 id total = dicOutput[@"total"];
                 if ([total isKindOfClass:[NSArray class]])
                 {
                     arrData  = [dicOutput[@"total"] firstObject];
                 }
                 else
                 {
                     arrData  = dicOutput[@"total"];
                 }
                 
                 NSInteger holeplayed;
                 //if (arrData[@"0"])
                 if ([[arrData allKeys] containsObject:@"0"])
                 {
                     NSDictionary *totalDic = arrData[@"0"];
                     
                     holeplayed = [totalDic[@"no_of_holes_played"] integerValue];
                     _noOfholePlayed = holeplayed;
                     _holeStartedfrom   = [totalDic[@"hole_start_from"] integerValue];
                     // model.arrplayedHole = [NSMutableArray new];
                     model.arrplayedHole = [totalDic[@"played_hole_number"] mutableCopy];
                     _arrHolesPlayed = model.arrplayedHole;
                 }
                 else
                 {
                     holeplayed = [arrData[@"no_of_holes_played"] integerValue];
                     _noOfholePlayed = holeplayed;
                     _holeStartedfrom   = [arrData[@"hole_start_from"] integerValue];
                     
                 }
                 
                 
                 
                 parholeInteraction = holeplayed;
                 
                 
                 if ( [self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                     [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                     [self.createdEventModel.formatId integerValue] == Format420Id ||
                     [self.createdEventModel.formatId integerValue] == Format21Id ||
                     [self.createdEventModel.formatId integerValue] == FormatVegasId ) {
                     
                     
                     _isButtonClicked = YES;
                     
                     
                     
                     [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li", (long)self.createdEventModel.golfCourseId] andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                 }else{
                     
                     [self handleIncreamentHoleNumber];
                 }
                 
                 
                 
                 
            }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error:%@",[error localizedDescription]);
             [self showAlertWithMessage:[error localizedDescription]];
             
         }];

        
        /*
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
         
         
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
         
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              isSaveTapped = YES;

                          }
                          
                          NSDictionary *arrData;
                          id total = dicOutput[@"total"];
                          if ([total isKindOfClass:[NSArray class]])
                          {
                              arrData  = [dicOutput[@"total"] firstObject];
                          }
                          else
                          {
                              arrData  = dicOutput[@"total"];
                          }
                          
                          NSInteger holeplayed;
                          //if (arrData[@"0"])
                          if ([[arrData allKeys] containsObject:@"0"])
                          {
                              NSDictionary *totalDic = arrData[@"0"];
                          
                               holeplayed = [totalDic[@"no_of_holes_played"] integerValue];
                              _noOfholePlayed = holeplayed;
                              _holeStartedfrom   = [totalDic[@"hole_start_from"] integerValue];
                             // model.arrplayedHole = [NSMutableArray new];
                              model.arrplayedHole = [totalDic[@"played_hole_number"] mutableCopy];
                              _arrHolesPlayed = model.arrplayedHole;
                          }
                          else
                          {
                              holeplayed = [arrData[@"no_of_holes_played"] integerValue];
                              _noOfholePlayed = holeplayed;
                              _holeStartedfrom   = [arrData[@"hole_start_from"] integerValue];

                          }
                          

                          
                          parholeInteraction = holeplayed;
                          
         
                          if (holeplayed == 18) {
                              
                              [_ScoreCardBottomBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                              [_scoreCentreBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                              actionBottomBtn = 5;
                          }
         
                          
                          if ( [self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                              [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                              [self.createdEventModel.formatId integerValue] == Format420Id ||
                              [self.createdEventModel.formatId integerValue] == Format21Id ||
                              [self.createdEventModel.formatId integerValue] == FormatVegasId ) {
                              
                              
                                      _isButtonClicked = YES;
                                      
                                      

                                      [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li", (long)self.createdEventModel.golfCourseId] andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                          }else{
                              
                              [self handleIncreamentHoleNumber];
                          }
                              
                                  
                                  
                                  
                                                             //  });
                                 
                          //}
//                          else
//                          {
//                              [self showAlertWithMessage:@"Unable to Save data. Please try again."];
//                          }
                      }
                      
                      else
                      {
                          [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                          self.loaderView.hidden = YES;


                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }else{
                      
                      //[MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                      //self.loaderView.hidden = YES;
                      [self actionSave:nil];

                      UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"PUTT2GETHER"
                                                    message:@"Connection Lost."
                                                    preferredStyle:UIAlertControllerStyleAlert];
                      
                      
                      
                      UIAlertAction* cancel = [UIAlertAction
                                               actionWithTitle:@"Dismiss"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   
                                                   [self handleDecreamentHoleNumber];
                                                   
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
                      
                      [alert addAction:cancel];
                      
                      [self presentViewController:alert animated:YES completion:nil];
 
 
                  }
         
                  
              }];
 */

    }
    
    
    
    
}

- (IBAction)actionpopupViewBtn:(id)sender {
    _popupView.hidden = YES;
}

- (IBAction)actionIncrementGross:(UIButton *)sender {
    _currentSelectedPlayerIndex = sender.tag;
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    
    if (_currentSelectedPlayerIndex == 0) {
        
    
    if (model.grossScore == 20)
    {
        grossVlaue = model.grossScore;

        return;
    }
    model.grossScore++;
    
    grossVlaue = model.grossScore;
        
    }else{
        
        if (model.grossScore == 20)
        {
            
            return;
        }
        
        
        model.grossScore++;
        
        
    
        
    }
    
    NSString * nbrStr = [NSString stringWithFormat:@"%li",model.grossScore];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    cell.grossValueLabel.text = nbrStr;
    
    /*model.numberOfPuts = 0;
    model.sand = 0;
    cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
    cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.sand];*/
    
}

- (IBAction)actionDecreamentGross:(UIButton *)sender
{
    _currentSelectedPlayerIndex = sender.tag;
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    

    if (_currentSelectedPlayerIndex == 0) {
        
        if (model.grossScore == 1)
        {
            grossVlaue = model.grossScore;
        }
        else
        {
            grossVlaue = model.grossScore;
            
            model.grossScore--;
            
            
            if (puttValue + sandMainValue == grossVlaue - 1 || puttValue + sandMainValue < grossVlaue -1) {
                
                if (puttValue > sandMainValue) {
                    
                    if ([cell.puttsValueLabel.text isEqualToString:@"0"] || [cell.puttsValueLabel.text isEqualToString:@"-"]) {
                        
                        cell.puttsValueLabel.text = @"-";
                        model.numberOfPuts = -1;
                        return;
                        
                    }else{
                        
                        puttValue = puttValue - 1;
                        cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",(long)puttValue];
                        model.numberOfPuts = puttValue;
                    }
                }else{
                    
                    if ([cell.sandValueLabel.text isEqualToString:@"0"] || [cell.sandValueLabel.text isEqualToString:@"-"]) {
                        
                        cell.sandValueLabel.text = @"-";
                        model.sand = @"-1";
                        return;
                        
                    }else{
                        
                        sandMainValue = sandMainValue - 1;
                        cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",(long)sandMainValue];
                        model.sand = [NSString stringWithFormat:@"%li",(long)sandMainValue];
                    }
                }
            }
        }

    }else{
        
        if (model.grossScore == 1)
        {
            
        }
        else
        {
            
            model.grossScore--;
        }
    }
    //if (model.grossScore == 0)
       NSString * nbrStr=[NSString stringWithFormat:@"%li",(long)model.grossScore];
    
    cell.grossValueLabel.text = nbrStr;
    
}

- (IBAction)actionIncreamentPutts:(UIButton *)sender
{
    _currentSelectedPlayerIndex = sender.tag;
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
   /* if (model.numberOfPuts == _scoringModel.parValue-1)
    {
        
    }
    else*/
    
    NSLog(@"%li",(long)grossVlaue);
    
    NSInteger PuttSandSum = grossVlaue - 1;
    
    if (puttValue + sandMainValue < PuttSandSum) {
        
        model.numberOfPuts = model.numberOfPuts + 1;
        cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
        puttValue = model.numberOfPuts;
        
    }else{
        
        if (puttValue + sandMainValue == PuttSandSum) {
            
            if (sandMainValue <= 0) {
                
                model.numberOfPuts = puttValue;
                
                return;
            }else{
                
                model.numberOfPuts = model.numberOfPuts + 1;
                sandMainValue = sandMainValue - 1;
                cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",(long)sandMainValue];
                puttValue = model.numberOfPuts;

            }
            
        }else{
            
            
        }
    }
    
    
    
    NSString * nbrStr=[NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
    
    
    cell.puttsValueLabel.text = nbrStr;
    
    
}

- (BOOL)vaidatePuttValue:(PT_ScoringIndividualPlayerModel *)model andPutEntry:(NSInteger)putts
{
    BOOL returnType = NO;
    
    if ([model.sand integerValue] == 0)
    {
        if (putts <= (model.grossScore - 1))
        {
            returnType = YES;
        }
        else
        {
            return YES;
        }
        
    }
    else
    {
        if (putts <= ((model.grossScore - [model.sand integerValue]) - 1))
        {
            returnType = YES;
        }
    }
    
    return returnType;
}

- (IBAction)actionDecreamentPutts:(UIButton *)sender {
    
    _currentSelectedPlayerIndex = sender.tag;

    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
    NSInteger PuttSandSum = grossVlaue - 1;
    
    if (puttValue + sandMainValue == PuttSandSum) {
        
        if ([cell.puttsValueLabel.text isEqualToString:@"0"] || [cell.puttsValueLabel.text isEqualToString:@"-"])
        {
            cell.puttsValueLabel.text = @"-";
            model.numberOfPuts = -1;
            return;
            
        }else
        {
           model.numberOfPuts = model.numberOfPuts - 1;
           cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
            puttValue = model.numberOfPuts;
        }
        
    }else{
        
        if (puttValue + sandMainValue < PuttSandSum) {
            
            if ([cell.puttsValueLabel.text isEqualToString:@"0"] || [cell.puttsValueLabel.text isEqualToString:@"-"])
            {
                cell.puttsValueLabel.text = @"-";
                model.numberOfPuts = -1;
                return;
                
            }else
            {
                model.numberOfPuts = model.numberOfPuts - 1;
                cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
                puttValue = model.numberOfPuts;
            }
            
        }
    }

    
    /*
    if (model.numberOfPuts == 0)
    {
        model.numberOfPuts = -1;
        NSString * nbrStr= @"-";
        
        cell.puttsValueLabel.text = nbrStr;
        
    }
    else
    {
        if ([cell.puttsValueLabel.text isEqualToString:@"-"]) {
            
            model.numberOfPuts = -1;
            
        }else{
        
        model.numberOfPuts--;
        NSString * nbrStr=[NSString stringWithFormat:@"%li",model.numberOfPuts];
        
        cell.puttsValueLabel.text = nbrStr;
        }
    }
    */
    
    
}
- (IBAction)actionBtn1:(id)sender {
    
    
    
    
    
    
    _clickImageView1.hidden = NO;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
}

- (IBAction)actionBtn2:(id)sender {
    
    
    
    
    _clickImageView1.hidden = YES;
    _clickImageView2.hidden = NO;
    _clickImageView3.hidden = YES;
    _clickImageView4.hidden = YES;
}
- (IBAction)actionBtn3:(id)sender {
    
    
    
    
    _clickImageView1.hidden = YES;
    _clickImageView2.hidden = YES;
    _clickImageView3.hidden = NO;
    _clickImageView4.hidden = YES;
}

- (IBAction)actionLeftArrow:(id)sender {
    
    _isLeftClicked = YES;
   
    [self handleDecreamentHoleNumber];
    
    
}

- (void)handleDecreamentHoleNumber
{
    [self loadDefaultFirstPlayer];
    //Hole Number
    NSInteger counter = [_holeNumberLabel.text integerValue];
    if ( [self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId ) {
        
        
        NSInteger count = [_holeNumberLabel.text integerValue];
        
        if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
        {
            if (count == 10)
            {
               // _currentHoleNumber = 18;
                count = 18;
                
                
            }else
            {
                count--;
               // _currentHoleNumber = count;

            }
        }else
        {
             if (count == _holeStartedfrom && count != 1)
            {
                //_currentHoleNumber = self.createdEventModel.totalHoleNumber;
                count--;
                
            }
            else if (count == 1){
                
                if ([self.createdEventModel.back9 isEqualToString:@"Front 9"]) {
                    
                    count = 9;
                }else{
                
                count = 18;
                }
                //counter = 18;
            }else
            {
                count--;
               // _currentHoleNumber = count;
            }
        }
        
        NSLog(@"%@",_arrHolesPlayed);
        
        
        NSNumber *num = [NSNumber numberWithInteger:count];
        
        if ([_arrHolesPlayed containsObject:num]) {
            
            ([self comparingDataForNewFormat:counter and:self.arrPlayersForScoring]);
                
            
        }else{
            
            [self showAlertWithMessage:@"Save score to continue. Skipping of the holes is not allowed."];
            _isLeftClicked = NO;

            NSString *nbrstr = [NSString stringWithFormat:@"%li",(long)counter];
            
            
            [_holeNumberLabel setText:nbrstr];
            
            return;
        }


        return;
        
    }

    PT_CacheHoleData *cacheHandler = [[PT_CacheHoleData alloc] initWithScoreDataArray:self.arrPlayersForScoring];
    
    [cacheHandler saveDataForHoleNumber:counter];
    
    if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
    {
        if (counter == 10)
        {
            _currentHoleNumber = 18;
            
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            counter = _currentHoleNumber;
            
            
            
        }
        else
        {
            counter--;
            _currentHoleNumber = counter;
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
          
        }
    }
    else
    {
        if (counter == _holeStartNumber)
        {
            _currentHoleNumber = self.createdEventModel.totalHoleNumber;
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            counter = _currentHoleNumber;
           
            
            
        }
        else
        {
            counter--;
            _currentHoleNumber = counter;
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
           
        }
    }
    
    
    NSString *nbrstr = [NSString stringWithFormat:@"%li",(long)counter];
    
    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:3.5f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    transitionAnimation.subtype = kCATransitionFromTop;
    [_holeNumberLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
    
    [_holeNumberLabel setText:nbrstr];
    
}

- (IBAction)actionRightArrow {
    
  
    _isRightClicked = YES;
    
    
    [self handleIncreamentHoleNumber];
    
}
- (void)handleIncreamentHoleNumber
{
    _isRightClicked = YES;

    
    [self loadDefaultFirstPlayer];
    
    NSInteger counter = _currentHoleNumber;
    
    if ( [self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId ) {
        
    if (_isButtonClicked == YES) {
        
        //_isButtonClicked = NO;
    }else{
    
         NSInteger counter = [_holeNumberLabel.text integerValue];
        
    NSInteger count = [_holeNumberLabel.text integerValue];
    
        if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
      {
        if (count == 18)
        {
            //_currentHoleNumber = 10;
            count = 10;

            
        }else
        {
            count++;
           // _currentHoleNumber = count;
        }
    }else
    {
        if (count == 18) {
            
            count = 1;
        }
        
       else if (count == _numberOfHoles)
        {
            //_currentHoleNumber = _holeStartNumber;
            count = _holeStartNumber;
            
        }else
        {
            count++;
           // _currentHoleNumber = count;
        }
    }
  


    
      
        
        NSLog(@"%@",_arrHolesPlayed);
        
        
        NSNumber *num = [NSNumber numberWithInteger:count];
        
        if ([_arrHolesPlayed containsObject:num]) {
            
            ([self comparingDataForNewFormat:counter and:self.arrPlayersForScoring]);
            
        }else{
            
            [self showAlertWithMessage:@"Save score to continue. Skipping of the holes is not allowed."];
            _isRightClicked = NO;
            NSString *nbrstr = [NSString stringWithFormat:@"%li",(long)counter];
            
            
            
            [_holeNumberLabel setText:nbrstr];
            
        }
        
        return;

        
    }
        
       
        
    }
    
     //counter = [_holeNumberLabel.text integerValue];

    if (isSaveTapped == YES) {
        
        isSaveTapped = NO;
        
        PT_CacheHoleData *cacheHandler = [[PT_CacheHoleData alloc] initWithScoreDataArray:self.arrPlayersForScoring];
        
        [cacheHandler saveDataForHoleNumber:counter];
    }

    
    

    
    if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
    {
        if (counter == 18)
        {
            if ( [self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                [self.createdEventModel.formatId integerValue] == Format420Id ||
                [self.createdEventModel.formatId integerValue] == Format21Id ||
                [self.createdEventModel.formatId integerValue] == FormatVegasId ) {
                
                
                      counter = 10;
                       _currentHoleNumber = counter;
                      [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                                         andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            }else{
                
                if ([self.createdEventModel.back9 isEqualToString:@"Front 9"])
                {
                    
                    _currentHoleNumber = _holeStartNumber;
                    [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                                       andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                    
                    counter = _currentHoleNumber;

                    
                }else{
            
            _currentHoleNumber = 10;
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            counter = _currentHoleNumber;
                }
            }
            
        }
        else
        {
            counter++;
            _currentHoleNumber = counter;
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
           
        }
    }
    else
    {
        if (counter == _numberOfHoles)
        {
            
            _currentHoleNumber = _holeStartNumber;

            if ( [self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                [self.createdEventModel.formatId integerValue] == Format420Id ||
                [self.createdEventModel.formatId integerValue] == Format21Id ||
                [self.createdEventModel.formatId integerValue] == FormatVegasId ) {
                
                
                _currentHoleNumber = 1;
            }
            
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            
            counter = _currentHoleNumber;
        }
        else
        {
            counter++;
            _currentHoleNumber = counter;
            


            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
           
        }
    }
    
    NSString *nbrstr = [NSString stringWithFormat:@"%li",(long)counter];
    
    NSNumber *nexthole = [NSNumber numberWithInteger:counter];
    
    if ([_arrHolesPlayed containsObject:nexthole]) {
        
        
    }else{
    
    [_arrHolesPlayed addObject:nexthole];
        
    }
    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:3.5f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    transitionAnimation.subtype = kCATransitionFromTop;
    [_holeNumberLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
    //Hole Number
    [_holeNumberLabel setText:nbrstr];
    


    
}
- (IBAction)actionLeftBtn:(id)sender;
{
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    model.fairways = @"1";
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
    cell.fairwaysLeftImage.image = [UIImage imageNamed:@"fairways_left(3)"];
    cell.fairwaysCentreImage.image = [UIImage imageNamed:@"centrehdpi"];
    cell.fairwaysRightImage.image = [UIImage imageNamed:@"righthdpi"];
    
}
- (IBAction)actionHitBtn:(id)sender
{
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    model.fairways = @"2";
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
    cell.fairwaysLeftImage.image = [UIImage imageNamed:@"lefthdpi"];
    cell.fairwaysCentreImage.image = [UIImage imageNamed:@"fairways_mid(3)"];
    cell.fairwaysRightImage.image = [UIImage imageNamed:@"righthdpi"];
}
- (IBAction)actionRightBtn:(id)sender
{
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    model.fairways = @"3";
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
    cell.fairwaysLeftImage.image = [UIImage imageNamed:@"lefthdpi"];
    cell.fairwaysCentreImage.image = [UIImage imageNamed:@"centrehdpi"];
    cell.fairwaysRightImage.image = [UIImage imageNamed:@"fairways_right"];
    
}

- (IBAction)actionbackBtn:(id)sender{
    [self removeAllCacheData];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.tabBarController.tabBar.hidden = NO;
    [delegate.tabBarController setSelectedIndex:1];
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
    
    
}
//Mark:-decrement Sand
- (IBAction)actionYesBtn:(id)sender
{
    _currentSelectedPlayerIndex = 0;

    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%li",grossVlaue);
    
    NSInteger PuttSandSum = grossVlaue - 1;
    
    if (puttValue + sandMainValue < PuttSandSum){
        
        if ([cell.sandValueLabel.text isEqualToString:@"0"] || [cell.sandValueLabel.text isEqualToString:@"-"]) {
            
            cell.sandValueLabel.text = @"-";
            model.sand = @"-1";
            return;
        }else{
            
            sandMainValue = sandMainValue -1;
            cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",sandMainValue];
            model.sand = [NSString stringWithFormat:@"%li",sandMainValue];

        }
    }else{
        
        if (puttValue + sandMainValue == PuttSandSum) {
            
            if ([cell.sandValueLabel.text isEqualToString:@"0"] || [cell.sandValueLabel.text isEqualToString:@"-"]) {
                
                cell.sandValueLabel.text = @"-";
                model.sand = @"-1";
                return;
            }else{
                
                sandMainValue = sandMainValue -1;
                cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",sandMainValue];
                model.sand = [NSString stringWithFormat:@"%li",sandMainValue];
            }
            
        }
    }
    
    /*
    NSInteger sandVal;
    NSLog(@"%@",model.sand);
    if ([model.sand integerValue] < 0)
    {
       
        cell.sandValueLabel.text = @"-";
        sandVal = -1;
        model.sand  = [NSString stringWithFormat:@"%li",(long) sandVal];
        
    }else{
        
    if ([model.sand integerValue] == 0)
    {
        
        cell.sandValueLabel.text = @"-";
        sandVal = -1;
        model.sand  = [NSString stringWithFormat:@"%li",(long)sandVal];

        //model.sand = cell.sandValueLabel.text;
    }
    else
    {
        sandVal = [model.sand integerValue];
        sandVal--;
        cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",sandVal];
        model.sand = cell.sandValueLabel.text;
    }
    }
     */
    
}
//Mark:-increment Sand

- (IBAction)actionNoBtn:(id)sender{
    
    _currentSelectedPlayerIndex = 0;

    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedPlayerIndex inSection:0];
    EnterScoreTableViewCell *cell = [self.tablePlayersOption cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%li",grossVlaue);
    
    NSInteger PuttSandSum = grossVlaue - 1;
    
    if (puttValue + sandMainValue < PuttSandSum) {
        
        if ([cell.sandValueLabel.text isEqualToString:@"-"]) {
            
            cell.sandValueLabel.text = @"0";
            model.sand = 0;
            sandMainValue = 0;
            
        }else{
        
            sandMainValue = sandMainValue +1;
        cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",(long)sandMainValue];
        model.sand = [NSString stringWithFormat:@"%li",sandMainValue];
        }
        
    }else{
        
        if (puttValue + sandMainValue == PuttSandSum) {
            
            if ([cell.sandValueLabel.text isEqualToString:@"-"]) {
                
                cell.sandValueLabel.text = @"0";
                model.sand = 0;
                sandMainValue = 0;
                
            }else{
                
                
                if ([cell.puttsValueLabel.text isEqualToString:@"0"]) {
                    
                    model.numberOfPuts = puttValue;
                    cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",model.numberOfPuts];
                    return;
                    
                }else{
                    sandMainValue = sandMainValue +1;
                    cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",(long)sandMainValue];
                    model.sand = [NSString stringWithFormat:@"%li",sandMainValue];

                puttValue = puttValue - 1;
                model.numberOfPuts = puttValue;
                cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",model.numberOfPuts];
                }
            }
            
        }else{
            
            
        }
    }
    

    
    /*
    NSInteger sandVal;
    
    if ([model.sand integerValue] < 0)
    {
        //sandVal = 0;
        cell.sandValueLabel.text = @"0"; //[NSString stringWithFormat:@"%li",sandVal];
        model.sand = cell.sandValueLabel.text;
    }
    else if ((model.numberOfPuts + [model.sand integerValue])+1 == model.grossScore)
     {
     return;
     }
    else if (model.grossScore > (model.numberOfPuts + [model.sand integerValue])+1)
    {
        sandVal = [model.sand integerValue] + 1;
        cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",sandVal];
        model.sand = cell.sandValueLabel.text;
    }
    else
    {
        
        if (([model.sand integerValue] + model.numberOfPuts + 1) < model.grossScore)
        {
            
            model.sand = [NSString stringWithFormat:@"%li", (long)[model.sand integerValue]+1];
            cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.sand];
            
        }
        else
        {
            if (model.numberOfPuts == 0 && [model.sand integerValue]+1 == model.grossScore)
            {
                return;
            }
            
            model.numberOfPuts = 0;
            cell.puttsValueLabel.text = @"0";
            NSInteger sandVal = [model.sand integerValue]+1;
            cell.sandValueLabel.text = [NSString stringWithFormat:@"%li",(long)sandVal];
            model.sand = cell.sandValueLabel.text;
        }
    }
    */
    
}
-(IBAction)actionBottomBtn:(id)sender{
    
    
    [self.popupView setHidden:NO];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.popupView2 addGestureRecognizer:singleFingerTap];
    
    
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    _popupView.hidden = YES;
    
}
-(IBAction)actionTableBtn:(id)sender{
    
    CGRect _tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    //    CGRect _tableViewFrame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 180);
    if (_tableViewBtn != nil)
    {
        self.tableViewBtn.frame = _tableViewFrame;
        self.tableViewBtn.hidden = NO;
        
        [_tableViewBtn loadTableViewWithData:self.arrSplFormatLeaderboard];
    }
    
    
    
}
- (IBAction)actionDelegate:(id)sender{
    
    PT_ScoringIndividualPlayerModel *playerModel = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
    PT_DelegateViewController *delegateViewController = [[PT_DelegateViewController alloc] initWithEvent:self.createdEventModel andPlayerModel:playerModel];
    [self presentViewController:delegateViewController animated:YES completion:nil];
    
    
}

- (void)didSelectEndRound
{
    [self actionEndRound];
}
-(IBAction)actionLeaderBoard:(id)sender{
    if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId)
    {
        
    }
    else
    {
        PT_LeaderBoardViewController *leaderboardViewController = [[PT_LeaderBoardViewController alloc] initWithEvent:self.createdEventModel];
        [self presentViewController:leaderboardViewController animated:YES completion:nil];
    }
    
    
    
}

-(IBAction)popUpScoreCardAction:(id)sender{
    
    if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId)
    {
        PT_ScoreCardSplFormatViewController *scorecardViewController = [[PT_ScoreCardSplFormatViewController alloc] initWithEvent:self.createdEventModel];
        //PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
        //scorecardViewController.playerId = model.playerId;
        scorecardViewController.holeStartNumber = _holeStartNumber;
        [self presentViewController:scorecardViewController animated:YES completion:nil];
    }
    else
    {
        PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:self.arrPlayersForScoring];
        [self presentViewController:scorecardViewController animated:YES completion:nil];
    }

    
    
}
- (IBAction)actionScorecard:(id)sender{
    
    if (actionBottomBtn == 1) {
        
        [self actionLeaderBoard:nil];
        
        
    }else if( actionBottomBtn == 5){
        
        //[self endRoundServiceCall];
        
        [self actionEndRound];
        
    }
    
    else{
    
    //if ([self.createdEventModel.formatId integerValue] == Format420Id)
    if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId)
    {
        PT_ScoreCardSplFormatViewController *scorecardViewController = [[PT_ScoreCardSplFormatViewController alloc] initWithEvent:self.createdEventModel];
        //PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
        //scorecardViewController.playerId = model.playerId;
        scorecardViewController.holeStartNumber = _holeStartNumber;
        [self presentViewController:scorecardViewController animated:YES completion:nil];
    }
    else
    {
        PT_ScoreCardViewController *scorecardViewController = [[PT_ScoreCardViewController alloc] initWithEvent:self.createdEventModel andPlayersArray:self.arrPlayersForScoring];
        [self presentViewController:scorecardViewController animated:YES completion:nil];
    }
    }
    
}

- (IBAction)actionEndRound
{
    
    [self.endRoundpopView setHidden:NO];
    [self.popupView setHidden:YES];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapdetected:)];
    [self.endRoundpopBackView addGestureRecognizer:singleFingerTap];
    
    
    




//    if (self.alertEndRound == nil)
//    {
//        _alertEndRound =   [UIAlertController
//                                      alertControllerWithTitle:@"PUTT2GETHER"
//                                      message:@"Do you want to end this round? Select Save Round to save this round otherwise Delete Round to delete the score for the event."
//                                      preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* save = [UIAlertAction
//                               actionWithTitle:@"SAVE"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action)
//                               {
//                                   [self saveRoundServiceCall];
//                                   
//                               }];
//        
//        UIAlertAction* delete = [UIAlertAction
//                                 actionWithTitle:@"DELETE"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action)
//                                 {
//                                     [self endRoundServiceCall];
//                                     
//                                 }];
//        
//        UIAlertAction *modify = [UIAlertAction actionWithTitle:@"MODIFY" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            
//            
//
//        
//        }];
//        
//        [_alertEndRound addAction:save];
//        [_alertEndRound addAction:delete];
//        [_alertEndRound addAction:modify];
//    }
//    
//    
//    [self presentViewController:self.alertEndRound animated:YES completion:nil];
}


-(void)tapdetected:(UITapGestureRecognizer *)recon
{
    [self.endRoundpopView setHidden:YES];
    
}
//Mark:Pop Up button Action Methods
-(IBAction)actionDelete{
    
    self.endRoundpopView.hidden = YES;
        if (self.alertEndRound == nil)
        {
            _alertEndRound =   [UIAlertController
                                          alertControllerWithTitle:@"PUTT2GETHER"
                                          message:@"Do you want to end this round?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
            
    
            UIAlertAction* delete = [UIAlertAction
                                     actionWithTitle:@"DELETE"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [self endRoundServiceCall];
    
                                     }];
    
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    
    
    
    
            }];
    
           
            [_alertEndRound addAction:delete];
            [_alertEndRound addAction:cancel];
        }
        
        
        [self presentViewController:self.alertEndRound animated:YES completion:nil];
    //[self endRoundServiceCall];
}
-(IBAction)actionModify{
    
    [self.endRoundpopView setHidden:YES];
}
-(IBAction)actionSave{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isBanner2"] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"eventIdOfBanner2"] isEqualToString:[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId]] ){
        
        self.bannnerView.hidden = NO;
        
        _bannnerImg.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"BannerImgdata"]];
        
        [_bannnercloseBtn addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        [self fetchBannerDetail];
    }
    
//    [self saveRoundServiceCall];
}

- (IBAction)actionParHoleNumber
{
    if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
        [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
        [self.createdEventModel.formatId integerValue] == Format420Id ||
        [self.createdEventModel.formatId integerValue] == Format21Id ||
        [self.createdEventModel.formatId integerValue] == FormatVegasId)
    {
        
        PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
        
        if (lastHolePlayed > 0 ||  parholeInteraction > 0) {
            
            _parHoleBtn.userInteractionEnabled = NO;
            [self showAlertWithMessage:@"Hole can't be skipped. Save score to continue."];
        }
        else
        {
            [_selectHolesView bringToFront];
            _selectHolesView.userInteractionEnabled = YES;
           // _isLeftClicked = YES;
            _selectHolesView.currentHole = _currentHoleNumber;
            [_selectHolesView updateHoles];
            _selectHolesView.hidden = NO;
            
            
        }
        
    }
    else
    {
        [_selectHolesView bringToFront];
        _selectHolesView.userInteractionEnabled = YES;
        
        _selectHolesView.currentHole = _currentHoleNumber;
        [_selectHolesView updateHoles];
        _selectHolesView.hidden = NO;
        
        
    }
    
}

- (void)didSelectHole:(NSInteger)selectedHole
{
    
    
    _currentHoleNumber = selectedHole+1;
    [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",self.createdEventModel.golfCourseId]
                       andHoleNumber:[NSString stringWithFormat:@"%li",_currentHoleNumber]];
    
    NSString *nbrstr = [NSString stringWithFormat:@"%li",_currentHoleNumber];
    
    //Hole Number
    [_holeNumberLabel setText:nbrstr];
    
//    PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
//
//    
//    NSNumber *num = [NSNumber numberWithInteger:_currentHoleNumber];
//    
//    [model.arrplayedHole addObject:num];
    
    _selectHolesView.hidden = YES;
    
   
}
/*- (void)actionSaveRound
 {
 
 [self saveRoundServiceCall];
 
 }
 
 - (void)actionEndRound
 {
 
 [self endRoundServiceCall];
 
 }
 */


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPlayersForScoring count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightToReturn = 0;
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[indexPath.row];
    if ([[MGUserDefaults sharedDefault] getUserId] == model.playerId)
    {
        //if (_isCollapse == NO)
        if (_collapseStatus == [NSNumber numberWithInt:0])
        {
            heightToReturn = 58.0;
        }
        else
        {
            if (spotPrizeType == SpotPrize_None)
            {
                heightToReturn = 295.0f - 66;
            }
            
            else
            {
                heightToReturn = 295.0f;
            }
            if (_scoringModel.parValue == 3)
            {
                heightToReturn = 295.0f - 110;
            }
        }
        
    }else if ([self.createdEventModel.playersInGame isEqualToString:@"4+"])
    {
        if (spotPrizeType == SpotPrize_None)
        {
            heightToReturn = 58.0;

        }else{
        
        heightToReturn = 130.0;
        }
    }
    else
    {
        heightToReturn = 58.0;
    }
    
    return heightToReturn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identifier = @"Identifier1";
    EnterScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EnterScoreTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.startVC = self;
        cell.textFeet.delegate = self;
        [cell setBordersForActionViews];
    }
    cell.bgActionButton.tag = indexPath.row;
    
    [cell.bgActionButton addTarget:self action:@selector(actionDidSelectTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_currentSelectedPlayerIndex == indexPath.row)
    {
        if (_collapseStatus == [NSNumber numberWithInt:0])
        {
            cell.containerView.hidden = YES;
        }
        else
        {
            cell.containerView.hidden = NO;
        }
        
        
    }
    else
    {
        if ([self.createdEventModel.playersInGame isEqualToString:@"4+"])
        {
            
            if (spotPrizeType == SpotPrize_None)
            {
                cell.containerView.hidden = YES;

            
            }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [cell.puttView removeFromSuperview];
                [cell.sandView removeFromSuperview];
                [cell.fairwaysView removeFromSuperview];
                cell.spotPrizeView.hidden = NO;

                NSInteger spot = spotPrizeType;
                    switch (spot) {
                        case SpotPrize_ClosestToPin:
                        {
                            cell.spotPrizeLabel.text = @"    CLOSEST TO PIN";
                            cell.feetLabel.text = @"FEET";
                            //cell.feetLabel.hidden = YES;
                        }
                            break;
                        case SpotPrize_StraightDrive:
                        {
                            cell.spotPrizeLabel.text = @"    STRAIGHT DRIVE";
                            cell.feetLabel.text = @"FEET";
                            //cell.feetLabel.hidden = NO;
                        }
                            break;
                        case SpotPrize_LongDrive:
                        {
                            cell.spotPrizeLabel.text = @"    LONG DRIVE";
                            cell.feetLabel.text = @"YARDS";
                            //cell.feetLabel.hidden = NO;
                        }
                            break;
                            
                    }
                    
                

            });
            }
            
        }else{
        
        cell.containerView.hidden = YES;
        }
    }
    
    cell.tag = indexPath.row;
    
    PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[indexPath.row];
    if (model.numberOfPuts <0)
    {
        model.numberOfPuts = -1;
    }
    if ([model.sand integerValue] < 0) {
        
        model.sand  = [NSString stringWithFormat:@"-1"];
    }
    NSLog(@"%@",model.sand);
    [self setValueForCell:cell forModel:model];
    [self setTableViewCellContentsForCell:cell forIndexPath:indexPath];
    [self disableOrEnableCellForAdminForCell:cell andModel:model];
    
    if (spotPrizeType == SpotPrize_None)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        cell.spotPrizeView.hidden = YES;
        [cell.spotPrizeView removeFromSuperview];
        cell.constraintContainerViewHeight.constant = cell.constraintContainerViewHeight.constant - 66;
        });
    }
    else
    {
        cell.spotPrizeView.hidden = NO;
        
        NSInteger spot = spotPrizeType;
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (spot) {
                case SpotPrize_ClosestToPin:
                {
                    cell.spotPrizeLabel.text = @"    CLOSEST TO PIN";
                    cell.feetLabel.text = @"FEET";
                    //cell.feetLabel.hidden = YES;
                }
                    break;
                case SpotPrize_StraightDrive:
                {
                    cell.spotPrizeLabel.text = @"    STRAIGHT DRIVE";
                    cell.feetLabel.text = @"FEET";
                    //cell.feetLabel.hidden = NO;
                }
                    break;
                case SpotPrize_LongDrive:
                {
                    cell.spotPrizeLabel.text = @"    LONG DRIVE";
                    cell.feetLabel.text = @"YARDS";
                    //cell.feetLabel.hidden = NO;
                }
                    break;
                    
            }
            
        });
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_scoringModel.parValue == 3)
        {
            
            
            cell.fairwaysView.hidden = YES;
            //self.fairwaysView.hidden = YES;
          
            
            cell.constraintFairwaysViewHeight.constant = cell.constraintFairwaysViewHeight.constant -  cell.sandView.frame.size.height - 10;
            }
        else
        {
            cell.fairwaysView.hidden = NO;
            //self.constraintFairwaysViewHeight.constant = 56;
        }
    });
    
    if (self.hud != nil) {
        
      [MBProgressHUD hideHUDForView:self.loaderInsideView animated:YES];
        self.loaderView.hidden = YES;
    }
    
    //
    
    return cell;
}

- (void)disableOrEnableCellForAdminForCell:(EnterScoreTableViewCell *)cell andModel:(PT_ScoringIndividualPlayerModel *)model
{
    
    if ([[MGUserDefaults sharedDefault] getUserId] == self.createdEventModel.adminId)
    {
        //If its the user and admin
        if (model.playerId == [[MGUserDefaults sharedDefault] getUserId])
        {
            cell.hitBtn.userInteractionEnabled = YES;
            cell.rightBtn.userInteractionEnabled = YES;
            cell.leftBtn.userInteractionEnabled = YES;
            cell.increamentPuttsButton.userInteractionEnabled = YES;;
            cell.decreamentPuttsButton.userInteractionEnabled = YES;;
            cell.decreamentGrossButton.userInteractionEnabled = YES;;
            cell.incre1Btn.userInteractionEnabled = YES;
            cell.noBtn.userInteractionEnabled = YES;
            cell.yesBtn.userInteractionEnabled = YES;
           // cell.textFeet.userInteractionEnabled = YES;
            
        }
        //Mark:-if player are more than four and delegted there score to admin
        else if ([self.createdEventModel.playersInGame isEqualToString:@"4+"])
        {
            cell.hitBtn.userInteractionEnabled = YES;
            cell.rightBtn.userInteractionEnabled = YES;
            cell.leftBtn.userInteractionEnabled = YES;
            cell.increamentPuttsButton.userInteractionEnabled = YES;;
            cell.decreamentPuttsButton.userInteractionEnabled = YES;;
            cell.decreamentGrossButton.userInteractionEnabled = YES;;
            cell.incre1Btn.userInteractionEnabled = YES;
            cell.noBtn.userInteractionEnabled = YES;
            cell.yesBtn.userInteractionEnabled = YES;
            
          //  cell.textFeet.userInteractionEnabled = YES;

        }
        
        //If its not the user
        else
        {
            cell.hitBtn.userInteractionEnabled = NO;
            cell.rightBtn.userInteractionEnabled = NO;
            cell.leftBtn.userInteractionEnabled = NO;
            cell.increamentPuttsButton.userInteractionEnabled = NO;;
            cell.decreamentPuttsButton.userInteractionEnabled = NO;;
            cell.decreamentGrossButton.userInteractionEnabled = YES;;
            cell.incre1Btn.userInteractionEnabled = YES;
            cell.noBtn.userInteractionEnabled = NO;
            cell.yesBtn.userInteractionEnabled = NO;
           // cell.textFeet.userInteractionEnabled = YES;
        }
    }
    else
    {
        if (model.playerId == [[MGUserDefaults sharedDefault] getUserId])
        {
            cell.hitBtn.userInteractionEnabled = YES;
            cell.rightBtn.userInteractionEnabled = YES;
            cell.leftBtn.userInteractionEnabled = YES;
            cell.increamentPuttsButton.userInteractionEnabled = YES;;
            cell.decreamentPuttsButton.userInteractionEnabled = YES;;
            cell.decreamentGrossButton.userInteractionEnabled = YES;;
            cell.incre1Btn.userInteractionEnabled = YES;
            cell.noBtn.userInteractionEnabled = YES;
            cell.yesBtn.userInteractionEnabled = YES;
          //  cell.textFeet.userInteractionEnabled = YES;
            
            
        }//Mark:-if player are more than four and delegted there score to admin
        else if ([self.createdEventModel.playersInGame isEqualToString:@"4+"])
        {
            
           // cell.textFeet.userInteractionEnabled = YES;
            
        }
        
        else
        {
            cell.hitBtn.userInteractionEnabled = NO;
            cell.rightBtn.userInteractionEnabled = NO;
            cell.leftBtn.userInteractionEnabled = NO;
            cell.increamentPuttsButton.userInteractionEnabled = NO;;
            cell.decreamentPuttsButton.userInteractionEnabled = NO;;
            cell.decreamentGrossButton.userInteractionEnabled = YES;

            cell.incre1Btn.userInteractionEnabled = YES;
            cell.noBtn.userInteractionEnabled = NO;
            cell.yesBtn.userInteractionEnabled = NO;
          //  cell.textFeet.userInteractionEnabled = NO;
            
            
        }
    }
    
}

- (void)actionDidSelectTableView:(UIButton *)sender
{
    
    _currentSelectedPlayerIndex = sender.tag;
    PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    if ([[MGUserDefaults sharedDefault] getUserId] == model.playerId)
    {
        //if (_isCollapse == NO)
        if (_collapseStatus == [NSNumber numberWithInt:0])
        {
            //_isCollapse = YES;
            _collapseStatus = [NSNumber numberWithInt:1];
        }
        else
        {
            //_isCollapse = NO;
            _collapseStatus = [NSNumber numberWithInt:0];
        }
        [self.tablePlayersOption reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        [self showSpotPrizeViewContents];
        
    }
}

- (void)setValueForCell:(EnterScoreTableViewCell *)cell forModel:(PT_ScoringIndividualPlayerModel *)model
{
    
    //cell.containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    //cell.containerView.layer.borderWidth = 0.6f;
   
    NSLog(@"%ld",(long)model.grossScore);
    cell.grossValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.grossScore];
    
    
    if (cell.tag == 0) {
        
        grossVlaue = model.grossScore;

    }
    
   // cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
    
    
    if (model.numberOfPuts < 0)
    {
        cell.puttsValueLabel.text = @"-";
        model.numberOfPuts = -1;
        
        if (cell.tag == 0) {
            
            puttValue = 0;
        }
               //
    }
    else
    {
        cell.puttsValueLabel.text = [NSString stringWithFormat:@"%li",(long)model.numberOfPuts];
        model.numberOfPuts = [cell.puttsValueLabel.text integerValue];
        
        puttValue = model.numberOfPuts;
    }
    
    NSInteger sandValue;
    NSLog(@"%@",model.sand);
    if ([model.sand integerValue] < 0 || [model.sand isEqualToString:@"null"])
    {
        cell.sandValueLabel.text = @"-";
        sandValue = -1;
        model.sand = [NSString stringWithFormat:@"%ld",(long)sandValue];
        
        sandMainValue = 0;
    }
    else
    {
        cell.sandValueLabel.text = [NSString stringWithFormat:@"%@",model.sand];
        
        sandMainValue = [model.sand integerValue];
    }
    
    cell.name.text = [model.playerName uppercaseString];
    cell.handicap.text = [NSString stringWithFormat:@"(%li)",(long)model.handicap];
    
    //Mark:-setting Values of feet ad inches
    NSString *feetnInch = closetFeet; //[NSString stringWithFormat:@"%li",(long)model.closestFeet];
    if ([closetFeet integerValue] == -1) {
        
        cell.textFeet.text = @"-";
        model.closestFeet = -1;
        return;
    }
    
    NSString *closetFeetnInch = [NSString stringWithFormat:@"%@'%@\"",closetFeet,closetInch];
    
    
    if ([feetnInch integerValue] == 0) {
        
        cell.textFeet.text = closetFeetnInch;
       
    }else if([feetnInch integerValue] >= 150){
        
        cell.textFeet.text = closetFeet;
        
    }else{
        
//        NSInteger characterCount = [closetFeetnInch length];
//        if (characterCount >3) {
//            
//           // UIFont *font = [UIFont fontWithName:@"Lato-Semibold" size:12];
//            
//            
//        }
        
        cell.textFeet.text = closetFeetnInch;
    }
    
    
    NSInteger fairways = [model.fairways integerValue];
    
    if (fairways == 0)
    {
        //Default
        cell.fairwaysLeftImage.image = [UIImage imageNamed:@"lefthdpi"];
        cell.fairwaysCentreImage.image = [UIImage imageNamed:@"centrehdpi"];
        cell.fairwaysRightImage.image = [UIImage imageNamed:@"righthdpi"];
    }
    else if (fairways == 1)//Left
    {
        cell.fairwaysLeftImage.image = [UIImage imageNamed:@"fairways_left(3)"];
        cell.fairwaysCentreImage.image = [UIImage imageNamed:@"centrehdpi"];
        cell.fairwaysRightImage.image = [UIImage imageNamed:@"righthdpi"];
    }
    else if (fairways == 2)//centre
    {
        cell.fairwaysLeftImage.image = [UIImage imageNamed:@"lefthdpi"];
        cell.fairwaysCentreImage.image = [UIImage imageNamed:@"fairways_mid(3)"];
        cell.fairwaysRightImage.image = [UIImage imageNamed:@"righthdpi"];
    }
    else if (fairways == 3)//right
    {
        cell.fairwaysLeftImage.image = [UIImage imageNamed:@"lefthdpi"];
        cell.fairwaysCentreImage.image = [UIImage imageNamed:@"centrehdpi"];
        cell.fairwaysRightImage.image = [UIImage imageNamed:@"fairways_right"];
    }
    
    
}
- (void)setTableViewCellContentsForCell:(EnterScoreTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    
    PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[indexPath.row];
    
    if ([self.createdEventModel.isIndividual isEqualToString:@"Team"])
    {
       
        
        cell.underlineView.backgroundColor = [UIColor colorFromHexString:model.playerColor];
    }
    else if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
    {
        if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
            [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
            [self.createdEventModel.formatId integerValue] == Format420Id ||
            [self.createdEventModel.formatId integerValue] == Format21Id ||
            [self.createdEventModel.formatId integerValue] == FormatVegasId)
        {
            
            cell.underlineView.backgroundColor = [UIColor colorFromHexString:model.playerColor];
        }
        
    }
    else if ([self.createdEventModel.numberOfPlayers integerValue] == 3 &&
             [self.createdEventModel.formatId integerValue] == Format420Id)
    {
        
        cell.underlineView.backgroundColor = [UIColor colorFromHexString:model.playerColor];
        
    }
    else
    {
        cell.underlineView.backgroundColor = SplFormatBlueColor;
    }
}

#pragma mark - AlertView

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"PUTT2GETHER"
                                  message:message
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

#pragma mark - ServiceCalls

- (void)fetchParIndexForGolfCourse:(NSString *)golfCourseId andHoleNumber:(NSString *)holeNumber
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        NSMutableArray *arrPlayerIds = [NSMutableArray new];
        [self.arrPlayersForScoring enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PT_ScoringIndividualPlayerModel *model = obj;
            NSString *playerId = [NSString stringWithFormat:@"%li",(long)model.playerId];
            [arrPlayerIds addObject:playerId];
        }];
        
        if (isSaveTapped == YES || isFirstLaunch == YES) {
            
            isFirstLaunch = NO;
        }else{
        
            self.loaderView.hidden = NO;
       self.hud =  [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];

        }
       // MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"golf_course_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.golfCourseId],
                                @"event_id":[NSString stringWithFormat:@"%li",(long)self.createdEventModel.eventId],
                                @"hole_number":holeNumber,
                                @"player_ids":arrPlayerIds,
                                @"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchParIndexPostfix];
        _hidingView.hidden = NO;
        NSString *encoded = [[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             stringByReplacingOccurrencesOfString:@"%20"
                             withString:@""] ;
        encoded = [encoded stringByReplacingOccurrencesOfString:@"%E2%80%8B" withString:@""];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
               
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager setResponseSerializer:responseSerializer];
        
        [manager POST:encoded parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
                      if (responseObject != nil)
                      {
                          NSDictionary *dicResponseData = responseObject;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              NSDictionary *dicData = dicOutput[@"data"];
                              
                              _scoringModel = [PT_ScoringModel new];
                              
                              if ([dicData[@"is_delegated"] integerValue] == 1) {
                                  
                                  _isDelegated = YES;
                              }
                              
                              _scoringModel.parValue = [dicData[@"par_value"] integerValue];
                              
                              _scoringModel.IndexValue = [dicData[@"hole_index"] integerValue];
                              
                              [self.arrPlayersForScoring enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  PT_ScoringIndividualPlayerModel *model = obj;
                                  model.grossScore = _scoringModel.parValue;
                              }];
                              
                              _parValueLabel.text = [NSString stringWithFormat:@"%li",(long)_scoringModel.parValue];
                              
                              NSArray *arrTotal = dicOutput[@"total"];
                              NSDictionary *dicTotal;
                              NSArray *arrTeamData = nil;
                              if (dicOutput[@"teamdata"])
                              {
                                  arrTeamData = dicOutput[@"teamdata"];
                              }
                              
                              if ([arrTotal count] == 1)
                              {
                                  dicTotal  = [arrTotal firstObject];
                              }
                              else
                              {
                                  //NSString *val1 = @"0";
                                  //NSString *val2 = @"0";
                                  //NSString *val3 = @"0";
                                  NSDictionary *dicPlayer1,*dicPlayer2,*dicPlayer3,*dicPlayer4;
                                  NSInteger player1 = 0;
                                  NSInteger player2 = 0;
                                  for (NSInteger count = 0; count < [arrTotal count]; count++)
                                  {
                                      NSDictionary *dicAtCount = arrTotal[count];
                                      if (count == 0)
                                      {
                                          player1 = [dicAtCount[@"player_id"] integerValue];
                                      }
                                      else if (count == 1)
                                      {
                                          player2 = [dicAtCount[@"player_id"] integerValue];
                                      }
                                      NSInteger playerId = [dicAtCount[@"player_id"] integerValue];
                                      PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
                                      NSInteger currentPlayerId = model.playerId;
                                      
                                      
                                      if (currentPlayerId == playerId)
                                      {
                                          dicTotal = arrTotal[count];
                                      }
                                      
                                      NSArray *arrLastScore = dicAtCount[@"last_score"];
                                      if ([arrLastScore count] > 0)
                                      {
                                          
                                          //NSDictionary *dicLastScore = arrLastScore[0];
                                          
                                          if ([self.createdEventModel.formatId integerValue] == Format420Id)
                                          {
                                              self.splFormatLeaderboardView.hidden = NO;
                                              self.splFormatLeaderboardView.hidden = NO;
                                              
                                          }
                                          if  (([self.createdEventModel.numberOfPlayers integerValue] == 2 && ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId) )
                                               )
                                          {
                                              self.splFormatLeaderboardView.hidden = NO;
                                              self.splFormatLeaderboardView.hidden = NO;

                                              
                                          }
                                      }
                                      else
                                      {
                                          if ([self.createdEventModel.numberOfPlayers integerValue] != 4)
                                          {
                                              self.splFormatLeaderboardView.hidden = YES;
                                          }
                                      }
                                      if (count == [arrTotal count] - 1)
                                      {
                                          if ([self.createdEventModel.formatId integerValue] == Format420Id)
                                          {
                                              dicPlayer1 = arrTotal[0];
                                              dicPlayer2 = arrTotal[1];
                                              dicPlayer3 = arrTotal[2];
                                              //[self set420BottomUI:val3 value2:val2 value3:val1];
                                              [self set420BottomUI:dicPlayer1 value2:dicPlayer2 value3:dicPlayer3];
                                          }
                                          if  (([self.createdEventModel.numberOfPlayers integerValue] == 2 && ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId) )
                                               )
                                          {
                                              //self.splFormatLeaderboardView.hidden = NO;
                                              //self.splFormatLeaderboardView.hidden = NO;
                                              dicPlayer1 = arrTotal[0];
                                              dicPlayer2 = arrTotal[1];
                                              [self set2PBottomUI:dicPlayer1 dictionary:dicPlayer2];
                                              
                                          }
                                          NSLog(@"%@",self.createdEventModel.formatId);
                                          if ([self.createdEventModel.playersInGame integerValue] == 4 && !([self.createdEventModel.formatId integerValue] == FormatAutoPressId) && [self.createdEventModel.formatId integerValue] >= 10)
                                          {
                                              
                                              
                                              self.speacialFormatLeftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                                              //self.splFormatLeaderboardView.hidden = NO;
                                              //self.splFormatLeaderboardView.hidden = NO;
                                              dicPlayer1 = arrTotal[0];
                                              dicPlayer2 = arrTotal[1];
                                              dicPlayer3 = arrTotal[2];
                                              dicPlayer4 = arrTotal[3];
                                              
                                              NSArray *arrLastScore = dicPlayer1[@"last_score"];
                                              if ([arrLastScore count] == 0)
                                              {
                                                  self.splFormatLeaderboardView.hidden = YES;
                                              }
                                              else{
                                              
                                                  [self setTeamBottomUI:dicPlayer1 :dicPlayer2 :dicPlayer3 :dicPlayer4 :arrTeamData];
                                              }
                                          }
                                          
                                      }
                                  }
                              }
                              
                              if ([self.createdEventModel.numberOfPlayers integerValue] == 4 && ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId || [self.createdEventModel.formatId integerValue] == Format21Id || [self.createdEventModel.formatId integerValue] == FormatVegasId))
                              {
                                  NSArray *arrTeam = dicData[@"teamdata"];
                                  if ([arrTeam count] > 0)
                                  {
                                      NSDictionary *dicTeamA = arrTeam[0];
                                      NSString *teamAId = [NSString stringWithFormat:@"%@",dicTeamA[@"team_id"]];
                                      
                                      NSDictionary *dicTeamB = arrTeam[1];
                                      NSString *teamBId = [NSString stringWithFormat:@"%@",dicTeamB[@"team_id"]];
                                      
                                      NSDictionary *dicCurrent = arrTeam[2];
                                      if ([dicCurrent[@"current_standing"] isKindOfClass:[NSArray class]])
                                      {
                                          ///self.splFormatLeaderboardView.hidden = YES;
                                      }
                                      else
                                      {
                                          NSDictionary *dicCurretStanding = dicCurrent[@"current_standing"];
                                          if ([dicCurrent count] == 0)
                                          {
//                                              /self.splFormatLeaderboardView.hidden = YES;
                                          }
                                          else
                                          {
                                              self.splFormatLeaderboardView.hidden = NO;
                                              //NSString *colorStr = dicCurretStanding[@"color"];
                                              //NSString *centreTitle = [NSString stringWithFormat:@"%@",dicCurretStanding[@"score_value"]];
                                              NSString *winner = [NSString stringWithFormat:@"%@",dicCurretStanding[@"winner"]];
                                              NSInteger direction;
                                              
                                              
                                              //if ([colorStr isEqualToString:@"#FF0000"])
                                              if ([winner isEqualToString:teamBId])
                                              {
                                                  //Red
                                                  direction = 0;
                                                  self.speacialFormatDirectionImage.hidden = NO;
                                              }
                                              else if ([winner isEqualToString:teamAId])
                                              {
                                                  //Blue
                                                  direction = 2;
                                                  self.speacialFormatDirectionImage.hidden = NO;
                                              }
                                              else
                                              {
                                                  //Black
                                                  direction = 1;
                                                  self.speacialFormatDirectionImage.hidden = YES;
                                              }
                                              
                                              NSInteger holeNumber = 0;
                                              if (_currentHoleNumber == 1)
                                              {
                                                  holeNumber = _currentHoleNumber;
                                              }
                                              else
                                              {
                                                  holeNumber = _currentHoleNumber - 1;
                                              }
                                              //[self setTeamOr2PBottomUI:centreTitle hole:[NSString stringWithFormat:@"%li",holeNumber] direction:direction];
                                          }
                                      }
                                  }
                                  
                                  
                                  
                                  
                                  
                              }
                              
                              if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId)
                              {
                                  id arrBack9;
                                  id arrScoreValue;
                                  if (_autopressView == nil)
                                  {
                                      _autopressView = [[[NSBundle mainBundle] loadNibNamed:@"PT_AutopressView" owner:self options:nil] firstObject];
                                      CGRect frameLeaderboard = self.splFormatLeaderboardView.frame;
                                      _autopressView.frame = CGRectMake(-1, 0, frameLeaderboard.size.width, frameLeaderboard.size.height);
                                      [self.splFormatLeaderboardView addSubview:_autopressView];
                                      UITapGestureRecognizer *splFormatGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOpenFormat)];
                                        [_autopressView addGestureRecognizer:splFormatGesture];
                                      [self.splFormatLeaderboardView bringToFront];
                                      
                                  }
                                  //2 PLAYERS
                                  if ([self.createdEventModel.numberOfPlayers integerValue] == 2 )
                                  {
                                      NSArray *arrTotal = dicOutput[@"total"];
                                      NSDictionary *dictTotal = [arrTotal firstObject];
                                      NSArray *arrScore = dictTotal[@"last_score"];
                                      
                                      if ([arrScore count] > 0)
                                      {
                                          self.splFormatLeaderboardView.hidden = NO;
                                          _autopressView.hidden = NO;
                                          NSDictionary *dicScore = [arrScore firstObject];
                                          arrBack9 = dicScore[@"back_to_9_score"];
                                          arrScoreValue = dicScore[@"score_value"];
                                          if ([arrScoreValue count] == 0 && [arrBack9 count] == 0)
                                          {
                                              _autopressView.hidden = YES;
                                              self.splFormatLeaderboardView.hidden = YES;
                                          }
                                      }
                                      else
                                      {
                                          _autopressView.hidden = YES;
                                          self.splFormatLeaderboardView.hidden = YES;
                                      }
                                      
                                  }
                                  //4 PLAYERS
                                  else
                                  {
                                      NSArray *arrTeam = dicData[@"teamdata"];
                                      NSDictionary *dicCurrent = arrTeam[2];
                                      //if ([dicCurrent[@"current_standing"] isKindOfClass:[NSArray class]])
                                      //{
                                          //self.splFormatLeaderboardView.hidden = YES;
                                      //}
                                      //else
                                      {
                                          NSDictionary *dicCurretStanding = [dicCurrent[@"current_standing"] firstObject];
                                          //if ([dicCurrent count] == 0)
                                          //{
                                              //self.splFormatLeaderboardView.hidden = YES;
                                              //_autopressView.hidden = YES;
                                          //}
                                          //else
                                          {
                                              
                                              self.splFormatLeaderboardView.hidden = NO;
                                              _autopressView.hidden = NO;
                                              if ([dicCurretStanding count] > 0)
                                              {
                                                  arrBack9 = dicCurretStanding[@"back_to_9_score"];
                                                  arrScoreValue = dicCurretStanding[@"score_value"];
                                                  if ([arrBack9 count] == 0 && [arrScoreValue count] == 0)
                                                  {
                                                      self.splFormatLeaderboardView.hidden = YES;
                                                      _autopressView.hidden = YES;
                                                  }
                                              }
                                              else
                                              {
                                                  self.splFormatLeaderboardView.hidden = YES;
                                                  _autopressView.hidden = YES;
                                              }
                                              
                                              
                                          }
                                      }
                                      
                                      
                                  }
                                  
                                  NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
                                  if ([arrScoreValue isKindOfClass:[NSArray class]])
                                  {
                                      if ([arrScoreValue count] > 0)
                                      {
                                          
                                          for (NSInteger count = 0; count < [arrScoreValue count]; count++) {
                                              NSDictionary *dicAtIndex = arrScoreValue[count];
                                              NSString *strColor = dicAtIndex[@"color"];
                                              if ([strColor length] == 0)
                                              {
                                                  strColor = @"#000000";
                                              }
                                              UIColor * color = [UIColor colorFromHexString:strColor];
                                              NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
                                              NSString *textValue = [NSString stringWithFormat:@"%@ ",dicAtIndex[@"score"]];
                                              NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
                                              [attributedString appendAttributedString:subString];
                                              
                                          }
                                          
                                          
                                      }
                                  }
                                  else if ([arrScoreValue isKindOfClass:[NSDictionary class]])
                                  {
                                      UIColor * color = [UIColor colorFromHexString:arrScoreValue[@"color"]];
                                      NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
                                      NSString *textValue = [NSString stringWithFormat:@"%@ ",arrScoreValue[@"score"]];
                                      NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
                                      [attributedString appendAttributedString:subString];
                                      
                                  }
                                  
                                  //BACK 9
                                  if ([arrBack9 isKindOfClass:[NSArray class]])
                                  {
                                      if ([arrBack9 count] > 0)
                                      {
                                          //Adding "&" text
                                          UIColor * colorBlack = [UIColor blackColor];
                                          NSDictionary * attributesAndText = [NSDictionary dictionaryWithObject:colorBlack forKey:NSForegroundColorAttributeName];
                                          NSString *textAnd = @" & ";
                                          NSAttributedString * subStringAnd = [[NSAttributedString alloc] initWithString:textAnd attributes:attributesAndText];
                                          [attributedString appendAttributedString:subStringAnd];
                                          
                                          for (NSInteger count = 0; count < [arrBack9 count]; count++) {
                                              NSDictionary *dicAtIndex = arrBack9[count];
                                              UIColor * color = [UIColor colorFromHexString:dicAtIndex[@"color"]];
                                              NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
                                              NSString *textValue = [NSString stringWithFormat:@"%@ ",dicAtIndex[@"score"]];
                                              NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
                                              [attributedString appendAttributedString:subString];
                                              
                                          }
                                          
                                          
                                      }
                                  }
                                  else if ([arrBack9 isKindOfClass:[NSDictionary class]])
                                  {
                                      //Adding "&" text
                                      UIColor * colorBlack = [UIColor blackColor];
                                      NSDictionary * attributesAndText = [NSDictionary dictionaryWithObject:colorBlack forKey:NSForegroundColorAttributeName];
                                      NSString *textAnd = @" & ";
                                      NSAttributedString * subStringAnd = [[NSAttributedString alloc] initWithString:textAnd attributes:attributesAndText];
                                      [attributedString appendAttributedString:subStringAnd];
                                      
                                      UIColor * color = [UIColor colorFromHexString:arrBack9[@"color"]];
                                      NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
                                      NSString *textValue = [NSString stringWithFormat:@"%@ ",arrBack9[@"score"]];
                                      NSAttributedString * subString = [[NSAttributedString alloc] initWithString:textValue attributes:attributes];
                                      [attributedString appendAttributedString:subString];
                                      
                                  }
                                  
                                  
                                  _autopressView.autopressTitle.attributedText = attributedString;
                                  
                                  
                              }
                              
                              //NSString *isHandicapGain = [NSString stringWithFormat:@"%@",dicTotal[@"is_handicap_gain"]];
                              
                              NSInteger fairways = [dicTotal[@"fairway"] integerValue];
                              
                              if (fairways == 4)
                              {
                                  self.fairwaysView.hidden = YES;
                                  //self.constraintFairwaysViewHeight.constant = 0;
                              }
                              else
                              {
                                  self.fairwaysView.hidden = NO;
                                  //self.constraintFairwaysViewHeight.constant = 56;
                              }
                              
                              _noOfholePlayed = [dicTotal [@"no_of_holes_played"] integerValue];
                              
                              NSInteger spot = [dicData[@"is_spot_type"] integerValue];
                              float xBase = (self.pickerViewMetrics.frame.origin.x+self.pickerViewMetrics.frame.size.width/2);
                              float yBase = (self.pickerViewMetrics.frame.origin.y+self.pickerViewMetrics.frame.size.height/2) - 10;
                              switch (spot) {
                                  case 0:
                                  {
                                      spotPrizeType = SpotPrize_None;
                                      self.textFeet.text = dicTotal[@"closest_feet"];
                                      self.textFeet.text = dicTotal[@"closest_inch"];
                                  }
                                      break;
                                      
                                  case 1:
                                  {
                                      spotPrizeType = SpotPrize_ClosestToPin;
                                      self.textFeet.text = nil;
                                      self.textFeet.text = dicTotal[@"closest_feet"];
                                       closetFeet = dicTotal[@"closest_feet"];
                                      closetInch = dicTotal[@"closest_inch"];
                                      self.labelFeet.frame = CGRectMake(xBase - 30, yBase, 40, 21);
                                      float x = self.pickerViewMetrics.frame.origin.x+self.pickerViewMetrics.frame.size.width -40;
                                      self.labelInches.frame = CGRectMake(x, yBase, 40, 21);
                                      self.labelInches.hidden = NO;
                                      self.textFeet.text = @"0'0\"";
                                      self.labelFeet.text = @"FEET";
                                      
                                  }
                                      break;
                                  case 2:
                                  {
                                      spotPrizeType = SpotPrize_StraightDrive;
                                      self.textFeet.text = dicTotal[@"closest_feet"];
                                       closetFeet = dicTotal[@"closest_feet"];
                                       closetInch = dicTotal[@"closest_inch"];
                                      
                                      //Mark:-changing it into Feet
                                      self.labelFeet.frame = CGRectMake(xBase - 30, yBase, 40, 21);
                                      float x = self.pickerViewMetrics.frame.origin.x+self.pickerViewMetrics.frame.size.width -40;
                                      self.labelInches.frame = CGRectMake(x, yBase, 40, 21);
//                                      self.labelFeet.frame = CGRectMake(xBase + 30, yBase, 70, 21);
                                      self.labelInches.hidden = NO;
//                                      self.textFeet.text = @"0";
                                     // self.textFeet.text = @"0'0\"";
                                      self.labelFeet.text = @"FEET";
                                      
                                  }
                                      break;
                                  case 3:
                                  {
                                      spotPrizeType = SpotPrize_LongDrive;
                                      self.textFeet.text = dicTotal[@"closest_feet"];
                                       closetFeet = dicTotal[@"closest_feet"];
                                      self.labelFeet.frame = CGRectMake(xBase + 30, yBase, 70, 21);
                                      self.labelInches.hidden = YES;
                                      self.textFeet.text = @"0";
                                      self.labelFeet.text = @"YARDS";
                                  }
                                      break;
                              }
                              
                              [self.pickerViewMetrics reloadAllComponents];
                              if (spotPrizeType == SpotPrize_ClosestToPin || spotPrizeType == SpotPrize_StraightDrive)
                              {
                                  [self.pickerViewMetrics selectRow:16 inComponent:0 animated:NO];
                                  [self.pickerViewMetrics selectRow:6 inComponent:1 animated:NO];
                              }
                              else
                              {
                                  [self.pickerViewMetrics selectRow:140 inComponent:0 animated:NO];
                              }
                              
                              NSLog(@"%@",_arrPlayersForScoring);
                              
                              if ([self.arrPlayersForScoring count] > 0)
                              {
                                  NSString *holeStr = [NSString stringWithFormat:@"Hole_%li",(long)_currentHoleNumber];
                                  BOOL isKeyPresent = [[MGUserDefaults sharedDefault] isvaluePresentForKey:holeStr];
                                  
                                  if (isKeyPresent == YES)
                                  {
                                      PT_CacheHoleData *cacheData = [[PT_CacheHoleData alloc] initWithScoreDataArray:_arrPlayersForScoring];
                                      [cacheData setDataFromExistingValuesForHole:_currentHoleNumber];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.saveCentreBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
                                          [self.SaveBottomBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
                                      });
                                      
                                  }
                                  else
                                  {
                                      
                                      if (isUpdateScore == YES) {
                                          isUpdateScore = NO;
                                          
                                      }else{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          [self.saveCentreBtn setTitle:@"SAVE" forState:UIControlStateNormal];
                                          [self.SaveBottomBtn setTitle:@"SAVE" forState:UIControlStateNormal];
                                      
                                      });
                                      }
                                      

                                      for (NSInteger counter = 0; counter < [_arrPlayersForScoring count]; counter++){
                                          
                                          NSDictionary *dicAtIndex = arrTotal[counter];
                                          
                                      PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[counter];
                                      model.grossScore = [dicAtIndex[@"score_value"] integerValue];
                                      model.numberOfPuts = [dicAtIndex[@"no_of_putt"] integerValue];
                                      
                                      
                                      model.fairways = [NSString stringWithFormat:@"%li",(long)fairways];
                                      model.closestFeet = [self.textFeet.text integerValue];
                                      model.closestInch = [self.textInches.text integerValue];
                                     // closetFeet = dicTotal[@"closest_feet"];
                                      NSInteger sandValue1  = [dicAtIndex [@"sand"] integerValue] ;
                                    
                                      model.sand = [NSString stringWithFormat:@"%ld",(long)sandValue1];
                                      NSLog(@"%@",model.sand);
                                      model.holeLastPlayed = [dicAtIndex [@"no_of_holes_played"] integerValue];
                                      //_noOfholePlayed = model.holeLastPlayed;
                                      NSLog(@"%ld",(long)model.holeLastPlayed);
                                    
                                      
                                      }

                                  }
                                  
                                  if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                                      [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                                      [self.createdEventModel.formatId integerValue] == Format420Id ||
                                      [self.createdEventModel.formatId integerValue] == Format21Id ||
                                      [self.createdEventModel.formatId integerValue] == FormatVegasId)
                                  {
                                      if (_isButtonClicked == YES) {
                                          
                                          PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
                                          
                                         
                                          NSLog(@"%@",model.arrplayedHole);
                                          model.grossScore = [dicTotal[@"score_value"] integerValue];
                                          model.numberOfPuts = [dicTotal[@"no_of_putt"] integerValue];
                                          NSLog(@"model.numberofPutts %ld",(long)model.numberOfPuts);
                                          model.fairways = [NSString stringWithFormat:@"%li",(long)fairways];
                                          model.closestFeet = [self.textFeet.text integerValue];
                                          model.closestInch = [self.textInches.text integerValue];
                                          // closetFeet = dicTotal[@"closest_feet"];
                                          NSInteger sandValue1  = [dicTotal [@"sand"] integerValue] ;
                                          
                                          model.sand = [NSString stringWithFormat:@"%ld",(long)sandValue1];
                                          
                                          [self handleIncreamentHoleNumber];
                                      }
                                  }
                                  
                                  
                                  
                                  
                                      
                                      _editScoreRightarrow.hidden = NO;
                                      _editscoreLeftarrow.hidden = NO;
                                 
                                  if ([self.createdEventModel.back9 isEqualToString:@"Back 9"] || [self.createdEventModel.back9 isEqualToString:@"Front 9"]) {
                                    
                                      if( _noOfholePlayed == 9){
                                          actionBottomBtn = 5;

                                          dispatch_async(dispatch_get_main_queue(), ^{

                                          [_ScoreCardBottomBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                                          [_scoreCentreBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                                              [self.saveCentreBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
                                              [self.SaveBottomBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
                                         });
                                      }
                                      
                                      
                                  }
                                  

                                  if( _noOfholePlayed == 18){
                                      
                                      actionBottomBtn = 5;

                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          [_ScoreCardBottomBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                                          [_scoreCentreBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                                      });
                                      [_ScoreCardBottomBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                                      [_scoreCentreBtn setTitle:@"END ROUND" forState:UIControlStateNormal];
                                      
                                      [self.saveCentreBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
                                      [self.SaveBottomBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
                                      
                                      
                                     
                                      
                                  }
                                  
                                  
                                  if (_isLeftClicked == YES) {
                                      _isLeftClicked = NO;
                                      
                                      
                                      
                                      [self.tablePlayersOption reloadData];
                                      CATransition *transition = [CATransition animation];
                                      transition.type = kCATransitionPush;
                                      transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                      transition.fillMode = kCAFillModeForwards;
                                      transition.duration = 0.5;
                                      transition.subtype = kCATransitionFromTop;
                                      
                                      [self.tablePlayersOption.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
                                  }else{
                                      
                                      if (_isButtonClicked == YES) {
                                          
                                          _isButtonClicked = NO;
                                          _currentSelectedPlayerIndex = 0;
                                          return;
                                      }
                                      
                                      [self.tablePlayersOption reloadData];
                                      CATransition *transition = [CATransition animation];
                                      transition.type = kCATransitionPush;
                                      transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                      transition.fillMode = kCAFillModeForwards;
                                      transition.duration = 0.5;
                                      transition.subtype = kCATransitionFromTop;
                                      
                                      [self.tablePlayersOption.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
                                  }
                                  
                                  
                                  
                              }
                              
                              
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                              self.loaderView.hidden = YES;


                              [self showAlertWithMessage:@"Please try again."];
                          }
                      }
                      
                      else
                      {
                          [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                          self.loaderView.hidden = YES;


                          [self showAlertWithMessage:@"Please try again."];
                      }
                      
                      dispatch_async(dispatch_get_main_queue(),^{
                          _currentSelectedPlayerIndex = 0;
                          //[self.tablePlayersOption reloadData];
                          
                          if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                              [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                              [self.createdEventModel.formatId integerValue] == Format420Id ||
                              [self.createdEventModel.formatId integerValue] == Format21Id ||
                              [self.createdEventModel.formatId integerValue] == FormatVegasId)
                          {
                              
                              PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[_currentSelectedPlayerIndex];
                              
                              if (model.holeLastPlayed > 0 ||  parholeInteraction > 0) {
                                  
                                  _parHoleBtn.userInteractionEnabled = NO;
                                  //[self showAlertWithMessage:@"Hole can't be skipped. Save score to continue."];
                              }
                              else
                              {
                                  if (isHolesViewShownForNewFormats == NO)
                                  {
                                      isHolesViewShownForNewFormats = YES;
                                      [_selectHolesView bringToFront];
                                      _selectHolesView.userInteractionEnabled = YES;
                                      
                                      _selectHolesView.currentHole = _currentHoleNumber;
                                      [_selectHolesView updateHoles];
                                      _selectHolesView.hidden = NO;
                                  }
                                  
                                  
                              }
                              
                          }

                      
                      });
                      UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                      btn.tag = 0;
                      //[self actionDidSelectTableView:btn];
                      
                      //[self showSpotPrizeViewContents];
                      _hidingView.hidden = YES;
                      //[MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                      //self.loaderView.hidden = YES;

         }
         
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"Error:%@",[error localizedDescription]);
             [self showAlertWithMessage:[error localizedDescription]];
             
         }];
    }
   

    
}

//Mark:-for edit Score on New Format
-(void)comparingDataForNewFormat:(NSInteger )counter and:(NSArray *)arrforScoring
{
    
    
    if (_isLeftClicked == YES) {
        //_isLeftClicked = NO;
        
        
    
    
    if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
    {
        if (counter == 10)
        {
            _currentHoleNumber = 18;
            
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            counter = _currentHoleNumber;
            
            
            
        }
        else
        {
            counter--;
            _currentHoleNumber = counter;
            
            
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
        }
        

    }
    else
    {
        if (counter == 1) {
            
            if ([self.createdEventModel.back9 isEqualToString:@"Front 9"]) {
                
                counter = 9;
                _currentHoleNumber = counter;
                
            }else{
            counter = 18;
            _currentHoleNumber = counter;
            }
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            counter = _currentHoleNumber;
        }
        
        
       else if (counter == _holeStartNumber)
        {
            
             counter--;
            _currentHoleNumber = counter;
            
            
            
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
            counter = _currentHoleNumber;
            
            
            
        }
        else
        {
            counter--;
            _currentHoleNumber = counter;
            
            
            
            [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                               andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
            
        }
        

        
    }
        

        
    }else{
        
        if ([self.createdEventModel.back9 isEqualToString:@"Back 9"])
        {
            if (counter == 18)
            {
                _currentHoleNumber = 10;
                [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                                   andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                
                counter = _currentHoleNumber;
                
            }
            else
            {
                counter++;
                _currentHoleNumber = counter;
                
                [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                                   andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                
            }
            
        }
        else
        {
            if (counter == _numberOfHoles)
            {
                counter = 1;
                _currentHoleNumber = counter;
                
                [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                                   andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                
                
                counter = _currentHoleNumber;
            }
            else
            {
                counter++;
                _currentHoleNumber = counter;
                
                
                
                [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId]
                                   andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                
            }
        }


    }
    NSString *nbrstr = [NSString stringWithFormat:@"%li",(long)counter];
    
    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:3.5f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    transitionAnimation.subtype = kCATransitionFromTop;
    [_holeNumberLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
    
    [_holeNumberLabel setText:nbrstr];
    
   // PT_ScoringIndividualPlayerModel *model = _arrPlayersForScoring[_currentSelectedPlayerIndex];
    
    NSNumber *number = [_arrHolesPlayed valueForKey:@"@lastObject"];
    NSNumber *counterHole = [NSNumber numberWithInteger:counter];
    if (counterHole == number ) {
        
        isUpdateScore = NO;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.saveCentreBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            [self.SaveBottomBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        });
    }else{
    
    isUpdateScore = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.saveCentreBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
        [self.SaveBottomBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
    });
    
    }
    
    
  }

- (void)fetchScoreCardData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        
        _hidingView.hidden = NO;
        MGMainDAO *mainDAO = [MGMainDAO new];
        
        NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetScorecardDataPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  //[self showLoadingView:NO];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _holeStartNumber = [dicOutput[@"hole_start_from"] integerValue];

                              _holeStartedfrom   = [dicOutput[@"hole_start_from"] integerValue];
                              
                              //Hole Number
                              //[_holeNumberLabel setText:[NSString stringWithFormat:@"%li",(long)_holeStartNumber]];
                              _numberOfHoles = [dicOutput[@"total_hole_num"] integerValue];
                              
                              [self.arrPlayersForScoring removeAllObjects];
                              
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  
                                  NSDictionary *dicData = obj;
                                  
                                  PT_ScoringIndividualPlayerModel *model = [PT_ScoringIndividualPlayerModel new];
                                  model.playerId = [dicData[@"player_id"] integerValue];
                                  model.playerName = dicData[@"full_name"];
                                  model.shortName = dicData[@"short_name"];
                                  model.handicap = [dicData[@"self_handicap"] integerValue];
                                  model.numberOfPuts = -1;
                                  model.playerColor = dicData[@"player_color_code"];
                                  //model.isSPotPrize = [dicData[@"is_spot_type"] boolValue];
                                  model.fairways = @"";
                                  
                                  NSString *str = @"-1";
                                  model.sand = str;
                                  model.closestFeet = 0;
                                  model.closestInch = 0;
                                  model.grossScore = _scoringModel.parValue;
                                  
                                  if ([[MGUserDefaults sharedDefault] getUserId] == model.playerId) {
                                      
                                      model.holeLastPlayed = [dicData[@"last_hole_played"] integerValue];
                                      lastHolePlayed = model.holeLastPlayed;

                                  }
                                  
                                  
                                  
                                  NSLog(@"%ld",(long)model.holeLastPlayed);
                                  model.arrplayedHole = [NSMutableArray new];
                                  model.arrplayedHole = [dicData[@"played_hole_number"] mutableCopy];
                                  
                                  _arrHolesPlayed = model.arrplayedHole;
                                  
                                  [self.arrPlayersForScoring addObject:model];
                                  
                                  if (idx == [arrData count]-1)
                                  {
                                      
                                    if([self.createdEventModel.back9 isEqualToString:@"Back 9"]){
                                          
                                        
                                          if (lastHolePlayed == 18) {
                                              
                                              _currentHoleNumber = 10;
                                               _holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)_currentHoleNumber];
                                              
                                          }else if(lastHolePlayed == 0){
                                              
                                              _currentHoleNumber = 10;
                                              //_currentHoleNumber = model.holeLastPlayed + 1;
                                              _holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)_currentHoleNumber];
                                              
                                          }else{
                                              //_currentHoleNumber = 10;
                                              _currentHoleNumber = lastHolePlayed + 1;
                                              _holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)_currentHoleNumber];
                                              
                                          }
                                          
                                      }else if ([self.createdEventModel.back9 isEqualToString:@"Front 9"]){
                                          
                                          if (lastHolePlayed == 9) {
                                              
                                              _currentHoleNumber = 1;
                                              _holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)_currentHoleNumber];
                                              
                                          }else{
                                              
                                              NSLog(@"%ld",(long)lastHolePlayed);
                                              _currentHoleNumber = lastHolePlayed + 1;
                                              _holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)_currentHoleNumber];
                                              
                                          }
                                          
                                      }else if (lastHolePlayed + 1 < self.createdEventModel.totalHoleNumber)
                                          
                                      {
                                          _currentHoleNumber = lastHolePlayed + 1;
                                          _holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)_currentHoleNumber];
                                      }else
                                      {
                                          _currentHoleNumber = lastHolePlayed;
                                          _holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)_currentHoleNumber];
                                      }
                                
                                      NSNumber *num = [NSNumber numberWithInteger:_currentHoleNumber];
                                      [_arrHolesPlayed addObject:num];
                                      
                                      [self setUpPlayerButtons];
                                      
                                      
                                      
                                      
                                      // [self.tableContainerView bringToFront];
                                      
                                      
                                      
                                      
                                      if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
                                          [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
                                          [self.createdEventModel.formatId integerValue] == Format420Id ||
                                          [self.createdEventModel.formatId integerValue] == Format21Id ||
                                          [self.createdEventModel.formatId integerValue] == FormatVegasId)
                                      {
                                          if (_isButtonClicked == YES) {
                                             
                                              
                                              [self handleIncreamentHoleNumber];
                                          }else{
                                              
                                              [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId] andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                                          }
                                          
                                          
                                          
                                          if ([model.arrplayedHole count] < 1) {
                                              
                                              [self actionParHoleNumber];
                                          }
                                          else{
                                              
                                             
                                              _parHoleBtn.userInteractionEnabled = NO;
                                              
                                          }
                                          
                                          if ([self.createdEventModel.formatId integerValue] == Format420Id)
                                          {
                                              
                                              //[self set420BottomUI:@"9" value2:@"5" value3:@"3"];
                                          }
                                          else
                                          {
                                              
                                          }
                                      }else{
                                          
                                          [self fetchParIndexForGolfCourse:[NSString stringWithFormat:@"%li",(long)self.createdEventModel.golfCourseId] andHoleNumber:[NSString stringWithFormat:@"%li",(long)_currentHoleNumber]];
                                      }
                                  }
                              }];
                              
                          }
                          else
                          {
                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                          self.loaderView.hidden = YES;

                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                      //[self showLoadingView:NO];
                  }
                  else
                  {
                      //[MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                      //self.loaderView.hidden = YES;
                      [self fetchScoreCardData];

                     // [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}
- (void)set2PBottomUI : (NSDictionary *)dic1 dictionary:(NSDictionary *)dic2
{
    __block UIColor *centreColor;
    float y = self.speacialFormatDirectionImage.frame.origin.y;
    float width = self.speacialFormatDirectionImage.frame.size.width;
    float height = self.speacialFormatDirectionImage.frame.size.height;
    
    //Player ID
    NSInteger player1Id = [dic1[@"player_id"] integerValue];
    NSInteger player2Id = [dic2[@"player_id"] integerValue];
    
    //Player Name
    NSString *playerName1 = [dic1[@"player_name"] uppercaseString];
    NSString *playerName2 = [dic2[@"player_name"] uppercaseString];
    
    //Handicap values
    NSString *handicapPlayer1 = dic1[@"player_handicap"];
    NSString *handicapPlayer2 = dic2[@"player_handicap"];
    
    //Player Color
    PT_ScoringIndividualPlayerModel *model1 = self.arrPlayersForScoring[0];
    PT_ScoringIndividualPlayerModel *model2 = self.arrPlayersForScoring[1];
    //NSString *player1Color = dic1[@"player_color_code"];
    //NSString *player2Color = dic2[@"player_color_code"];
    NSString *player1Color = model1.playerColor;
    NSString *player2Color = model2.playerColor;
    
    //Last Score
    NSDictionary *dicLastScorePlayer1 = [dic1[@"last_score"] firstObject];
    NSInteger winnerId = [dicLastScorePlayer1[@"winner"] integerValue];
    
    //Centre Title
    NSString *centreTitle = dicLastScorePlayer1[@"score_value"];
    
    NSInteger holeNumber = 0;
    if (_currentHoleNumber == 1)
    {
        holeNumber = _currentHoleNumber;
    }
    else
    {
        holeNumber = _currentHoleNumber - 1;
    }
    
    NSInteger direction = 0;
    if (winnerId == player1Id)
    {
        direction = 0;
    }
    else if (winnerId == player2Id)
    {
        direction = 2;
    }
    
    if (direction == 0)
    {
        //Red
        //centreColor = SplFormatRedTeamColor;
        if ([centreTitle isEqualToString:@"AS"]) {
            
            centreColor = [UIColor colorFromHexString:@"#000000"];
            self.speacialFormatDirectionImage.hidden = YES;


        }else{
        
            self.speacialFormatDirectionImage.hidden = NO;
            centreColor = [UIColor colorFromHexString:player1Color];
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            
            self.speacialFormatDirectionImage.hidden = NO;

            
            //Blue
            
            float x = self.speacialFormatCentreButton.frame.origin.x - width;
            self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
            self.speacialFormatDirectionImage.image = [UIImage imageNamed:LeftRedArrowImage];
            _speacialFormatDirectionImage.image = [_speacialFormatDirectionImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_speacialFormatDirectionImage setTintColor:[UIColor colorFromHexString:player1Color]];
       // });
        
        }
    }
    else if (direction == 1)
    {
        centreColor = [UIColor blackColor];
        //dispatch_async(dispatch_get_main_queue(), ^{
        
        
        //Black
        self.speacialFormatDirectionImage.hidden = YES;
        //});
        
    }
    else
    {
        if ([centreTitle isEqualToString:@"AS"]) {
            
            centreColor = [UIColor colorFromHexString:@"#000000"];
            self.speacialFormatDirectionImage.hidden = YES;
            
            
        }else{
        
        //centreColor = SplFormatBlueColor;
        self.speacialFormatDirectionImage.hidden = NO;

        centreColor = [UIColor colorFromHexString:player2Color];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            float x = self.speacialFormatCentreButton.frame.origin.x + self.speacialFormatCentreButton.frame.size.width;
            
            self.speacialFormatDirectionImage.image = [UIImage imageNamed:RightBlueArrowImage];
            self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
            _speacialFormatDirectionImage.image = [_speacialFormatDirectionImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_speacialFormatDirectionImage setTintColor:[UIColor colorFromHexString:player2Color]];
        });
        }
        
    }
    [[self speacialFormatCentreButton] setBackgroundColor:centreColor];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
    UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:7.0f];
    NSDictionary *dict1 = @{
                            NSFontAttributeName:font1};
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2};
    
    //Left
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
    {
        NSUInteger strLength = playerName1.length;
        if (strLength > 6) {
            
            NSString *valueLeft = [NSString stringWithFormat:@"%@ \n%@",playerName1,handicapPlayer1];
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:valueLeft attributes:dict1]];
        }else{
            
            NSString *valueLeft = [NSString stringWithFormat:@"%@ %@",playerName1,handicapPlayer1];
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString:valueLeft attributes:dict1]];
            
            
        }
        
        
        
    }
    
    
    [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
    [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor colorFromHexString:player1Color]];
    [self speacialFormatLeftButton].contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    UIFont *fontC1 = [UIFont fontWithName:@"Lato-Bold" size:18.0f];
    UIFont *fontC2 = [UIFont fontWithName:@"Lato-Regular"  size:8.0f];
    NSDictionary *dictC1 = @{
                             NSFontAttributeName:fontC1};
    NSDictionary *dictC2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                             NSFontAttributeName:fontC2};
    //Centre
    NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
    NSString *centreTitleStr = [NSString stringWithFormat:@"%@ \n",centreTitle];
    [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:centreTitleStr    attributes:dictC1]];
    NSString *thruStr = [NSString stringWithFormat:@"THRU %li",(long)holeNumber];
    [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:thruStr      attributes:dictC2]];
    [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
    [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
    
    //Right
    NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
    if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
    {
        NSUInteger strLength = playerName2.length;
        if (strLength > 8) {
            
            NSString *valueRight = [NSString stringWithFormat:@"%@ %@",playerName2,handicapPlayer2];
            [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:valueRight    attributes:dict1]];

        }else{
            
            NSString *valueRight = [NSString stringWithFormat:@"%@ \n%@",playerName2,handicapPlayer2];
            [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:valueRight    attributes:dict1]];


        }
    }
    
    
    [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
    [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor colorFromHexString:player2Color]];
    [self speacialFormatRightButton].contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //self.speacialFormatRightButton.titleLabel.backgroundColor = [UIColor whiteColor];
    
    _speacialFormatLeftButton.backgroundColor = SplFormatGrayColor;
    _speacialFormatRightButton.backgroundColor = SplFormatGrayColor;
    //_speacialFormatCentreButton.backgroundColor = SplFormatRedTeamColor;
    
}

- (void)setTeamBottomUI : (NSDictionary *)dic1
                            : (NSDictionary *)dic2
                            : (NSDictionary *)dic3
                            : (NSDictionary *)dic4
                            : (NSArray *)arrTeamData
{
    __block UIColor *centreColor;
    self.splFormatLeaderboardView.hidden = NO;
    
    
    
    
    float y = self.speacialFormatDirectionImage.frame.origin.y;
    float width = self.speacialFormatDirectionImage.frame.size.width;
    float height = self.speacialFormatDirectionImage.frame.size.height;
    
    
    //Team Id of Players
    NSInteger teamIdPlayer1 = [dic1[@"team_id"] integerValue];
    NSInteger teamIdPlayer2 = [dic2[@"team_id"] integerValue];
    NSInteger teamIdPlayer3 = [dic3[@"team_id"] integerValue];
    NSInteger teamIdPlayer4 = [dic4[@"team_id"] integerValue];
    
    //Player Names of Team
    NSString *playerName1 = dic1[@"player_name"];
    NSString *playerName2 = dic2[@"player_name"];
    NSString *playerName3 = dic3[@"player_name"];
    NSString *playerName4 = dic4[@"player_name"];
    
    //Handicap values
    NSString *handicapPlayer1 = dic1[@"player_handicap"];
    NSString *handicapPlayer2 = dic2[@"player_handicap"];
    NSString *handicapPlayer3 = dic3[@"player_handicap"];
    NSString *handicapPlayer4 = dic4[@"player_handicap"];
    
    //Last Score
    NSDictionary *dicLastScore1 = [dic1[@"last_score"] firstObject];
    //NSDictionary *dicLastScore2 = [dic2[@"last_score"] firstObject];
    //NSDictionary *dicLastScore3 = [dic3[@"last_score"] firstObject];
    //NSDictionary *dicLastScore4 = [dic4[@"last_score"] firstObject];
    
    //Winner
    if ([dicLastScore1 count] == 0)
    {
        _splFormatLeaderboardView.hidden = YES;
        return;
    }
    NSInteger winnerId = [dicLastScore1[@"winner"] integerValue];
    
    //Team Color
    NSString *playerColor1 = dic1[@"player_color_code"];
    NSString *playerColor2 = dic2[@"player_color_code"];
    NSString *playerColor3 = dic3[@"player_color_code"];
    NSString *playerColor4 = dic4[@"player_color_code"];
    
    NSString *teamPlayerName1 = @"Player Name1";
    NSString *teamPlayerName2 = @"Player Name2";
    NSString *color = @"Color Code";
    
    
    
    NSInteger direction = 0;
    
    //Team
    NSDictionary *dicTeamA;
    NSDictionary *dicTeamB;
    if (teamIdPlayer1 == teamIdPlayer2)
    {
        // Player 1 player 2 are team A
         dicTeamA = [NSDictionary dictionaryWithObjectsAndKeys:playerName1,teamPlayerName1,playerName2,teamPlayerName2,playerColor1,color, nil];
        
        
        //Player 3 Player 4 are team B
        dicTeamB = [NSDictionary dictionaryWithObjectsAndKeys:playerName3,teamPlayerName1,playerName4,teamPlayerName2,playerColor3,color, nil];
        if (winnerId == teamIdPlayer1)
        {
            direction = 0;
        }
        else if (winnerId == teamIdPlayer3)
        {
            direction = 2;
        }
    }
    if (teamIdPlayer1 == teamIdPlayer3)
    {
        //player 1  player 3 are team A
        dicTeamA = [NSDictionary dictionaryWithObjectsAndKeys:playerName1,teamPlayerName1,playerName3,teamPlayerName2,playerColor1,color, nil];
        
        //Player 2 player 4 are team B
        dicTeamB = [NSDictionary dictionaryWithObjectsAndKeys:playerName2,teamPlayerName1,playerName4,teamPlayerName2,playerColor2,color, nil];
        
        if (winnerId == teamIdPlayer1)
        {
            direction = 0;
        }
        else if (winnerId == teamIdPlayer2)
        {
            direction = 2;
        }
    }
    if (teamIdPlayer1 == teamIdPlayer4)
    {
        //player 1 player 4 are team A
        dicTeamA = [NSDictionary dictionaryWithObjectsAndKeys:playerName1,teamPlayerName1,playerName4,teamPlayerName2,playerColor1,color, nil];
        
        //player 2 player 3 are team B
        dicTeamB = [NSDictionary dictionaryWithObjectsAndKeys:playerName2,teamPlayerName1,playerName3,teamPlayerName2,playerColor2,color, nil];
        
        if (winnerId == teamIdPlayer1)
        {
            direction = 0;
        }
        else if (winnerId == teamIdPlayer2)
        {
            direction = 2;
        }
    }
    
    NSString *centreTitle = [NSString stringWithFormat:@"%@",dicLastScore1[@"score_value"]];
    
    
    
    NSInteger holeNumber = 0;
    if (_currentHoleNumber == 1)
    {
        holeNumber = _currentHoleNumber;
    }
    else
    {
        holeNumber = _currentHoleNumber - 1;
    }
    
    if (direction == 0)
    {
        if ([centreTitle isEqualToString:@"AS"] || [centreTitle isEqualToString:@"0"]) {
            
            centreColor = [UIColor colorFromHexString:@"#000000"];
            self.speacialFormatDirectionImage.hidden = YES;
            
        }else{
        centreColor = [UIColor colorFromHexString:playerColor1];
        
        
        self.speacialFormatDirectionImage.hidden = NO;

        dispatch_async(dispatch_get_main_queue(), ^{
            //Blue
            
            float x = self.speacialFormatCentreButton.frame.origin.x - width;
            self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
            self.speacialFormatDirectionImage.image = [UIImage imageNamed:LeftRedArrowImage];
            _speacialFormatDirectionImage.image = [_speacialFormatDirectionImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_speacialFormatDirectionImage setTintColor:[UIColor colorFromHexString:playerColor1]];
        });
        }
        
    }
    else if (direction == 1)
    {
        if ([centreTitle isEqualToString:@"AS"] || [centreTitle isEqualToString:@"0"]) {
            
            centreColor = [UIColor colorFromHexString:@"#000000"];
            self.speacialFormatDirectionImage.hidden = YES;
        }else{
           // centreColor = SplFormatRedTeamColor;
        }        //dispatch_async(dispatch_get_main_queue(), ^{
        
        
        //Black
        self.speacialFormatDirectionImage.hidden = YES;
        //});
        
    }
    else
    {
        if ([centreTitle isEqualToString:@"AS"] || [centreTitle isEqualToString:@"0"]) {
            
            centreColor = [UIColor colorFromHexString:@"#000000"];
            self.speacialFormatDirectionImage.hidden = YES;
        }else{
            centreColor = [UIColor colorFromHexString:playerColor3];
        
        self.speacialFormatDirectionImage.hidden = NO;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            float x = self.speacialFormatCentreButton.frame.origin.x + self.speacialFormatCentreButton.frame.size.width;
            
            self.speacialFormatDirectionImage.image = [UIImage imageNamed:RightBlueArrowImage];
            self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
            _speacialFormatDirectionImage.image = [_speacialFormatDirectionImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_speacialFormatDirectionImage setTintColor:[UIColor colorFromHexString:playerColor3]];
        });
        }
        
    }
    [[self speacialFormatCentreButton] setBackgroundColor:centreColor];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
    UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:7.0f];
    NSDictionary *dict1 = @{
                            NSFontAttributeName:font1};
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2};
    
    //Left
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    
    {
        NSString *teamAMemberName1 = dicTeamA[teamPlayerName1];
        NSString *teamAMemberName2 = dicTeamA[teamPlayerName2];
        //NSString *teamAColor = dicTeamA[color];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM A\n"    attributes:dict1]];
        NSString *strTEamA = [NSString stringWithFormat:@"%@ %@ \n%@ %@",teamAMemberName1,handicapPlayer1,teamAMemberName2,handicapPlayer2];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:strTEamA  attributes:dict2]];
        
        [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor blackColor]];

        NSRange selectedRange = NSMakeRange(0, 6); // 4 characters, starting at index 0
        
        [attString beginEditing];
        
        [attString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorFromHexString:dicTeamA[color]]
                       range:selectedRange];
        
        [attString endEditing];
    }
    
    [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
    [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
//    [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor blackColor]];
    [self speacialFormatLeftButton].contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    UIFont *fontC1 = [UIFont fontWithName:@"Lato-Bold" size:18.0f];
    UIFont *fontC2 = [UIFont fontWithName:@"Lato-Regular"  size:8.0f];
    NSDictionary *dictC1 = @{
                             NSFontAttributeName:fontC1};
    NSDictionary *dictC2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                             NSFontAttributeName:fontC2};
    //Centre
    NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
    NSString *centreTitleStr = [NSString stringWithFormat:@"%@ \n",centreTitle];
    [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:centreTitleStr    attributes:dictC1]];
    NSString *thruStr = [NSString stringWithFormat:@"THRU %li",(long)holeNumber];
    [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:thruStr      attributes:dictC2]];
    [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
    [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
    
    //Right
    NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
    
    {
        NSString *teamBMemberName1 = dicTeamB[teamPlayerName1];
        NSString *teamBMemberName2 = dicTeamB[teamPlayerName2];
        //[attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM A\n"    attributes:dict1]];
        NSString *strTeamB = [NSString stringWithFormat:@"%@ %@ \n %@ %@",teamBMemberName1,handicapPlayer3,teamBMemberName2,handicapPlayer4];
        [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM B\n"    attributes:dict1]];
        [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:strTeamB      attributes:dict2]];
        
        NSRange selectedRange = NSMakeRange(0, 6); // 4 characters, starting at index 0
        [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor blackColor]];
  
        [attStringRight beginEditing];
        
        [attStringRight addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorFromHexString:dicTeamB[color]]
                          range:selectedRange];
        
        [attStringRight endEditing];
    }
    
    [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
    [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
//    [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor blackColor]];
    [self speacialFormatRightButton].contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    _speacialFormatLeftButton.backgroundColor = SplFormatGrayColor;
    _speacialFormatRightButton.backgroundColor = SplFormatGrayColor;
    //_speacialFormatCentreButton.backgroundColor = SplFormatRedTeamColor;
    
    
    
}
/*- (void)setTeamOr2PBottomUI : (NSString *)centreTitle hole:(NSString *)holeNumber direction:(NSInteger)direction
 {
 __block UIColor *centreColor;
 float y = self.speacialFormatDirectionImage.frame.origin.y;
 float width = self.speacialFormatDirectionImage.frame.size.width;
 float height = self.speacialFormatDirectionImage.frame.size.height;
 if (direction == 0)
 {
 //Red
 centreColor = SplFormatRedTeamColor;
 dispatch_async(dispatch_get_main_queue(), ^{
 
 float x = self.speacialFormatCentreButton.frame.origin.x + self.speacialFormatCentreButton.frame.size.width;
 
 self.speacialFormatDirectionImage.image = [UIImage imageNamed:LeftRedArrowImage];
 self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
 });
 }
 else if (direction == 1)
 {
 centreColor = [UIColor blackColor];
 //dispatch_async(dispatch_get_main_queue(), ^{
 
 
 //Black
 self.speacialFormatDirectionImage.hidden = YES;
 //});
 
 }
 else
 {
 centreColor = SplFormatBlueColor;
 dispatch_async(dispatch_get_main_queue(), ^{
 
 
 
 //Blue
 
 float x = self.speacialFormatCentreButton.frame.origin.x - width;
 self.speacialFormatDirectionImage.frame = CGRectMake(x, y, width, height);
 self.speacialFormatDirectionImage.image = [UIImage imageNamed:RightBlueArrowImage];
 });
 
 }
 [[self speacialFormatCentreButton] setBackgroundColor:centreColor];
 
 NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
 [style setAlignment:NSTextAlignmentCenter];
 [style setLineBreakMode:NSLineBreakByWordWrapping];
 
 UIFont *font1 = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
 UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:7.0f];
 NSDictionary *dict1 = @{
 NSFontAttributeName:font1};
 NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
 NSFontAttributeName:font2};
 
 //Left
 NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
 if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
 {
 PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[0];
 NSString *valueLeft = [NSString stringWithFormat:@"\n%@ %li\n",model.shortName,model.handicap];
 [attString appendAttributedString:[[NSAttributedString alloc] initWithString:valueLeft attributes:dict1]];
 
 }
 else
 {
 PT_ScoringIndividualPlayerModel *model1 = self.arrPlayersForScoring[0];
 PT_ScoringIndividualPlayerModel *model2 = self.arrPlayersForScoring[1];
 [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM A\n"    attributes:dict1]];
 NSString *strTEamA = [NSString stringWithFormat:@"%@ %li \n %@ %li",model1.shortName,model1.handicap,model2.shortName,model2.handicap];
 [attString appendAttributedString:[[NSAttributedString alloc] initWithString:strTEamA  attributes:dict2]];
 }
 
 [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
 [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
 [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
 [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
 [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor blackColor]];
 
 UIFont *fontC1 = [UIFont fontWithName:@"Lato-Bold" size:18.0f];
 UIFont *fontC2 = [UIFont fontWithName:@"Lato-Regular"  size:8.0f];
 NSDictionary *dictC1 = @{
 NSFontAttributeName:fontC1};
 NSDictionary *dictC2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
 NSFontAttributeName:fontC2};
 //Centre
 NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
 NSString *centreTitleStr = [NSString stringWithFormat:@"%@ \n",centreTitle];
 [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:centreTitleStr    attributes:dictC1]];
 NSString *thruStr = [NSString stringWithFormat:@"THRU %@",holeNumber];
 [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:thruStr      attributes:dictC2]];
 [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
 [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
 [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
 [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
 [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
 
 //Right
 NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
 if ([self.createdEventModel.numberOfPlayers integerValue] == 2)
 {
 PT_ScoringIndividualPlayerModel *model = self.arrPlayersForScoring[1];
 NSString *valueRight = [NSString stringWithFormat:@"\n%@ %li\n",model.shortName,model.handicap];
 [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:valueRight    attributes:dict1]];
 }
 else
 {
 PT_ScoringIndividualPlayerModel *model1 = self.arrPlayersForScoring[2];
 PT_ScoringIndividualPlayerModel *model2 = self.arrPlayersForScoring[3];
 //[attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM A\n"    attributes:dict1]];
 NSString *strTeamB = [NSString stringWithFormat:@"%@ %li \n %@ %li",model1.shortName,model1.handicap,model2.playerName,model2.handicap];
 [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:@"TEAM B\n"    attributes:dict1]];
 [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:strTeamB      attributes:dict2]];
 }
 
 [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
 [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
 [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
 [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
 [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor blackColor]];
 
 _speacialFormatLeftButton.backgroundColor = SplFormatGrayColor;
 _speacialFormatRightButton.backgroundColor = SplFormatGrayColor;
 //_speacialFormatCentreButton.backgroundColor = SplFormatRedTeamColor;
 
 }*/
//- (void)set420BottomUI:(NSString *)val1 value2:(NSString *)val2 value3:(NSString *)val3
- (void)set420BottomUI:(NSDictionary *)dic1 value2:(NSDictionary *)dic2 value3:(NSDictionary *)dic3
{
    
    NSString *player1 = [dic1[@"player_name"] uppercaseString];
    NSString *player2 = [dic2[@"player_name"] uppercaseString];
    NSString *player3 = [dic3[@"player_name"] uppercaseString];
    
    NSArray *arrLastScore1 = dic1[@"last_score"];
    if ([arrLastScore1 count] == 0)
    {
        return;
    }
    NSDictionary *dicLastScore1 = arrLastScore1[0];
    PT_ScoringIndividualPlayerModel *model1 = self.arrPlayersForScoring[0];
    NSString *color1 = model1.playerColor;
    //NSString *color1 = dic1[@"player_color_code"];
    [[self speacialFormatLeftButton] setBackgroundColor:[UIColor colorFromHexString:color1]];
    
    NSArray *arrLastScore2 = dic2[@"last_score"];
    NSDictionary *dicLastScore2 = arrLastScore2[0];
    PT_ScoringIndividualPlayerModel *model2 = self.arrPlayersForScoring[1];
    NSString *color2 = model2.playerColor;
    //NSString *color2 = dic2[@"player_color_code"];
    //[[self speacialFormatRightButton] setBackgroundColor:[UIColor colorFromHexString:color2]];
    [[self speacialFormatCentreButton] setBackgroundColor:[UIColor colorFromHexString:color2]];
    
    NSArray *arrLastScore3 = dic3[@"last_score"];
    NSDictionary *dicLastScore3 = arrLastScore3[0];
    PT_ScoringIndividualPlayerModel *model3 = self.arrPlayersForScoring[2];
    NSString *color3 = model3.playerColor;
    //NSString *color3 = dic3[@"player_color_code"];
    [[self speacialFormatRightButton] setBackgroundColor:[UIColor colorFromHexString:color3]];
    
    NSString *playerScore1 = [NSString stringWithFormat:@"%@\n",dicLastScore1[@"score_value"]];
    
    NSString *playerScore2 = [NSString stringWithFormat:@"%@\n",dicLastScore2[@"score_value"]];
    
    NSString *playerScore3 = [NSString stringWithFormat:@"%@\n",dicLastScore3[@"score_value"]];
    
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"Lato-Regular" size:22.0f];
    UIFont *font2 = [UIFont fontWithName:@"Lato-Regular"  size:10.0f];
    NSDictionary *dict1 = @{
                            NSFontAttributeName:font1};
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2};
    //Left
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:playerScore1    attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:player1      attributes:dict2]];
    [[self speacialFormatLeftButton] setAttributedTitle:attString forState:UIControlStateNormal];
    [[[self speacialFormatLeftButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatLeftButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatLeftButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self speacialFormatLeftButton] titleLabel] setTextColor:[UIColor whiteColor]];
    //[self speacialFormatLeftButton].contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //Centre
    NSMutableAttributedString *attStringCentre = [[NSMutableAttributedString alloc] init];
    [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:playerScore2    attributes:dict1]];
    [attStringCentre appendAttributedString:[[NSAttributedString alloc] initWithString:player2      attributes:dict2]];
    [[self speacialFormatCentreButton] setAttributedTitle:attStringCentre forState:UIControlStateNormal];
    [[[self speacialFormatCentreButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatCentreButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatCentreButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self speacialFormatCentreButton] titleLabel] setTextColor:[UIColor whiteColor]];
    
    //Right
    NSMutableAttributedString *attStringRight = [[NSMutableAttributedString alloc] init];
    [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:playerScore3    attributes:dict1]];
    [attStringRight appendAttributedString:[[NSAttributedString alloc] initWithString:player3      attributes:dict2]];
    [[self speacialFormatRightButton] setAttributedTitle:attStringRight forState:UIControlStateNormal];
    [[[self speacialFormatRightButton] titleLabel] setNumberOfLines:0];
    [[[self speacialFormatRightButton] titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[[self speacialFormatRightButton] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self speacialFormatRightButton] titleLabel] setTextColor:[UIColor whiteColor]];
    //[[[self speacialFormatRightButton] titleLabel] setBackgroundColor:[UIColor brownColor]];
    //[self speacialFormatRightButton].contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)fetchSpecialFormatLeadershipData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
                                @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        NSLog(@"%@",param);
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchSCoreboardDataPostfix];
        _hidingView.hidden = NO;
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  //[self showLoadingView:NO];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arrSplFormatLeaderboard = [NSMutableArray new];
                              //[self.arrSplFormatLeaderboard removeAllObjects];
                              if ([arrData isKindOfClass:[NSArray class]])
                              {
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicData = obj;
                                      PT_SpecialFormatLeaderboardModel *modelSplFormat = [PT_SpecialFormatLeaderboardModel new];
                                      
                                      //4th column
                                      NSMutableArray *arr4tColumn = [NSMutableArray new];
                                      arr4tColumn = dicData[@"back_to_9_score"];
                                      [arr4tColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (modelSplFormat.arrBackto9Score == nil)
                                          {
                                              modelSplFormat.arrBackto9Score = [NSMutableArray new];
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          [modelSplFormat.arrBackto9Score addObject:model];
                                      }];
                                      
                                      //3rd Column
                                      
                                      modelSplFormat.arrScoreValue = [NSMutableArray new];
                                      if ([dicData[@"score_value"] isKindOfClass:[NSDictionary class]])
                                      {
                                          /*NSDictionary *dicFront9 = dicData[@"score_value"];
                                           PT_Front9Model *model = [PT_Front9Model new];
                                           model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                           model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                           [modelSplFormat.arrScoreValue addObject:model];
                                           */
                                      }
                                      else
                                      {
                                          NSMutableArray *arr3rdColumn = dicData[@"score_value"];
                                          if ([arr3rdColumn isKindOfClass:[NSMutableArray class]] && [arr3rdColumn count] > 0)
                                              [arr3rdColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                  if (modelSplFormat.arrScoreValue == nil)
                                                  {
                                                      modelSplFormat.arrScoreValue = [NSMutableArray new];
                                                  }
                                                  NSDictionary *dicFront9 = obj;
                                                  PT_Front9Model *model = [PT_Front9Model new];
                                                  model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                                  model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                                  [modelSplFormat.arrScoreValue addObject:model];
                                              }];
                                          
                                      }
                                      
                                      //Winner color
                                      modelSplFormat.colorWinner = dicData[@"color"];
                                      
                                      //Hole Number
                                      modelSplFormat.hole_number = dicData[@"hole_number"];
                                      
                                      [_arrSplFormatLeaderboard addObject:modelSplFormat];
                                  }];
                              }
                              
                          }
                          else
                          {
                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
    
}


- (void)saveRoundServiceCall
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        self.loaderView.hidden = NO;

       self.hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",[[MGUserDefaults sharedDefault] getUserId]],
                                @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,SaveRoundPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                  self.loaderView.hidden = YES;

                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              self.endRoundpopView.hidden = YES;
                              UIAlertController * alert=   [UIAlertController
                                                            alertControllerWithTitle:@"PUTT2GETHER"
                                                            message:@"Round saved successfully.."
                                                            preferredStyle:UIAlertControllerStyleAlert];
                              
                              
                              
                              UIAlertAction* cancel = [UIAlertAction
                                                       actionWithTitle:@"Dismiss"
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               /* AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                                delegate.tabBarController.tabBar.hidden = NO;
                                                                [delegate.tabBarController setSelectedIndex:0];
                                                                //[self actionBAck];
                                                                UIViewController *vc = self.presentingViewController;
                                                                while (vc.presentingViewController) {
                                                                vc = vc.presentingViewController;
                                                                }
                                                                [vc dismissViewControllerAnimated:YES completion:NULL];
                                                                */
                                                               [self removeAllCacheData];
                                                               PT_MyScoresViewController *statsVC = [PT_MyScoresViewController new];
                                                               //PT_StatsViewController *statsVC = [[PT_StatsViewController alloc] initWithNibName:@"PT_StatsViewController" bundle:nil];
                                                               
                                                               [self presentViewController:statsVC animated:YES completion:nil];
                                                           });
                                                           
                                                       }];
                              
                              [alert addAction:cancel];
                              
                              [self presentViewController:alert animated:YES completion:nil];
                              
                          }
                          else
                          {
                              [self showAlertWithMessage:@"Unable to Save Round. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
    
}

- (void)endRoundServiceCall
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {            self.loaderView.hidden = NO;

       self.hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,EndRoundPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                  self.loaderView.hidden = YES;

                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              UIAlertController * alert=   [UIAlertController
                                                            alertControllerWithTitle:@"PUTT2GETHER"
                                                            message:@"Event End Succesfully."
                                                            preferredStyle:UIAlertControllerStyleAlert];
                              
                              
                              
                              UIAlertAction* cancel = [UIAlertAction
                                                       actionWithTitle:@"Dismiss"
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               /*AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                                delegate.tabBarController.tabBar.hidden = NO;
                                                                [delegate.tabBarController setSelectedIndex:0];
                                                                //[self actionBAck];
                                                                UIViewController *vc = self.presentingViewController;
                                                                while (vc.presentingViewController) {
                                                                vc = vc.presentingViewController;
                                                                }
                                                                [vc dismissViewControllerAnimated:YES completion:NULL];
                                                                */
                                                               [self removeAllCacheData];
                                                               PT_MyScoresViewController *statsVC = [PT_MyScoresViewController new];
                                                               //PT_StatsViewController *statsVC = [[PT_StatsViewController alloc] initWithNibName:@"PT_StatsViewController" bundle:nil];
                                                               
                                                               [self presentViewController:statsVC animated:YES completion:nil];
                                                           });
                                                           
                                                       }];
                              
                              [alert addAction:cancel];
                              
                              [self presentViewController:alert animated:YES completion:nil];
                              
                          }
                          else
                          {
                              [self showAlertWithMessage:@"Unable to End Round. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
    
}

- (void)loadDefaultFirstPlayer
{
    for (NSInteger count = 1; count < [self.playersOptionView.subviews count]; count++)
    {
        id object = self.playersOptionView.subviews[count];
        if ([object isKindOfClass:[UIButton class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _currentSelectedPlayerIndex = 0;
                UIButton *sender = (UIButton *)object;
                [self setUpSelectedMarkderimageforButton:sender];
                
            });
            
            break;
        }
    }
}

- (void)setUpSelectedMarkderimageforButton:(UIButton *)sender
{
    
    //[self showLoadingView:YES];
    [self checkAndDisableOtherFieldsForEntry];
    
    if ([self.createdEventModel.formatId integerValue] == Format420Id)
    {
        float width = sender.frame.size.width;
        self.clickImageView3.frame = CGRectMake((sender.frame.origin.x + sender.frame.size.width/2) - width/2, self.clickImageView3.frame.origin.y, width, 2);
        [self.clickImageView3 bringToFront];
        switch (sender.tag) {
            case 0:
            {
                self.clickImageView3.backgroundColor = SplFormatRedColor;
            }
                break;
                
            case 1:
            {
                self.clickImageView3.backgroundColor = SplFormatBlueColor;
            }
                break;
            case 2:
            {
                self.clickImageView3.backgroundColor = SplFormatGreenColor;
            }
                break;
        }
        
    }
    else if ([self.createdEventModel.formatId integerValue] == FormatMatchPlayId ||
             [self.createdEventModel.formatId integerValue] == FormatAutoPressId ||
             [self.createdEventModel.formatId integerValue] == Format21Id ||
             [self.createdEventModel.formatId integerValue] == FormatVegasId)
    {
        float width = 12;
        self.clickImageView3.frame = CGRectMake(sender.center.x - width/2, self.clickImageView3.frame.origin.y, width, self.clickImageView3.frame.size.height);
        [self.clickImageView3 bringToFront];
        
    }
    else
    {
        float width = sender.frame.size.width;
        self.clickImageView3.frame = CGRectMake((sender.frame.origin.x + sender.frame.size.width/2) - width/2, self.clickImageView3.frame.origin.y, width, 2);
        [self.clickImageView3 bringToFront];
    }

}

- (void)removeAllCacheData
{
    PT_CacheHoleData *cacheData = [[PT_CacheHoleData alloc] initWithScoreDataArray:_arrPlayersForScoring];
    [cacheData removeAllCachedHoleData];
}

-(IBAction)actionOpenFormat{
    
    if ([self.createdEventModel.formatId integerValue] == Format420Id) {
       
        [self fourTwoZeroformatdata];

       
        
    }
      else if ([self.createdEventModel.formatId integerValue] == FormatVegasId) {
        
        [self vegasFormatData];
    } else if ([self.createdEventModel.formatId integerValue] == Format21Id){
        
        [self vegasFormatData];
    } else if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId){
        
        [self autoPressFormatData];
    }

    
}
-(void)openViewforFourTwozero{
    
    CGRect _tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    _fourTwoZeroView = [[[NSBundle mainBundle] loadNibNamed:@"PT_FourTwoZeroView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [self.view addSubview:self.fourTwoZeroView];
    [_fourTwoZeroView bringToFront];
    
    
    if (_fourTwoZeroView != nil)
    {
        self.fourTwoZeroView.frame = _tableViewFrame;
        self.fourTwoZeroView.hidden = NO;
        
        [_fourTwoZeroView loadDatawithArray:self.arr420Format];
    }
    

}

-(void)fourTwoZeroformatdata
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        self.loaderView.hidden = NO;

       self.hud = [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getexpandablescoreview"];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                  self.loaderView.hidden = YES;

                  NSLog(@"%@",responseData);
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arr420Format = [NSMutableArray new];
                              
                              if ([arrData isKindOfClass:[NSArray class]])
                              {
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicData = obj;
                                      PT_420Formatmodel *model420Format = [PT_420Formatmodel new];
                                      
                                      //firs array data
                                      NSMutableArray *arr4tColumn = [NSMutableArray new];
                                      arr4tColumn = dicData[@"first_array"];
                                      [arr4tColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrFirst == nil)
                                          {
                                              model420Format.arrFirst = [NSMutableArray new];
                                              model420Format.arrFirstColor = [NSMutableArray new];
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          [model420Format.arrFirst addObject:model.score];
                                          [model420Format.arrFirstColor addObject:model.color];
                                      }];
                                      
                                      
                                      //Mark:-Second Array
                                      NSMutableArray *arr4202ndColumn = [NSMutableArray new];
                                      arr4202ndColumn = dicData[@"second_array"];
                                      [arr4202ndColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrSecond == nil)
                                          {
                                              model420Format.arrSecond = [NSMutableArray new];
                                              model420Format.arrSecondColor = [NSMutableArray new];

                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          [model420Format.arrSecond addObject:model.score];
                                          [model420Format.arrSecondColor addObject:model.color];

                                      }];
                                      //3rd Column
                                      
//                                      modelSplFormat.arrScoreValue = [NSMutableArray new];
//                                      if ([dicData[@"score_value"] isKindOfClass:[NSDictionary class]])
//                                      {
//                                          /*NSDictionary *dicFront9 = dicData[@"score_value"];
//                                           PT_Front9Model *model = [PT_Front9Model new];
//                                           model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
//                                           model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
//                                           [modelSplFormat.arrScoreValue addObject:model];
//                                           */
//                                      }
//                                      else
//                                      {
//                                          NSMutableArray *arr3rdColumn = dicData[@"score_value"];
//                                          if ([arr3rdColumn isKindOfClass:[NSMutableArray class]] && [arr3rdColumn count] > 0)
//                                              [arr3rdColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                                  if (modelSplFormat.arrScoreValue == nil)
//                                                  {
//                                                      modelSplFormat.arrScoreValue = [NSMutableArray new];
//                                                  }
//                                                  NSDictionary *dicFront9 = obj;
//                                                  PT_Front9Model *model = [PT_Front9Model new];
//                                                  model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
//                                                  model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
//                                                  [modelSplFormat.arrScoreValue addObject:model];
//                                              }];
//                                          
//                                      }
//                                      
                                      
                                      //Hole Number
                                      model420Format.hole_number = [dicData[@"hole_number"] integerValue];
                                      
                                      [self.arr420Format addObject:model420Format];
                                      
                                      if (idx == [arrData count] -1) {
                                          
                                          [self openViewforFourTwozero];
                                      }
                                      
                                      
                                      for (id value in _arr420Format) {
                                          NSLog(@"Value: %@", value);
                                      }
                                      //NSLog(@"%@",_arr420Format);
                                  }];
                              }
                              
                          }
                          else
                          {
                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }

}

//Mark:-Temporay action method for Vegas Format
-(IBAction)actionTempBtn
{
//    if ([self.createdEventModel.formatId integerValue] == FormatVegasId) {
//        
//        [self vegasFormatData];
//    }else if ([self.createdEventModel.formatId integerValue] == Format21Id){
//        
//        [self vegasFormatData];
//    }else if ([self.createdEventModel.formatId integerValue] == FormatAutoPressId){
//        
//        [self autoPressFormatData];
//    }

}

-(void)vegasFormatDataShownOntap{
    
    CGRect _tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    _vegasFormatView = [[[NSBundle mainBundle] loadNibNamed:@"PT_VegasFormatView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [self.view addSubview:self.vegasFormatView];
    [_vegasFormatView bringToFront];
    
    
    if (_vegasFormatView != nil)
    {
        self.vegasFormatView.frame = _tableViewFrame;
        self.vegasFormatView.hidden = NO;
        
        [_vegasFormatView loadTableWithdata:self.arr420Format];
    }


}


-(void)vegasFormatData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        self.loaderView.hidden = NO;

      self.hud =   [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getexpandablescoreview"];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                  self.loaderView.hidden = YES;

                  NSLog(@"%@",responseData);
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arr420Format = [NSMutableArray new];
                              
                              if ([arrData isKindOfClass:[NSArray class]])
                              {
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      
                                      
                                      NSDictionary *dicData = obj;
                                      PT_Front9Model *modelVegas = [PT_Front9Model new];
                                      
                                      modelVegas.holeNumber = [dicData[@"hole_number"] integerValue] ;
                                      modelVegas.aggScore = dicData[@"agg_score"] ;
                                      modelVegas.color = dicData[@"agg_color"];
                                      modelVegas.holeScore = dicData[@"hole_score"];
                                      modelVegas.colorhole = dicData[@"hole_color"];
                                      
                                      [self.arr420Format addObject:modelVegas];
                                      
                                      if (idx == [arrData count] - 1) {
                                          
                                          [self vegasFormatDataShownOntap];
                                      }
                                      
                                      [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                                      self.loaderView.hidden = YES;

                                   }];
                              }
                              
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                              self.loaderView.hidden = YES;


                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  }];
              
    }

}

-(void)autopressViewOpen{
    
    CGRect _tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    _autoPressFormatView = [[[NSBundle mainBundle] loadNibNamed:@"PT_AutoPressFormatView"
                                                      owner:self
                                                    options:nil] objectAtIndex:0];
    [self.view addSubview:self.autoPressFormatView];
    [_autoPressFormatView bringToFront];
    
    
    if (_autoPressFormatView != nil)
    {
        self.autoPressFormatView.frame = _tableViewFrame;
        self.autoPressFormatView.hidden = NO;
        
        [_autoPressFormatView  loadTableWithdata:self.arr420Format];
    }
    
}

-(void)autoPressFormatData
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        self.loaderView.hidden = NO;

      self.hud =  [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        /*NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", self.createdEventModel.adminId],
         @"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
         @"version":@"2"
         };*/
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getexpandablescoreview"];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                  self.loaderView.hidden = YES;

                  NSLog(@"%@",responseData);
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              
                              _arr420Format = [NSMutableArray new];
                              
                              if ([arrData isKindOfClass:[NSArray class]])
                              {
                                  [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDictionary *dicData = obj;
                                      PT_420Formatmodel *model420Format = [PT_420Formatmodel new];
                                      
                                      //firs array data
                                      NSMutableArray *arr4tColumn = [NSMutableArray new];
                                      arr4tColumn = dicData[@"first_array"];
                                      [arr4tColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrFirst == nil)
                                          {
                                              model420Format.arrFirst = [NSMutableArray new];
                                              model420Format.arrFirstColor = [NSMutableArray new];
                                              model420Format.arrFirstCount = [NSMutableArray new];
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          
                                          [model420Format.arrFirst addObject:model.score];
                                          [model420Format.arrFirstColor addObject:model.color];
                                      }];
                                      
                                      
                                      //Mark:-Second Array
                                      NSMutableArray *arr4202ndColumn = [NSMutableArray new];
                                      arr4202ndColumn = dicData[@"second_array"];
                                      [arr4202ndColumn enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          if (model420Format.arrSecond == nil)
                                          {
                                              model420Format.arrSecond = [NSMutableArray new];
                                              model420Format.arrSecondColor = [NSMutableArray new];
                                              model420Format.arrSecondCount = [NSMutableArray new];
                                          }
                                          NSDictionary *dicFront9 = obj;
                                          PT_Front9Model *model = [PT_Front9Model new];
                                          model.score = [NSString stringWithFormat:@"%@",dicFront9[@"score"]];
                                          model.color = [NSString stringWithFormat:@"%@",dicFront9[@"color"]];
                                          
                                          [model420Format.arrSecond addObject:model.score];
                                          [model420Format.arrSecondColor addObject:model.color];
                                          
                                      }];
                                      
                                      //Hole Number
                                      model420Format.hole_number = [dicData[@"hole_number"] integerValue];
                                      
                                      NSString *countArrFirst = dicData[@"first_array_count"];
                                      [model420Format.arrFirstCount addObject:countArrFirst];
                                      
                                      model420Format.secondArrayCount = [dicData[@"second_array_count"] integerValue];
                                     // [model420Format.arrSecondColor addObject:countArrSecond];
                                      NSLog(@"%@",countArrFirst);
                                      [self.arr420Format addObject:model420Format];
                                      
                                      
                                      if (idx == [arrData count] -1) {
                                          
                                          [self autopressViewOpen];
                                      }
                                      for (id value in _arr420Format) {
                                          NSLog(@"Value: %@", value);
                                      }
                                      NSLog(@"%@",_arr420Format);
                                  }];
                              }
                              
                          }
                          else
                          {
                              //[self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
    

}

//Mark:- Banner in the Bottom Service Call
- (void)fetchBannerDetail
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        //[self showLoadingView:YES];
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        
        
        NSDictionary *param = @{@"type":@"5",
                                @"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        self.loaderView.hidden = NO;

      self.hud =   [MBProgressHUD showHUDAddedTo:self.loaderInsideView animated:YES];

        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchBannerPostFix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.loaderView animated:YES];
                  self.loaderView.hidden = YES;

                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              _arrBanner = [NSMutableArray new];
                              
                              NSArray *arrData = dicOutput[@"data"];
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  NSDictionary *dicAtIndex = obj;
                                  PT_MyScoresModel *model = [PT_MyScoresModel new];
                                  
                                  model.eventId = [dicAtIndex[@"event_id"] integerValue];
                                  model.formatId = [dicAtIndex[@"id"] integerValue];
                                  model.eventName = dicAtIndex[@"image_path"];
                                  model.golfCourseName = dicAtIndex[@"image_href"];
                                  [_arrBanner addObject:model];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      
                                      [self.bannnerImg setImageWithURL:[NSURL URLWithString:model.eventName]];
                                      [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isBanner2"];
                                      
                                      NSString *imagePath = dicAtIndex[@"image_path"];
                                      NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:model.golfCourseName forKey:@"bannerPath2"];
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"BannerImgdata"];
                                      
                                       [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId] forKey:@"eventIdOfBanner2"];
                                      
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      self.bannnerView.hidden = NO;


                                  }else{
                                      
                                      
                                  }
                              }];
                          }
                          else
                          {
                              
                              self.bannnerView.hidden = YES;
                              [self saveRoundServiceCall];
                              
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
    
}

-(IBAction)actionBannerClicked:(UIButton *)sender{
    
    PT_MyScoresModel *model = _arrBanner[sender.tag];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isBanner2"] isEqualToString:@"1"]) {
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"bannerPath2"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{
        
        if (model.golfCourseName.length == 0) {
            
            
        }else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.golfCourseName]];
        }
    }
    
}

-(IBAction)actionClose:(UIButton *)sender{
    
    [self.bannnerView setHidden:YES];
    [self saveRoundServiceCall];
}

         
@end
