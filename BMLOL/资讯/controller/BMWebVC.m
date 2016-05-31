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

@property(nonatomic,weak) NSTimer *timer;

@property(nonatomic,copy) NSString *loadUrlString;

@property(nonatomic,assign) BOOL isConLoad;  //解决在有视频的 webview 多次创建 nstimer 问题
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [self.timer invalidate];
    self.timer = nil;
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
    

    if ([[request.URL relativeString] hasPrefix:@"http://"]) {
        self.loadUrlString = [request.URL relativeString];
    
        
          [UIView animateWithDuration:1.f animations:^{
              self.progressView.progress = 0.3f;
          }];
    }
    return  YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
 
    if ([self.loadUrlString hasPrefix:@"http://"]){
        if(!self.isConLoad){
            
//             [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(addProgress) userInfo:nil repeats:YES];
			//由于这里是webview是有滑动的，在滑动的时候 runlooph mode会发生改变，所以不用使用上面的这种方法
			NSTimer *timer = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(addProgress) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
			
			
            self.timer  = timer;
            self.isConLoad = YES;
        }
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    if(self.timer){
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
       self.progressView.progress = 1.0;
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
    });
    

}
-(void) addProgress{
    if (self.progressView.progress >= 0.7f) {
        if(self.timer){
            
            [self.timer invalidate];
            self.timer = nil;
        }
    }else {
        NSLog(@"addProgress");
        
              
              self.progressView.progress += 0.1f;
        
    }
}
@end
