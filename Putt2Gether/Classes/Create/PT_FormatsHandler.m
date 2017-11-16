//
//  PT_FormatsHandler.m
//  Putt2Gether
//
//  Created by Devashis on 22/04/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import "PT_FormatsHandler.h"

@implementation PT_FormatsHandler

- (NSMutableArray *)get1PlayerFormats
{
    NSMutableArray *arrFormats = [NSMutableArray new];
    PT_StrokePlayListItemModel *model1 = [PT_StrokePlayListItemModel new];
    
    model1.strokeName = @"GROSS STROKEPLAY";
    model1.strokeId = 2;
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"In Gross Strokeplay, total number of strokes taken on each hole without adjusting your handicap is counted. The leaderboard shows the deviation of your score against the par score of the course."];
    model1.descriptionText = text1;
    
    [arrFormats addObject:model1];
    
    PT_StrokePlayListItemModel *model2 = [PT_StrokePlayListItemModel new];
    
    model2.strokeName = @"GROSS STABLEFORD";
    model2.strokeId = 5;
    
    //Bold The String
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"In Gross Stableford, points are awarded to you without adjusting your handicap in relation to your par. The scoring is as follows: \n\nAlbatross -> +5 , Eagle -> +4 , Birdie -> +3 , Par -> +2 , Bogey -> +1 , Double Bogey onwards -> 0"];
    [text addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:12]
                 range:NSMakeRange(47, 31)];
    
    model2.descriptionText = text;
    
    [arrFormats addObject:model2];
    
    return arrFormats;
}

- (NSMutableArray *)get2PlayerFormats
{
    NSMutableArray *arrFormats = [NSMutableArray new];
    
    PT_StrokePlayListItemModel *model1 = [PT_StrokePlayListItemModel new];
    model1.strokeName = @"MATCHPLAY";
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"In match play, two players (or two teams) play every hole as a separate contest against each other. The party with the lower score wins that hole. If the scores of both players or teams are equal the hole is “halved” (drawn). The game is won by that party that wins more holes than the other."];
    model1.descriptionText = text1;
    model1.strokeId = 10;
    [arrFormats addObject:model1];
    
    PT_StrokePlayListItemModel *model2 = [PT_StrokePlayListItemModel new];
    model2.strokeName = @"AUTOPRESS";
    model2.strokeId = 11;
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:@"Auto Press or Press Repress or Nassau Scoring is a variation of Match play scoring. The scoring is done for each of the 9 holes called Halves and for the total 18 holes called the Match."];
    model2.descriptionText = text2;
    [arrFormats addObject:model2];
    
    PT_StrokePlayListItemModel *model3 = [PT_StrokePlayListItemModel new];
    model3.strokeName = @"GROSS STROKEPLAY";
    model3.strokeId = 2;
    NSMutableAttributedString *text3 = [[NSMutableAttributedString alloc] initWithString:@"In Gross Strokeplay, total number of strokes taken on each hole without adjusting your handicap is counted. The leaderboard shows the deviation of your score against the par score of the course."];

    model3.descriptionText = text3;
    [arrFormats addObject:model3];
    
    PT_StrokePlayListItemModel *model4 = [PT_StrokePlayListItemModel new];
    model4.strokeName = @"NET STROKEPLAY";
    model4.strokeId = 3;
    NSMutableAttributedString *text4 = [[NSMutableAttributedString alloc] initWithString:@"In Net Strokeplay, total number of strokes taken on each hole adjusting your full handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model4.descriptionText = text4;
    [arrFormats addObject:model4];
    
    PT_StrokePlayListItemModel *model5 = [PT_StrokePlayListItemModel new];
    model5.strokeName = @"3/4TH NET STROKEPLAY";
    model5.strokeId = 4;
    NSMutableAttributedString *text5 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Handicap Strokeplay, total number of strokes taken on each hole adjusting your 3/4th handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model5.descriptionText = text5;
    [arrFormats addObject:model5];
    
    PT_StrokePlayListItemModel *model6 = [PT_StrokePlayListItemModel new];
    model6.strokeName = @"GROSS STABLEFORD";
    model6.strokeId = 5;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"In Gross Stableford, points are awarded to you without adjusting your handicap in relation to your par. The scoring is as follows: \n\nAlbatross -> +5 , Eagle -> +4 , Birdie -> +3 , Par -> +2 , Bogey -> +1 , Double Bogey onwards -> 0"];
    [text addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:12]
                 range:NSMakeRange(47, 31)];
    
    model6.descriptionText = text;
    [arrFormats addObject:model6];
    
    PT_StrokePlayListItemModel *model7 = [PT_StrokePlayListItemModel new];
    model7.strokeName = @"NET STABLEFORD";
    model7.strokeId = 6;
    NSMutableAttributedString *text6 = [[NSMutableAttributedString alloc] initWithString:@"In Net Stableford, points are awarded to you by adjusting your full handicap in relation to your par. The scoring is as follows \n\nNet Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text6 addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:12]
                 range:NSMakeRange(48, 28)];
    model7.descriptionText = text6;
    [arrFormats addObject:model7];
    
    PT_StrokePlayListItemModel *model8 = [PT_StrokePlayListItemModel new];
    model8.strokeName = @"3/4th NET STABLEFORD";
    model8.strokeId = 7;
    NSMutableAttributedString *text7 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Net Stableford, points are awarded to you by adjusting your 3/4 th handicap in relation to your par. The scoring is as follows \n o Net Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text7 addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:12]
                  range:NSMakeRange(55, 31)];
    model8.descriptionText = text7;
    [arrFormats addObject:model8];
    
    return arrFormats;
}


- (NSMutableArray *)get3PlayerFormats
{
    NSMutableArray *arrFormats = [NSMutableArray new];
    
    PT_StrokePlayListItemModel *model1 = [PT_StrokePlayListItemModel new];
    model1.strokeName = @"4-2-0";
    model1.strokeId = 12;
    NSMutableAttributedString *text5 = [[NSMutableAttributedString alloc] initWithString:@"This format is staple scoring to a 3 ball game. Each hole carries a values of 6 points. These 6 points are distributed based on results for each hole (4 – 2 – 0, 3 – 3 – 0, 3 – 0 – 0, 0 – 0 – 0) The scores for all 18 holes are totaled to arrive at the final score."];
    model1.descriptionText = text5;
    [arrFormats addObject:model1];
    
    PT_StrokePlayListItemModel *model2 = [PT_StrokePlayListItemModel new];
    model2.strokeName = @"GROSS STROKEPLAY";
    model2.strokeId = 2;
    NSMutableAttributedString *text123 = [[NSMutableAttributedString alloc] initWithString:@"In Gross Strokeplay, total number of strokes taken on each hole without adjusting your handicap is counted. The leaderboard shows the deviation of your score against the par score of the course."];
    model2.descriptionText = text123;
    [arrFormats addObject:model2];
    
    PT_StrokePlayListItemModel *model3 = [PT_StrokePlayListItemModel new];
    model3.strokeName = @"NET STROKEPLAY";
    model3.strokeId = 3;
    NSMutableAttributedString *text8 = [[NSMutableAttributedString alloc] initWithString:@"In Net Strokeplay, total number of strokes taken on each hole adjusting your full handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model3.descriptionText = text8;
    [arrFormats addObject:model3];
    
    PT_StrokePlayListItemModel *model4 = [PT_StrokePlayListItemModel new];
    model4.strokeName = @"3/4th NET STROKEPLAY";
    model4.strokeId = 4;
    NSMutableAttributedString *text9 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Handicap Strokeplay, total number of strokes taken on each hole adjusting your 3/4th handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model4.descriptionText = text9;
    [arrFormats addObject:model4];
    
    PT_StrokePlayListItemModel *model5 = [PT_StrokePlayListItemModel new];
    model5.strokeName = @"GROSS STABLEFORD";
    model5.strokeId = 5;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"In Gross Stableford, points are awarded to you without adjusting your handicap in relation to your par. The scoring is as follows: \n\nAlbatross -> +5 , Eagle -> +4 , Birdie -> +3 , Par -> +2 , Bogey -> +1 , Double Bogey onwards -> 0"];
    [text addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:12]
                 range:NSMakeRange(47, 31)];
    
    model5.descriptionText = text;

    [arrFormats addObject:model5];
    
    PT_StrokePlayListItemModel *model6 = [PT_StrokePlayListItemModel new];
    model6.strokeName = @"NET STABLEFORD";
    model6.strokeId = 6;
    NSMutableAttributedString *text6 = [[NSMutableAttributedString alloc] initWithString:@"In Net Stableford, points are awarded to you by adjusting your full handicap in relation to your par. The scoring is as follows \n\nNet Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text6 addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:12]
                  range:NSMakeRange(48, 28)];
    model6.descriptionText = text6;
    [arrFormats addObject:model6];
    
    PT_StrokePlayListItemModel *model7 = [PT_StrokePlayListItemModel new];
    model7.strokeName = @"3/4th NET STABLEFORD";
    model7.strokeId = 7;
    NSMutableAttributedString *text7 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Net Stableford, points are awarded to you by adjusting your 3/4 th handicap in relation to your par. The scoring is as follows \n o Net Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text7 addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:12]
                  range:NSMakeRange(55, 31)];
    model7.descriptionText = text7;

    [arrFormats addObject:model7];
    
    
    
    return arrFormats;
}

- (NSMutableArray *)get4PlayerNoTeamFormats
{
    NSMutableArray *arrFormats = [NSMutableArray new];
    
    PT_StrokePlayListItemModel *model1 = [PT_StrokePlayListItemModel new];
    model1.strokeName = @"GROSS STROKEPLAY";
    model1.strokeId = 2;
    NSMutableAttributedString *text123 = [[NSMutableAttributedString alloc] initWithString:@"In Gross Strokeplay, total number of strokes taken on each hole without adjusting your handicap is counted. The leaderboard shows the deviation of your score against the par score of the course."];
    model1.descriptionText = text123;
    
    [arrFormats addObject:model1];
    
    PT_StrokePlayListItemModel *model2 = [PT_StrokePlayListItemModel new];
    model2.strokeName = @"NET STROKEPLAY";
    model2.strokeId = 3;
    NSMutableAttributedString *text8 = [[NSMutableAttributedString alloc] initWithString:@"In Net Strokeplay, total number of strokes taken on each hole adjusting your full handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model2.descriptionText = text8;
    [arrFormats addObject:model2];
    
    PT_StrokePlayListItemModel *model3 = [PT_StrokePlayListItemModel new];
    model3.strokeName = @"3/4th NET STROKEPLAY";
    model3.strokeId = 4;
    NSMutableAttributedString *text9 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Handicap Strokeplay, total number of strokes taken on each hole adjusting your 3/4th handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model3.descriptionText = text9;
    [arrFormats addObject:model3];
    
    PT_StrokePlayListItemModel *model4 = [PT_StrokePlayListItemModel new];
    model4.strokeName = @"GROSS STABLEFORD";
    model4.strokeId = 5;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"In Gross Stableford, points are awarded to you without adjusting your handicap in relation to your par. The scoring is as follows: \n\nAlbatross -> +5 , Eagle -> +4 , Birdie -> +3 , Par -> +2 , Bogey -> +1 , Double Bogey onwards -> 0"];
    [text addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:12]
                 range:NSMakeRange(47, 31)];
    
    model4.descriptionText = text;
    [arrFormats addObject:model4];
    
    PT_StrokePlayListItemModel *model5 = [PT_StrokePlayListItemModel new];
    model5.strokeName = @"NET STABLEFORD";
    model5.strokeId = 6;
    NSMutableAttributedString *text6 = [[NSMutableAttributedString alloc] initWithString:@"In Net Stableford, points are awarded to you by adjusting your full handicap in relation to your par. The scoring is as follows \n\nNet Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text6 addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:12]
                  range:NSMakeRange(48, 28)];
    model5.descriptionText = text6;

    [arrFormats addObject:model5];
    
    PT_StrokePlayListItemModel *model6 = [PT_StrokePlayListItemModel new];
    model6.strokeName = @"3/4th NET STABLEFORD";
    model6.strokeId = 7;
    NSMutableAttributedString *text7 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Net Stableford, points are awarded to you by adjusting your 3/4 th handicap in relation to your par. The scoring is as follows \n o Net Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text7 addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:12]
                  range:NSMakeRange(55, 31)];
    model6.descriptionText = text7;

    [arrFormats addObject:model6];
    
    return arrFormats;
}

- (NSMutableArray *)get4PlayerTeamFormats
{
    NSMutableArray *arrFormats = [NSMutableArray new];
    
    PT_StrokePlayListItemModel *model1 = [PT_StrokePlayListItemModel new];
    model1.strokeName = @"MATCHPLAY";
    model1.strokeId = 10;
    NSMutableAttributedString *text7 = [[NSMutableAttributedString alloc] initWithString:@"In match play, two players (or two teams) play every hole as a separate contest against each other. The party with the lower score wins that hole. If the scores of both players or teams are equal the hole is “halved” (drawn). The game is won by that party that wins more holes than the other."];
    model1.descriptionText = text7;
    [arrFormats addObject:model1];
    
    PT_StrokePlayListItemModel *model2 = [PT_StrokePlayListItemModel new];
    model2.strokeName = @"AUTOPRESS";
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"Auto Press or Press Repress or Nassau Scoring is a variation of Match play scoring. The scoring is done for each of the 9 holes called Halves and for the total 18 holes called the Match."];
    model2.descriptionText = text1;
    model2.strokeId = 11;
    [arrFormats addObject:model2];
    
    PT_StrokePlayListItemModel *model3 = [PT_StrokePlayListItemModel new];
    model3.strokeName = @"VEGAS";
    model3.strokeId = 13;
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:@"Vegas scoring is a gamblers delight. A variation of the match play (teams) this format takes into consideration the scores of both the players. The gross scores of the partners are paired to form a 2 digit score (i.e 44 if both players scored a par on a Par 4). Net of the team scores over 18 holes decides the winner."];
    model3.descriptionText = text2;
    [arrFormats addObject:model3];
    
    PT_StrokePlayListItemModel *model4 = [PT_StrokePlayListItemModel new];
    model4.strokeName = @"2-1";
    NSMutableAttributedString *text3 = [[NSMutableAttributedString alloc] initWithString:@"2-1 is a variation of the standard Match Play (teams). This formats takes into consideration scores of both players in the team. Each hole is worth 3 points, 2 points are won by the winner of the better ball and 1 point is won by the winner of the second ball."];
    model4.descriptionText = text3;
    model4.strokeId = 14;
    [arrFormats addObject:model4];
    
    return arrFormats;
}

- (NSMutableArray *)get4PlusFormats
{
    NSMutableArray *arrFormats = [NSMutableArray new];
    
    PT_StrokePlayListItemModel *model1 = [PT_StrokePlayListItemModel new];
    model1.strokeName = @"GROSS STROKEPLAY";
    model1.strokeId = 2;
    NSMutableAttributedString *text123 = [[NSMutableAttributedString alloc] initWithString:@"In Gross Strokeplay, total number of strokes taken on each hole without adjusting your handicap is counted. The leaderboard shows the deviation of your score against the par score of the course."];
    model1.descriptionText = text123;
    [arrFormats addObject:model1];
    
    PT_StrokePlayListItemModel *model2 = [PT_StrokePlayListItemModel new];
    model2.strokeName = @"NET STROKEPLAY";
    model2.strokeId = 3;
    NSMutableAttributedString *text8 = [[NSMutableAttributedString alloc] initWithString:@"In Net Strokeplay, total number of strokes taken on each hole adjusting your full handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model2.descriptionText = text8;
    [arrFormats addObject:model2];
    
    PT_StrokePlayListItemModel *model3 = [PT_StrokePlayListItemModel new];
    model3.strokeName = @"3/4 th NET STROKEPLAY";
    model3.strokeId = 4;
    NSMutableAttributedString *text9 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Handicap Strokeplay, total number of strokes taken on each hole adjusting your 3/4th handicap is counted. The leaderboard shows the deviation of your net score against the par score of the course."];
    model3.descriptionText = text9;
    [arrFormats addObject:model3];
    
    PT_StrokePlayListItemModel *model4 = [PT_StrokePlayListItemModel new];
    model4.strokeName = @"GROSS STABLEFORD";
    model4.strokeId = 5;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"In Gross Stableford, points are awarded to you without adjusting your handicap in relation to your par. The scoring is as follows: \n\nAlbatross -> +5 , Eagle -> +4 , Birdie -> +3 , Par -> +2 , Bogey -> +1 , Double Bogey onwards -> 0"];
    [text addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:12]
                 range:NSMakeRange(47, 31)];
    
    model4.descriptionText = text;

    [arrFormats addObject:model4];
    
    PT_StrokePlayListItemModel *model5 = [PT_StrokePlayListItemModel new];
    model5.strokeName = @"NET STABLEFORD";
    model5.strokeId = 6;
    NSMutableAttributedString *text6 = [[NSMutableAttributedString alloc] initWithString:@"In Net Stableford, points are awarded to you by adjusting your full handicap in relation to your par. The scoring is as follows \n\nNet Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text6 addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:12]
                  range:NSMakeRange(48, 28)];
    model5.descriptionText = text6;
    [arrFormats addObject:model5];
    
    PT_StrokePlayListItemModel *model6 = [PT_StrokePlayListItemModel new];
    model6.strokeName = @"3/4 th NET STABLEFORD";
    model6.strokeId = 7;
    NSMutableAttributedString *text7 = [[NSMutableAttributedString alloc] initWithString:@"In 3/4 th Net Stableford, points are awarded to you by adjusting your 3/4 th handicap in relation to your par. The scoring is as follows \n o Net Albatross -> +5 , Net Eagle -> +4 , Net Birdie -> +3 ,Net Par -> +2 , Net Bogey -> +1 ,Net Double Bogey onwards -> 0"];
    [text7 addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:12]
                  range:NSMakeRange(55, 31)];
    model6.descriptionText = text7;


    [arrFormats addObject:model6];
    
    return arrFormats;
}




@end
