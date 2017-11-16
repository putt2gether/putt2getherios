//
//  UITabBarController+Designing.m
//  MyGrid
//
//  Created by Devashis on 15/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "UITabBarController+Designing.h"

#import "PT_HomeViewController.h"

static NSString *TabHomeImage = @"stats";
static NSString *TabInviteImage = @"invite";
static NSString *TabCreateImage = @"create";
static NSString *TabNotificationImage = @"notification_white";
static NSString *TabMoreImage = @"more";


@implementation UITabBarController (Designing)


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
    
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    CGFloat tabBarHeight = self.tabBar.frame.size.height;
//   // [self setDefaultTabDesign];
//    CGRect frame = self.view.frame;
//    self.tabBar.frame = CGRectMake(0, frame.size.height - tabBarHeight, frame.size.width, tabBarHeight);
//}
//
//-(void)setDeisgnForOrientaion
//{
//    if (!self.tabBar) {
//        
//        CGFloat tabBarHeight = self.tabBar.frame.size.height;
//        // [self setDefaultTabDesign];
//        CGRect frame = self.view.frame;
//        self.tabBar.frame = CGRectMake(0, frame.size.height - tabBarHeight, frame.size.width, tabBarHeight);
//        [self setDefaultTabDesign];
//        
//    }
//   
//}


- (void)setDefaultTabDesign
{
    //[self.tabBar removeFromSuperview];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSInteger screenHeight = screenRect.size.height;
    float height = self.tabBar.frame.size.height;
   
    switch (screenHeight)
    {
            
        case 667:
        {
            //CGSize imageSize = [[UIImage imageNamed:TabHomeImage] size];
//            self.tabBar.frame = CGRectMake(self.view.frame.origin.x,
//                                           self.tabBar.frame.origin.y-5,
//                                           self.view.frame.size.width,
//                                           imageSize.height + 9);
            
            //height = 49; imageSize.height;
            
        }
            break;
            
        case 736:
        {
            
//            CGSize imageSize = [[UIImage imageNamed:TabHomeImage] size];
//            self.tabBar.frame = CGRectMake(self.view.frame.origin.x,
//                                           self.tabBar.frame.origin.y-5,
//                                           self.view.frame.size.width,
//                                           imageSize.height + 9);
            //height = imageSize.height;
            
        }
            break;
            
    }
    
//    if ( IDIOM == IPAD )
//    {
//        CGSize imageSize = [[UIImage imageNamed:TabHomeImage] size];
//        self.tabBar.frame = CGRectMake(self.view.frame.origin.x,
//                                       self.tabBar.frame.origin.y,
//                                       self.view.frame.size.width,
//                                       imageSize.height + 9);
//        height = imageSize.height;
//    }

    
    for (NSInteger count = 0; count < [self.viewControllers count]; count++)
    {
        
        switch (count)
        {
                
            case TabBarTpye_Home:
            {
                
                [self customizeHomeTabWithCount:count withHeight:height];
                
            }
                break;
            case TabBarTpye_Invite:
            {
                
                [self customizeInviteTabWithCount:count withHeight:height];
                
            }
                break;
            case TabBarTpye_Create:
            {
                
                [self customizeCreateTabWithCount:count withHeight:height];
            }
                break;
            case TabBarTpye_Notifications:
            {
                [self customizeNotificationsTabWithCount:count withHeight:height];
                
            }
                break;
            case TabBarTpye_More:
            {
                [self customizeMoreTabWithCount:count withHeight:height];
                
            }
                break;
        }
        
    }
}


#pragma mark - Tab Customization View Creation

//Contact TabBar Cusomization
- (void)customizeHomeTabWithCount :(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    UIView *itemViewContacts;
    itemViewContacts = [UIView new];
    
    itemViewContacts.frame = CGRectMake(x, 0, containingWidth, height);
    UIImage *imageBG = [UIImage imageNamed:TabHomeImage];
    CGSize imageSize = imageBG.size;
    float imgx = itemViewContacts.frame.size.width/2 - imageSize.width/2;
    CGRect frameForImage = CGRectMake(imgx, 6, imageSize.width, imageSize.height);
    
    itemViewContacts.backgroundColor = [self getBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:frameForImage];
    iconImageView.image = [UIImage imageNamed:TabHomeImage];
    [itemViewContacts addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(2, iconImageView.frame.size.height + 4, itemViewContacts.frame.size.width - 4, 20);
    titleLabel.text = @"STATS";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    titleLabel.textColor = [UIColor whiteColor];
    [itemViewContacts addSubview:titleLabel];
   // UITabBar *tBar = self.tabBar;
    [self.tabBar insertSubview:itemViewContacts atIndex:TabBarTpye_Home];
}

- (void)customizeInviteTabWithCount :(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    
    float x = containingWidth * count;
   // UIView *itemViewGroji = [UIView new];
    
    UIView *itemViewGroji = [UIView new];
    
    itemViewGroji.frame = CGRectMake(x, 0, containingWidth, height);
    
    UIImage *imageBG = [UIImage imageNamed:TabHomeImage];
    CGSize imageSize = imageBG.size;
    float imgx = itemViewGroji.frame.size.width/2 - imageSize.width/2;
    CGRect frameForImage = CGRectMake(imgx, 6, imageSize.width, imageSize.height);
    
    itemViewGroji.backgroundColor = [self getBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:frameForImage];
    iconImageView.image = [UIImage imageNamed:TabInviteImage];
    [itemViewGroji addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(2, iconImageView.frame.size.height + 4, itemViewGroji.frame.size.width - 4, 20);
    titleLabel.text = @"INVITE";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    titleLabel.textColor = [UIColor whiteColor];
    [itemViewGroji addSubview:titleLabel];
    //UITabBar *tBar = self.tabBar;
    [self.tabBar insertSubview:itemViewGroji atIndex:TabBarTpye_Invite];
}


- (void)customizeCreateTabWithCount:(NSInteger)count withHeight:(float)height
{
    
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    
    UIView *itemView = [UIView new];
    
    itemView.frame = CGRectMake(x, 0, containingWidth, height);
    
    UIImage *imageBG = [UIImage imageNamed:TabHomeImage];
    CGSize imageSize = imageBG.size;
    float imgx = itemView.frame.size.width/2 - imageSize.width/2;
    CGRect frameForImage = CGRectMake(imgx, 6, imageSize.width, imageSize.height);
    
    itemView.backgroundColor = [self getBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:frameForImage];
    iconImageView.image = [UIImage imageNamed:TabCreateImage];
    [itemView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(2, iconImageView.frame.size.height + 4, itemView.frame.size.width - 4, 20);
    titleLabel.text = @"CREATE";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    titleLabel.textColor = [UIColor whiteColor];
    [itemView addSubview:titleLabel];
    
    //UITabBar *tBar = self.tabBar;
    [self.tabBar insertSubview:itemView atIndex:TabBarTpye_Create];
}


- (void)customizeMoreTabWithCount:(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    
    UIView *itemView = [UIView new];
    
    itemView.frame = CGRectMake(x, 0, containingWidth, height);
    
    UIImage *imageBG = [UIImage imageNamed:TabHomeImage];
    CGSize imageSize = imageBG.size;
    float imgx = itemView.frame.size.width/2 - imageSize.width/2;
    CGRect frameForImage = CGRectMake(imgx, 6, imageSize.width, imageSize.height);
    
    itemView.backgroundColor = [self getBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:frameForImage];
    iconImageView.image = [UIImage imageNamed:TabMoreImage];
    [itemView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(2, iconImageView.frame.size.height + 4, itemView.frame.size.width - 4, 20);
    titleLabel.text = @"MORE";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    titleLabel.textColor = [UIColor whiteColor];
    [itemView addSubview:titleLabel];
    
    //UITabBar *tBar = self.tabBar;
    [self.tabBar insertSubview:itemView atIndex:TabBarTpye_More];
}


- (void)customizeNotificationsTabWithCount:(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    
    UIView *itemView = [UIView new];
    
    itemView.frame = CGRectMake(x, 0, containingWidth, height);
    
    UIImage *imageBG = [UIImage imageNamed:TabHomeImage];
    CGSize imageSize = imageBG.size;
    float imgx = itemView.frame.size.width/2 - imageSize.width/2;
    CGRect frameForImage = CGRectMake(imgx, 6, imageSize.width, imageSize.height);
    
    itemView.backgroundColor = [self getBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:frameForImage];
    iconImageView.image = [UIImage imageNamed:TabNotificationImage];
    [itemView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, iconImageView.frame.size.height + 4, itemView.frame.size.width, 20);
    titleLabel.text = @"NOTIFICATIONS";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    titleLabel.textColor = [UIColor whiteColor];
    [itemView addSubview:titleLabel];
    
   // UITabBar *tBar = self.tabBar;
    [self.tabBar insertSubview:itemView atIndex:TabBarTpye_Notifications];
}


#pragma mark - Tabs Background Color
- (UIColor *)getBGColor
{
    return [UIColor colorWithRed:(11/255.0f) green:(90/255.0f) blue:(151/255.0f) alpha:1.0];
}

@end
