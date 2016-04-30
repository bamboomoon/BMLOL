//
//  BMScollView.m
//  BMScrollImage
//
//  Created by donglei on 16/4/5.
//  Copyright © 2016年 donglei. All rights reserved.
//  这里是滚动图片

#import "BMScollView.h"
#import "BMNewsContentCellModel.h"
#import "UIButton+WebCache.h"
#import "BMWebVC.h"


typedef NS_ENUM(NSInteger,Direction){
    DirectionNone,  //图片没有滚动
    DirectionLeft,  //图片向左滚动
    DirectionRight, //图片向右滚动
    
};

@interface BMScollView()
<
UIScrollViewDelegate
>

@property(nonatomic,assign) NSTimer *timer; //自动滚动定时器

@property(nonatomic,assign) Direction direction;  //滚动的方向

@property(nonatomic,strong) NSArray *scrollImageArray; //图片数组

@property(nonatomic,assign) CGFloat scrollViewWidth;  //滚动视图的宽度

@property(nonatomic,assign) CGFloat scrollViewHeight;  //滚动视图的高度

@property(nonatomic,weak) UIButton *currentBtn;     //当前显示在屏幕上的图片

@property(nonatomic,weak) UIButton  *otherBtn;     //另外一个显示在屏幕上的图片


@property(nonatomic,assign) int  currentIndex;  //显示在屏幕上的那张图片在图片数组中位置

@property(nonatomic,assign) int  nextIndex;     //下一张要显示在图片的数组中位置


@property(nonatomic,weak) UILabel *otherImageLabel;

@property(nonatomic,weak) UILabel *currentImageLabel;


@end

@implementation BMScollView



-(instancetype) initBMScrollImages:(NSArray *)scrollImageUrlArray offest:(CGPoint)offets scrollViewSize:(CGSize) scrollViewSize
{
    self = [super init];
    if(self){
        
        
        //监听滚动
        [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew context:nil];
        
        
        
        _scrollImageArray = [NSArray array];
        self.scrollImageArray = scrollImageUrlArray;
        
        _scrollViewWidth = scrollViewSize.width;
        _scrollViewHeight = scrollViewSize.height;
        //设置scrollview的一些属性
        self.delegate = self;
        self.contentSize = CGSizeMake(_scrollViewWidth * 3, scrollViewSize.height);
        self.contentOffset = CGPointMake(_scrollViewWidth, 0);
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
     
        
    
        
        //在scrollview上加上两个imageView
        [self addTwoImageViewToScrollView];
        
        //开启自动滚动
        [self startTimer];
    }
    return self;
}

+(instancetype)BMScrollImages:(NSArray *)scrollImageUrlArray offest:(CGPoint)offets scrollViewSize:(CGSize)scrollViewSize
{
    return [[self alloc] initBMScrollImages:scrollImageUrlArray offest:offets scrollViewSize:scrollViewSize];
}





-(void) addTwoImageViewToScrollView{
    


    
    //创建另一个图片view

    
    UIButton *otherBtn  = [[UIButton alloc] init];
    otherBtn.frame = CGRectMake(self.scrollViewWidth, 0, self.scrollViewWidth, self.scrollViewHeight);
    self.otherBtn = otherBtn;
    [self addSubview:otherBtn];
   
    //创建承载 label的 view
    UIView *otherView = [self createViewWithLabel];
    [otherBtn addSubview:otherView];

    //添加 label
    UILabel * label = [self createLabelInImage];
    _otherImageLabel = label;
    [otherView addSubview:label];
    
    
    
    
    //创建当前的图片view
    //取出数组中的模型
    BMNewsContentCellModel *model0 = (BMNewsContentCellModel*)_scrollImageArray[0];

    
    UIButton *currentBtn = [[UIButton alloc] init];
    currentBtn.frame = CGRectMake(self.scrollViewWidth, 0, self.scrollViewWidth, self.scrollViewHeight);
    [currentBtn addTarget:self action:@selector(currentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [currentBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model0.image_url_big] forState:UIControlStateNormal];
    self.currentBtn = currentBtn;
    [self addSubview:currentBtn];
    
    self.currentIndex = 0;
    
    //创建 view
    UIView *cuiView = [self createViewWithLabel];
    [currentBtn addSubview:cuiView];
    //添加 label
    UILabel *label2 = [self createLabelInImage];
    self.currentImageLabel = label2;
    label2.text = model0.title;
    [cuiView addSubview:label2];
    


}


#pragma mark 创建 label
/**
 *  创建一个 view 来放置 lable
 *
 *  @return 创建好的 view
 */
-(UIView *) createViewWithLabel{
    CGFloat labelHeight = screenWidth * 0.5 * 1/8; //screenwidth * 0.5 为滚动图片的高度
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screenWidth * 0.5 - labelHeight, screenWidth, labelHeight)];
    [view setBackgroundColor:[UIColor colorWithRed:173/255.0 green:171/255.0 blue:159/255.0 alpha:1.0]];
    return  view;
}
/**
 *  创建在图片上显示标题的 label
 *  @return 创建好的 label
 */
-(UILabel *) createLabelInImage{
    CGFloat labelHeight = screenWidth * 0.5 * 1/8; //screenwidth * 0.5 为滚动图片的高度
    UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screenWidth -  10, labelHeight - 10)];
    [laebl setFont:[UIFont systemFontOfSize:15.f]];
    return  laebl;
}


#pragma  mark 逻辑处理
//滚动完成之后清空scroll

-(void) pauseScroll{
    self.direction = DirectionNone; //清空滚动方向
    
    //判断最终滚动到了右边还是左边
    int index = self.contentOffset.x/self.scrollViewWidth;
    if (index == 1) {
        return;
    }
    
    self.currentIndex = self.nextIndex;
    
    [self.currentBtn setBackgroundImage:self.otherBtn.currentBackgroundImage forState:UIControlStateNormal];
    self.currentImageLabel.text = self.otherImageLabel.text; // 更换标题
    self.contentOffset = CGPointMake(self.scrollViewWidth, 0);
}


#pragma mark delegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_timer){
        
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}


//scrollview在被拖动的时候，一直调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView                                           
{
    self.direction = self.contentOffset.x > _scrollViewWidth ? DirectionLeft :DirectionRight;

}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewDidEndDecelerating");
    [self pauseScroll];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self pauseScroll];
}



#pragma mark kvo
    //接受direction的变化
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (change[NSKeyValueChangeNewKey] == change[NSKeyValueChangeOldKey]) return;  //没有滚动
    
    if([change[NSKeyValueChangeNewKey] intValue] == DirectionLeft){  //向左滚动
        self.otherBtn.frame = CGRectMake(self.scrollViewWidth * 2, 0, self.scrollViewWidth, self.scrollViewHeight);
        
        self.nextIndex = self.currentIndex + 1;
        if (self.nextIndex >= self.scrollImageArray.count) {
            self.nextIndex = 0;
        }

        
    }else if ([change[NSKeyValueChangeNewKey] intValue]==  DirectionRight){  //向右滚动
        self.otherBtn.frame = CGRectMake(0, 0, self.scrollViewWidth, self.scrollViewHeight);
        self.nextIndex = self.currentIndex - 1;
        if(self.nextIndex < 0 ) self.nextIndex = (int)self.scrollImageArray.count - 1;
        
    }
    //取出模型->设置图片
    BMNewsContentCellModel *model = (BMNewsContentCellModel *)_scrollImageArray[self.nextIndex];
    
    
    //发送一个通知 让tableview iamgeScrollCell 去改变页数
    NSNumber *number =  [NSNumber numberWithInt:self.currentIndex];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:number forKey:@"index"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIndex" object:self userInfo:dict];

    //设置 标题
    self.otherImageLabel.text = model.title;
    [self.otherBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.image_url_big] forState:UIControlStateNormal];
}




#pragma mark 添加定时器
-(void) startTimer{
    if (self.scrollImageArray.count <= 1) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void) nextPage{
    [self setContentOffset:CGPointMake(self.scrollViewWidth * 2 , 0) animated:YES];
}

-(void) currentBtnClicked:(UIButton *) btnClicked{
    BMNewsContentCellModel *model = (BMNewsContentCellModel*)_scrollImageArray[self.currentIndex];

    BMWebVC *webVc = [[BMWebVC alloc] init];
    webVc.urlString = [newsUrlPath stringByAppendingString:model.article_url ];
    webVc.isVideo = NO;
    webVc.hidesBottomBarWhenPushed = YES;
    
    //发送通知 在 BMNewVc 中接收
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollViewBtnClick" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:webVc,@"webVc", nil]];
  
    
    
}
@end
