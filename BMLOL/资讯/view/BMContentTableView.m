//
//  BMContentTableView.m
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMContentTableView.h"
#import "BMSingleUrlContentModel.h"
#import "BMNewsContentCellModel.h"
#import "BMNesContentTableViewCell.h"
#import "BMNetworing.h"
#import "BMScollView.h"
#import "BMWebVC.h"
#import "BMSearchViewController.h"



#import <MJRefresh.h>


@interface BMContentTableView()
<
UITableViewDelegate,
UITableViewDataSource
>

//cell的模型数组 上一个 string 加载出来的数据
@property (nonatomic,strong) __block BMSingleUrlContentModel *contentModel;

//这个tableview 是否有图片的滚动视图
@property (nonatomic,assign) BOOL                    isHasScroll;

//是否调整 tableview 的 frame 以使searchCell 合适的显示
@property (nonatomic,assign) BOOL                    canSearchCell;

//第一页数据url string
@property (nonatomic,copy  ) NSString                * firstUrlString;

//所有的tableView的数据的数组。包裹的对象是BMSingleUrlContentModel
@property (nonatomic,strong) NSMutableArray          *dataArray;


//当前tableview 中有多少行cell。用处：上拉刷新时，知道在哪里插入数据
@property(nonatomic,assign) NSInteger                  allCellCount;


//该 tableView 在 scrollView 中的 x坐标
@property(nonatomic,assign) CGFloat  tableViewInScrollViewX;

//那个页数被选中的 iv
@property(nonatomic,weak) UIImageView *pageSelectedImageView;

@property(nonatomic,assign) NSInteger scrollImageCount; //滚动图的数量
@end




@implementation BMContentTableView
//页数显示的图片的宽度 高度也是他们
static const CGFloat   siglePageControlWidth =6.f;
static const CGFloat   siglePageControlSelectWidth = 8.f;
//页数图片之间的间隔
static const CGFloat  pageImageMargin = 8.f;
//最后一个页数图片 距离右边的距离
static const CGFloat  lastPageImageMaringRight = 10.f;



-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(instancetype)initContentTableViewFirstUrlString:(NSString *)firstUrlString isHasScroll:(BOOL)isHasScroll inScrollViewX:(CGFloat) x
{
  self =   [super init];
    __weak typeof(self) replaceSelf = self;
    _isHasScroll = isHasScroll;
    if (self) {
    
        _tableViewInScrollViewX = x;
        //如果有滚动图 在没有数据的时候就已经 2 个 cell 了，否则只有 1 个
        isHasScroll == YES ? (_allCellCount = 2): (_allCellCount = 1);
    
        
        _firstUrlString            = firstUrlString;
        //默认是可以调整 searchCell 合适的显示的
        _canSearchCell             = YES;

        
        
        
        /**
         *设置下拉刷新
         */
     MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoadData:)];

      [header setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"common_loading_anne_0"]] forState:MJRefreshStateIdle]; //设置普通状态的动画图片
      [header setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"common_loading_anne_1"]] forState:MJRefreshStatePulling]; //设置即将刷新状态的动画图片
        //设置正在熟悉状态的动画图片
        [header setImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"common_loading_anne_0"],[UIImage imageNamed:@"common_loading_anne_1"],nil] forState:MJRefreshStatePulling];
        self.mj_header             = header;

        
        
        /**
         *  设置上拉刷新
         */
        MJRefreshBackNormalFooter *footer   = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData:)];
       // 设置文字
        [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateIdle];
        [footer setTitle:@"松开即可加载更多..." forState:MJRefreshStatePulling];
        [footer setTitle:@"正在加载更多..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据..." forState:MJRefreshStateNoMoreData];
        self.mj_footer = footer;
        



//        self.contentOffset         = CGPointMake(0, -44);
        replaceSelf.delegate       = replaceSelf;
        replaceSelf.dataSource     = replaceSelf;


        //刚刚进来时获取数据
        [self getDataAndUpdateTableView:_firstUrlString withMJRefreshGifHeader:nil withMJRefreshBackNormalFooter:nil];


        }
    return self;
}


#pragma mark 获取数据并刷新
/**
 *  使用在初始化时获取数据 和刷新的时候获取数据
 *
 *  @param urlString 获取数据的地址
 *  @param header    下拉刷新时获取数据的下拉刷新控件
 *  @param footer    上拉刷新时获取数据的上拉刷新控件
 */
-(void) getDataAndUpdateTableView:(NSString *) urlString withMJRefreshGifHeader:(MJRefreshGifHeader *) header withMJRefreshBackNormalFooter:(MJRefreshBackNormalFooter *)footer
{
    


    
    //重新获取数据
    __weak BMSingleUrlContentModel *contentModel = [BMSingleUrlContentModel singleUrlContentModelWithUrlString:urlString];
    __weak typeof(self) replaceSelf = self;
    
    
    contentModel.getModelAfterBlock = ^(){
       
        
        
     _contentModel = contentModel;
//        NSLog(@"重新获取数据:%@",contentModel.listCellModelArray);
        
      
        if (footer) {  //如果是上拉刷新
            
            [self.dataArray addObject:contentModel]; //将每次获取到的数据到加载进来
             _allCellCount += _contentModel.listCellModelArray.count;
            NSMutableArray *newData = [NSMutableArray arrayWithCapacity:contentModel.listCellModelArray.count];
           
            for (int i = 0 ; i < contentModel.listCellModelArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allCellCount + i inSection:0];
                [newData addObject:indexPath];
            }
            [self insertRowsAtIndexPaths:newData withRowAnimation:UITableViewRowAnimationBottom];
            
//            NSLog(@"上拉刷新");
            
            
        }else {
            
            if (header) { //如果是下拉刷新 获取数据,就结束刷新.否则就不执行
                if (_dataArray) {  //下拉刷新替换 而不是增加
                 BMSingleUrlContentModel* con =(BMSingleUrlContentModel*) self.dataArray[0];
                 con = contentModel;
                }
                
                [header endRefreshing];  //刷新结束
            }else { //第一次创建
                [self.dataArray addObject:contentModel]; //将每次获取到的数据到加载进来
            }
            
            [replaceSelf reloadData];
        }
        
       
      

        
    };
}

/**
 *
 * 下拉刷新数据
 *  @param header 下拉刷新控件
 */
-(void) downLoadData:(MJRefreshGifHeader *) header
{
 

    [self getDataAndUpdateTableView:_firstUrlString withMJRefreshGifHeader:header withMJRefreshBackNormalFooter:nil];

    //调整 searchcell的显示位置
    _canSearchCell = NO;
    self.frame = CGRectMake(_tableViewInScrollViewX, -44, screenWidth, screenHeight - 64);
    _canSearchCell = YES;
}


/**
 *  上拉刷新
 *
 *  @param footer 上拉刷新控件
 */
-(void) upLoadData:(MJRefreshBackNormalFooter *) footer{
    
    
    [self getDataAndUpdateTableView:[newsUrlPath stringByAppendingString:_contentModel.next] withMJRefreshGifHeader:nil withMJRefreshBackNormalFooter:footer];
    [footer endRefreshing];
}


#pragma  mark 图片的页数控件创建
-(void) createPageControlWithImageArray:(NSArray*)scrollImageArray inCell:(UITableViewCell *)cell{
//    NSLog(@"createPageControl");
    CGFloat pageControlX = screenWidth -  (scrollImageArray.count * (siglePageControlWidth + pageImageMargin ) - pageImageMargin  + lastPageImageMaringRight);
    CGFloat pageControlY = (screenWidth * 0.5 * 1/8 - siglePageControlWidth) * 0.5;
    
    for (int i = 0 ; i < scrollImageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(pageControlX + (siglePageControlWidth + pageImageMargin) * i,screenWidth * 0.5  -  pageControlY-siglePageControlWidth, siglePageControlWidth, siglePageControlWidth)];
        imageView.image = [UIImage imageNamed:@"list_news_tab_image_background"];
//        NSLog(@"createPageControlx:%f-y:%f",pageControlX + (siglePageControlWidth + pageImageMargin) * i,screenWidth * 0.5  -  pageControlY-siglePageControlWidth);
        [cell.contentView addSubview:imageView];
        
    }
}

/**
 * 是当前页数的图片
 */
-(void) pageSelectedImageWithImageArray:(NSArray*)scrollImageArray inCell:(UITableViewCell *)cell{
    self.scrollImageCount = scrollImageArray.count;
    
    CGFloat pageControlX = screenWidth -  (scrollImageArray.count * (siglePageControlWidth + pageImageMargin ) - pageImageMargin  + lastPageImageMaringRight);
    CGFloat pageControlY = (screenWidth * 0.5 * 1/8 - siglePageControlWidth) * 0.5;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(pageControlX + (siglePageControlWidth + pageImageMargin) * 0 - 1, screenWidth * 0.5 -  pageControlY-siglePageControlWidth - 1, siglePageControlSelectWidth, siglePageControlSelectWidth)];
    iv.image = [UIImage imageNamed:@"list_news_tab_image_select"];
    _pageSelectedImageView = iv;
    
    //接收通知 页数改变了之后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIndex:) name:@"changeIndex" object:nil];;
    [cell.contentView addSubview:iv];
}
-(void)changeIndex:(NSNotification *) no{
    
//    NSLog(@"changeIndex%@",no.userInfo[@"index"]);
    NSInteger index =[no.userInfo[@"index"] integerValue];
        //设置选中那个页数图片
    
         CGFloat pageControlX = screenWidth - ( self.scrollImageCount * (siglePageControlWidth + pageImageMargin ) - pageImageMargin  + lastPageImageMaringRight);
         CGFloat pageControlY = (screenWidth * 0.5 * 1/8 - siglePageControlWidth) * 0.5;
       _pageSelectedImageView.frame = CGRectMake(pageControlX + (siglePageControlWidth + pageImageMargin) * index - 1.f, screenWidth * 0.5  -  pageControlY-siglePageControlWidth - 1, siglePageControlSelectWidth, siglePageControlSelectWidth);
}

#pragma mark UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHasScroll) {
        return  _dataArray.count*20 + 2;
    }
    return _dataArray.count*20 + 1;
}


-(UITableViewCell *)createCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //搜索 cell
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
            cell.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];

            
            UISearchBar *searchBar = [[UISearchBar alloc] init];
            searchBar.userInteractionEnabled = NO; //不允许用户交互，直接跳转...
            
            searchBar.layer.cornerRadius = 6.f;
            searchBar.layer.masksToBounds = YES;
            searchBar.backgroundImage  = [UIImage imageNamed:@"search_item_bg"];
            searchBar.placeholder = @"搜索您想了解的资讯";
            [cell.contentView addSubview:searchBar];
            [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).offset(5);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
                make.left.equalTo(cell.contentView.mas_left).offset(10);
                make.right.equalTo(cell.contentView.mas_right).offset(-10);
            }];
        }
        
        
        return cell;
    }
    
    //有滚动图的 tableView
    if (_isHasScroll) {  //有滚动视图
        
            //图片轮播cell
            if (indexPath.row == 1) {
              
                
                
                
                NSString *identifier = @"imageScroll";
                UITableViewCell *imageScrollCell = [tableView dequeueReusableCellWithIdentifier:identifier];
          
                if (!imageScrollCell) {
                    imageScrollCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    
                    //创建页数控制视图
                
                    
                    //发送网络请求 获取到图片滚动视图的json数据
                    [BMNetworing BMNetworingWithUrlString:@"http://qt.qq.com/static/pages/news/phone/c13_list_1.shtml" commpleWithNSDictionary:^(NSDictionary *jsonData) {
                        
                        
                        //字典转模型
                        NSMutableArray *modelArray = [NSMutableArray array];
                        for (NSDictionary *dict in jsonData[@"list"]) {
                            BMNewsContentCellModel *model  = [BMNewsContentCellModel newsContentCellModelWithDict:dict];
                            [modelArray addObject:model];
                        }
                       
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //创建滚动视图
                            BMScollView *scrollView = [BMScollView BMScrollImages:modelArray offest:CGPointMake(0, 0) scrollViewSize:CGSizeMake(screenWidth, screenWidth * 0.5)];
                            scrollView.frame =  CGRectMake(0, 0, screenWidth, screenWidth * 0.5);
                            //将视图添加到cell中
                            [imageScrollCell.contentView addSubview:scrollView];
                            
                            
                            //创建页数控制视图
                            [self createPageControlWithImageArray:modelArray inCell:imageScrollCell];
                            [self pageSelectedImageWithImageArray:modelArray inCell:imageScrollCell];
                            
                            [self reloadData];
                        });
                  
                    }];
                    
                }
                
                
                return imageScrollCell;
        }
    }
    
    
    int k  = 1;
    if (_isHasScroll) {
        k = 2;
    }
    
    //取__dataArray 中的第几个元素
    NSInteger j  = (indexPath.row - k ) / 20;
    BMSingleUrlContentModel *model = (BMSingleUrlContentModel *)_dataArray[j];
    //取 model 中的第几个 元素
    NSInteger i  = (indexPath.row - k ) % 20;
    
    //_contentModel.listCellModelArray[indexPath.row -k ]
    BMNesContentTableViewCell *cell = [BMNesContentTableViewCell newsContentTableViewCellWithContentModel:model.listCellModelArray[i] tableView:self];
    
    return cell;
}

#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   return  [self createCellTableView:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return  44.f;
    }
    if (_isHasScroll) { //有滚动视图
        if (indexPath.row == 1) {
            return  screenWidth * 0.5;
        }
    }
    return 80.f;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
   
    
    if (indexPath.row != 0) {
        
    
    //取出数据
    
    int k  = 1;
    if (_isHasScroll) {
        k = 2;
    }
    //取__dataArray 中的第几个元素
    NSInteger j  = (indexPath.row - k ) / 20;
    BMSingleUrlContentModel *model = (BMSingleUrlContentModel *)_dataArray[j];
    //取 model 中的第几个 元素
    NSInteger i  = (indexPath.row - k ) % 20;
    BMNewsContentCellModel *cellModel = model.listCellModelArray[i];
    
    //取到 html 的 url
    
    NSString *article_url = cellModel.article_url;
    
    if(![article_url hasPrefix:@"http://"]){ //不是视频链接 拼接 url
        article_url = [newsUrlPath stringByAppendingString:article_url];
    }
    NSLog(@"articel_rul:%@",article_url);
    //创建控制器
    BMWebVC *webVc = [[BMWebVC alloc] init];
    webVc.urlString = article_url;
    webVc.isVideo = NO;
    if ([self.webVcDelegate respondsToSelector:@selector(cellClickGoToWithBMConTableView:GoToWBMWebV:)]) {
        [self.webVcDelegate cellClickGoToWithBMConTableView:self GoToWBMWebV:webVc];
    }
    }
    
    else { //搜索 cell，图片滚动 cell 不可交互，所以当滚动 cell 被点击之后，不会在这里调用
        if ([self.webVcDelegate respondsToSelector:@selector(bmContentTable:GotoBMSearchVC:)]) {
            BMSearchViewController *serchVc = [[BMSearchViewController alloc] init];
            serchVc.hidesBottomBarWhenPushed = YES;
     
            
            [self.webVcDelegate bmContentTable:self GotoBMSearchVC:serchVc];
        }
    }
    
}



#pragma mark 搜索 cell 可隐藏在 navigationbar 下

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (_canSearchCell) {
        
    if(self.contentOffset.y < 0 && self.frame.origin.y == -44) // 偏移量大于y 小于0=== 意味着是在向下滚动
    {
        [UIView animateWithDuration:0.3f animations:^{
            
            self.frame = CGRectMake(_tableViewInScrollViewX, 0, screenWidth, screenHeight - 64 -44);
        }];
            }else if(self.contentOffset.y > 0 && self.frame.origin.y == 0) //y>0意味着向上滚动
    {
        [UIView animateWithDuration:0.3f animations:^{
            
            self.frame = CGRectMake(_tableViewInScrollViewX, -44, screenWidth, screenHeight - 64);
        }];
      
    }
}
  
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
