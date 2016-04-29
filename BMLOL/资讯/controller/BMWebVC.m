//
//  BMWebVC.m
//  BMLOL
//
//  Created by donglei on 16/4/30.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMWebVC.h"

@interface BMWebVC()
<
UIWebViewDelegate
>

@property(nonatomic,weak) UIWebView *webView;

//判断这个控制器中的 webview 是否包含视频
@property(nonatomic,assign,getter = isVideo) BOOL video;
@end

@implementation BMWebVC


-(instancetype)initWebViewControllIsViedo:(BOOL)isViedo WebViewUrlString:(NSString *) urlString
{
    if (self = [super init]) {
        self.video = isViedo;
        [self addWebViewUrlString:urlString]; //创建 webview
        
        [self addBarBtnItems];
     
        self.title = @"资讯详情";
    }
    return self;
}


+ (instancetype)webViewControllIsViedo:(BOOL)isViedo WebViewUrlString:(NSString *) urlString
{
    return  [[self alloc] initWebViewControllIsViedo:isViedo WebViewUrlString:urlString];
}


#pragma mark 创建这个控制器界面上的一些控件

-(void) addWebViewUrlString:(NSString *) urlString{
    //创建webview

        UIWebView *webV = [[UIWebView alloc] init];
        self.view = webV;
        [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}

/**
 *  创建 barBtnItems
 */
-(void) addBarBtnItems{
    
    NSMutableArray *barBtnItems = [NSMutableArray array];
    //创建分享 barbtnItem
    UIBarButtonItem *shareBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBarBtnItemClicked)];
    [shareBtnItem setBackgroundImage:[UIImage imageNamed:@"share_pressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [barBtnItems addObject:shareBtnItem];
    
    //创建下载的 barButtonItem
    if (self.isVideo) {
        
        UIBarButtonItem *downloadBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hero_btn_update_right_bar_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(downloadBtnItemClicked)];
        [downloadBtnItem setBackgroundImage:[UIImage imageNamed:@"hero_btn_update_right_bar_press"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [barBtnItems addObject:downloadBtnItem];
    }

    [self.navigationItem setRightBarButtonItems:barBtnItems];
}

#pragma  mark barButtonItem 的点击方法

-(void) shareBarBtnItemClicked
{
    
}

@end
