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

#define  Spacing (screenWidth - 34 - (4*40))/4  //scrollView上btn之间的间隔
#define   topScrollViewWidth  ([UIScreen mainScreen].bounds.size.width - 34) //scrollview的宽度

@interface BMNewVC()


@property(nonatomic,weak) UIView *viewInTopScrollView; // navigationItem中的view

@property(nonatomic,strong) NSArray *newsTopDataModelArray; //scrollView中的btn模型数组

@property(nonatomic,strong) BMTopScrollButton *previousBtn; //scrollview中的btn的前一个按钮


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
   
    



    
    
    CGFloat contentSizeWidth = (self.newsTopDataModelArray.count - 1)*Spacing+40*self.newsTopDataModelArray.count+20;
    //创建navigationbar 中的滑动视图
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    topScrollView.alwaysBounceVertical = NO;
    topScrollView.alwaysBounceHorizontal = YES;
    UINavigationItem *scrollItem = [[UINavigationItem alloc] init];
    scrollItem.titleView = topScrollView;
    
    UINavigationBar *newNavigationBar = self.navigationController.navigationBar;
    [self.navigationController.navigationBar setItems:@[scrollItem] animated:YES];
    [topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newNavigationBar.mas_left);
        make.right.equalTo(newNavigationBar.mas_right).with.offset(-34);
        make.top.equalTo(newNavigationBar.mas_top).with.offset(8);
        make.bottom.equalTo(newNavigationBar.mas_bottom).with.offset(-8);
    }];

   
    //在 topScrollView 中添加同一个UIView 解决直接添加 UIButton,topScrollView 不能拖动的问题
    UIView *viewInTopScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSizeWidth, 28)];
//    viewInTopScrollView.backgroundColor = [UIColor blueColor];
    self.viewInTopScrollView = viewInTopScrollView;
    [topScrollView addSubview:viewInTopScrollView];
    
    //创建第一个btn
    NewsTop *oneTopMoel = (NewsTop*)self.newsTopDataModelArray[0];
    BMTopScrollButton *oneBtn = [BMTopScrollButton topScrollButtonDict:oneTopMoel];
     [viewInTopScrollView addSubview:oneBtn];
    [oneBtn setSelected:YES];
    [oneBtn setPreviousSelectedBtn:oneBtn];
    oneBtn.btnClicked = ^(){
        
    };
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
        if (i >= 3 ) {
            //按钮被点击之后,需要偏移的x
            CGFloat offsetXBtnClicked = 20+BtnWidth*i+Spacing*i + BtnWidth*0.5 - topScrollViewWidth * 0.5;
            //被点击后居中的按钮执行的block
            if ( (topScrollView.contentSize.width  - offsetXBtnClicked) > topScrollViewWidth) {
                
                currentBtn.btnClicked = ^(){
                    topScrollView.contentOffset = CGPointMake(20+BtnWidth*i+Spacing*i + BtnWidth*0.5 - topScrollViewWidth * 0.5 - 14, 0);
                };
            }else {
                //最后面的几个按钮 但是不居中
                currentBtn.btnClicked = ^(){
                    topScrollView.contentOffset = CGPointMake(topScrollView.contentSize.width-topScrollViewWidth, 0);
                };
            }
        }else {
            //offsetx为0 的按钮
            currentBtn.btnClicked = ^(){
                topScrollView.contentOffset = CGPointMake(0, 0);
            };
        }

        _previousBtn = currentBtn;
    }
 
    
    
    
    //创建topScrollview的右边的按钮
    UIButton *nextBtnInScrollView = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 20, 20)];
    [nextBtnInScrollView setBackgroundImage:[UIImage imageNamed:@"list_news_top_arrow_normal"] forState:UIControlStateNormal];
    [nextBtnInScrollView setBackgroundImage:[UIImage imageNamed:@"list_news_top_arrow_press"] forState:UIControlStateHighlighted | UIControlStateDisabled];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:nextBtnInScrollView];
        [self.navigationItem setRightBarButtonItem:bar animated:YES];
    
    
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




@end
