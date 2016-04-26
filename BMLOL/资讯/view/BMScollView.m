//
//  BMScollView.m
//  BMScrollImage
//
//  Created by donglei on 16/4/5.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMScollView.h"
#import "BMNewsContentCellModel.h"
#import "UIImageView+WebCache.h"


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

@property(nonatomic,weak) UIImageView *currentImageView;     //当前显示在屏幕上的图片

@property(nonatomic,weak) UIImageView  *otherImageView;     //另外一个显示在屏幕上的图片


@property(nonatomic,assign) int  currentIndex;  //显示在屏幕上的那张图片在图片数组中位置

@property(nonatomic,assign) int  nextIndex;     //下一张要显示在图片的数组中位置
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
    

    NSLog(@"addTwoImageViewToScrollView");
    
    //创建另一个图片view
    UIImageView *otherimagev =   [[UIImageView alloc] init];
    otherimagev.frame = CGRectMake(self.scrollViewWidth, 0, self.scrollViewWidth, self.scrollViewHeight);
    self.otherImageView = otherimagev;
    [self addSubview:otherimagev];
    
    
    
    //创建当前的图片view
    //取出数组中的模型
    BMNewsContentCellModel *model0 = (BMNewsContentCellModel*)_scrollImageArray[0];
     UIImageView *cuimagev =   [[UIImageView alloc] init];
    cuimagev.frame = CGRectMake(self.scrollViewWidth, 0, self.scrollViewWidth, self.scrollViewHeight);
    [cuimagev sd_setImageWithURL:[NSURL URLWithString:model0.image_url_big]];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollImageOk" object:self];
    self.currentImageView = cuimagev;
    [self addSubview:cuimagev];
    self.currentIndex = 0;
    

}


//滚动完成之后清空scroll

-(void) pauseScroll{
    self.direction = DirectionNone; //清空滚动方向
    
    //判断最终滚动到了右边还是左边
    int index = self.contentOffset.x/self.scrollViewWidth;
    if (index == 1) {
        return;
    }
    
    self.currentIndex = self.nextIndex;
    
    self.currentImageView.image = self.otherImageView.image;
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
        self.otherImageView.frame = CGRectMake(self.scrollViewWidth * 2, 0, self.scrollViewWidth, self.scrollViewHeight);
        
        self.nextIndex = self.currentIndex + 1;
        if (self.nextIndex >= self.scrollImageArray.count) {
            self.nextIndex = 0;
        }

        
    }else if ([change[NSKeyValueChangeNewKey] intValue]==  DirectionRight){  //向右滚动
        self.otherImageView.frame = CGRectMake(0, 0, self.scrollViewWidth, self.scrollViewHeight);
        self.nextIndex = self.currentIndex - 1;
        if(self.nextIndex < 0 ) self.nextIndex = (int)self.scrollImageArray.count - 1;
   

        
    }
    //取出模型->设置图片
    BMNewsContentCellModel *model = (BMNewsContentCellModel *)_scrollImageArray[self.nextIndex];
    [self.otherImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url_big]];
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
@end
