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


//进度条
@property(nonatomic,weak) UIProgressView *progressView;

@property(nonatomic,strong) NSTimer *timer;
@end

@implementation BMWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = gloabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:gloabColor,NSForegroundColorAttributeName, nil]];
//    UITextAttributeTextColor[]
    self.navigationItem.hidesBackButton = YES;
    [self addWebViewUrlString:self.urlString]; //创建 webview
    
    [self addBarBtnItems];
    
    self.title = @"资讯详情";
    
    UIProgressView *progressview = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 10)];
    self.progressView = progressview;
    progressview.progressTintColor = [UIColor blueColor];
    [self.view addSubview:progressview];
}




#pragma mark 创建这个控制器界面上的一些控件

-(void) addWebViewUrlString:(NSString *) urlString{
    //创建webview
//var video = doucment.getElemtById(\"tenvideo_video_player_0\");alert(video.src)
        UIWebView *webV = [[UIWebView alloc] init];
    webV.delegate = self;
        self.view = webV;
        [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

    
}

/**
 *  创建 barBtnItems
 */
-(void) addBarBtnItems{

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_back_normal"] style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    [backItem setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_pressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
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

-(void) backItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)downloadBtnItemClicked
{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"webView%@ %@,",[request.URL relativeString],request);
    if ([[request.URL relativeString] hasPrefix:@"http://"]) {
        
        self.progressView.progress = 0.3f;
    }
    return  YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(addProgress) userInfo:nil repeats:YES];
    self.timer  = timer;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.progressView.progress = 1.0f;
    self.progressView.hidden = YES;

}
-(void) addProgress{
    if (self.progressView.progress == 0.7f) {
        [self.timer invalidate];
        self.timer = nil;
    }else {
        self.progressView.progress += 0.05f;
    }
}
@end
