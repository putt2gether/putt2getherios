//
//  PT_ParticipantsTableViewCell.m
//  Putt2Gether
//
//  Created by Devashis on 09/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_ParticipantsTableViewCell.h"

@implementation PT_ParticipantsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDefaultUIProperties
{
   dispatch_async(dispatch_get_main_queue(), ^{
       UIColor *blueBGColor = [UIColor colorWithRed:(11/255.0f) green:(51/255.0f) blue:(96/255.0f) alpha:1.0];
       self.buttonView.backgroundColor = blueBGColor ;
       
       
       
       //self.handicapText.layer.borderColor = [blueBGColor CGColor];
       self.handicapText.layer.borderWidth = 1.0;
      // self.handicapText.layer.cornerRadius = self.handicapText.frame.size.width/2;
       //self.handicapText.layer.masksToBounds = YES;
       
       self.status.textColor = [UIColor whiteColor];
       self.editHandicapLabel.textColor = [UIColor whiteColor];
       //self.handicapText.background = [UIColor whiteColor];
       self.handicapText.hidden = NO;
       self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
       self.userImageView.clipsToBounds = YES;
       //self.editHandicapButton.layer.borderColor = [blueBGColor CGColor];
       //self.editHandicapButton.layer.borderWidth = 1.0;
     //  self.editHandicapButton.layer.cornerRadius = 4.0;
       //self.editHandicapButton.layer.masksToBounds = YES;
       
       self.saveButton.layer.borderWidth = 1.0;
       self.saveButton.layer.borderColor = [[UIColor clearColor] CGColor];
       self.saveButton.layer.cornerRadius = 4.0;
       self.saveButton.layer.masksToBounds = YES;
       
       [self.handicapText bringToFront];
   });
   
}

@end
