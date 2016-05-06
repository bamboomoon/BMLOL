//
//  BMSearchTv.m
//  BMLOL
//
//  Created by donglei on 16/5/2.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMSearchTv.h"
#import "BMNetworing.h"
#import "BMSearchRecordModel.h"
#import "BMSearchRecordCell.h"


@interface BMSearchTv()
<
    UITableViewDelegate,
    UITableViewDataSource
 
>

//最热搜索
@property(nonatomic,copy) __block NSString * hotSearchTitle;

//最热搜索列表
@property(nonatomic,strong) __block NSArray *hotSerchArray;


//数据库对象
@property(nonatomic,strong) BMSearchRecordModel *searchRecordModel;



@end

@implementation BMSearchTv


-(instancetype) initSearchTableViewWithHotSearchUrlString:(NSString *) hotSearchUrlString frame:(CGRect ) frame
{
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        
        
        self.tableFooterView = [[UIView alloc] init];

       
        //设置tableview 的 headerView 高度为0.1f
            CGRect headerViewframe = self.tableHeaderView.frame;
            headerViewframe.size.height = 0.1;
            UIView *headerView = [[UIView alloc] initWithFrame:headerViewframe];
            [self setTableHeaderView:headerView];
    
        //从数据库中获取搜索记录
        self.searchRecordModel = [BMSearchRecordModel getShareInstace];
        self.searchRecordArray = [_searchRecordModel findSearch];
        if (self.searchRecordArray.count <= 2) {
            self.isShowAllRecord = YES;
        }else{
            self.isShowAllRecord = NO;
        }
        NSLog(@"findSearch:%@",[_searchRecordModel findSearch]);
       
        //1> 通过 urlString 异步获取数据 并转模型 刷新表格
        [BMNetworing BMNetworingWithUrlString:hotSearchUrlString commpleWithNSDictionary:^(NSDictionary *jsonData) {
            self.hotSearchTitle =  jsonData[@"title"];
            self.hotSerchArray  =  [NSArray array];
            self.hotSerchArray  = jsonData[@"list"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];//主线程刷新数据
            });
        }];
    
        //2> 设置代理 处理代理
        self.dataSource = self;
        self.delegate   = self;
        
    }
    return self;
}

+(instancetype) searchTableViewWithHotSearchUrlString:(NSString *)hotSearchUrlString frame:(CGRect ) frame
{
    return [[self alloc] initSearchTableViewWithHotSearchUrlString:hotSearchUrlString frame:(CGRect ) frame];
}

#pragma mark UITableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchRecordArray.count == 0) {  //如果搜索记录为空的话，就只有一组
        return 1;
    }
    return 2;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self numberOfSections] == 1) {  //只有一组，就只有 热搜
        
        return _hotSerchArray.count + 1;
    }
    if ([self numberOfSections] == 2) {
        if (section == 1) {
            return _hotSerchArray.count + 1;
        }else if(section == 0){ //搜索记录
          
            if (self.isShowAllRecord) {
                
                return  _searchRecordArray.count + 1;
            }else {
                return 3; //如果不显示全部的搜索记录。就显示2个最近的和全部显示按钮
            }
            
        }
    }
    return 0;
}



-(UITableViewCell *) createHotRearchCellIndexPath:(NSIndexPath *) indexPath tableView:(UITableView *)tableView{
    if(indexPath.row == 0) //创建 hot cell
    {
        UITableViewCell *hotCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
        hotCell.textLabel.text = _hotSearchTitle;
        
        //label 实际显示出来的宽度
        CGFloat width =   [_hotSearchTitle sizeWithFont:[UIFont systemFontOfSize:20.f] constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width;
        
        hotCell.textLabel.textColor = [UIColor grayColor];
        UIImageView *hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_news_item_hot_mark"]];
        [hotCell.contentView addSubview:hotImageView];
        [hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hotCell.textLabel.mas_left).with.offset(width);
            make.size.mas_equalTo(CGSizeMake(24, 12));
            make.centerY.mas_equalTo(hotCell.textLabel.mas_centerY);
        }];
        
        return hotCell;
    }
    
    NSString *identifier = @"hotSerchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dict = _hotSerchArray[indexPath.row - 1];
    cell.textLabel.text = dict[@"keyword"];
    return cell;
}

/**
 *  创建清空记录/显示全部记录 cell
 *
 *  @param title     清空记录 / 显示全部 jil
 *  @param tableView tableViw
 *
 *  @return cell
 */
-(UITableViewCell *)createSearchRecordCellWithCleanBtnTitle:(NSString *)title tableView:(UITableView *)tableView {
    UITableViewCell *cleanRecordCell = [tableView dequeueReusableCellWithIdentifier:@"celanRecordCell"];
    
    UIButton *cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - 100) * 0.5, 10, 100, 22)];
    self.cleanBtn = cleanBtn;
    [cleanBtn addTarget:self action:@selector(cleanRecordBtnClicked:) forControlEvents:UIControlEventTouchUpInside]; //增加 清空历史记录/显示全部记录 按钮点击事件
    cleanBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    cleanBtn.clipsToBounds = YES;
    cleanBtn.layer.cornerRadius = 3;
    cleanBtn.layer.borderWidth = 1;
    cleanBtn.layer.borderColor = [[UIColor blueColor] CGColor];
    [cleanBtn setTitle:title  forState:UIControlStateNormal];
    [cleanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if (!cleanRecordCell) {
        cleanRecordCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celanRecordCell"];
    
        [cleanRecordCell.contentView addSubview:cleanBtn];
    }
    
    return cleanRecordCell;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self numberOfSections] == 1) {  //只有一组，就只有 热搜
        
       return  [self createHotRearchCellIndexPath:indexPath tableView:tableView];
    }
    if ([self numberOfSections] == 2) {
        if (indexPath.section == 1) {
          return   [self createHotRearchCellIndexPath:indexPath tableView:tableView];
        }else if(indexPath.section == 0){ //搜索记录
           
            if (self.isShowAllRecord) { //显示全部
                if (indexPath.row == _searchRecordArray.count ) {  //最后一行  清空记录 或者 显示全部
                  return   [self createSearchRecordCellWithCleanBtnTitle:@"清空全部记录" tableView:tableView];
                }
            }else {
                if (indexPath.row == 2) {
                    return   [self createSearchRecordCellWithCleanBtnTitle:@"显示全部记录" tableView:tableView];
                }
            }
            BMSearchRecordCell *cell = [BMSearchRecordCell searchRecordCellTitle:_searchRecordArray[_searchRecordArray.count - 1 - indexPath.row] tableView:tableView];
            return cell;
        }
    }
    return nil;
 
}


#pragma mark UITableViewDelegate
//让热搜第一行不高亮  历史记录最后一行不高亮
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self numberOfSections]  == 2 ) {
        if (indexPath.section == 0) {
            if (self.isShowAllRecord) {
                if (indexPath.row == _searchRecordArray.count) {
                    return NO;
                }
            }else {
                if (indexPath.row == 2) {
                    return  NO;
                }
            }
            
        }
        else {
            if (indexPath.row == 0) {
                return NO;
            }
        }
    }else{
        if (indexPath.row == 0) {
            return NO;
        }
    }
    
    return YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    if ([self numberOfSections] == 2) {
       if(section == 1)
        {
            return 10.f;
        }
    }
    return 0.1f;
}




#pragma mark 删除历史数据的辅助视图 点击事件
- (void)checkButtonTapped:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];   // 把触摸的事件放到集合里
    
    UITouch *touch = [touches anyObject];   // 把事件放到触摸的对象了
    
    //把触发的这个点转成TableView二维坐标
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    //匹配坐标点
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:currentTouchPosition];
    
    if(indexPath){
        
     
        //通过 indexPath 获取到对应的 cell 上显示的 text并删除
        NSLog(@"%@",[self cellForRowAtIndexPath:indexPath].textLabel.text);
        [self.searchRecordModel deleteRecord:[self cellForRowAtIndexPath:indexPath].textLabel.text];
        self.searchRecordArray = [_searchRecordModel findSearch];
        [self reloadData];
        
      
    }
    
}


#pragma mark  增加 清空历史记录/显示全部记录 按钮点击事件

-(void) cleanRecordBtnClicked:(UIButton *) cleanBtn{
    
    if(self.isShowAllRecord){ //已经显示的是全部的搜索记录；所以这个按钮被点击时  应该清空全部的记录
        NSLog(@"清空%d",[self.searchRecordModel cleanRecordTable]);

      
    }else{
        NSLog(@"显示全部");
        self.isShowAllRecord = YES;
   
            [cleanBtn setTitle:@"清空全部记录" forState: UIControlStateNormal];
    }
     self.searchRecordArray = [_searchRecordModel findSearch];
    [self reloadData];
}

@end
