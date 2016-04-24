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



@interface BMContentTableView()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)  BMSingleUrlContentModel *contentModel;  //cell的模型数组

@property(nonatomic,assign) BOOL isHasScroll;  //这个tableview 是否有图片的滚动视图
@end




@implementation BMContentTableView


-(instancetype)initContentTableViewFirstUrlString:(NSString *)firstUrlString isHasScroll:(BOOL)isHasScroll
{
  self =   [super init];
    __weak typeof(self) replaceSelf = self;
    _isHasScroll = isHasScroll;
    if (self) {
    
        
    self.translatesAutoresizingMaskIntoConstraints = NO; //解决自动布局 崩溃的问题
    
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




#pragma mark UITableViewDataSource








-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHasScroll) {
        NSLog(@"tableView ---- numberOfRowsInSection");
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





@end
