//
//  PT_StartEventTableView.h
//  Putt2Gether
//
//  Created by Nitin Chauhan on 05/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SplFormatLeadershipTableViewCell.h"


//@protocol PT_StartEventTableViewDelegate <NSObject>
//@end

@interface PT_StartEventTableView : UIView
{
    NSArray *arrSection;
    NSArray *arrvalues3;
    NSArray *arrvalues4;
}

//@property (weak, nonatomic) id <PT_StartEventTableViewDelegate> delegate;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) IBOutlet UIView *backgroundView;
-(IBAction)actioncloseBtn:(id)sender;

- (void)loadTableViewWithData:(NSMutableArray *)dataArray;


@end
