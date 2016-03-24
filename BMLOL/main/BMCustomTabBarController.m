//
//  BMCustomTabBarController.m
//  BMLOL
//
//  Created by donglei on 2/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMCustomTabBarController.h"
#import "BMTabBarBtn.h"


@interface BMCustomTabBarController()
@end

@implementation BMCustomTabBarController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.tabBar.items[0].selectedImage = [UIImage imageNamed:@"tab_icon_news_press"];
    self.tabBar.items[1].selectedImage = [UIImage imageNamed:@"tab_icon_friend_press"];
    self.tabBar.items[2].selectedImage = [UIImage imageNamed:@"tab_icon_quiz_press"];
    self.tabBar.items[3].selectedImage = [UIImage imageNamed:@"tab_icon_more_press"];
    
    self.tabBar.tintColor = [UIColor colorWithRed:68/255.0 green:135/255.0 blue:194/255.0 alpha:1.0];
    
}




@end
