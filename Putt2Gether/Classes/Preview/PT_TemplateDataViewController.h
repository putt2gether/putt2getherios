//
//  PT_TemplateDataViewController.h
//  Putt2Gether
//
//  Created by Nivesh on 25/06/17.
//  Copyright © 2017 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PT_TemplateDataViewController : UIViewController

@property(weak,nonatomic) IBOutlet UIWebView *webView;

- (instancetype)initWithEvent:(PT_CreatedEventModel *)model;


@end
