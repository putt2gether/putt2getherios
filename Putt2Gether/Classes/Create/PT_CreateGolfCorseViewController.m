//
//  PT_CreateGolfCorseViewController.m
//  Putt2Gether
//
//  Created by Devashis on 18/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_CreateGolfCorseViewController.h"

#import "PT_TempGCTableViewCell.h"

#import "PT_TempGolfCourseItemModel.h"

static const int ParBaseTag = 100;

static const int IndexBaseTag = 200;

@interface PT_CreateGolfCorseViewController ()<UITextFieldDelegate>
{
    UITextField *currentTextField;

}

//@property (strong, nonatomic) PT_SelectGolfCorseViewController *createVC;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableHeaderyAxis;

@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UITableView *tableTempGC;

@property (strong, nonatomic) NSMutableArray *arrTempGCList;

@property (weak, nonatomic) IBOutlet UIButton *tempGCButton;

@property (weak, nonatomic) IBOutlet UITextField *golfCourseName;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *country;

//Mark:-temporary
@property(assign,nonatomic) NSInteger selectedButton;

//Mark:-for making header stationary hile keyboard opens
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation PT_CreateGolfCorseViewController


- (instancetype)initWithDelegate:(PT_SelectGolfCorseViewController *)parent
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    self.createVC = parent;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableHeaderView.hidden = YES;
    self.tableTempGC.hidden = YES;
    _arrTempGCList = [NSMutableArray new];
    
    for (NSInteger index = 0; index < 18; index++)
    {
        PT_TempGolfCourseItemModel *model = [PT_TempGolfCourseItemModel new];
    
        model.parKey = [NSString stringWithFormat:@"par_%li",(long)index+1];
        model.indexKey = [NSString stringWithFormat:@"index_%li",(long)index+1];
        model.isParAssigned = NO;
        model.isIndexAssigned = NO;
        [self.arrTempGCList addObject:model];
    }
    
    UIColor *borderColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    self.tempGCButton.backgroundColor = [UIColor whiteColor];
    self.tempGCButton.layer.borderWidth = 1.0;
    self.tempGCButton.layer.cornerRadius = self.tempGCButton.frame.size.width/2;
    self.tempGCButton.layer.borderColor = borderColor.CGColor;
    self.tempGCButton.layer.masksToBounds = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    switch (screenHeight) {
        case 480 :
        {
            
            
        }
            break;
            
        case 568:
        {
            
            self.constraintTableHeaderyAxis.constant = (self.view.frame.size.height / 10);
        }
            break;
            
        case 667:
        {
            self.constraintTableHeaderyAxis.constant = (self.view.frame.size.height / 16);
        }
            break;
            
        case 736:
        {
            //self.loginBoxHeight.constant = 220;
        }
            break;
            
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWasShown:(NSNotification *)sender
{
    CGFloat height = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, height-140, 0);
    _tableTempGC.contentInset = edgeInsets;
    _tableTempGC.scrollIndicatorInsets = edgeInsets;
    
}

- (void)keyboardWillBeHidden:(NSNotification *)sender
{
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    _tableTempGC.contentInset = edgeInsets;
    //tableContents.scrollIndicatorInsets = edgeInsets;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Mark:-Hide KeyBoard from anywhere
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [currentTextField resignFirstResponder];
    [_golfCourseName resignFirstResponder];
    [_state resignFirstResponder];
    [_city resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
//    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *tagStr = [[NSString stringWithFormat:@"%li",(long)textField.tag] substringToIndex:1];
    if ([tagStr integerValue] == 1 || [tagStr integerValue] == 2)
    {
        self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y - self.tableTempGC.frame.size.height-45, self.containerView.frame.size.width, self.containerView.frame.size.height);
    }
    
    currentTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *tagStr = [[NSString stringWithFormat:@"%li",(long)textField.tag] substringToIndex:1];
    if ([tagStr integerValue] == 1)//Par
    {
        NSInteger holeNumber = textField.tag - ParBaseTag;
        PT_TempGolfCourseItemModel *model = self.arrTempGCList[holeNumber];
        self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y + self.tableTempGC.frame.size.height+45, self.containerView.frame.size.width, self.containerView.frame.size.height);
        if (([textField.text isEqualToString:@"3"]) ||
            ([textField.text isEqualToString:@"4"])||
            [textField.text isEqualToString:@"5"])
        {
            model.parValue = textField.text;
            model.isParAssigned = YES;
            
        }else if ([textField.text isEqualToString:@""]){
            
            textField.text = nil;
            model.isParAssigned = NO;

            
        }
        else{
            textField.text = nil;
            model.isParAssigned = NO;
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"PUTT2GETHER"
                                          message:@"Values other than 3, 4 and 5 not allowed for this field"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Dismiss"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [textField resignFirstResponder];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if ([tagStr integerValue] == 2)//Index
    {
        NSInteger holeNumber = textField.tag - IndexBaseTag;
        PT_TempGolfCourseItemModel *model = self.arrTempGCList[holeNumber];
        self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y + self.tableTempGC.frame.size.height+45, self.containerView.frame.size.width, self.containerView.frame.size.height);
        BOOL isInRange = [self float:[textField.text floatValue] between:1.0 and:18.0 ];
        if (isInRange == YES)
        {
            BOOL isPresent = NO;
            for (NSInteger index = 0; index < [self.arrTempGCList count]; index++)
            {
                PT_TempGolfCourseItemModel *model = self.arrTempGCList[index];
                if ([model.indexValue isEqualToString:textField.text])
                {
                    isPresent = YES;
                    textField.text = nil;
                    model.isIndexAssigned = NO;
                    NSString *message = [NSString stringWithFormat:@"Index value already entered in hole number %i. Please enter any other value.", index+1];
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"PUTT2GETHER"
                                                  message:message
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    
                    UIAlertAction* cancel = [UIAlertAction
                                             actionWithTitle:@"Dismiss"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [textField resignFirstResponder];
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
                    
                    [alert addAction:cancel];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    isPresent = NO;
                }
            }
            if (isPresent == NO)
            {
                model.indexValue = textField.text;
                model.isIndexAssigned = YES;
            }
        }else if ([textField.text isEqualToString:@""]){
            
            textField.text = nil;
            model.isParAssigned = NO;
            
            
        }

        else
        {
            textField.text = nil;
            model.isIndexAssigned = NO;
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"PUTT2GETHER"
                                          message:@"Values other than 1 - 18 not allowed for this field"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Dismiss"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [textField resignFirstResponder];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Action Methods

- (IBAction)actionSubmitTempGolfCourse
{
    if (self.golfCourseName.text.length ==0 ||
        self.city.text.length == 0 ||
        self.state.text.length == 0 ||
        self.country.text.length == 0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"PUTT2GETHER"
                                      message:@"Please fill all the fields."
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
        if (_selectedButton == 1){
            
            if ([self checkForParAndIndex] == YES)
            {
                [self sendCreateTempGolfCourseRequest];
            }
        }else{
            
            [self createTepmGCWithoutPar];

        }
        
    }
}

- (IBAction)actionTemporaryGolfCourse:(id)sender
{
    
    if ([sender isSelected]) {
        //[sender setSelected: NO];
        
        _selectedButton = 0;
    } else {
       // [sender setSelected: YES];
        
        _selectedButton = 1;
    }

    if (self.tableHeaderView.hidden == YES)
    {
        self.tableHeaderView.hidden = NO;
        self.tableTempGC.hidden = NO;
        [self.tempGCButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        self.tempGCButton.selected = YES;
    }
    else
    {
        [self.tempGCButton setBackgroundImage:nil forState:UIControlStateNormal];
        self.tableHeaderView.hidden = YES;
        self.tableTempGC.hidden = YES;
        self.tempGCButton.selected = NO;

    }
}



- (IBAction)actionBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendCreateTempGolfCourseRequest
{
    NSMutableDictionary *dictionaryRequest = [NSMutableDictionary new];
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];
    [dictionaryRequest setValue:userId forKey:@"created_by"];
    [dictionaryRequest setValue:self.golfCourseName.text forKey:@"name"];
    [dictionaryRequest setValue:self.city.text forKey:@"city"];
    [dictionaryRequest setValue:self.state.text forKey:@"state"];
    [dictionaryRequest setValue:self.country.text forKey:@"country"];
    [dictionaryRequest setValue:@"1" forKey:@"create_temporary"];
    [dictionaryRequest setValue:@"2" forKey:@"version"];
    NSMutableArray *arrPar = [NSMutableArray new];
    NSMutableArray *arrIndex = [NSMutableArray new];
    
    NSMutableDictionary *dicPar = [NSMutableDictionary new];
    NSMutableDictionary *dicIndex = [NSMutableDictionary new];
    
    for (NSInteger index = 0; index <[self.arrTempGCList count]; index++)
    {
        PT_TempGolfCourseItemModel *model = self.arrTempGCList[index];
        NSString *parValue = model.parValue;
        NSString *indexValue = model.indexValue;
        [dicPar setObject:parValue forKey:model.parKey];
        //NSDictionary *dicPar = [NSDictionary dictionaryWithObjectsAndKeys:parValue,model.parKey, nil];
        //[arrPar addObject:dicPar];
        
        [dicIndex setObject:indexValue forKey:model.indexKey];
        //NSDictionary *dicIndex = [NSDictionary dictionaryWithObjectsAndKeys:indexValue,model.indexKey, nil];
        //[arrIndex addObject:dicIndex];
        
    }
    [arrPar addObject:dicPar];
    [arrIndex addObject:dicIndex];
    
    //[dictionaryRequest setValue:arrPar forKey:@"par_values"];
    //[dictionaryRequest setValue:arrIndex forKey:@"index_values"];
    [dictionaryRequest setValue:dicPar forKey:@"par_values"];
    [dictionaryRequest setValue:dicIndex forKey:@"index_values"];
    NSLog(@"REQUEST DICTIONARY : %@",dictionaryRequest);
    
    MGMainDAO *mainDAO = [MGMainDAO new];
    
    
    NSString *urlString = @"http://clients.vfactor.in/puttdemo/createtemporarygolfcourse";
    //[NSString stringWithFormat:@"%@%@",BASE_URL,GetGolfCoursePostFix]
    [mainDAO postRequest:urlString
          withParameters:dictionaryRequest withCompletionBlock:^(id responseData, NSError *error) {
              
              if (!error)
              {
                  if (responseData != nil)
                  {
                      if ([responseData isKindOfClass:[NSDictionary class]])
                      {
                          NSLog(@"RESPONSE DATA:%@",responseData);
                          NSDictionary *dicOutput = responseData[@"output"];
                          if ([dicOutput[@"status"] integerValue] == 1 ||[dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                              //NSDictionary *data = responseData;
                              //NSDictionary *responseType = [data objectForKey:@"Success"];
                              PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
                              model.golfCourseId = [dicOutput[@"golfcourseid"] integerValue];
                              model.golfCourseName = self.golfCourseName.text;
                              [self.createVC setSelectedGolfCourse:model];
                              [self dismissViewControllerAnimated:YES completion:nil];
                              
                              [self.createVC setSelectedGolfCourse:model];
                              
                          }
                          else
                          {
                              //[self showLoadingView:NO];
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

//MArk:-service call for creating temp GC without PAR/Index Values
-(void)createTepmGCWithoutPar{
    
    NSString *userId = [NSString stringWithFormat:@"%li",(long)[[MGUserDefaults sharedDefault] getUserId]];

    
    MGMainDAO *mainDAO = [MGMainDAO new];
    
    NSDictionary *params = @{@"created_by":userId,
                             @"name":self.golfCourseName.text,
                             @"city":self.city.text,
                             @"state":self.state.text,
                             @"country":self.country.text,
                             @"create_temporary":@"0",
                             @"version":@"2"};
    
    NSString *urlString = @"http://clients.vfactor.in/puttdemo/createtemporarygolfcourse";
    //[NSString stringWithFormat:@"%@%@",BASE_URL,GetGolfCoursePostFix]
    [mainDAO postRequest:urlString
          withParameters:params withCompletionBlock:^(id responseData, NSError *error) {
              
              if (!error)
              {
                  if (responseData != nil)
                  {
                      if ([responseData isKindOfClass:[NSDictionary class]])
                      {
                          NSLog(@"RESPONSE DATA:%@",responseData);
                          NSDictionary *dicOutput = responseData[@"output"];
                          if ([dicOutput[@"status"] integerValue] == 1 ||[dicOutput[@"status"] isEqualToString:@"1"])
                          {
                             
 
                              PT_SelectGolfCourseModel *model = [PT_SelectGolfCourseModel new];
                              model.golfCourseId = [dicOutput[@"golfcourseid"] integerValue];
                              model.golfCourseName = self.golfCourseName.text;
                              [self.createVC setSelectedGolfCourse:model];
                              [self dismissViewControllerAnimated:YES completion:nil];
                              [self.createVC setSelectedGolfCourse:model];
                             
                              
                          }
                          else
                          {
                              //[self showLoadingView:NO];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    PT_TempGCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GolfCourse"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_TempGCTableViewCell"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.parTextField.delegate = self;
        cell.indexTextField.delegate = self;
        
    }
    
    cell.parTextField.tag = ParBaseTag + indexPath.row;
    cell.indexTextField.tag = IndexBaseTag + indexPath.row;
    
    PT_TempGolfCourseItemModel *model = self.arrTempGCList[indexPath.row];
    if (model.parValue.length != 0)
    {
        cell.parTextField.text = model.parValue;
    }
    if (model.indexValue.length != 0)
    {
        cell.indexTextField.text = model.indexValue;
    }
    
    NSString *holeNumber = [NSString stringWithFormat:@"Hole %li",indexPath.row+1];
    
    cell.holeNumber.text = holeNumber;
    
    return cell;
}

- (BOOL)float:(float)aFloat between:(float)minValue and:(float)maxValue {
    if (aFloat >= minValue && aFloat <= maxValue) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkForParAndIndex
{
    BOOL returnValue = NO;
    for (NSInteger index = 0; index < [self.arrTempGCList count]; index++) {
        PT_TempGolfCourseItemModel *model = self.arrTempGCList[index];
        if (model.isParAssigned == NO || model.isIndexAssigned == NO)
        {
            returnValue = NO;
            NSString *message = [NSString stringWithFormat:@"You can't leave fileds for hole number %i empty",index+1];
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
        else
        {
            returnValue = YES;
        }
    }
    return returnValue;
}


@end
