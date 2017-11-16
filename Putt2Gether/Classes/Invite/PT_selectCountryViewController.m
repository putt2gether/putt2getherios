//
//  PT_selectCountryViewController.m
//  Putt2Gether
//
//  Created by Devashis on 15/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_selectCountryViewController.h"

#import "PT_SelectGolfCorseViewController.h"

#import "PT_CalenderViewController.h"

typedef NS_ENUM(NSInteger,TableType)
{
    TableType_Country,
    TableType_States,
    TableType_Cities,
    TableType_golfCourses
};


static NSString *const FetchCountryListPostfix = @"getcountrylist";

static NSString *const FetchStatesListPostfix = @"getstatelist";

static NSString *const FetchCitiesListPostfix = @"getcitylist";

@interface PT_selectCountryViewController ()<UITableViewDataSource, UITableViewDelegate, PT_SelectGolfCourseDelegate>



@property (weak, nonatomic) IBOutlet UITableView *tableList;

@property (strong, nonatomic) NSMutableArray *arrCountries;
@property (strong, nonatomic) NSMutableArray *arrCountryFirstLetters;

@property (strong, nonatomic) NSMutableDictionary *dicoAlphabet;

@property (strong, nonatomic) NSMutableArray *arrStates;
@property (strong, nonatomic) NSMutableArray *arrStatesFirstLetters;
@property (strong, nonatomic) NSMutableDictionary *dicoStates;

@property (strong, nonatomic) NSMutableArray *arrCities;
@property (strong, nonatomic) NSMutableArray *arrCitiesFirstLetters;
@property (strong, nonatomic) NSMutableDictionary *dicoCities;

@property (strong, nonatomic) NSMutableArray *arrGolfCoursesList,*arrSendforCalender;

@property (assign, nonatomic)TableType tableType;

@end

@implementation PT_selectCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view from its nib.
    _tableType = TableType_Country;
    [self fetchCountryList];
    [self IntialfetchGolfCourses];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_tableType == TableType_Country)
    {
        return [_arrCountryFirstLetters count];
    }
    else if (_tableType == TableType_States)
    {
        return [_arrStatesFirstLetters count];
    }
    else if(_tableType == TableType_Cities){
        return [_arrCitiesFirstLetters count];
    }else{
        
        return 1;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_tableType == TableType_Country)
    {
        return [_arrCountryFirstLetters objectAtIndex:section];
    }
    else if (_tableType == TableType_States)
    {
        return [_arrStatesFirstLetters objectAtIndex:section];
    }
    else if(_tableType == TableType_Cities){
        return [_arrCitiesFirstLetters objectAtIndex:section];
    }else{
        
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableType == TableType_Country)
    {
        NSString *sectionTitle = [_arrCountryFirstLetters objectAtIndex:section];
        NSArray *sectionCountries = [self.dicoAlphabet objectForKey:sectionTitle];
        return [sectionCountries count];
    }
    else if (_tableType == TableType_States)
    {
        NSString *sectionTitle = [_arrStatesFirstLetters objectAtIndex:section];
        NSArray *sectionCountries = [self.dicoStates objectForKey:sectionTitle];
        return [sectionCountries count];
    }
    else if(_tableType == TableType_Cities){
        NSString *sectionTitle = [_arrCitiesFirstLetters objectAtIndex:section];
        NSArray *sectionCountries = [self.dicoCities objectForKey:sectionTitle];
        return [sectionCountries count];
    }else
    {
        return _arrGolfCoursesList.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;// = @"Identifier";
    identifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    for (UIView *sView in cell.contentView.subviews)
    {
        [sView removeFromSuperview];
    }
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (_tableType == TableType_Country)
    {
        NSString *sectionTitle = [_arrCountryFirstLetters objectAtIndex:indexPath.section];
        NSArray *sectionAnimals = [self.dicoAlphabet objectForKey:sectionTitle];
        NSString *name = [sectionAnimals objectAtIndex:indexPath.row];
        cell.textLabel.text = name;
        cell.textLabel.textColor = [UIColor grayColor];
        
        for (NSInteger count =0; count < [_arrCountries count]; count ++)
        {
            PT_CountryModel *model = _arrCountries[count];
            if ([name isEqualToString:model.countryName])
            {
                if (model.countryHasEvent > 0)
                {
                    float width  = 15;
                    float x = cell.frame.size.width - width - 10;
                    float y = cell.frame.size.height/2 - (width/2);
                    UIView *circleView = [UIView new];
                    circleView.frame = CGRectMake(x, y, width, width);
                    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                    circleView.backgroundColor = borderColor;
                    circleView.layer.cornerRadius = width/2;
                    circleView.layer.borderColor = [[UIColor clearColor] CGColor];
                    circleView.layer.borderWidth = 1.0;
                    circleView.layer.masksToBounds = YES;
                    [cell.contentView addSubview:circleView];
                }
            }
            
        }
        
        
    }
    else if (_tableType == TableType_States)
    {
        NSString *sectionTitle = [_arrStatesFirstLetters objectAtIndex:indexPath.section];
        NSArray *sectionAnimals = [self.dicoStates objectForKey:sectionTitle];
        NSString *name = [sectionAnimals objectAtIndex:indexPath.row];
        cell.textLabel.text = name;
        cell.textLabel.textColor = [UIColor grayColor];
        for (NSInteger count =0; count < [_arrStates count]; count ++)
        {
            PT_CountryModel *model = _arrStates[count];
            if ([name isEqualToString:model.countryName])
            {
                if (model.countryHasEvent > 0)
                {
                    float width  = 15;
                    float x = cell.frame.size.width - width - 10;
                    float y = cell.frame.size.height/2 - (width/2);
                    UIView *circleView = [UIView new];
                    circleView.frame = CGRectMake(x, y, width, width);
                    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                    circleView.backgroundColor = borderColor;
                    circleView.layer.cornerRadius = width/2;
                    circleView.layer.borderColor = [[UIColor clearColor] CGColor];
                    circleView.layer.borderWidth = 1.0;
                    circleView.layer.masksToBounds = YES;
                    [cell.contentView addSubview:circleView];
                }
            }
            
        }
    }
    else if(_tableType == TableType_Cities){
        NSString *sectionTitle = [_arrCitiesFirstLetters objectAtIndex:indexPath.section];
        NSArray *sectionAnimals = [self.dicoCities objectForKey:sectionTitle];
        NSString *name = [sectionAnimals objectAtIndex:indexPath.row];
        cell.textLabel.text = name;
        cell.textLabel.textColor = [UIColor grayColor];
        
        for (NSInteger count =0; count < [_arrCities count]; count ++)
        {
            PT_CountryModel *model = _arrCities[count];
            if ([name isEqualToString:model.countryName])
            {
                if (model.countryHasEvent > 0)
                {
                    float width  = 15;
                    float x = cell.frame.size.width - width - 10;
                    float y = cell.frame.size.height/2 - (width/2);
                    UIView *circleView = [UIView new];
                    circleView.frame = CGRectMake(x, y, width, width);
                    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                    circleView.backgroundColor = borderColor;
                    circleView.layer.cornerRadius = width/2;
                    circleView.layer.borderColor = [[UIColor clearColor] CGColor];
                    circleView.layer.borderWidth = 1.0;
                    circleView.layer.masksToBounds = YES;
                    [cell.contentView addSubview:circleView];
                }
            }
            
        }
    }else{
        
        _tableType = TableType_golfCourses;
        PT_CountryModel *model = [_arrGolfCoursesList objectAtIndex:indexPath.row];
        
        NSString *nameString = [NSString stringWithFormat:@"%@ ",model.countryName];
        NSString *cityStr = [NSString stringWithFormat:@"%@",model.cityName];
        cell.textLabel.text = nameString;
        cell.detailTextLabel.text = cityStr;
        cell.textLabel.textColor = [UIColor blackColor];    

        for (NSInteger count =0; count < [_arrGolfCoursesList count]; count ++)
        {
            //PT_CountryModel *model = _arrGolfCoursesList[count];
            //if ([nameString isEqualToString:model.countryName])
            {
                if (model.countryHasEvent > 0)
                {
                    float width  = 15;
                    float x = cell.frame.size.width - width - 10;
                    float y = cell.frame.size.height/2 - (width/2);
                    UIView *circleView = [UIView new];
                    circleView.frame = CGRectMake(x, y, width, width);
                    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
                    circleView.backgroundColor = borderColor;
                    circleView.layer.cornerRadius = width/2;
                    circleView.layer.borderColor = [[UIColor clearColor] CGColor];
                    circleView.layer.borderWidth = 1.0;
                    circleView.layer.masksToBounds = YES;
                    [cell.contentView addSubview:circleView];
                }
            }
            
        }

    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableType == TableType_Country)
    {
        _tableType = TableType_States;
        NSString *sectionTitle = [_arrCountryFirstLetters objectAtIndex:indexPath.section];
        NSArray *sectionAnimals = [self.dicoAlphabet objectForKey:sectionTitle];
        __block NSString *name = [sectionAnimals objectAtIndex:indexPath.row];
        [_arrCountries enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PT_CountryModel *model = obj;
            if ([name isEqualToString:model.countryName])
            {
                *stop = YES;
                [self fetchStates:model];
            }
        }];
    }
    else if (_tableType == TableType_States)
    {
        //_tableType = TableType_Cities;
        NSString *sectionTitle = [_arrStatesFirstLetters objectAtIndex:indexPath.section];
        NSArray *sectionAnimals = [self.dicoStates objectForKey:sectionTitle];
        __block NSString *name = [sectionAnimals objectAtIndex:indexPath.row];
        [_arrStates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PT_CountryModel *model = obj;
            if ([name isEqualToString:model.countryName])
            {
                *stop = YES;
                [self fetchCities:model];
            }
        }];


    } else if (_tableType == TableType_golfCourses){
        
        NSLog(@"Selected IndexPath: %li",(long)indexPath.row);
        PT_CountryModel *countryModel = [_arrGolfCoursesList objectAtIndex:indexPath.row];
        //PT_SelectGolfCourseModel *model = [_arrGolfCoursesList objectAtIndex:indexPath.row];
        PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
        model.golfCourseName = countryModel.countryName;
        model.golfCourseId = countryModel.countryId;
        model.golfCourseHasEvent = countryModel.countryHasEvent;
        model.golfCourseLocation = countryModel.cityName;

        
        dispatch_async(dispatch_get_main_queue(), ^{
            PT_CalenderViewController *calenderVC = [[PT_CalenderViewController alloc] initWithGolfCourse:model];
            
            [self presentViewController:calenderVC animated:YES completion:nil];
        });

        
    }
    
    else{
        if ([_arrCities count]>0) {
            
        
           _tableType = TableType_golfCourses;
            NSString *sectionTitle = [_arrCitiesFirstLetters objectAtIndex:indexPath.section];
            NSArray *sectionAnimals = [self.dicoCities objectForKey:sectionTitle];
            __block NSString *name = [sectionAnimals objectAtIndex:indexPath.row];
            [_arrCities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PT_CountryModel *model = obj;
                if ([name isEqualToString:model.countryName])
                {
                    *stop = YES;
                    [self fetchGolfCourses:model];
                }
            }];
//            PT_SelectGolfCorseViewController *selctGC = [[PT_SelectGolfCorseViewController alloc] initWithGolfCourseList:self.arrGolfCoursesList];
//            
//            selctGC.delegate = self;
//            
//            [self presentViewController:selctGC animated:YES completion:nil];
        }
    }
}

- (void)didSelectGolfCourse:(PT_SelectGolfCourseModel *)golfCourseModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PT_CalenderViewController *calenderVC = [[PT_CalenderViewController alloc] initWithGolfCourse:golfCourseModel];
        
        [self presentViewController:calenderVC animated:YES completion:nil];
    });
    
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


#pragma mark - Service Calls
- (void)fetchCountryList
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"version":@"2",@"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchCountryListPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      NSDictionary *responseDic = responseData;
                      NSArray *arrCountryList = responseDic[@"CountryList"];
                      //_arrCountries = [NSMutableArray new];
                      NSMutableArray *arrnames = [NSMutableArray new];
                      _arrCountries = [NSMutableArray new];
                      [arrCountryList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                          NSDictionary *dicCountry = obj;
                          PT_CountryModel *model = [PT_CountryModel new];
                          model.countryId = [dicCountry[@"country_id"] integerValue];
                          model.countryName = dicCountry[@"country_name"];
                          model.countryPhoneCode = [dicCountry[@"phonecode"] integerValue];
                          model.countryHasEvent = [dicCountry[@"has_event"] integerValue];
                          if ([dicCountry[@"has_event"] isEqualToString:@"1"])
                          {
                              NSLog(@"Has Event");
                          }
                          
                          [_arrCountries addObject:model];
                          [arrnames addObject:dicCountry[@"country_name"]];
                          if (idx == [arrCountryList count]-1)
                          {
                              _arrCountryFirstLetters = [NSMutableArray new];
                              NSArray *nameArray = [arrnames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                              for (int i = 0; i < [nameArray count]; i++)
                              {
                                  if ([[nameArray objectAtIndex:i] length]>0)
                                  {
                                      [_arrCountryFirstLetters addObject:nameArray[i]];
                                  }
                              }

                              self.dicoAlphabet = [NSMutableDictionary dictionary];
                              
                              // Iterate over all the values in our sorted array
                              for (NSString *value in _arrCountryFirstLetters) {
                                  
                                  // Get the first letter and its associated array from the dictionary.
                                  // If the dictionary does not exist create one and associate it with the letter.
                                  if (value.length>0)
                                  {
                                      NSString *firstLetter = [value substringToIndex:1];
                                      NSMutableArray *arrayForLetter = [self.dicoAlphabet objectForKey:firstLetter];
                                      if (arrayForLetter == nil) {
                                          arrayForLetter = [NSMutableArray array];
                                          [self.dicoAlphabet setObject:arrayForLetter forKey:firstLetter];
                                      }
                                      
                                      // Add the value to the array for this letter
                                      [arrayForLetter addObject:value];
                                  }
                              }
                              
                              // arraysByLetter will contain the result you expect
                              NSLog(@"Dictionary: %@", self.dicoAlphabet);
                              _arrCountryFirstLetters = (NSMutableArray *)[[self.dicoAlphabet allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                    [_tableList reloadData];
                              });
                              
                              
                          }
                      }];
                  }
                  else
                  {
                  }
                  
                  
              }];
    }

}

- (void)IntialfetchGolfCourses
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
#if (TARGET_OS_SIMULATOR)
        
        
        //self.latestLocation = [[CLLocation alloc] initWithLatitude:12.9716 longitude:77.5946];
        delegate.latestLocation = [[CLLocation alloc] initWithLatitude:28.5922729 longitude:77.33453080000004];
        
#endif
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"latitude":[NSString stringWithFormat:@"%f", delegate.latestLocation.coordinate.latitude],
                                @"longitude":[NSString stringWithFormat:@"%f", delegate.latestLocation.coordinate.longitude],
                                @"version":@"2",
                                @"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"ip_address":@""
                                };
        
        NSString *urlString = @"http://clients.vfactor.in/puttdemo/getnearestgolfcourse";
        
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"GolfcourseNerabyDistance"])
                              {
                                  self.arrSendforCalender = [NSMutableArray new];
                                  NSDictionary *data = responseData;
                                  id responseType = [data objectForKey:@"GolfcourseNerabyDistance"];
                                  if ([responseType isKindOfClass:[NSArray class]])
                                  {
                                      NSArray *arrData = [data objectForKey:@"GolfcourseNerabyDistance"];
                                      if ([arrData count] > 0)
                                      {
                                          _arrSendforCalender = [NSMutableArray new];
                                      }
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                                          
                                          [self.arrSendforCalender addObject:model];
                                          
                                          
                                          //Call Stroke types
                                          
                                      }];
                                  }
                                  else
                                  {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];                                      UIAlertController * alert=   [UIAlertController
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
                              [MBProgressHUD hideHUDForView:self.view animated:YES];                                  NSDictionary *dicData = responseData;
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
                  }
                  
                  
              }];
    }
}
//Mark:-fetch golfCourses according to city
- (void)fetchGolfCourses:(PT_CountryModel *)model
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
#if (TARGET_OS_SIMULATOR)
        
        
        //self.latestLocation = [[CLLocation alloc] initWithLatitude:12.9716 longitude:77.5946];
        delegate.latestLocation = [[CLLocation alloc] initWithLatitude:28.5922729 longitude:77.33453080000004];
        
#endif
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"cityId":[NSString stringWithFormat:@"%li",(long)model.countryId],
                                @"search_keyword":@"",
                                @"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        
        NSString *urlString = @"http://clients.vfactor.in/puttdemo/getgolfcourselist";
        
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          if ([responseData isKindOfClass:[NSDictionary class]])
                          {
                              if (responseData[@"CityGolfCourseList"])
                              {
                                  self.arrGolfCoursesList = [NSMutableArray new];
                                  NSDictionary *data = responseData;
                                  id responseType = [data objectForKey:@"CityGolfCourseList"];
                                  if ([responseType isKindOfClass:[NSArray class]])
                                  {
                                      NSArray *arrData = [data objectForKey:@"CityGolfCourseList"];
                                      if ([arrData count] > 0)
                                      {
                                          _arrGolfCoursesList = [NSMutableArray new];
                                      }
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          NSDictionary *dicCountry = obj;

                                          PT_CountryModel *model = [PT_CountryModel new];
                                          model.countryId = [dicCountry[@"golf_course_id"] integerValue];
                                          model.countryName = dicCountry[@"golf_course_name"];
                                          model.countryPhoneCode = [dicCountry[@"city_id"] integerValue];
                                          model.cityName = dicCountry[@"city_name"];
                                          model.countryHasEvent = [dicCountry[@"has_event"] integerValue];
                                          if ([dicCountry[@"has_event"] isEqualToString:@"1"])
                                          {
                                              NSLog(@"Has Event");
                                          }

                                          
                                          [self.arrGolfCoursesList addObject:model];
                                          NSLog(@"%@",model.cityName);
                                          //if (idx == [arrData count] - 1)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [_tableList reloadData];
                                              });
                                          }
                                          //Call Stroke types
                                          
                                      }];
                                  }
                                  else
                                  {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      UIAlertController * alert=   [UIAlertController
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
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                          
                          
                          
                      }
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
}




- (void)fetchStates:(PT_CountryModel *)model
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"version":@"2",
                                @"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"country_id":[NSString stringWithFormat:@"%li",model.countryId]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchStatesListPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      NSDictionary *responseDic = responseData;
                      NSDictionary *dicOutput = responseDic[@"output"];
                      NSArray *arrStateList = dicOutput[@"StateList"];
                      //_arrCountries = [NSMutableArray new];
                      NSMutableArray *arrnames = [NSMutableArray new];
                      _arrStates = [NSMutableArray new];
                      [arrStateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                          NSDictionary *dicCountry = obj;
                          PT_CountryModel *model = [PT_CountryModel new];
                          model.countryId = [dicCountry[@"state_id"] integerValue];
                          model.countryName = dicCountry[@"state_name"];
                          model.countryHasEvent = [dicCountry[@"has_event"] integerValue];
                          [_arrStates addObject:model];
                          [arrnames addObject:dicCountry[@"state_name"]];
                          if (idx == [arrStateList count]-1)
                          {
                              _arrStatesFirstLetters = [NSMutableArray new];
                              NSArray *nameArray = [arrnames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                              for (int i = 0; i < [nameArray count]; i++)
                              {
                                  if ([[nameArray objectAtIndex:i] length]>0)
                                  {
                                      [_arrStatesFirstLetters addObject:nameArray[i]];
                                  }
                              }
                              
                              self.dicoStates = [NSMutableDictionary dictionary];
                              
                              // Iterate over all the values in our sorted array
                              for (NSString *value in _arrStatesFirstLetters) {
                                  
                                  // Get the first letter and its associated array from the dictionary.
                                  // If the dictionary does not exist create one and associate it with the letter.
                                  if (value.length>0)
                                  {
                                      NSString *firstLetter = [value substringToIndex:1];
                                      NSMutableArray *arrayForLetter = [self.dicoStates objectForKey:firstLetter];
                                      if (arrayForLetter == nil) {
                                          arrayForLetter = [NSMutableArray array];
                                          [self.dicoStates setObject:arrayForLetter forKey:firstLetter];
                                      }
                                      
                                      // Add the value to the array for this letter
                                      [arrayForLetter addObject:value];
                                  }
                              }
                              
                              // arraysByLetter will contain the result you expect
                              NSLog(@"Dictionary: %@", self.dicoAlphabet);
                              _arrStatesFirstLetters = (NSMutableArray *)[[self.dicoStates allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [_tableList reloadData];
                              });
                              //[_tableList reloadData];
                              
                          }
                      }];
                  }
                  else
                  {
                  }
                  
                  
              }];
    }

}

- (void)fetchCities:(PT_CountryModel *)model
{
    __block AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"version":@"2",
                                @"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"state_id":[NSString stringWithFormat:@"%li",model.countryId]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchCitiesListPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      NSDictionary *responseDic = responseData;
                      NSDictionary *dicOutput = responseDic[@"output"];
                      NSArray *arrStateList = dicOutput[@"StateList"];
                      
                      if ([dicOutput[@"msg"] isEqualToString:@"City List Empty"])
                      {
                          UIAlertController * alert=   [UIAlertController
                                                        alertControllerWithTitle:@"PUTT2GETHER"
                                                        message:@"Cities for selected state could not be loaded. Please try selecting some other state."
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
                          //_arrCountries = [NSMutableArray new];
                          _tableType = TableType_Cities;
                          NSMutableArray *arrnames = [NSMutableArray new];
                          _arrCities = [NSMutableArray new];
                          [arrStateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                              NSDictionary *dicCountry = obj;
                              PT_CountryModel *model = [PT_CountryModel new];
                              model.countryId = [dicCountry[@"city_id"] integerValue];
                              model.countryName = dicCountry[@"city_name"];
                              model.countryHasEvent = [dicCountry[@"has_event"] integerValue];
                              [_arrCities addObject:model];
                              [arrnames addObject:dicCountry[@"city_name"]];
                              if (idx == [arrStateList count]-1)
                              {
                                  _arrCitiesFirstLetters = [NSMutableArray new];
                                  NSArray *nameArray = [arrnames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                  for (int i = 0; i < [nameArray count]; i++)
                                  {
                                      if ([[nameArray objectAtIndex:i] length]>0)
                                      {
                                          [_arrCitiesFirstLetters addObject:nameArray[i]];
                                      }
                                  }
                                  
                                  self.dicoCities = [NSMutableDictionary dictionary];
                                  
                                  // Iterate over all the values in our sorted array
                                  for (NSString *value in _arrCitiesFirstLetters) {
                                      
                                      // Get the first letter and its associated array from the dictionary.
                                      // If the dictionary does not exist create one and associate it with the letter.
                                      if (value.length>0)
                                      {
                                          NSString *firstLetter = [value substringToIndex:1];
                                          NSMutableArray *arrayForLetter = [self.dicoCities objectForKey:firstLetter];
                                          if (arrayForLetter == nil) {
                                              arrayForLetter = [NSMutableArray array];
                                              [self.dicoCities setObject:arrayForLetter forKey:firstLetter];
                                          }
                                          
                                          // Add the value to the array for this letter
                                          [arrayForLetter addObject:value];
                                      }
                                  }
                                  
                                  // arraysByLetter will contain the result you expect
                                  _arrCitiesFirstLetters = (NSMutableArray *)[[self.dicoCities allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [_tableList reloadData];
                                  });
                                  //[_tableList reloadData];
                                  
                              }
                          }];
                      }
                      
                  }
                  else
                  {
                  }
                  
                  
              }];
    }
    
}


@end
