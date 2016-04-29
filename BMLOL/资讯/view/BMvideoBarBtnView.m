
//
//  BMvideoBarBtnView.m
//  BMLOL
//
//  Created by donglei on 16/4/29.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMvideoBarBtnView.h"
#import "BMVideoBarBtnWebView.h"

@implementation BMvideoBarBtnView

-(instancetype)initViedoBarBtnView
{
    if (self = [super init]) {
         self.backgroundColor  = [UIColor lightGrayColor];
        //创建 search
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.layer.cornerRadius = 6.f;
        searchBar.layer.masksToBounds = YES;
        searchBar.backgroundImage  = [UIImage imageNamed:@"search_item_bg"];
        searchBar.placeholder = @"搜索您想了解的资讯";
        [self addSubview:searchBar];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.height.equalTo(@34);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        //创建 webview
        BMVideoBarBtnWebView *videoWebView = [BMVideoBarBtnWebView viedoBarBtnWebViewUrlString:@"http://lol.qq.com/m/act/a20150319lolapp/video.htm?APP_BROWSER_VERSION_CODE=1&ios_version=873"];
        videoWebView.frame = CGRectMake(0,44, screenWidth, screenHeight-64-44);
        [self addSubview:videoWebView];
    }
    return self;
}

+(instancetype)viedeoBarBrnView
{
    return  [[self alloc] initViedoBarBtnView];
}

@end
