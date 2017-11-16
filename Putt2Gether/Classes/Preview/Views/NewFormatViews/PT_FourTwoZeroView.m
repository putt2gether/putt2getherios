//
//  PT_FourTwoZeroView.m
//  Putt2Gether
//
//  Created by Nivesh on 01/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_FourTwoZeroView.h"

#import "PT_FourTwoZeroTableViewCell.h"

#import "PT_420Formatmodel.h"

#define kProductCellIdentifier @"CellIdentifier"


@interface PT_FourTwoZeroView ()<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) NSArray *arrTable420Format;

@property (weak, nonatomic) IBOutlet UITableView *table420format;

@property(strong,nonatomic) IBOutlet NSLayoutConstraint *tableYpos;

@property(weak,nonatomic) IBOutlet UIView *fadedView;

@end


@implementation PT_FourTwoZeroView

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
    UINib *nib = [UINib nibWithNibName:@"PT_FourTwoZeroTableViewCell" bundle: nil];
    [self.table420format  registerNib:nib forCellReuseIdentifier:kProductCellIdentifier];
    
    [self.table420format setDataSource:self];
    [self.table420format setDelegate:self];
    
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


-(void)loadDatawithArray:(NSMutableArray *)array
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.arrTable420Format = [[NSArray alloc] initWithArray:array];
        //Mark:-for Y postion of
        CGFloat tableYpostion = 35.0f;
        for (int i = 0; i < [array count]; i ++) {
            tableYpostion += [self tableView:self.table420format heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
       
        }
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        int screenHeight    = screenRect.size.height;
       
        CGFloat tableviewHeight = screenHeight - tableYpostion;
        
        self.tableYpos.constant = tableviewHeight;
        _table420format.scrollEnabled = NO;

        if (tableYpostion > screenHeight) {
            
            self.tableYpos.constant = 0;
            _table420format.scrollEnabled = YES;

        }
//        self.table420format.frame = CGRectMake(self.table420format.frame.origin.x,tableviewHeight, self.table420format.frame.size.width, tableYpostion);

        /*self.tableLeaderboard.layer.borderWidth = 1.0;
         self.tableLeaderboard.layer.borderColor = [[UIColor darkGrayColor] CGColor];
         self.tableLeaderboard.layer.cornerRadius = 2.0;
         self.tableLeaderboard.layer.masksToBounds = YES;
         */
        [self.table420format reloadData];
    });

    
}





#pragma mark - TableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTable420Format count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PT_FourTwoZeroTableViewCell *cell =  (PT_FourTwoZeroTableViewCell *)[self.table420format dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
    
    
        
        
        cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.table420format.separatorStyle = UITableViewCellSeparatorStyleNone;

    
        PT_420Formatmodel *modelFormat = self.arrTable420Format[indexPath.row];
    
    cell.firstView.layer.cornerRadius = 10.0f;
    cell.firstView.clipsToBounds = YES;
    cell.secondView.layer.cornerRadius = 10.0f;
    cell.secondView.clipsToBounds = YES;
    
    
    cell.holenumberLabel.textColor = [UIColor whiteColor];
        cell.holenumberLabel.text =[NSString stringWithFormat:@"%ld", (long)modelFormat.hole_number];
    
    //Mark:-for firstView
    
        cell.firstVFirstLabel.text =[NSString stringWithFormat:@"%@",[modelFormat.arrFirst objectAtIndex:0]];
    cell.firstVSecondLabel.text =[NSString stringWithFormat:@"%@",[modelFormat.arrFirst objectAtIndex:1]];
    cell.firstVThirdLabel.text =[NSString stringWithFormat:@"%@",[modelFormat.arrFirst objectAtIndex:2]];
         [cell.firstVFirstLabel setTextColor:[self colorWithHexString:[modelFormat.arrFirstColor objectAtIndex:0]]];
    [cell.firstVSecondLabel setTextColor:[self colorWithHexString:[modelFormat.arrFirstColor objectAtIndex:1]]];
    [cell.firstVThirdLabel setTextColor:[self colorWithHexString:[modelFormat.arrFirstColor objectAtIndex:2]]];
    
    //Mark:-for Second View
    cell.secondVFirstLabel.text =[NSString stringWithFormat:@"%@",[modelFormat.arrSecond objectAtIndex:0]];
    cell.secondVSecondLabel.text =[NSString stringWithFormat:@"%@",[modelFormat.arrSecond objectAtIndex:1]];
    cell.secondVThirdLabel.text =[NSString stringWithFormat:@"%@",[modelFormat.arrSecond objectAtIndex:2]];
    [cell.secondVFirstLabel setTextColor:[self colorWithHexString:[modelFormat.arrSecondColor objectAtIndex:0]]];
    [cell.secondVSecondLabel setTextColor:[self colorWithHexString:[modelFormat.arrSecondColor objectAtIndex:1]]];
    [cell.secondVThirdLabel setTextColor:[self colorWithHexString:[modelFormat.arrSecondColor objectAtIndex:2]]];
    
    
    
    return cell;
}
//Mark:-Converting Hexcode to string
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
        
        UILabel *holeScore = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 150, 18)];
        [holeScore setFont:[UIFont boldSystemFontOfSize:14]];
        [holeScore setTextColor:[UIColor whiteColor]];
        
        NSString *string2 = @"HOLE SCORE";
        /* Section header is in 0th index... */
        [holeScore setText:string2];
        
        [view addSubview:holeScore];
        
        //Mark:-for third Label
        UILabel *aggScore = [[UILabel alloc] initWithFrame:CGRectMake(210, 20, 200, 18)];
        [aggScore setFont:[UIFont boldSystemFontOfSize:14]];
        [aggScore setTextColor:[UIColor whiteColor]];
        
        NSString *string3 = @"AGG. SCORE";
        /* Section header is in 0th index... */
        [aggScore setText:string3];
        
        [view addSubview:aggScore];
        
        UIButton *closebutton = [[UIButton alloc] initWithFrame:CGRectMake(295, 15, 18, 18)];
        [closebutton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [closebutton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        UIButton *closeoverlapBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 0, 30, 35)];
        [closeoverlapBtn addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [closeoverlapBtn setTintColor:[UIColor clearColor]];
        
        [view addSubview:closeoverlapBtn];
        [view addSubview:closebutton];
        
    }else{
    UILabel *holeScore = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 150, 18)];
    [holeScore setFont:[UIFont boldSystemFontOfSize:14]];
    [holeScore setTextColor:[UIColor whiteColor]];
    
    NSString *string2 = @"HOLE SCORE";
    /* Section header is in 0th index... */
    [holeScore setText:string2];

    [view addSubview:holeScore];
    
    //Mark:-for third Label
    UILabel *aggScore = [[UILabel alloc] initWithFrame:CGRectMake(255, 20, 200, 18)];
    [aggScore setFont:[UIFont boldSystemFontOfSize:14]];
    [aggScore setTextColor:[UIColor whiteColor]];
    
    NSString *string3 = @"AGG. SCORE";
    /* Section header is in 0th index... */
    [aggScore setText:string3];
    
    [view addSubview:aggScore];
    
    UIButton *closebutton = [[UIButton alloc] initWithFrame:CGRectMake(350, 15, 18, 18)];
    [closebutton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [closebutton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];

        UIButton *closeoverlapBtn = [[UIButton alloc] initWithFrame:CGRectMake(340, 0, 30, 35)];
        [closeoverlapBtn addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [closeoverlapBtn setTintColor:[UIColor clearColor]];
        
        [view addSubview:closeoverlapBtn];
    [view addSubview:closebutton];
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
