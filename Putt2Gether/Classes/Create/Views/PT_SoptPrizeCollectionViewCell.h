//
//  PT_SoptPrizeCollectionViewCell.h
//  Putt2Gether
//
//  Created by Devashis on 27/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_SoptPrizeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (assign, atomic) BOOL isSelected;

@end
