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

#define  Spacing (screenWidth - 34 - (4*40))/4  //scrollView上btn之间的间隔
#define   topScrollViewWidth  ([UIScreen mainScreen].bounds.size.width - 34) //scrollview的宽度

@interface BMNewVC()



@property(nonatomic,weak) UIView *viewInTopScrollView; // navigationItem中的view

@property(nonatomic,strong) NSArray *newsTopDataModelArray; //scrollView中的btn模型数组

@property(nonatomic,strong) BMTopScrollButton *previousBtn; //scrollview中的btn的前一个按钮

@property(nonatomic,strong) NSMutableArray *topScrollViewBtnArray;// 顶部scrollview中的btn数组


@property(nonatomic,weak) UIButton *moveNextBtnInScrollView;//顶部topScorllView中最右边的btn

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
    [self initTopScrollView]; //创建顶部的视图
    self.view.backgroundColor = [UIColor redColor];
    
    self.automaticallyAdjustsScrollViewInsets =  NO;
    [self initContentScrollView];
   
    
    
}

#pragma mark 创建navigationbar上的scrollView视图

-(void) initTopScrollView{
    //1>uivewitem 创建一个view 来包裹scrollview 和 右边的button
    UIView *viewItem = [[UIView alloc] init];
    UINavigationItem *viewnavititem = [[UINavigationItem alloc] init];
    viewnavititem.titleView  = viewItem;
    
    
    CGFloat contentSizeWidth = (self.newsTopDataModelArray.count - 1)*Spacing+40*self.newsTopDataModelArray.count+20;
    
    
    
    //2>创建navigationbar 中的滑动视图
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    topScrollView.alwaysBounceVertical = NO;
    topScrollView.alwaysBounceHorizontal = YES;
    [viewItem addSubview:topScrollView];
    UINavigationBar *newNavigationBar = self.navigationController.navigationBar;
    
    [self.navigationController.navigationBar setItems:@[viewnavititem] animated:YES];
    
    [viewItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(newNavigationBar);
    }];
    
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
    _topScrollViewBtnArray = [NSMutableArray array];
    oneBtn.tag = 0;
    [_topScrollViewBtnArray addObject:oneBtn];
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewInTopScrollView.mas_left).offset(20);
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
            CGFloat offsetXBtnClicked = 20+BtnWidth*i+Spacing*i + BtnWidth*0.5 - topScrollViewWidth * 0.5;
            //被点击后居中的按钮执行的block
            if ( (topScrollView.contentSize.width  - offsetXBtnClicked) > topScrollViewWidth) {
                
                currentBtn.btnClicked = ^(){
                    [UIView animateWithDuration:0.3f animations:^{
                        
                        topScrollView.contentOffset = CGPointMake(20+BtnWidth*i+Spacing*i + BtnWidth*0.5 - topScrollViewWidth * 0.5 - 14, 0);
                    }];
                    [self moveNextBtnIsEnabel];
                };
            }else {
                //最后面的几个按钮 但是不居中
                currentBtn.btnClicked = ^(){
                    [UIView animateWithDuration:0.3f animations:^{
                        
                        topScrollView.contentOffset = CGPointMake(topScrollView.contentSize.width-topScrollViewWidth, 0);
                    }];
                    [self moveNextBtnIsEnabel];
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
    contentSc.showsVerticalScrollIndicator = NO;
    contentSc.showsHorizontalScrollIndicator = NO;
    contentSc.bounces =  NO;
    contentSc.alwaysBounceVertical = NO;
    contentSc.alwaysBounceHorizontal = NO;
    contentSc.pagingEnabled = YES;
 
    contentSc.contentSize = CGSizeMake(screenWidth * _topScrollViewBtnArray.count, 0);
    [self.view addSubview:contentSc];
    

    
    
    BMContentTableView *tableview =  [[BMContentTableView alloc] initContentTableViewFirstUrlString:@"http://qt.qq.com/static/pages/news/phone/c12_list_1.shtml" isHasScroll:YES];
    tableview.frame = CGRectMake(0,-44, screenWidth, screenHeight-64);
//    tableview.sectionHeaderHeight = 20;
  
//    tableview.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
//    tableview.alwaysBounceVertical = YES;//TODO: 需要解决偏移问题
    [contentSc addSubview:tableview];
}

@end
