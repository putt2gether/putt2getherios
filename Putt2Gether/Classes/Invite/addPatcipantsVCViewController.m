#import "addPatcipantsVCViewController.h"

#import "PT_SelectGolfCourseModel.h"

#import "PT_SelectGolfCourseTableViewCell.h"
#import "PT_GolfCourceTableViewCell.h"

#import "PT_selectCountryViewController.h"

#import "PT_CalenderViewController.h"

@interface addPatcipantsVCViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *nearByArray;
    NSArray *browseArray;
    NSArray *recentArray;
    
}
@property (strong, nonatomic) NSMutableArray *arrGolfCourseList;
@property (strong, nonatomic) PT_InviteViewController *inviteVC;

//For Country
@property (weak, nonatomic) IBOutlet UIView *browseCanvasView;
@property (strong, nonatomic) PT_selectCountryViewController *countryViewController;

@property(assign,nonatomic) NSInteger selButton;

@end

@implementation addPatcipantsVCViewController
- (instancetype)initWithDelegate:( UIViewController *)parent andGolfCourseList:(NSArray *)list
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    self.inviteVC = (PT_InviteViewController *)parent;
    self.arrGolfCourseList = [NSMutableArray arrayWithArray:list];
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    float nearByxDelta = 0.0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    if (screenHeight == 568)
    {
        nearByxDelta = (-1)*_nearBtn.frame.size.width/4 + 10;
    }
    else
    {
        nearByxDelta = (-1)*_nearBtn.frame.size.width/4;
    }
    _nearBtn.titleEdgeInsets = UIEdgeInsetsMake(58, nearByxDelta , 20, 0);
    
    _browseBtn.titleEdgeInsets = UIEdgeInsetsMake(58, nearByxDelta, 20, 0);
    _recentbtn.titleEdgeInsets = UIEdgeInsetsMake(58, (-1)*_recentbtn.frame.size.width/4 , 20, 0);
    
    [self fetchGolfCourses];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
    }



- (void)fetchRecentGolfCourse
{
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlert:@"Please check the internet connection and try again."];
        
    }
    else
    {

        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"player_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"limit":@"0",
                                @"user_id":[NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]],
                                @"version":@"2"
                                };
        
        NSString *urlString = @"getrecentgolfcourselist";
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
                              if (responseData[@"output"])
                              {
                                  NSDictionary *data = responseData;
                                  NSDictionary *responseType = [data objectForKey:@"output"];
                                  if ([responseType isKindOfClass:[NSDictionary class]])
                                  {
                                      NSArray *arrData = [responseType objectForKey:@"data"];
                                      if ([arrData count] > 0)
                                      {
                                          [self.arrGolfCourseList removeAllObjects];
                                          _arrGolfCourseList = [NSMutableArray new];
                                      }
                                      //                                      [self showLoadingView:NO];
                                      [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
                                          NSDictionary *dicGCData = obj;
                                          
                                          model.golfCourseName = [dicGCData[@"golf_course_name"] uppercaseString];
                                          model.golfCourseId = [dicGCData[@"golf_course_id"] integerValue];
                                          model.golfCourseLocation = [dicGCData[@"city_name"] uppercaseString];
                                          model.golfCourseLocationId = [dicGCData[@"city_id"] integerValue];
                                          model.distance = [dicGCData[@"Distance"] floatValue];
                                          model.golfCourseLatitude = [dicGCData[@"lat"] floatValue];
                                          model.golfCourseLongitude = [dicGCData[@"lon"] floatValue];
                                          model.golfCourseHasEvent = [dicGCData[@"has_event"] integerValue];
                                          
                                          [self.arrGolfCourseList addObject:model];
                                          nearByArray = self.arrGolfCourseList;
                                          if (idx == 0)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.tableView reloadData];
                                              });
                                              
                                          }
                                          
                                          //Call Stroke types
                                      }];
                                      
                                      
                                  }
                                  else
                                  {
                                      
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                                      });
                                          
                                     
                                  }
                                  
                              }
                              else
                              {
                                  //                                  [self showLoadingView:NO];
                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
                                  [self showAlert:messageError];
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
- (void)fetchGolfCourses
{
    AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlert:@"Please check the internet connection and try again."];
        
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
        
        NSString *urlString = @"getnearestgolfcourse";
        //
        [mainDAO postRequest:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                                          [self.arrGolfCourseList removeAllObjects];
                                          _arrGolfCourseList = [NSMutableArray new];
                                      }
                                      //                                      [self showLoadingView:NO];
                                      [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
                                          NSDictionary *dicGCData = obj;
                                          
                                          NSLog(@"Golf Course:%@",dicGCData[@"golf_course_name"]);
                                          NSLog(@"Has Event:%li",[dicGCData[@"has_even"] integerValue]);
                                          
                                          model.golfCourseName = [dicGCData[@"golf_course_name"] uppercaseString];
                                          model.golfCourseId = [dicGCData[@"golf_course_id"] integerValue];
                                          model.golfCourseLocation = [dicGCData[@"city_name"] uppercaseString];
                                          model.golfCourseLocationId = [dicGCData[@"city_id"] integerValue];
                                          model.distance = [dicGCData[@"Distance"] floatValue];
                                          model.golfCourseLatitude = [dicGCData[@"lat"] floatValue];
                                          model.golfCourseLongitude = [dicGCData[@"lon"] floatValue];
                                          model.golfCourseHasEvent = [dicGCData[@"has_event"] integerValue];
                                          
                                          [self.arrGolfCourseList addObject:model];
                                          nearByArray = self.arrGolfCourseList;
                                          if (idx == 0)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.tableView reloadData];
                                              });
                                          }
                                          
                                          //Call Stroke types
                                      }];
                                      
                                      
                                  }
                                  else
                                  {
                                      //                                      [self showLoadingView:NO];
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
                                      
                                      //[self presentViewController:alert animated:YES completion:nil];
                                  }
                                  
                              }
                              else
                              {
                                  //                                  [self showLoadingView:NO];
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
                      [self showAlert:@"Connection Lost."];

                  }
                  
                  
              }];
    }
}


- (void)setSelectedGolfCourse:(PT_SelectGolfCourseModel *)golfCourseModel
{
   // _currentGolfCourseModel = golfCourseModel;
    //    [self setGolfCourseForPreviewEvent:golfCourseModel];
    //get tee based on selected
    //    [self fetchTeeForGolfcourse];
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"title";
//}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    //same as your previous code
    return [_arrGolfCourseList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier ;//= @"SimpleTableItem";
    simpleTableIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    PT_SelectGolfCourseModel *model = self.arrGolfCourseList[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    for (UIView *sView in cell.contentView.subviews)
    {
        [sView removeFromSuperview];
    }
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    cell.textLabel.text = model.golfCourseName;
    cell.detailTextLabel.text = model.golfCourseLocation;
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10.0f];
    if (model.golfCourseHasEvent > 0)
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    PT_SelectGolfCourseModel *model = self.arrGolfCourseList[indexPath.row];
    
    PT_CalenderViewController *calenderVC = [[PT_CalenderViewController alloc] initWithGolfCourse:model];
    
    [self presentViewController:calenderVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)selecgolfBtnClicked:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.tabBarController.tabBar.hidden = NO;
        [delegate addTabBarAsRootViewController];
        
//        UIViewController *vc = self.presentingViewController;
//        while (vc.presentingViewController) {
//            vc = vc.presentingViewController;
//        }
//        [vc dismissViewControllerAnimated:YES completion:NULL];
        
    });
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)nearBtnClicked:(id)sender {
    
    if ([sender isSelected]) {
        //[sender setSelected: NO];
        
    } else {
        // [sender setSelected: YES];
        
        _selButton = 0;
    }

//    [tableData addObject:@"NIVESH" ];
    self.browseCanvasView.hidden = YES;
    //self.arrGolfCourseList = [NSMutableArray arrayWithArray:nearByArray];
    //[self.tableView reloadData];
    [self.arrGolfCourseList removeAllObjects];
    [self fetchGolfCourses];
}
- (IBAction)browseBtnclicked:(id)sender {
    //if (self.countryViewController == nil)
    
    if ([sender isSelected]) {
        //[sender setSelected: NO];
        
    } else {
        // [sender setSelected: YES];
        
        _selButton = 1;
    }
    {
        _countryViewController = [[PT_selectCountryViewController alloc] initWithNibName:@"PT_selectCountryViewController" bundle:nil];
        
    }
    self.browseCanvasView.hidden = NO;
    [self addChildViewController:self.countryViewController];
    [self.countryViewController.view setFrame:self.browseCanvasView.bounds];
    [self.browseCanvasView addSubview:self.countryViewController.view];
    [self.countryViewController didMoveToParentViewController:self];
   
}
- (IBAction)recentBtnClicked:(id)sender {
    
    if ([sender isSelected]) {
        //[sender setSelected: NO];
        
    } else {
        // [sender setSelected: YES];
        
        _selButton = 2;
    }
    //self.arrGolfCourseList = [NSMutableArray arrayWithArray:recentArray];
    self.browseCanvasView.hidden = YES;
    //self.arrGolfCourseList = [NSMutableArray arrayWithArray:nearByArray];
    //[self.tableView reloadData];
    [self.arrGolfCourseList removeAllObjects];
    [self fetchRecentGolfCourse];
}

- (void)fetchGolfCityCourse
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlert:@"Please check the internet connection and try again."];
    }
    else
    {
        //        [self showLoadingView:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        NSDictionary *param = @{@"cityId":@"6",
                                @"search_keyword":@"Delhi Golf Club",
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
                                  NSDictionary *data = responseData;
                                  id responseType = [data objectForKey:@"CityGolfCourseList"];
                                  if ([responseType isKindOfClass:[NSArray class]])
                                  {
                                      NSArray *arrData = [data objectForKey:@"CityGolfCourseList"];
                                      if ([arrData count] > 0)
                                      {
                                          _arrGolfCourseList = [NSMutableArray new];
                                      }
                                      //                                      [self showLoadingView:NO];
                                      [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                          PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
                                          NSDictionary *dicGCData = obj;
                                          
                                          model.golfCourseName = [dicGCData[@"golf_course_name"] uppercaseString];
                                          model.golfCourseId = [dicGCData[@"golf_course_id"] integerValue];
                                          model.golfCourseLocation = [dicGCData[@"city_name"] uppercaseString];
                                          model.golfCourseLocationId = [dicGCData[@"city_id"] integerValue];
                                          //model.distance = [dicGCData[@"Distance"] floatValue];
                                          model.golfCourseLatitude = [dicGCData[@"lat"] floatValue];
                                          model.golfCourseLongitude = [dicGCData[@"lon"] floatValue];
                                          model.golfCourseHasEvent = [dicGCData[@"has_event"] integerValue];
                                          model.golfCourseEventcount = [dicGCData[@"event_count"] integerValue];
                                          
                                          [self.arrGolfCourseList addObject:model];
                                          browseArray = self.arrGolfCourseList;
                                          if (idx == 0)
                                          {

                                              
                                              [self browseBtnclicked:self.browseBtn];                                              //                                              [self setGolfCourseForPreviewEvent:model];
                                          }
                                          
                                          //Call Stroke types
                                      }];
                                      
                                      [self.tableView reloadData];
                                  }
                                  else
                                  {
                                      //                                      [self showLoadingView:NO];
                                      [self showAlert:@"No Golf Course data found. please try again later."];
                                      
                                  }
                                  
                              }
                              else
                              {
                                  //                                  [self showLoadingView:NO];
                                  NSDictionary *dicData = responseData;
                                  NSDictionary *dictError = [dicData objectForKey:@"Error"];
                                  NSString *messageError = [dictError objectForKey:@"message"];
                                  
                                  [self showAlert:messageError];
                                  
                              }
                              
                          }
                      }
                      
                  }else{
                      
                      [self showAlert:@"Connection Lost."];

                  }
                  
                  
              }];
    }
}



-(void)showAlert:(NSString *)titleMsg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"PUTT2GETHER"
                                  message:titleMsg
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


#pragma Textfeild Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (_selButton == 0) {
        
        [self searchTableWithKeyword];

    }else if (_selButton == 1)
    {
        [self searchTableWithKeyword];
        _browseCanvasView.hidden = YES;


    }else if (_selButton == 2){
        
        [self searchTableWithKeyword];

    }
    
    [textField resignFirstResponder];

    return YES;
}


//Mark:-for Searching in tableView through Service call
-(void)searchTableWithKeyword
{
    MGMainDAO *DAO = [MGMainDAO new];
    
    NSDictionary *param = @{@"search_keyword":_searchText.text,
                            @"cityId":@"0",
                            @"user_id":[NSString stringWithFormat:@"%ld",(long)[[MGUserDefaults sharedDefault] getUserId]],
                            @"version":@"2"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getgolfcourselist"];
    NSLog(@"%@",urlString);
    
    [DAO postRequest:urlString withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
        
        //NSDictionary *outputDictionary = [responseData objectForKey:@"output"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        
        if (!error)
        {
            if (responseData != nil)
            {
                if ([responseData isKindOfClass:[NSDictionary class]])
                {
                    //                    if (responseData[@"output"])
                    //                    {
                    //
                    //                        NSDictionary *dataOutput = responseData[@"output"];
                    if ([responseData[@"status"] integerValue] == 1 || [responseData[@"status"] isEqualToString:@"1"])
                    {
                        
                        NSArray *arrData = [responseData objectForKey:@"CityGolfCourseList"];
                        
                        if ([arrData isKindOfClass:[NSArray class]])
                        {
                            if (_arrGolfCourseList == nil)
                            {
                                _arrGolfCourseList = [NSMutableArray new];
                            }
                            
                            [_arrGolfCourseList removeAllObjects];
                            
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
                                

                                
                                [_arrGolfCourseList addObject:model];
                                if (idx == [arrData count] - 1)
                                {
                                    _searchText.text = nil;

                                    [self.tableView reloadData];
                                }
                            }];
                        }
                        
                        
                        else
                        {
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                            NSDictionary *dictError = [responseData objectForKey:@"Error"];
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
            }
        }else{
            
            [self showAlert:@"Connection Lost."];
        }
        
        
    }];
    
    
}



@end
