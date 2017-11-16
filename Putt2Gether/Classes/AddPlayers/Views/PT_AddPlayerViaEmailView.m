//
//  PT_AddPlayerViaEmailView.m
//  Putt2Gether
//
//  Created by Devashis on 26/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_AddPlayerViaEmailView.h"


@interface PT_AddPlayerViaEmailView ()<UITextFieldDelegate>

{
    UITextField *currentTextField;

}

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation PT_AddPlayerViaEmailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBasicUI
{
    self.scrollView.frame = [super bounds];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height-150);
    
    self.addPlayerButton.layer.cornerRadius = 9.0f;
    self.addPlayerButton.layer.borderWidth = 1.0f;
    self.addPlayerButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.addPlayerButton.layer.masksToBounds = YES;
    _arrViewContainers = [NSMutableArray new];
    
    _playerView.textDisplayName.delegate = self;
    _playerView.textHandicap.delegate = self;
    _playerView.textEmail.delegate = self;
    
    //[self actionAddPlayer];
    [self actionAddPlayer];
}

- (IBAction)actionAddPlayer
{
    CGRect frameForNewView;
    float dy = 0;
    if ([_arrViewContainers count] > 0)
    {
        UIView *vPlayer = [self.arrViewContainers lastObject];
        frameForNewView = vPlayer.frame;
        dy = frameForNewView.size.height;
    }
    else
    {
        frameForNewView = self.addPlayerButton.frame;
    }
    
    
    _playerView = [[[NSBundle mainBundle] loadNibNamed:@"PT_PlayerIndividualCreationView" owner:self options:nil] objectAtIndex:0];
    float x = frameForNewView.origin.x;
    float y = frameForNewView.origin.y+dy;
    float width = self.frame.size.width - (x * 2); //-10;
    float height = 190.0f;
    _playerView.frame = CGRectMake(x, y, width, height);
    _playerView.roundCornerView.layer.cornerRadius = _playerView.roundCornerView.frame.size.width/2;
    [_playerView.playerButton setTitle:[NSString stringWithFormat:@"Player %li",self.arrViewContainers.count + 1] forState:UIControlStateNormal];
    _playerView.roundCornerView.layer.borderColor = [UIColor clearColor].CGColor;
    _playerView.roundCornerView.layer.borderWidth = 1.0;
    _playerView.roundCornerView.layer.masksToBounds = YES;
    _playerView.playerButton.layer.cornerRadius = 9.0f;
    _playerView.playerButton.layer.borderColor = [UIColor clearColor].CGColor;
    _playerView.playerButton.layer.borderWidth = 1.0;
    _playerView.playerButton.layer.masksToBounds = YES;
    [self.scrollView addSubview:_playerView];
    
    
    UIColor *borderColor = [UIColor colorWithRed:(48/255.0f) green:(131/255.0f) blue:(216/255.0f) alpha:1.0];
    _playerView.textDisplayName.layer.borderColor = borderColor.CGColor;
    _playerView.textDisplayName.layer.borderWidth = 1.0;
    _playerView.textDisplayName.layer.masksToBounds = YES;
    _playerView.textHandicap.layer.borderColor = borderColor.CGColor;
    _playerView.textHandicap.layer.borderWidth = 1.0;
    _playerView.textHandicap.layer.masksToBounds = YES;
    _playerView.textEmail.layer.borderColor = borderColor.CGColor;
    _playerView.textEmail.layer.borderWidth = 1.0;
    _playerView.textEmail.layer.masksToBounds = YES;
    
    _playerView.textDisplayName.delegate = self;
    _playerView.textHandicap.delegate = self;
    _playerView.textEmail.delegate = self;
    
    _playerView.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _playerView.contentView.layer.borderWidth = 0.5f;
    _playerView.contentView.layer.cornerRadius = 2.0f;
    _playerView.contentView.layer.masksToBounds = YES;
    
    [self.arrViewContainers addObject:_playerView];
    NSLog(@"%@",_arrViewContainers);

    
    float xAddButton = x;
    float yAddButton = _playerView.frame.origin.y + _playerView.frame.size.height;
    float wAddButton = self.addPlayerButton.frame.size.width;
    float hAddButton = self.addPlayerButton.frame.size.height;
    self.addPlayerButton.frame = CGRectMake(xAddButton, yAddButton, wAddButton, hAddButton);
    
    float contentHeight = self.arrViewContainers.count * 190;
    
    if (contentHeight >= self.frame.size.height)
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height  + _playerView.frame.size.height * 2);
        
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.exclusiveTouch = YES;
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.delaysContentTouches = YES;
    }
}

- (IBAction)actionAdd
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.playerView.textHandicap)
    {
        NSString *stringValue = textField.text;
        NSInteger integer = [stringValue intValue];
        if (integer <0 || integer > 30){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Putt2gether" message:@"Please Enter Valid Handicap Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];

            textField.textColor = [UIColor redColor];
        // You can make the text red here for example
        return ;
        }
        
    }else if (textField == self.playerView.textEmail){
        
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:textField.text] == NO) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Putt2gether!" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return ;
        }else{
            
            
        }
    }

    currentTextField = nil;
}


- (void)keyboardWasShown:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil]; //this is it!
    //yKeyboard = keyboardRect.origin.y;
    
    
    CGRect textFrame = [self convertRect:currentTextField.frame fromView:[currentTextField superview]];
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.frame;
    aRect.size.height -= kbSize.height;
    /*if (screenHeight == 568 && currentTextField == self.psswrdvalue)
     {
     CGPoint scrollPoint = CGPointMake(0.0, textFrame.origin.y-kbSize.height);
     [scrollView setContentOffset:scrollPoint animated:YES];
     }
     */
    if (!CGRectContainsPoint(aRect, textFrame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, textFrame.origin.y-kbSize.height);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)viewDidLayoutSubviews
{
    dispatch_async (dispatch_get_main_queue(), ^
                    {
                        [_scrollView setContentSize:CGSizeMake(0, self.frame.size.height -78 )];
                    });
}



@end
