//
//  CustomCell.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 23/08/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property(strong,nonatomic)IBOutlet UILabel *eventNameLabel;
@property(strong,nonatomic)IBOutlet UILabel *timeLabel;
@property(strong,nonatomic)IBOutlet UILabel *dateLabel;

@property(strong,nonatomic)IBOutlet UILabel *adminLabel;

@property(strong,nonatomic)IBOutlet UILabel *venueLabel;

@property(strong,nonatomic)IBOutlet UILabel *adminNameLabel;
@property(strong,nonatomic)IBOutlet UILabel *venueNameLabel;
@property(strong,nonatomic) IBOutlet CustomCell *customCell;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)editBtnClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *declineButton;
- (IBAction)declineBtnClicked:(id)sender;
- (IBAction)accptBtnClicked:(id)sender;


@property(strong,nonatomic) IBOutlet UIImageView *timeImageview;
@property(strong,nonatomic) IBOutlet UIImageView *dateImageview;


@property (strong, nonatomic) IBOutlet UIButton *accptButton,*bannerBtn;


@property(strong,nonatomic) IBOutlet UIImageView *bannerImg;




@end
