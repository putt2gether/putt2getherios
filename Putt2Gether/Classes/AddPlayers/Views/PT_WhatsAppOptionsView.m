//
//  PT_WhatsAppOptionsView.m
//  Putt2Gether
//
//  Created by Devashis on 20/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "PT_WhatsAppOptionsView.h"

@interface PT_WhatsAppOptionsView ()

@property(strong,nonatomic) NSString *urlsTring;


@end

@implementation PT_WhatsAppOptionsView

-(IBAction)actionWhatsapp:(id)sender{
    
    
    [self stringToSend];
    
    
}

-(void)stringToSend
{
    
    PT_SelectGolfCourseModel *model = [[PT_PreviewEventSingletonModel sharedPreviewEvent] getGolfCourse];
    
    
    _urlsTring  = [NSString stringWithFormat:@"Hi! I’m inviting you to a golf event "];
    
    NSString *st1 = [NSString stringWithFormat:@" '%@' ",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventName]];
    
    
    NSString *str = [_urlsTring stringByAppendingString:st1];
    
    NSString *str1 = [NSString stringWithFormat:@" at "];
    
    NSString *st3 = [NSString stringWithFormat:@" '%@' ",model.golfCourseName];
    
    NSString *str2 = [str1 stringByAppendingString:st3];
    
    // NSString *st4 = [NSString stringWithFormat:@" '%@' ",str];
    
    
    NSString *mainStr = [str stringByAppendingString:str2];
    
    NSString*strfir = [mainStr stringByAppendingString:@" using the putt2gether app."];
    
    NSString *textStr = @"Follow these 3 STEPS to join the event.";
    
    NSString *str3 = @"1: Download putt2gether";
    NSString *str4 = @"https://appsto.re/in/rloW7.i";
    NSString*str5 = @"https://play.google.com/store/apps/details?id=com.putt2gether";
    
    NSString *str6 = @"2: Go to 'Request to Participate' under Invites section";
    
    
    NSString*txt = [NSString stringWithFormat:@"%@\n\n %@ \n\n %@ \n\n %@ \n\n %@ \n\n %@",strfir,textStr,str3,str4,str5,str6];
    
    //NSString *urlStr = [mainStr stringByAppendingString:textStr];
    
    NSString *str7 = [NSString stringWithFormat:@"3: Select '%@'",model.golfCourseName];
    NSString *str8 = [NSString stringWithFormat:@", Select '%@'",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventTime]];
    
    NSString *str9 = [NSString stringWithFormat:@", select '%@'",[[PT_PreviewEventSingletonModel sharedPreviewEvent] getEventName]];
    
    NSString*str10 = @" and send the request to join the event.";
    NSString *str11 = @"Thanks";
    
    NSString *txt2m = [NSString stringWithFormat:@"%@%@%@%@ \n\n%@",str7,str8,str9,str10,str11];
    
    NSString *mainString = [NSString stringWithFormat:@"%@ \n\n %@",txt,txt2m];
    NSLog(@"%@",mainString);
    
    
    
    //    mainString = [mainString stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    //        mainString = [mainString stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    //        mainString = [mainString stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    //        mainString = [mainString stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    //        mainString = [mainString stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    
    mainString =    (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) mainString, NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    
    
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",mainString];
    
    NSURL * whatsappURL = [NSURL URLWithString: urlWhats];//[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        //        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Whatsapp!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[warningAlert show];
    }
    
    //
    
}



@end
