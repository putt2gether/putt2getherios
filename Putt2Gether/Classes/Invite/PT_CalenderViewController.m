//
//  PT_CalenderViewController.m
//  Putt2Gether
//
//  Created by Devashis on 15/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_CalenderViewController.h"

#import <PDTSimpleCalendar/PDTSimpleCalendar.h>

#import "PT_InviteViewController.h"

#import "addPatcipantsVCViewController.h"


static NSString *const GetEventByDatePostfix = @"geteventperyearmonth";

@interface PT_CalenderViewController ()<PDTSimpleCalendarViewDelegate,PDTSimpleCalendarViewCellDelegate>
{
    BOOL _isNearByOrRecentGolfCourse;
}

@property (weak, nonatomic) IBOutlet UIView *canvasView;

@property (strong, nonatomic) PT_SelectGolfCourseModel *golfCourseModel;


@property (strong, nonatomic) NSArray *arrDates;

@property (strong, nonatomic) PDTSimpleCalendarViewController *calendarViewController;

@property(weak,nonatomic) IBOutlet UILabel *headerLbl;

@end

@implementation PT_CalenderViewController

- (instancetype)initWithGolfCourse:(PT_SelectGolfCourseModel *)model
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    _isNearByOrRecentGolfCourse = YES;
    self.golfCourseModel = model;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
   // NSInteger day = [components day];
   // NSInteger month = [components month];
    NSInteger year = [components year];
    
    _headerLbl.text = [NSString stringWithFormat:@"%ld",(long)year];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotated) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [_calendarViewController reload];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_isNearByOrRecentGolfCourse == YES)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger month = [components month];
        NSInteger year = [components year];
        NSString *golfCourse = [NSString stringWithFormat:@"%li",self.golfCourseModel.golfCourseId];
        NSString *monthStr = [NSString stringWithFormat:@"%li",month];
        NSString *yearStr = [NSString stringWithFormat:@"%li",year];
        
        [self fetchEventForGolfCourse:golfCourse andYear:yearStr andMonth:monthStr];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionack
{
    
    addPatcipantsVCViewController *countryVC = [[addPatcipantsVCViewController alloc] initWithNibName:@"addPatcipantsVCViewController" bundle:nil];
    [self presentViewController:countryVC animated:YES completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
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
- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    //[_calendarViewController.delegate simpleCalendarViewController:_calendarViewController textColorForDate:date];
}
-(void)didSelectDate:(NSDate *)date
{
    //Mark:-to disable previous date from Current color

    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateBySettingHour:0 minute:0 second:0 ofDate:[NSDate date] options:0];

    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    //NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    //NSDate *thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
    //NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    //NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    //NSDate *lastMonth = [cal dateFromComponents:components];
    
    // Get the current date
    
    //NSDate *todays = [NSDate date];
    
    // Add the current year onto our date string
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    //NSString *todayDate = [formatter stringFromDate:date];
    //NSDate *newDate = [formatter dateFromString:todayDate];
    if ([today compare:date] == NSOrderedDescending){
        
        
        [self showAlertWithMessage:@"past dates disabled"];
 }else{
        
    

    if ([_arrDates count]>0) {
        
        
    
    NSDateComponents *componentsCurrent = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger month = [componentsCurrent month];
    NSInteger year = [componentsCurrent year];
    NSInteger day = [componentsCurrent day];

    [self.calendarViewController.datesToCompare enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDateComponents *componentsExisting = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:obj];
        NSInteger monthExisting = [componentsExisting month];
        NSInteger yearExisting = [componentsExisting year];
        NSInteger dayExisting = [componentsExisting day];
        
        if (month == monthExisting && day == dayExisting && year == yearExisting)
        {
            NSLog(@"Found");
            NSString *golfCourseId = [NSString stringWithFormat:@"%li",(long)self.golfCourseModel.golfCourseId];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"dd-MM-yyyy"];
            NSString *date = [formatter stringFromDate:obj];
            
            PT_InviteViewController *inviteVC = [[PT_InviteViewController alloc] initWithDate:date andGolfCourse:golfCourseId];
            
            [self presentViewController:inviteVC animated:YES completion:nil];
            
            *stop = YES;
        }
    }];
        
    }else{
        NSLog(@"Not found");
        
        NSDateComponents *componentsCurrent = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        NSInteger month = [componentsCurrent month];
        NSInteger year = [componentsCurrent year];
        NSInteger day = [componentsCurrent day];
        
        //if (month == month && day == dayExisting && year == yearExisting)
        //{
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%li-%li",(long)day,(long)month,(long)year];
                NSString *golfCourseId = [NSString stringWithFormat:@"%li",(long)self.golfCourseModel.golfCourseId];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"dd-MM-yyyy"];
               // NSString *date = [formatter stringFromDate:date];
//
                PT_InviteViewController *inviteVC = [[PT_InviteViewController alloc] initWithDate:dateStr andGolfCourse:golfCourseId];
        
        
               [self presentViewController:inviteVC animated:YES completion:nil];
                
       // }
            
        

        
       
        
    }
    }
}


- (BOOL)simpleCalendarViewCell:(PDTSimpleCalendarViewCell *)cell shouldUseCustomColorsForDate:(NSDate *)date
{
    return YES;
}

- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date
{
    NSLog(@"Date : %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *strDateToCompare = [formatter stringFromDate:date];
    NSDate *dateToCompare = [formatter dateFromString:strDateToCompare];
    BOOL returnType = NO;
    
    
    for (NSInteger count = 0; count < [_calendarViewController.datesToCompare count]; count++) {
        NSString *strExistingDate = [formatter stringFromDate:_calendarViewController.datesToCompare[count]];
        NSDate *dateForMonth = [formatter dateFromString:strExistingDate];
        //if ([_calendarViewController.datesToCompare[count] isEqualToDate:date])
        if ([dateForMonth isEqualToDate:date])
        {
            returnType = YES;
            break;
        }
    }
    
    return returnType;
}
- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDateToCompare = [formatter stringFromDate:date];
    NSDate *dateToCompare = [formatter dateFromString:strDateToCompare];
    BOOL returnType = NO;
    for (NSInteger count = 0; count < [_calendarViewController.datesToCompare count]; count++) {
        NSString *strExistingDate = [formatter stringFromDate:_calendarViewController.datesToCompare[count]];
        NSDate *dateForMonth = [formatter dateFromString:strExistingDate];
        if ([dateForMonth isEqualToDate:dateToCompare])
        {
            returnType = YES;
            //break;
        }
    }
    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    if (returnType == YES)
    {
        return borderColor;
        
    }
    else
    {
        return nil;
    }
    return borderColor;
}
- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDateToCompare = [formatter stringFromDate:date];
    NSDate *dateToCompare = [formatter dateFromString:strDateToCompare];
    BOOL returnType = NO;
    for (NSInteger count = 0; count < [_calendarViewController.datesToCompare count]; count++) {
        NSString *strExistingDate = [formatter stringFromDate:_calendarViewController.datesToCompare[count]];
        NSDate *dateForMonth = [formatter dateFromString:strExistingDate];
        if ([dateForMonth isEqualToDate:dateToCompare])
        {
            returnType = YES;
            //break;
        }
    }
    
    if (returnType == YES)
    {
        return [UIColor whiteColor];
    }
    else
    {
        return [UIColor blackColor];
    }
   // return [UIColor whiteColor];
}
#pragma mark - Web service calls

- (void)fetchEventForGolfCourse:(NSString *)golfCourseId andYear:(NSString *)year andMonth:(NSString *)month
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        
        
        NSDictionary *param = @{@"admin_id":[NSString stringWithFormat:@"%li", (long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"golf_course_id":golfCourseId,
                                @"month":month,
                                @"year":year,
                                @"version":@"2"
                                };
        
        NSLog(@"%@",param);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,GetEventByDatePostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  NSLog(@"Params:-%@",responseData);
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              _arrDates = dicOutput[@"data"];
                              
                              UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                              
                             
                              NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                              [formatter setDateFormat:@"dd-MM-yyyy"];
                              NSMutableArray *arrDatesFinal = [NSMutableArray new];
                              if ([_arrDates isKindOfClass:[NSArray class]])
                              {
                                  [_arrDates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
                                      NSInteger month = [components month];
                                      NSInteger year = [components year];
                                      //NSInteger day = [obj integerValue];
                                      NSString *dateStr = [NSString stringWithFormat:@"%@-%li-%li",obj,(long)month,(long)year];
                                      NSDate *date = [formatter dateFromString:dateStr];
                                      [arrDatesFinal addObject:date];
                                   
                                    
                                      
                                      if (idx == [_arrDates count] - 1)
                                      {
                                          
                                          if (_calendarViewController == nil)
                                          {
                                              _calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
                                              _calendarViewController.datesToCompare = arrDatesFinal;
                                              
                                              _calendarViewController.delegate = self;
                                              //[[PDTSimpleCalendarViewCell appearance] setDelegate:self];
                                              [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor blackColor]];
                                              [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor whiteColor]];
                                              [[PDTSimpleCalendarViewCell appearance] setCircleDefaultColor:[UIColor whiteColor]];
                                              [[PDTSimpleCalendarViewWeekdayHeader appearance] setHeaderBackgroundColor:[UIColor lightGrayColor]];
                                              [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:borderColor];
                                              
                                              _calendarViewController.weekdayHeaderEnabled = YES;
                                              _calendarViewController.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
                                              [_calendarViewController.view setFrame:self.canvasView.bounds];
                                              [self.canvasView addSubview:_calendarViewController.view];
                                          }
                                          
                                          [self setDatesForEventsOnCalender];
                                    }
                                      
                                      
                                }];
                              }
                              if ([dicOutput[@"data"] count] == 0) {
                                
                                                                    //Mark:-if no event occur calender would display
                                  _calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
                                  _calendarViewController.datesToCompare = arrDatesFinal;
                                  
                                  _calendarViewController.delegate = self;
                                  [[PDTSimpleCalendarViewCell appearance] setDelegate:self];
                                  [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor blackColor]];
                                  [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor whiteColor]];
                                  [[PDTSimpleCalendarViewWeekdayHeader appearance] setHeaderBackgroundColor:[UIColor lightGrayColor]];
                                  
                                  [self setDatesForEventsOnCalender];
                                  //[_calendarViewController setDelegate:self];
                                  _calendarViewController.weekdayHeaderEnabled = YES;
                                  _calendarViewController.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
                                  //[self addChildViewController:_calendarViewController];
                                  [_calendarViewController.view setFrame:self.canvasView.bounds];
                                  [self.canvasView addSubview:_calendarViewController.view];
                                 // [self showAlertWithMessage:@"No event found"];
                              }
  
                              
                          }
                          else
                          {
                              
                              //Mark:-if no event occur calender would display
                              _calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
                              //_calendarViewController.datesToCompare = arrDatesFinal;
                              
                              _calendarViewController.delegate = self;
                              [[PDTSimpleCalendarViewCell appearance] setDelegate:self];
                              [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor blackColor]];
                              [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor whiteColor]];
                              [[PDTSimpleCalendarViewWeekdayHeader appearance] setHeaderBackgroundColor:[UIColor lightGrayColor]];
                              
                              [self setDatesForEventsOnCalender];
                              //[_calendarViewController setDelegate:self];
                              _calendarViewController.weekdayHeaderEnabled = YES;
                              _calendarViewController.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
                              //[self addChildViewController:_calendarViewController];
                              [_calendarViewController.view setFrame:self.canvasView.bounds];
                              [self.canvasView addSubview:_calendarViewController.view];
                             // [self showAlertWithMessage:@"No event found"];
                          }
                      }
                      
                      else
                      {
                          //Mark:-if no event occur calender would display
                          _calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
                          //_calendarViewController.datesToCompare = arrDatesFinal;
                          
                          _calendarViewController.delegate = self;
                          [[PDTSimpleCalendarViewCell appearance] setDelegate:self];
                          [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor blackColor]];
                          [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor whiteColor]];
                          [[PDTSimpleCalendarViewWeekdayHeader appearance] setHeaderBackgroundColor:[UIColor lightGrayColor]];
                          
                          [self setDatesForEventsOnCalender];
                          //[_calendarViewController setDelegate:self];
                          _calendarViewController.weekdayHeaderEnabled = YES;
                          _calendarViewController.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
                          //[self addChildViewController:_calendarViewController];
                          [_calendarViewController.view setFrame:self.canvasView.bounds];
                          [self.canvasView addSubview:_calendarViewController.view];
                         // [self showAlertWithMessage:@"No event found"];
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }

}

- (void)setDatesForEventsOnCalender
{
    [_calendarViewController.datesToCompare enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //_calendarViewController.selectedDate = [_calendarViewController.datesToCompare objectAtIndex:idx];
        
        
        
        if (idx == [_calendarViewController.datesToCompare count] - 1)
        {
            [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor whiteColor]];
            [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:[UIColor blackColor]];
            [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor blackColor]];
            [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor whiteColor]];
            //[_calendarViewController.delegate simpleCalendarViewController:_calendarViewController circleColorForDate:_calendarViewController.datesToCompare[idx]];
            //[_calendarViewController reload];
        }
    }];
    
}



@end
