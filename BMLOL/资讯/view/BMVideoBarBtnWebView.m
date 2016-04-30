//
//  BMVideoBarBtnTableView.m
//  BMLOL
//
//  Created by donglei on 16/4/29.
//  Copyright © 2016年 donglei. All rights reserved.
//  navigationitem 中视频对应的 tableView

#import "BMVideoBarBtnWebView.h"

@interface BMVideoBarBtnWebView()
<UIWebViewDelegate>
@end


@implementation BMVideoBarBtnWebView

-(instancetype)initViedoBarBtnTableViewWithWebViewUrlString:(NSString *)urlString
{
    if (self = [super init]) {
        
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        self.delegate = self;
    }
    return self;
}


+(instancetype)viedoBarBtnWebViewUrlString:(NSString *)urlString
{
   return  [[self alloc] initViedoBarBtnTableViewWithWebViewUrlString:urlString];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    request.URL.absoluteString
//    NSLog(@"string:%@",request.URL.absoluteString);
    return YES; //string:qtpage://news_detail?url=http://lol.qq.com/m/act/a20150319lolapp/exp_3.htm?iVideoId=26688
}




@end
