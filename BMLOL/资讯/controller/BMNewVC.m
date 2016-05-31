//
//  BMNewVC.m
//  BMLOL
//
//  Created by donglei on 3/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMNewVC.h"
#import "AppDelegate.h"
#import "NewsTop.h"
#import "BMTopScrollButton.h"
#import "BMNewsContentCellModel.h"
#import "BMContentTableView.h"
#import "BMNewsLasetNewTbView.h"
#import "BMvideoBarBtnView.h"



#define  Spacing (screenWidth - 34 - (4*40))/4  //scrollView上btn之间的间隔
#define   topScrollViewWidth  ([UIScreen mainScreen].bounds.size.width - 34) //scrollview的宽度

@interface BMNewVC()
<
UIScrollViewDelegate,
BMContentTableViewGoTo //实现 BMContentTableView 的 代理
>


@property(nonatomic,weak) UIView *viewInTopScrollView; // navigationItem中的view

@property(nonatomic,strong) NSArray *newsTopDataModelArray; //scrollView中的btn模型数组

@property(nonatomic,strong) BMTopScrollButton *previousBtn; //scrollview中的btn的前一个按钮

@property(nonatomic,strong) NSMutableArray *topScrollViewBtnArray;// 顶部scrollview中的btn数组


@property(nonatomic,weak) UIButton *moveNextBtnInScrollView;//顶部topScorllView中最右边的btn

//包裹 tableView 的内容的 ScrollView
@property(nonatomic,weak) UIScrollView *contentScroll;

@end



@implementation BMNewVC

static const CGFloat BtnWidth =  40.0;  //按钮的宽度



-(NSArray *)newsTopDataModelArray
{
    if (_newsTopDataModelArray == nil) {
        //从数据库中获取 newstop上的数据模型
        AppDelegate* appDelegate =   (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entiy = [NSEntityDescription entityForName:@"NewsTop" inManagedObjectContext:context];
        [fetchRequest setEntity:entiy];
        NSArray *topDataModel = [context executeFetchRequest:fetchRequest error:nil];
        _newsTopDataModelArray = topDataModel;
    }
    return _newsTopDataModelArray;
}



-(void)viewDidLoad
{
    [super viewDidLoad];
   
    //注册 图片轮播视图中 按钮被点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewBtnClick:) name:@"scrollViewBtnClick" object:nil];;
    
    [self initTopScrollView]; //创建顶部的视图
    
    
    self.automaticallyAdjustsScrollViewInsets =  NO;
    [self initContentScrollView];
   
    
    
}

#pragma mark 创建navigationbar上的scrollView视图

-(void) initTopScrollView{
    //1>uivewitem 创建一个view 来包裹scrollview 和 右边的button
    UIView *viewItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    self.navigationItem.titleView = viewItem;

    
    CGFloat contentSizeWidth = (self.newsTopDataModelArray.count - 1)*Spacing+40*self.newsTopDataModelArray.count+20;
    
    
    
    //2>创建navigationbar 中的滑动视图
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    topScrollView.alwaysBounceVertical = NO;
    topScrollView.alwaysBounceHorizontal = YES;
    [viewItem addSubview:topScrollView];
    
    

    [topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewItem.mas_left);
        make.right.equalTo(viewItem.mas_right).with.offset(-34);
        make.top.equalTo(viewItem.mas_top).with.offset(8);
        make.bottom.equalTo(viewItem.mas_bottom).with.offset(-8);
    }];
    
    
    
    
    //3>创建topScrollview的右边的按钮
    UIButton *nextBtnInScrollView = [[UIButton alloc] init];
    _moveNextBtnInScrollView = nextBtnInScrollView;
    [nextBtnInScrollView addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextBtnInScrollView setBackgroundImage:[UIImage imageNamed:@"list_news_top_arrow_normal"] forState:UIControlStateNormal];
    [nextBtnInScrollView setBackgroundImage:[UIImage imageNamed:@"list_news_top_arrow_press"] forState:UIControlStateHighlighted | UIControlStateDisabled];
    [viewItem addSubview:nextBtnInScrollView];
    [nextBtnInScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewItem.mas_right);
        make.left.equalTo(topScrollView.mas_right);
        make.top.equalTo(topScrollView.mas_top);
        make.bottom.equalTo(topScrollView.mas_bottom);
    }];
    
    
    
    
    /**
     4>> 处理scrollView的逻辑
     */
    
    //在 topScrollView 中添加同一个UIView 解决直接添加 UIButton,topScrollView 不能拖动的问题
    UIView *viewInTopScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSizeWidth, 28)];
    self.viewInTopScrollView = viewInTopScrollView;
    [topScrollView addSubview:viewInTopScrollView];
  
    //创建第一个btn
    NewsTop *oneTopMoel = (NewsTop*)self.newsTopDataModelArray[0];
    BMTopScrollButton *oneBtn = [BMTopScrollButton topScrollButtonDict:oneTopMoel];
    [viewInTopScrollView addSubview:oneBtn];
    [oneBtn setSelected:YES];
    [oneBtn setPreviousSelectedBtn:oneBtn];
    oneBtn.btnClicked = ^(){

        [self moveNextBtnIsEnabel];
    };
    
    //调整内容 scrollView 的 offestX block
    oneBtn.btnClickWithChangeContentScroll = ^(){
        _contentScroll.contentOffset = CGPointMake(screenWidth * 0, 0);
    };
    _topScrollViewBtnArray = [NSMutableArray array];
    oneBtn.tag = 0;
    [_topScrollViewBtnArray addObject:oneBtn];
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewInTopScrollView.mas_left).offset(0);
        make.top.equalTo(viewInTopScrollView.mas_top);
        make.bottom.equalTo(viewInTopScrollView.mas_bottom);
        make.width.equalTo(@40);
    }];
    _previousBtn = oneBtn;
    //创建后面几个btn
    for (int i = 1;i < _newsTopDataModelArray.count;i++) {
        NewsTop *newTopModel = (NewsTop *)_newsTopDataModelArray[i]; //获取按钮对应的模型数据
        //创建按钮
        __block BMTopScrollButton *currentBtn = [self createBtnInScrollViewWithPrevious:_previousBtn btnModel:newTopModel];
        currentBtn.tag = i;
        [_topScrollViewBtnArray addObject:currentBtn];
        if (i >= 3 ) {
            //按钮被点击之后,需要偏移的x
            CGFloat offsetXBtnClicked = BtnWidth*i+Spacing*i + BtnWidth*0.5 - topScrollViewWidth * 0.5;
            //被点击后居中的按钮执行的block
            if ( (topScrollView.contentSize.width  - offsetXBtnClicked) > topScrollViewWidth) {
                
                currentBtn.btnClicked = ^(){
                    [UIView animateWithDuration:0.3f animations:^{
                        
                        topScrollView.contentOffset = CGPointMake(BtnWidth*i+Spacing*i + BtnWidth*0.5 - topScrollViewWidth * 0.5 - 10 , 0);
                    }];

                    [self moveNextBtnIsEnabel];
                };
                
                //调整内容 scrollView 的 offestX block
                currentBtn.btnClickWithChangeContentScroll = ^(){
                    _contentScroll.contentOffset = CGPointMake(screenWidth * i, 0);
                };
            }else {
                //最后面的几个按钮 但是不居中
                currentBtn.btnClicked = ^(){
                    [UIView animateWithDuration:0.3f animations:^{
                        
                        topScrollView.contentOffset = CGPointMake(topScrollView.contentSize.width-topScrollViewWidth, 0);

                    }];

                    [self moveNextBtnIsEnabel];
                };
                
                //调整内容 scrollView 的 offestX block
                currentBtn.btnClickWithChangeContentScroll = ^(){
                    _contentScroll.contentOffset = CGPointMake(screenWidth * i, 0);
                };
            }
        }else {
            //offsetx为0 的按钮
            currentBtn.btnClicked = ^(){
                [UIView animateWithDuration:0.3f animations:^{
                    
                    topScrollView.contentOffset = CGPointMake(0, 0);

                }];

                [self moveNextBtnIsEnabel];
            };
            //调整内容 scrollView 的 offestX block
            currentBtn.btnClickWithChangeContentScroll = ^(){
                _contentScroll.contentOffset = CGPointMake(screenWidth * i, 0);
            };
        }
        
        _previousBtn = currentBtn;
    }
    
    

}


/**
 *  创建顶部scrollView中按钮的方法
 *
 *  @param previousBtn 正在创建的这个按钮的前一个按钮
 *  @param btnModel    正在创建的这个按钮的模型数据
 *
 *  @return 返回创建好的按钮
 */
-(BMTopScrollButton * ) createBtnInScrollViewWithPrevious:(BMTopScrollButton *)previousBtn btnModel:(NewsTop *) btnModel{
    BMTopScrollButton *btn = [BMTopScrollButton topScrollButtonDict:btnModel];
    [_viewInTopScrollView addSubview:btn];
    __weak typeof(self) newsVc = self;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(previousBtn.mas_right).offset(Spacing);
        make.top.equalTo(newsVc.viewInTopScrollView.mas_top);
        make.bottom.equalTo(newsVc.viewInTopScrollView.mas_bottom);
        make.width.equalTo(@40);
    }];
   
    return btn;
    
}

/**
 *  顶部右边的按钮被点击触发的回调
 *
 *  @param btn  当前被点击的那个 按钮的下一个按钮
 */
-(void) clickNextBtn{
    for (BMTopScrollButton *btn in _topScrollViewBtnArray) {
        if (btn.selected) {
            
            //通过tag获取 下个按钮
            BMTopScrollButton * nextBtn = (BMTopScrollButton*) _topScrollViewBtnArray[btn.tag+1];
            //调用这个按钮的点击方法
            [nextBtn buttonClick:nextBtn];
            break;
        }
    }
}

/**
 *  判断最右边的按钮是否可以点击
 */
-(void) moveNextBtnIsEnabel{
    for (BMTopScrollButton *btn in _topScrollViewBtnArray) {
        if (btn.selected) {
            if(btn.tag < _topScrollViewBtnArray.count-1){
                _moveNextBtnInScrollView.enabled = YES;
            }else {
                _moveNextBtnInScrollView.enabled = NO;
            }
        }
    }
}


#pragma mark 创建内容区的scrollview

-(void) initContentScrollView{
    UIScrollView *contentSc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 , screenWidth, screenHeight-44)];
    _contentScroll = contentSc;
    contentSc.showsVerticalScrollIndicator = NO;
    contentSc.showsHorizontalScrollIndicator = NO;
    contentSc.bounces =  NO;
    contentSc.alwaysBounceVertical = NO;
    contentSc.alwaysBounceHorizontal = NO;
    contentSc.decelerationRate = 0.001f;

    contentSc.pagingEnabled = YES;
    contentSc.delegate  = self;
    contentSc.contentSize = CGSizeMake(screenWidth * _topScrollViewBtnArray.count, 0);
    [self.view addSubview:contentSc];
    

    
    //最新
    BMContentTableView *tableview =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c12_list_1.shtml" isHasScroll:YES inScrollViewX:screenWidth * 0];
    tableview.webVcDelegate = self;
    tableview.frame = CGRectMake(screenWidth * 0,-44, screenWidth, screenHeight-64);
    [contentSc addSubview:tableview];
    
//  赛事
//    
    BMContentTableView *tableview1 =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c73_list_1.shtml" isHasScroll:NO inScrollViewX:screenWidth * 1];
    tableview1.webVcDelegate = self;
    tableview1.frame = CGRectMake(screenWidth * 1,-44, screenWidth, screenHeight-64);
    [contentSc addSubview:tableview1];
// 活动 //TODO: urlString 有问题
    BMContentTableView *tableview2 =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c23_list_1.shtml" isHasScroll:NO inScrollViewX:screenWidth * 2];
    tableview2.webVcDelegate = self;
    tableview2.frame = CGRectMake(screenWidth * 2,-44, screenWidth, screenHeight-64);
    [contentSc addSubview:tableview2];
//视频

//    BMVideoBarBtnWebView *videoWebView = [BMVideoBarBtnWebView viedoBarBtnWebViewUrlString:@"http://lol.qq.com/m/act/a20150319lolapp/video.htm?APP_BROWSER_VERSION_CODE=1&ios_version=873"];
//    videoWebView.frame = CGRectMake(screenWidth * 3,44, screenWidth, screenHeight-64-44);
//    [contentSc addSubview:videoWebView];
    
    BMvideoBarBtnView *videoView = [BMvideoBarBtnView viedeoBarBrnView];
    videoView.frame = CGRectMake(screenWidth * 3,0, screenWidth, screenHeight-64-44);
    [contentSc addSubview:videoView];

////娱乐
    BMContentTableView *tableview4 =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c18_list_1.shtml" isHasScroll:NO inScrollViewX:screenWidth * 4];
    tableview4.webVcDelegate = self;
    tableview4.frame = CGRectMake(screenWidth * 4,-44, screenWidth, screenHeight-64);
    [contentSc addSubview:tableview4];

//官方
    BMContentTableView *tableview5 =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c3_list_1.shtml" isHasScroll:NO inScrollViewX:screenWidth * 5];
    tableview5.webVcDelegate = self;
    tableview5.frame = CGRectMake(screenWidth * 5,-44, screenWidth, screenHeight-64);
    [contentSc addSubview:tableview5];
//美女
    BMContentTableView *tableview6 =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c17_list_1.shtml" isHasScroll:NO inScrollViewX:screenWidth * 6];
    tableview6.webVcDelegate = self;
    tableview6.frame = CGRectMake(screenWidth * 6,-44, screenWidth, screenHeight-64);
    [contentSc addSubview:tableview6];
//攻略
    BMContentTableView *tableview7 =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c10_list_1.shtml" isHasScroll:NO inScrollViewX:screenWidth * 7];
    tableview7.webVcDelegate = self;
    tableview7.frame = CGRectMake(screenWidth * 7,-44, screenWidth, screenHeight-64);
    [contentSc addSubview:tableview7];
    
	


}


#pragma mark UIScrollViewDelegate
// 内容 scrollView 滚动超过屏幕一半时。就滚动到下一页 同时 topScrollView 标题也发生改变
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int k = 0;
    if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x <= screenWidth * 0.5) {
        k = 0;
    }
    if (scrollView.contentOffset.x > screenWidth * 0.5 && scrollView.contentOffset.x <= screenWidth * 1.5) {
        k  = 1 ;
    }
    if (scrollView.contentOffset.x > screenWidth * 1.5 && scrollView.contentOffset.x <= screenWidth * 2.5) {
        k = 2;
    }
    if (scrollView.contentOffset.x > screenWidth * 2.5 && scrollView.contentOffset.x <= screenWidth * 3.5) {
        k = 3;
    }
    if (scrollView.contentOffset.x > screenWidth * 3.5 && scrollView.contentOffset.x <= screenWidth * 4.5) {
        k = 4;
    }
    if (scrollView.contentOffset.x > screenWidth * 4.5 && scrollView.contentOffset.x <= screenWidth * 5.5) {
        k = 5;
    }
    if (scrollView.contentOffset.x > screenWidth * 5.5 && scrollView.contentOffset.x <= screenWidth * 6.5) {
        k = 6;
    }
    if (scrollView.contentOffset.x > screenWidth * 6.5 && scrollView.contentOffset.x <= screenWidth * 7.5) {
        k = 7;
    }
    BMTopScrollButton * nextBtn = (BMTopScrollButton*) _topScrollViewBtnArray[k];
    [nextBtn btnClickChangeContentScrollView:nextBtn];

}

#pragma mark BMContentTableViewGoTo

-(void) cellClickGoToWithBMConTableView:(BMContentTableView *)contentTableView GoToWBMWebV:(BMWebVC *)webVc
{
    
    ((UIViewController *)webVc).hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVc animated:YES];
}

-(void) bmContentTable:(BMContentTableView *)contentTableView GotoBMSearchVC:(BMSearchViewController *)serchVc
{
    [self.navigationController pushViewController:serchVc animated:YES];
}

#pragma mark 图片轮播 按钮被点击的回调方法
-(void) scrollViewBtnClick:(NSNotification *) notification
{
   BMWebVC *webvc = notification.userInfo[@"webVc"];
   [self.navigationController pushViewController:webvc animated:YES];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
