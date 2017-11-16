//
//  PT_SelectGolfCorseViewController.m
//  Putt2Gether
//
//  Created by Devashis on 18/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_SelectGolfCorseViewController.h"

#import "PT_SelectGolfCourseModel.h"

#import "PT_SelectGolfCourseTableViewCell.h"

#import "PT_CreateGolfCorseViewController.h"

#import "MGMainDAO.h"

#import "PT_GolfSearchModel.h"




@interface PT_SelectGolfCorseViewController ()<UITableViewDataSource,
                                               UITextFieldDelegate,
                                               UITableViewDelegate>
{
    NSArray *tempArray;
    IBOutlet UITextField *textSearch;
}

@property (weak, nonatomic) IBOutlet UITableView *tableGolfCourse;

@property (strong, nonatomic) PT_CreateViewController *createVC;

@property (strong, nonatomic) NSMutableArray *arrGolfCourseList;



@end

@implementation PT_SelectGolfCorseViewController

- (instancetype)initWithDelegate:(PT_CreateViewController *)parent andGolfCourseList:(NSArray *)list
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    self.createVC = parent;
    self.arrGolfCourseList = [NSMutableArray arrayWithArray:list];
    return self;
}

- (instancetype)initWithGolfCourseList:(NSArray *)list
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    self.createVC = nil;
    self.arrGolfCourseList = [NSMutableArray arrayWithArray:list];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableGolfCourse reloadData];
    
   // [textSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegte

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchTableWithKeyword];
    [self.tableGolfCourse reloadData];
    [textField resignFirstResponder];
    //[_arrGolfCourseList removeAllObjects];

    
    return YES;
}

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    return YES;
}*/

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length == 0 && tempArray != nil)
    {
        [self.arrGolfCourseList removeAllObjects];
        self.arrGolfCourseList = [tempArray mutableCopy];
        tempArray = nil;
        [self.tableGolfCourse reloadData];
        return;
    }
    
    if (tempArray == nil)
    {
        tempArray = [NSArray arrayWithArray:self.arrGolfCourseList];
    }
    
    NSString * match = textField.text;
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"golfCourseName",match];
    
    //or use Name like %@ //”Name” is the Key we are searching
    NSArray *arrSorted = [tempArray filteredArrayUsingPredicate:predicate];
    
    self.arrGolfCourseList = nil;
    self.arrGolfCourseList = [NSMutableArray arrayWithArray:arrSorted];
    
    [self.tableGolfCourse reloadData];
}

#pragma mark - Action Methods

- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCreateNewGolfCourse
{
    PT_CreateGolfCorseViewController *createGF = [[PT_CreateGolfCorseViewController alloc] initWithDelegate:self];
    [self presentViewController:createGF animated:YES completion:nil];
}

#pragma mark - TableView Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrGolfCourseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PT_SelectGolfCourseModel *model = self.arrGolfCourseList[indexPath.row];
    
    PT_SelectGolfCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GolfCourse"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_SelectGolfCourseTableViewCell"
                                                  owner:self
                                                options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    cell.golfCourseName.text = model.golfCourseName;
    cell.golfClubAddress.text = model.golfCourseLocation;
    
    if (self.createVC == nil)
    {
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
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_SelectGolfCourseModel *model = self.arrGolfCourseList[indexPath.row];
    
    if (self.createVC == nil)
    {
        [self.delegate didSelectGolfCourse:model];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
        [self.createVC setSelectedGolfCourse:model];
        self.createVC.isGolfCourseExplicitlySelected = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//Mark:-for Searching in tableView through Service call
-(void)searchTableWithKeyword
{
    MGMainDAO *DAO = [MGMainDAO new];
    
    NSDictionary *param = @{@"search_keyword":textSearch.text,
                            @"cityId":@"0"};
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"getgolfcourselist"];
    NSLog(@"%@",urlString);
    
    [DAO postRequest:urlString withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
        
        //NSDictionary *outputDictionary = [responseData objectForKey:@"output"];
        
        
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
                                
//                                PT_GolfSearchModel *model = [PT_GolfSearchModel new];
//                                model.city_name = dic[@"city_name"];
//                                model.golfCourseName = dic[@"golf_course_name"];
//                                model.cityId = [dic[@"city_id"] integerValue];
//                                model.latitude = [dic[@"latitude"] floatValue];
//                                model.longitude = [dic[@"longitude"] floatValue];
//                                model.golfcourseId = [dic[@"golf_course_id"] integerValue];
//                                model.hasEvent = [dic[@"has_event"] integerValue];
//                                model.event_count = [dic[@"event_count"] integerValue];
                                
                                [_arrGolfCourseList addObject:model];
                                if (idx == [arrData count] - 1)
                                {
                                    [self.tableGolfCourse reloadData];
                                }
                            }];
                        }

                    
                    else
                    {
                        
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
        }
        
                         
    }];

    
}

@end
