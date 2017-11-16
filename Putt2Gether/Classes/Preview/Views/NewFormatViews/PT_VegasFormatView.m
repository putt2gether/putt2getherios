//
//  PT_VegasFormatView.m
//  Putt2Gether
//
//  Created by Nivesh on 02/03/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_VegasFormatView.h"

#import "PT_Front9Model.h"

#import "PT_VegasTableViewCell.h"


#define kProductCellIdentifier @"CellIdentifier"



@interface PT_VegasFormatView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *arrtableVegas;

@property (weak, nonatomic) IBOutlet UITableView *tableVegasformat;

@property(strong,nonatomic) IBOutlet NSLayoutConstraint *tableYpos;

@property(weak,nonatomic) IBOutlet UIView *fadedView;

@end


@implementation PT_VegasFormatView

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
    UINib *nib = [UINib nibWithNibName:@"PT_VegasTableViewCell" bundle: nil];
    [self.tableVegasformat  registerNib:nib forCellReuseIdentifier:kProductCellIdentifier];
    
    [self.tableVegasformat setDataSource:self];
    [self.tableVegasformat setDelegate:self];
    
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
        
        
        self.arrtableVegas = [[NSArray alloc] initWithArray:array];
        //Mark:-for Y postion of
        CGFloat tableYpostion = 35.0f;
        for (int i = 0; i < [array count]; i ++) {
            tableYpostion += [self tableView:self.tableVegasformat heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            
        }
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        int screenHeight    = screenRect.size.height;
        
        CGFloat tableviewHeight = screenHeight - tableYpostion;
        
        self.tableYpos.constant = tableviewHeight;
        _tableVegasformat.scrollEnabled = NO;
        if (tableYpostion > screenHeight) {
            
            self.tableYpos.constant = 0;
            _tableVegasformat.scrollEnabled = YES;

        }
        //        self.table420format.frame = CGRectMake(self.table420format.frame.origin.x,tableviewHeight, self.table420format.frame.size.width, tableYpostion);
        
        /*self.tableLeaderboard.layer.borderWidth = 1.0;
         self.tableLeaderboard.layer.borderColor = [[UIColor darkGrayColor] CGColor];
         self.tableLeaderboard.layer.cornerRadius = 2.0;
         self.tableLeaderboard.layer.masksToBounds = YES;
         */
        [self.tableVegasformat reloadData];
    });
    
    
}
#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrtableVegas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PT_VegasTableViewCell *cell =  (PT_VegasTableViewCell *)[self.tableVegasformat dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
    
    
    
    
    cell.backgroundColor = [UIColor colorWithRed:11/255.0 green:90/255.0 blue:151/255.0 alpha:1];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableVegasformat.separatorStyle = UITableViewCellSeparatorStyleNone;

    PT_Front9Model *modelFormat = self.arrtableVegas[indexPath.row];
    
    cell.firstView.layer.cornerRadius = 10.0f;
    cell.firstView.clipsToBounds = YES;
    cell.seccondView.layer.cornerRadius = 10.0f;
    cell.seccondView.clipsToBounds = YES;
    
    
    cell.holeNumberLabel.textColor = [UIColor whiteColor];
    cell.holeNumberLabel.text = [NSString stringWithFormat:@"%li",(long)modelFormat.holeNumber];
    
    //Mark:-for firstView
    
    cell.firstVlabel.text = modelFormat.holeScore;
    cell.firstVlabel.textColor = [UIColor whiteColor];
    [cell.firstView setBackgroundColor:[self colorWithHexString:modelFormat.colorhole]];
    
    //Mark:-for Second View
    cell.secondVlabel.text = modelFormat.aggScore;
    cell.secondVlabel.textColor = [UIColor whiteColor];

    [cell.seccondView setBackgroundColor:[self colorWithHexString:modelFormat.color]];

    
    
    
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
        
        UILabel *holeScore = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 150, 18)];
        [holeScore setFont:[UIFont boldSystemFontOfSize:14]];
        [holeScore setTextColor:[UIColor whiteColor]];
        
        NSString *string2 = @"HOLE SCORE";
        /* Section header is in 0th index... */
        [holeScore setText:string2];
        
        [view addSubview:holeScore];
        
        //Mark:-for third Label
        UILabel *aggScore = [[UILabel alloc] initWithFrame:CGRectMake(198, 20, 200, 18)];
        [aggScore setFont:[UIFont boldSystemFontOfSize:14]];
        [aggScore setTextColor:[UIColor whiteColor]];
        
        NSString *string3 = @"AGG. SCORE";
        /* Section header is in 0th index... */
        [aggScore setText:string3];
        
        [view addSubview:aggScore];
        
        UIButton *closebutton = [[UIButton alloc] initWithFrame:CGRectMake(295, 15, 18, 18)];
        [closebutton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [closebutton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        [view addSubview:closebutton];
        
        UIButton *closeoverlapBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 0, 30, 35)];
        [closeoverlapBtn addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
        [closeoverlapBtn setTintColor:[UIColor clearColor]];
        
        [view addSubview:closeoverlapBtn];


        
    }else{
    
    UILabel *holeScore = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 150, 18)];
    [holeScore setFont:[UIFont boldSystemFontOfSize:14]];
    [holeScore setTextColor:[UIColor whiteColor]];
    
    NSString *string2 = @"HOLE SCORE";
    /* Section header is in 0th index... */
    [holeScore setText:string2];
    
    [view addSubview:holeScore];
    
    //Mark:-for third Label
    UILabel *aggScore = [[UILabel alloc] initWithFrame:CGRectMake(285, 20, 200, 18)];
    [aggScore setFont:[UIFont boldSystemFontOfSize:14]];
    [aggScore setTextColor:[UIColor whiteColor]];
    
    NSString *string3 = @"AGG. SCORE";
    /* Section header is in 0th index... */
    [aggScore setText:string3];
    
    [view addSubview:aggScore];
    
    UIButton *closebutton = [[UIButton alloc] initWithFrame:CGRectMake(380, 15, 18, 18)];
    [closebutton addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [closebutton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        UIButton *closeoverlapBtn = [[UIButton alloc] initWithFrame:CGRectMake(370, 0, 30, 35)];
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
