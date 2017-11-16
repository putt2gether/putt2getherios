//
//  PT_StartEventTableViewCell.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PT_StartEventTableViewCellDelegate <NSObject>
@end
@interface PT_StartEventTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
- (IBAction)actionWinner:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *winnerBtn;
//@property (weak, nonatomic) id <PT_StartEventTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;
@property (weak, nonatomic) IBOutlet UIButton *andLabel;
@property (weak, nonatomic) IBOutlet UILabel *value4Label;



@end
