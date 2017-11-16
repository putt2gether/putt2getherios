//
//  PT_ViewParticipantsViewController.m
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ViewParticipantsViewController.h"

#import "PT_ParticipantsTableViewCell.h"

#import "PT_AddPlayerOptionsViewController.h"

#import "PT_ViewRequestsViewController.h"

#import "PT_CreatedEventModel.h"

#import "NSMutableString+Color.h"

#import "UIImageView+AFNetworking.h"

#import "PT_PlayerProfileViewController.h"


static NSString *const FetchEventParticipantsPostfix = @"geteventparticipentlist";

static NSString *const UpdateHandicapPostfix = @"updateuserhandicap";


@interface PT_ViewParticipantsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    BOOL _isShowEditView;
    NSInteger _currentSelectedIndex;
    PT_CreatedEventModel *_createdEventModel;
    UIToolbar* numberToolbar;
    UITextField *selectedTextField;
}

@property (weak, nonatomic) IBOutlet UITableView *tableParticipants;


@property (nonatomic, strong) NSMutableArray *arrEventParticipants;

@property (nonatomic, strong) NSString *currentHandicapText;

@property (weak, nonatomic) IBOutlet UILabel *viewRequestsLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewRequestsButton;
@property (weak, nonatomic) IBOutlet UILabel *addParticipantsLabel;
@property (weak, nonatomic) IBOutlet UIButton *addParticipantsButton;
@property (weak, nonatomic) IBOutlet UIView *footerView,*addParticipantView;



@end

@implementation PT_ViewParticipantsViewController

- (instancetype)initWithEventModel:(PT_CreatedEventModel *)model
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    _createdEventModel = model;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isShowEditView = NO;
    
    self.addParticipantView.hidden = YES;
    
    
    
    [self fetchEventParticipants];
    if ([self.createdEventModel.isEventStarted isEqualToString:@"2"] || [self.createdEventModel.isEventStarted isEqualToString:@"4"])
    {
        self.addParticipantsLabel.hidden = YES;
        self.addParticipantsButton.hidden = YES;
        self.viewRequestsLabel.hidden = YES;
        self.viewRequestsButton.hidden = YES;
        self.footerView.hidden = YES;
    }
    else
    {
        if ([[MGUserDefaults sharedDefault] getUserId] == self.createdEventModel.adminId) {
            
            if ([self.createdEventModel.numberOfPlayers integerValue] > 4 ) {
                
                self.addParticipantView.hidden = YES;
                
            }else{
                
                self.addParticipantView.hidden = NO;

            self.addParticipantsLabel.hidden = NO;
            self.addParticipantsButton.hidden = NO;
            self.viewRequestsLabel.hidden = NO;
            self.viewRequestsButton.hidden = NO;
            }
        }
        else
        {
            self.addParticipantsLabel.hidden = YES;
            self.addParticipantsButton.hidden = YES;
            self.viewRequestsLabel.hidden = YES;
            self.viewRequestsButton.hidden = YES;
            self.footerView.hidden = YES;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    UIColor *toolBarColor = [UIColor colorWithRed:(228/255.0f) green:(232/255.0f) blue:(239/255.0f) alpha:1.0];
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [numberToolbar setBackgroundColor:toolBarColor/*[UIColor darkGrayColor]*/];
    numberToolbar.tintColor = toolBarColor;//[UIColor darkGrayColor];
    numberToolbar.barTintColor = toolBarColor;
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    [doneItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [doneItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
                                      [UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:1.0], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
    
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneItem] ;
    [numberToolbar sizeToFit];
    
    self.tableParticipants.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)keyboardWasShown:(NSNotification *)sender
{
    CGFloat height = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, height, 0);
    _tableParticipants.contentInset = edgeInsets;
    _tableParticipants.scrollIndicatorInsets = edgeInsets;
    
}

- (void)keyboardWillBeHidden:(NSNotification *)sender
{
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    _tableParticipants.contentInset = edgeInsets;
    //tableContents.scrollIndicatorInsets = edgeInsets;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //spinnerSmall = [[SHActivityView alloc]init];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    if (_isShowEditView == YES && _currentSelectedIndex == indexPath.row)
    {
        height = 125.0f;
    }
    else
    {
        height = 79.5f;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrEventParticipants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PT_ParticipantsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamACell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PT_ParticipantsTableViewCell"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    PT_PlayerItemModel *playerModel = self.arrEventParticipants[indexPath.row];
    
    
    NSString *name = [NSString stringWithFormat:@"%@ %li",playerModel.playerName,(long)playerModel.handicap];
    NSString *strHandicap = [NSString stringWithFormat:@"%li",(long)playerModel.handicap];
    NSMutableAttributedString * stringName = [[NSMutableAttributedString alloc] initWithString:name];
    
    NSRange boldRange = [name rangeOfString:strHandicap];
    [stringName addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:boldRange];
    
    [stringName setColorForText:strHandicap withColor:[UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1]];
    cell.userName.attributedText = stringName;
    //cell.userName.text = name;
    cell.status.text = playerModel.status;
    cell.handicapText.delegate = self;
    //cell.handicapText.textColor = [UIColor blueColor];
    cell.handicapText.text = [NSString stringWithFormat:@"%li",(long)playerModel.handicap];
    cell.handicapText.inputAccessoryView = numberToolbar;
    cell.editHandicapButton.tag = indexPath.row;
    [cell.userImageView setImageWithURL:[NSURL URLWithString:playerModel.playerImageURL]];
    cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.height/2;
    cell.userImageView.clipsToBounds = YES;
    cell.saveButton.tag = indexPath.row;
    /*
    if ([playerModel.status isEqualToString:@"Pending"]) {
        
        cell.profileEditImage.image = [UIImage imageNamed:@"edit_profile"];
        cell.buttonView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        cell.status.textColor = [UIColor blackColor];
        cell.editHandicapLabel.textColor = [UIColor blackColor];
        
    }else{
        
        [cell setDefaultUIProperties];

    }
    */
    
    //if (self.createdEventModel.)
    if (self.createdEventModel.adminId == [[MGUserDefaults sharedDefault] getUserId])
    {
        if ([self.createdEventModel.isEventStarted isEqualToString:@"1"] || [self.createdEventModel.isEventStarted isEqualToString:@"3"])
        {
            
            if ([playerModel.status isEqualToString:@"Pending"]) {
                
                cell.profileEditImage.image = [UIImage imageNamed:@"edit_profile"];
                cell.buttonView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
                cell.status.textColor = [UIColor blackColor];
                cell.editHandicapLabel.textColor = [UIColor blackColor];
                
                [cell.editHandicapButton addTarget:self action:@selector(actionEditHandicap:) forControlEvents:UIControlEventTouchUpInside];
                [cell.saveButton addTarget:self action:@selector(actionSaveHandicap:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                
                [cell.editHandicapButton addTarget:self action:@selector(actionEditHandicap:) forControlEvents:UIControlEventTouchUpInside];
                [cell.saveButton addTarget:self action:@selector(actionSaveHandicap:) forControlEvents:UIControlEventTouchUpInside];
                [cell setDefaultUIProperties];
               // [cell setDefaultUIProperties];
                
            }

            

        }
        
        else
        {
            if ([playerModel.status isEqualToString:@"Pending"]) {
                
                cell.profileEditImage.image = [UIImage imageNamed:@"edit_profile"];
                cell.buttonView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
                cell.status.textColor = [UIColor blackColor];
                cell.editHandicapLabel.textColor = [UIColor blackColor];
                
              //  [cell.editHandicapButton addTarget:self action:@selector(actionEditHandicap:) forControlEvents:UIControlEventTouchUpInside];
               // [cell.saveButton addTarget:self action:@selector(actionSaveHandicap:) forControlEvents:UIControlEventTouchUpInside];
            }else{

                [cell.editHandicapButton addTarget:self action:@selector(actionEditHandicap:) forControlEvents:UIControlEventTouchUpInside];
                [cell.saveButton addTarget:self action:@selector(actionSaveHandicap:) forControlEvents:UIControlEventTouchUpInside];
                [cell setDefaultUIProperties];
            }
        }
    }
    else
    {
       // cell.editHandicapButton.hidden = YES;
//        if (playerModel.playerId == [[MGUserDefaults sharedDefault] getUserId])
//        {
//            [cell.editHandicapButton addTarget:self action:@selector(actionEditHandicap:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.saveButton addTarget:self action:@selector(actionSaveHandicap:) forControlEvents:UIControlEventTouchUpInside];
//            [cell setDefaultUIProperties];
//
//        }
//        else
       // {
            cell.profileEditImage.hidden = YES; //[UIImage imageNamed:@"edit_profile"];

          //cell.buttonView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
            cell.buttonView.hidden = YES;
            cell.status.hidden = YES;
           // cell.status.textColor = [UIColor blackColor];
            cell.editHandicapLabel.hidden = YES;
            cell.singleLineStatus.text = playerModel.status;
       // }
    }
    
    [cell.saveButton addTarget:self action:@selector(actionSaveHandicap:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_currentSelectedIndex == indexPath.row && _isShowEditView == YES)
    {
        cell.lowerView.hidden = NO;
    }
    else
    {
        cell.lowerView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PT_PlayerItemModel *playerModel = self.arrEventParticipants[indexPath.row];

    
    PT_PlayerProfileViewController *playerVC = [[PT_PlayerProfileViewController alloc] initWithNibName:@"PT_PlayerProfileViewController" bundle:nil];
    [playerVC fetchUserDetails:[NSString stringWithFormat:@"%ld",(long)playerModel.playerId]];
    [playerVC fetchMyScores:[NSString stringWithFormat:@"%ld",(long)playerModel.playerId]];
    [self presentViewController:playerVC animated:YES completion:nil];
    
}

-(IBAction)doneWithNumberPad{
    
    [selectedTextField resignFirstResponder];
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

- (void)actionEditHandicap:(UIButton *)sender
{
    
    if (_createdEventModel.isStarted == 3) {
        
        [self showAlertWithMessage:@"Event already started can not edit handicap."];
        
    }else{
    
    if (_isShowEditView == YES)
    {
        _isShowEditView = NO;
    }
    else
    {
        _currentSelectedIndex = sender.tag;
        _isShowEditView = YES;
        
        
    }
    
    [self.tableParticipants reloadData];
    }
}

- (void)actionSaveHandicap:(UIButton *)sender
{
    NSLog(@"Tag : %li",(long)sender.tag);
    _isShowEditView = NO;
    [self.tableParticipants reloadData];
    PT_PlayerItemModel *model = self.arrEventParticipants[sender.tag];
    
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([_currentHandicapText length] == 0 || [_currentHandicapText isEqualToString:@"0"])
    {
        [self showAlertWithMessage:@"Please enter the value for Handicap and try again."];
        _currentHandicapText = [NSString stringWithFormat:@"%li",(long)model.playerId];
        return;
    }
    
    else if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", (long)self.createdEventModel.eventId],
                                @"user_id":[NSString stringWithFormat:@"%li",(long)model.playerId],
                                @"handicap_value":_currentHandicapText,
                                @"version":@"2"
                                };
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,UpdateHandicapPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                  
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              _currentHandicapText = nil;
                              [self fetchEventParticipants];
                              
                          }
                          else
                          {
                              [self showAlertWithMessage:dicOutput[@"message"]];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }
    
}

- (IBAction)actionBack
{
    self.previewVC.isEditMode = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionAddParticipants
{
    PT_AddPlayerOptionsViewController *addPlayersOptionsVC = [[PT_AddPlayerOptionsViewController alloc] initWithEventModel:self.createdEventModel];

    addPlayersOptionsVC.isComingFromAddParticipant = YES;
        addPlayersOptionsVC.numberOfPlayers = NumberOfPlayers_MoreThan4;
    
    [self presentViewController:addPlayersOptionsVC animated:YES completion:nil];
}


- (IBAction)actionRequests
{
    PT_ViewRequestsViewController *viewRequests = [[PT_ViewRequestsViewController alloc] initWithNibName:@"PT_ViewRequestsViewController" bundle:nil];
    
    [self presentViewController:viewRequests animated:YES completion:nil];
}

#pragma text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentHandicapText = nil;
    selectedTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@"0"] || [textField.text length] == 0)
    {
        
    }else if ([textField.text integerValue] > 30)
    {
        
        [self showAlertWithMessage:@"Value must be less than 30"];
       // selectedTextField.text = _currentHandicapText;
        PT_PlayerItemModel *playerModel = self.arrEventParticipants[_currentSelectedIndex];
        selectedTextField.text = [NSString stringWithFormat:@"%ld", (long)playerModel.handicap];
    }
    
    else
    {
        _currentHandicapText = textField.text;
        PT_PlayerItemModel *playerModel = self.arrEventParticipants[_currentSelectedIndex];
        playerModel.handicap = [_currentHandicapText integerValue];
    }
    selectedTextField = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _currentHandicapText = textField.text;
    [textField resignFirstResponder];
    return YES;
}

#pragma marks - WEb service Calls

- (void)fetchEventParticipants
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.internetReachability.currentReachabilityStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check the internet connection and try again."];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MGMainDAO *mainDAO = [MGMainDAO new];
        
        NSDictionary *param = @{@"event_id":[NSString stringWithFormat:@"%li", self.createdEventModel.eventId],
                                @"version":@"2"
                                };
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,FetchEventParticipantsPostfix];
        [mainDAO postRequest:urlString
              withParameters:param withCompletionBlock:^(id responseData, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (!error)
                  {
                      if (responseData != nil)
                      {
                          NSDictionary *dicResponseData = responseData;
                          
                          NSDictionary *dicOutput = dicResponseData[@"output"];
                          if ([dicOutput[@"status"] isEqualToString:@"1"])
                          {
                              
                              NSArray *arrData = dicOutput[@"data"];
                              _arrEventParticipants = [NSMutableArray new];
                              [arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                  
                                  NSDictionary *dicData = obj;
                                  PT_PlayerItemModel *playerModel = [PT_PlayerItemModel new];
                                  playerModel.playerName = dicData[@"full_name"];
                                  playerModel.playerId = [dicData[@"userId"] integerValue];
                                  playerModel.handicap = [dicData[@"handicap_value"] integerValue];
                                  playerModel.playerImageURL = dicData[@"thumb_url"];
                                  playerModel.status = dicData[@"invitation_status"];
                                  
                                  [self.arrEventParticipants addObject:playerModel];
                                  
                                  if (idx == [arrData count] - 1)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                           [_tableParticipants reloadData];
                                      });
                                  }
                              }];
                              
                          }
                          else
                          {
                              [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                          }
                      }
                      
                      else
                      {
                          [self showAlertWithMessage:@"Unable to fetch data. Please try again."];
                      }
                  }
                  else
                  {
                      [self showAlertWithMessage:@"Connection Lost."];
                  }
                  
                  
              }];
    }

}

@end
