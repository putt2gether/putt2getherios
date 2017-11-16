//
//  PT_SelectHoleCollectionViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 07/12/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_SelectHoleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *holeLabel;

@property (weak, nonatomic) IBOutlet UIView *selectedHoleButton;

@property (weak, nonatomic) IBOutlet UIButton *bgButton;

@end
