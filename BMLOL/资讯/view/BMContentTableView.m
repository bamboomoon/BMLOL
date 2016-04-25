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
#import <MJRefresh.h>


@interface BMContentTableView()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)  BMSingleUrlContentModel *contentModel;  //cell的模型数组

@property(nonatomic,assign) BOOL isHasScroll;  //这个tableview 是否有图片的滚动视图


@property(nonatomic,assign) BOOL canSearchCell;  //是否调整 tableview 的 frame 以使searchCell 合适的显示
@end




@implementation BMContentTableView



-(instancetype)initContentTableViewFirstUrlString:(NSString *)firstUrlString isHasScroll:(BOOL)isHasScroll
{
  self =   [super init];
    __weak typeof(self) replaceSelf = self;
    _isHasScroll = isHasScroll;
    if (self) {
    
        
        //默认是可以调整 searchCell 合适的显示的
        _canSearchCell = YES;
        
        //设置下拉刷新
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoadData:)];
      
        [header setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"common_loading_anne_0"]] forState:MJRefreshStateIdle]; //设置普通状态的动画图片
      [header setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"common_loading_anne_1"]] forState:MJRefreshStatePulling]; //设置即将刷新状态的动画图片
        //设置正在熟悉状态的动画图片
        [header setImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"common_loading_anne_0"],[UIImage imageNamed:@"common_loading_anne_1"],nil] forState:MJRefreshStatePulling];
        self.mj_header = header;
    
        
  
       
        self.contentOffset = CGPointMake(0, -44);
        
        replaceSelf.delegate = replaceSelf;
            replaceSelf.dataSource = replaceSelf;
    
         __weak BMSingleUrlContentModel *contentModel = [BMSingleUrlContentModel singleUrlContentModelWithUrlString:firstUrlString];
            _contentModel = contentModel;
            //这里执行 模型 在异步在获取到数据之后 执行的方法
            contentModel.getModelAfterBlock = ^(){
    
                [replaceSelf reloadData];
            };
            
          
        }
    return self;
}


-(void) downLoadData:(MJRefreshGifHeader *) header
{
    NSLog(@"结束刷新");
    [header endRefreshing];
//    [UIView animateWithDuration:0.3f animations:^{
        _canSearchCell = NO;
        self.frame = CGRectMake(0, -44, screenWidth, screenHeight - 64);
      _canSearchCell = YES;
//    }];
}



#pragma mark UITableViewDataSource








-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHasScroll) {
        return _contentModel.listCellModelArray.count + 2;
    }
    return _contentModel.listCellModelArray.count + 1;
}


-(UITableViewCell *)createCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
            cell.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
            
            UISearchBar *searchBar = [[UISearchBar alloc] init];
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
                    
                    
                    __weak typeof(self) replaceSelf = self;
                    
                    //发送网络请求 获取到图片滚动视图的json数据
                    [BMNetworing BMNetworingWithUrlString:@"http://qt.qq.com/static/pages/news/phone/c13_list_1.shtml" commpleWithNSDictionary:^(NSDictionary *jsonData) {
                              NSLog(@"kuaima -imageScroll");
                        //第一张图片加载OK 发送通知刷新界面
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollImageok) name:@"scrollImageOk" object:nil];
                        
                        //字典转模型
                        NSMutableArray *modelArray = [NSMutableArray array];
                        for (NSDictionary *dict in jsonData[@"list"]) {
                            BMNewsContentCellModel *model  = [BMNewsContentCellModel newsContentCellModelWithDict:dict];
                            [modelArray addObject:model];
                        }
                        //创建滚动视图
                        BMScollView *scrollView = [BMScollView BMScrollImages:modelArray offest:CGPointMake(0, 0) scrollViewSize:CGSizeMake(screenWidth, screenWidth * 0.5)];
                        scrollView.frame =  CGRectMake(0, 0, screenWidth, screenWidth * 0.5);
                        //将视图添加到cell中
                        [imageScrollCell.contentView addSubview:scrollView];
                  
                    }];
                    
                }
                
                
                return imageScrollCell;
        }
    }
    
    
    int k  = 1;
    if (_isHasScroll) {
        k = 2;
    }
    BMNesContentTableViewCell *cell = [BMNesContentTableViewCell newsContentTableViewCellWithContentModel:_contentModel.listCellModelArray[indexPath.row -k ] tableView:self];
    
    return cell;
}

-(void) scrollImageok
{
    NSLog(@"scrollImageok");
    [self reloadData];
}

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



#pragma mark 搜索 cell 可隐藏在 navigationbar 下

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrool --x %f",self.frame.origin.y);
    if (_canSearchCell) {
        
    if(self.contentOffset.y < 0 && self.frame.origin.y == -44) // 偏移量大于y 小于0=== 意味着是在向下滚动
    {
        [UIView animateWithDuration:0.3f animations:^{
            
            self.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64 -44);
        }];
        NSLog(@"(self.contentOffset.x) > 0");
    }else if(self.contentOffset.y > 0 && self.frame.origin.y == 0) //y>0意味着向上滚动
    {
        [UIView animateWithDuration:0.3f animations:^{
            
            self.frame = CGRectMake(0, -44, screenWidth, screenHeight - 64);
        }];
        NSLog(@"(self.contentOffset.x) < 0");
    }
}
    NSLog(@"scrollViewDidScroll %f",self.contentOffset.y);
}



@end
