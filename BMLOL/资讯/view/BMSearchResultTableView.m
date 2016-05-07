//
//  BMSearchResultTableView.m
//  BMLOL
//
//  Created by donglei on 16/5/7.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMSearchResultTableView.h"
#import "BMNetworing.h"
#import "BMNewsContentCellModel.h"
#import "BMNesContentTableViewCell.h"
#import "BMWebVC.h"
#import <MJRefresh.h>

@interface BMSearchResultTableView()
<
    UITableViewDelegate,
    UITableViewDataSource
>




@property(nonatomic,assign) NSInteger currentPage;


@end


@implementation BMSearchResultTableView

-(NSMutableArray *) dataModelArray{
    if (!_dataModelArray) {
        _dataModelArray  = [NSMutableArray array];
    }
    return _dataModelArray;
}

-(instancetype) init
{
    if (self = [super init]) {
        self.delegate = self;
        self.dataSource = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyWordChange) name:@"searchChange" object:nil];
        
        
        
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
    }
    return self;
}



#pragma mark UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModelArray.count * 10 ;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     NSInteger arrayOne =  indexPath.row / 10 ; //一维数组下标
     NSInteger arrayTwo =  indexPath.row -  arrayOne * 10; //二维数组下标
 
     BMNewsContentCellModel *model = self.dataModelArray[arrayOne][arrayTwo];
   
     BMNesContentTableViewCell *cell = [BMNesContentTableViewCell newsContentTableViewCellWithContentModel:model tableView:tableView];
     return cell;
 }



#pragma  mark UITableViewDelegate
-(CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger arrayOne =  indexPath.row / 10 ; //一维数组下标
    NSInteger arrayTwo =  indexPath.row -  arrayOne * 10; //二维数组下标
    
    BMNewsContentCellModel *model = self.dataModelArray[arrayOne][arrayTwo];
    //创建控制器
    BMWebVC *webVc = [[BMWebVC alloc] init];
    webVc.urlString = model.article_url;
    webVc.isVideo = NO;
    
    if ([self.searchResulteDelegate respondsToSelector:@selector(BMSearchResultTableView:WebVc:)]) {
        [self.searchResulteDelegate BMSearchResultTableView:self WebVc:webVc];
    }
}

-(void) KeyWordChange{
    [self loadDataWithHeader:nil footer:nil pageNumber:0];
}
//加载数据
-(void)loadDataWithHeader:(MJRefreshGifHeader *) header footer:(MJRefreshBackNormalFooter *) footer pageNumber:(NSInteger) pageNumber{

    __weak typeof(self) replaceSelf = self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://qt.qq.com/php_cgi/lol_mobile/iso/php/search_articles.php?keyword=%@&page=%ld&num=10&plat=ios&version=3",self.keyWord,(long)pageNumber];
    NSLog(@"urlString%@",urlString);
    [BMNetworing BMNetworingWithUrlString:urlString commpleWithNSDictionary:^(NSDictionary *jsonData) {
        
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *middleArray = [NSMutableArray array];
        
        array = jsonData[@"list"];
      
        
       
        for (NSDictionary *dict in array) {
            BMNewsContentCellModel *cellModel = [BMNewsContentCellModel newsContentCellModelWithDict:dict];
            [middleArray addObject:cellModel];
        }
        if (header) { //下拉刷新数据
            if (replaceSelf.dataModelArray) {
                
                [replaceSelf.dataModelArray replaceObjectAtIndex:0 withObject:middleArray];
            }else {
                [replaceSelf.dataModelArray addObject:middleArray];
            }
            //在主线程中刷新表格
            dispatch_async(dispatch_get_main_queue(), ^{
                [replaceSelf reloadData];
                [header endRefreshing];
            });
            

        }else if (footer) { //上拉刷新数据
            
              NSMutableArray *newData = [NSMutableArray array];
            NSInteger insertPage = replaceSelf.dataModelArray.count * 10;
            [replaceSelf.dataModelArray addObject:middleArray];
           
            for (int i = 0 ; i < middleArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:insertPage + i inSection:0];
                [newData addObject:indexPath];
            }
            

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self insertRowsAtIndexPaths:newData withRowAnimation:UITableViewRowAnimationNone];
                [footer endRefreshing];
            });
            
        }else {
            
            [replaceSelf.dataModelArray addObject:middleArray];
            
            
            //在主线程中刷新表格
            dispatch_async(dispatch_get_main_queue(), ^{
                [replaceSelf reloadData];
            });
        }
        
    }];
}

/**
 *
 * 下拉刷新数据
 *  @param header 下拉刷新控件
 */
-(void) downLoadData:(MJRefreshGifHeader *) header
{
    
    
    [self loadDataWithHeader:header footer:nil pageNumber:0];
    
    
}


/**
 *  上拉刷新
 *
 *  @param footer 上拉刷新控件
 */
-(void) upLoadData:(MJRefreshBackNormalFooter *) footer{
    
  
    [self loadDataWithHeader:nil footer:footer pageNumber:++self.currentPage];
}


@end

