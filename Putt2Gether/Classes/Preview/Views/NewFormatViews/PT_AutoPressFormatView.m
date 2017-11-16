//
//  PT_AutoPressFormatView.m
//  Putt2Gether
//
//  Created by Nivesh on 02/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_AutoPressFormatView.h"

#import "PT_AutoPressTableViewCell.h"

#import "PT_420Formatmodel.h"

#import "PT_AutopressSecTableViewCell.h"



#define kProductCellIdentifier @"CellIdentifier"

#define pPrdoduc @"cell"


@interface PT_AutoPressFormatView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *arrTableautoPress;

@property (weak, nonatomic) IBOutlet UITableView *tableautoPress;

@property(strong,nonatomic) IBOutlet NSLayoutConstraint *tableYpos;

@property(weak,nonatomic) IBOutlet UIView *fadedView;

@end


@implementation PT_AutoPressFormatView

- (instancetype)init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    return self;
}

- (void)awakeFromNib {
    // [self fetchEmoji];
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:@"PT_AutoPressTableViewCell" bundle: nil];
    [self.tableautoPress  registerNib:nib forCellReuseIdentifier:kProductCellIdentifier];
    
    UINib *nib2 = [UINib nibWithNibName:@"PT_AutopressSecTableViewCell" bundle: nil];
    [self.tableautoPress  registerNib:nib2 forCellReuseIdentifier:pPrdoduc];
    
    [self.tableautoPress setDataSource:self];
    [self.tableautoPress setDelegate:self];
    
    UITapGestureRecognizer*tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapped.numberOfTapsRequired = 1;
    [_fadedView addGestureRecognizer:tapped];
    
    
}

-(void)tapDetected:(UITapGestureRecognizer *)recognizer
{
    [self hideview];
    
}
-(void)hideview
{
    [self setHidden:YES];
    [_fadedView removeFromSuperview];
}


-(void)loadTableWithdata:(NSMutableArray *)array
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.arrTableautoPress = [[NSArray alloc] initWithArray:array];
        //Mark:-for Y postion of
        CGFloat tableYpostion = 35.0f;
        for (int i = 0; i < [array count]; i ++) {
            tableYpostion += [self tableView:self.tableautoPress heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            
        }
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        int screenHeight    = screenRect.size.height;
        
        CGFloat tableviewHeight = screenHeight - tableYpostion;
        
        self.tableYpos.constant = tableviewHeight;
        _tableautoPress.scrollEnabled = NO;

        
        if (tableYpostion > screenHeight) {
            
            self.tableYpos.constant = 0;
            _tableautoPress.scrollEnabled = YES;

        }
        //        self.table420format.frame = CGRectMake(self.table420format.frame.origin.x,tableviewHeight, self.table420format.frame.size.width, tableYpostion);
        
        /*self.tableLeaderboard.layer.borderWidth = 1.0;
         self.tableLeaderboard.layer.borderColor = [[UIColor darkGrayColor] CGColor];
         self.tableLeaderboard.layer.cornerRadius = 2.0;
         self.tableLeaderboard.layer.masksToBounds = YES;
         */
        [self.tableautoPress reloadData];
    });
    
    
}
#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTableautoPress count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    PT_AutoPressTableViewCell *cell =  (PT_AutoPressTableViewCell *)[self.tableautoPress dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
//    
//    cell.firstView.layer.cornerRadius = 10.0f;
//    cell.firstView.clipsToBounds = YES;
//    cell.secondView.layer.cornerRadius = 10.0f;
//    cell.secondView.clipsToBounds = YES;
//    
//    
//    cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.tableautoPress.separatorStyle = UITableViewCellSeparatorStyleNone;
//
    
    PT_420Formatmodel *model = self.arrTableautoPress[indexPath.row];
//    cell.holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)model.hole_number];
    
    //NSInteger row = indexPath.row;
    
   
    NSLog(@"%ld",(long)model.secondArrayCount);
//    if (model.secondArrayCount > 0) {
//        
//        CGSize stringsize=[cell.secondV1stLbl.text sizeWithAttributes:
//                           @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
//        
//        CGSize stringsize2 = [cell.firstV1stLbl.text sizeWithAttributes:
//                              @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
//        CGFloat strSize2 = stringsize2.width+20;
//        
//        cell.widthConsFirstView.constant = strSize2;
//        CGFloat strSize = stringsize.width+20;
//        
//        cell.widthConsSecondView.constant = strSize;
//        
////        NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:cell.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
////        [cell.contentView addConstraint:xCenterConstraint];
//    }
//    
//    else  {
//        
//        [cell.secondView removeFromSuperview];
//        [cell.mpercentLbl removeFromSuperview];
//        
//        [cell.firstView removeConstraint:cell.xConstFirstView];
//        
//        CGSize stringsize=[cell.firstV1stLbl.text sizeWithAttributes:
//                           @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
//        cell.firstView.center = CGPointMake(cell.containerView.bounds.size.width/2,cell.containerView.bounds.size.height/2);
//        
//        CGFloat strSize = stringsize.width+20;
//        
//        cell.widthConsFirstView.constant = strSize;
//        
//        //        CGSize stringsize=[cell.secondV1stLbl.text sizeWithAttributes:
//        //                           @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
//        //
//        //        CGSize stringsize2 = [cell.firstV1stLbl.text sizeWithAttributes:
//        //                              @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
//        //        CGFloat strSize2 = stringsize2.width+20;
//        //
//        //        cell.widthConsFirstView.constant = strSize2;
//        //        CGFloat strSize = stringsize.width+20;
//        //
//        //        cell.widthConsSecondView.constant = strSize;
//        //
//        //        NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:cell.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//        //                [cell.contentView addConstraint:xCenterConstraint];
//        
//    }
    

    
    if (model.secondArrayCount > 0 ) {//(row == 0|| row == 1|| row == 2|| row==3 || row==4|| row==5|| row==6|| row==7|| row==8){
        
        PT_AutoPressTableViewCell *cell =  (PT_AutoPressTableViewCell *)[self.tableautoPress dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        
        cell.firstView.layer.cornerRadius = 10.0f;
        cell.firstView.clipsToBounds = YES;
        cell.secondView.layer.cornerRadius = 10.0f;
        cell.secondView.clipsToBounds = YES;
        
        
        cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableautoPress.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        cell.holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)model.hole_number];

        
        cell.secondView.hidden = NO;
            cell.mpercentLbl.hidden = NO;
        
        NSMutableAttributedString* message = [[NSMutableAttributedString alloc] init];
        
        
        for (int i =0; i<model.arrFirst.count; i++) {
            
            
            NSString *str = [NSString stringWithFormat:@"%@ ",[model.arrFirst objectAtIndex:i]];
            
            [message appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14],
                                                                                                         NSForegroundColorAttributeName : [self colorWithHexString:[model.arrFirstColor objectAtIndex:i]]
                                                                                                         }]];
            NSLog(@"%@",message);
            
            
            
        }
        cell.firstV1stLbl.attributedText = message;
        
        
        NSMutableAttributedString* secondMessage = [[NSMutableAttributedString alloc] init];
        
        
        for (int i =0; i<model.arrSecond.count; i++) {
            
            
            NSString *str = [NSString stringWithFormat:@"%@ ",[model.arrSecond objectAtIndex:i]];
            
            [secondMessage appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14],
                                                                                                               NSForegroundColorAttributeName : [self colorWithHexString:[model.arrSecondColor objectAtIndex:i]]
                                                                                                               }]];
            NSLog(@"%@",secondMessage);
            
            
            
        }
        cell.secondV1stLbl.attributedText = secondMessage;
        
        CGSize stringsize=[cell.secondV1stLbl.text sizeWithAttributes:
                           @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
        
        CGSize stringsize2 = [cell.firstV1stLbl.text sizeWithAttributes:
                              @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
        CGFloat strSize2 = stringsize2.width+20;
        
        cell.widthConsFirstView.constant = strSize2;
        CGFloat strSize = stringsize.width+20;
        
        cell.widthConsSecondView.constant = strSize;
        
        return cell;

        
  }
        else{
        
    PT_AutopressSecTableViewCell *cell =  (PT_AutopressSecTableViewCell *)[self.tableautoPress dequeueReusableCellWithIdentifier:pPrdoduc forIndexPath:indexPath];
        
       // [cell.secondView setHidden:YES];
        //[cell.mpercentLbl setHidden:YES];
        
        cell.firstView.layer.cornerRadius = 10.0f;
        cell.firstView.clipsToBounds = YES;
        
        
        
        cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableautoPress.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)model.hole_number];
        
        NSMutableAttributedString* message = [[NSMutableAttributedString alloc] init];
        
        for (int i =0; i<model.arrFirst.count; i++) {
            
            
            NSString *str = [NSString stringWithFormat:@"%@ ",[model.arrFirst objectAtIndex:i]];
            //set text
            [message appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14],
                                                                                                        NSForegroundColorAttributeName : [self colorWithHexString:[model.arrFirstColor objectAtIndex:i]]
                                                                                                        }]];
            NSLog(@"%@",message);
            
            
            
            
            
        }
        
        cell.firstV1stLbl.attributedText = message;
        CGSize stringsize=[cell.firstV1stLbl.text sizeWithAttributes:
                           @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12.0f]}];
        //cell.firstView.center = cell.containerView.center;
        
        CGFloat strSize = stringsize.width+20;
        cell.widthConsFirstView.constant = strSize;

        
        return cell;

        
        
       
        
           }
    }


//Mark:-Converting hex String To Rgb
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


//Mark:-Header for tableview

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 40, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setTextColor:[UIColor whiteColor]];
    
    NSString *string = @"HOLE";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenHeight = screenRect.size.height;
    
    if (screenHeight == 568) {
        
        UILabel *holeScore = [[UILabel alloc] initWithFrame:CGRectMake(152, 20, 150, 18)];
        [holeScore setFont:[UIFont boldSystemFontOfSize:14]];
        [holeScore setTextColor:[UIColor whiteColor]];
        
        NSString *string2 = @"SCORE";
        /* Section header is in 0th index... */
        [holeScore setText:string2];
        
        [view addSubview:holeScore];
        UIButton *closebutton = [[UIButton alloc] initWithFrame:CGRectMake(295, 15, 18, 18)];
        //    [closebutton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *closeoverlapBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 0, 30, 35)];
        [closeoverlapBtn addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [closeoverlapBtn setTintColor:[UIColor clearColor]];
        [closebutton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        [view addSubview:closebutton];
        [view addSubview:closeoverlapBtn];


    }else{
        
        UILabel *holeScore = [[UILabel alloc] initWithFrame:CGRectMake(180, 20, 150, 18)];
        [holeScore setFont:[UIFont boldSystemFontOfSize:14]];
        [holeScore setTextColor:[UIColor whiteColor]];
        NSString *string2 = @"SCORE";
        /* Section header is in 0th index... */
        [holeScore setText:string2];
        
        [view addSubview:holeScore];
        UIButton *closebutton = [[UIButton alloc] initWithFrame:CGRectMake(350, 15, 18, 18)];
        //    [closebutton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *closeoverlapBtn = [[UIButton alloc] initWithFrame:CGRectMake(350, 0, 30, 35)];
        [closeoverlapBtn addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [closeoverlapBtn setTintColor:[UIColor clearColor]];
        [closebutton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        [view addSubview:closebutton];
        [view addSubview:closeoverlapBtn];


    }
    
    
            [view setBackgroundColor:[UIColor colorWithRed:8/255.0 green:77/255.0 blue:131/255.0 alpha:1.0]];
    //self.table420format.tableHeaderView = view;
    //your background color...
    return view;
}

-(void)closeTapped:(UIButton *)sender
{
    [self hideview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}

@end
