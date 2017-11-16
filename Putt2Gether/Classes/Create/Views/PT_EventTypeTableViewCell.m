//
//  PT_EventTypeTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 17/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_EventTypeTableViewCell.h"

@implementation PT_EventTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)actionEventTypeSelectedForCell:(UIButton *)sender
{
    UIColor *blueBGColor = [UIColor colorWithRed:(6/255.0f) green:(68/255.0f) blue:(116/255.0f) alpha:1.0];
    UIColor *whiteBGColor = [UIColor whiteColor];
    switch (sender.tag) {
        case 0:
        {
            self.publicButton.backgroundColor = blueBGColor;
            [self.publicButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.privateButton.backgroundColor = whiteBGColor;
            self.privateButton.layer.borderColor = blueBGColor.CGColor;
            self.privateButton.titleLabel.textColor = blueBGColor;
            [self.parentVieController setEventTypeForPreviewevent:PUBLIC];
            if (self.parentVieController.isEditMode == YES)
            {
                [self.parentVieController updateEventTypeForUpdateEvent:PUBLIC];
            }
        
        }
            break;
        case 1:
        {
            self.privateButton.backgroundColor = blueBGColor;
            [self.privateButton setTitleColor:whiteBGColor forState:UIControlStateNormal];
            self.publicButton.backgroundColor = whiteBGColor;
            self.publicButton.layer.borderColor = blueBGColor.CGColor;
            self.publicButton.titleLabel.textColor = blueBGColor;
            [self.parentVieController setEventTypeForPreviewevent:PRIVATE];
            if (self.parentVieController.isEditMode == YES)
            {
                [self.parentVieController updateEventTypeForUpdateEvent:PRIVATE];
            }
        }
            break;
            
    }
}

@end
