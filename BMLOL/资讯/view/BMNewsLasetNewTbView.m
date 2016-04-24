//
//  BMNewsLasetNewTbView.m
//  BMLOL
//
//  Created by donglei on 16/4/23.
//  Copyright © 2016年 donglei. All rights reserved.
// //  这个类废弃

#import "BMNewsLasetNewTbView.h"
#import "BMScollView.h"
#import "BMNetworing.h"
#import "BMNewsContentCellModel.h"

@interface BMNewsLasetNewTbView()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@end

@implementation BMNewsLasetNewTbView



#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [super numberOfRowsInSection:section] + 1;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //图片轮播cell
    if (indexPath.row == 1) {
        NSString *identifier = @"imageScroll";
        UITableViewCell *imageScrollCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!imageScrollCell) {
            imageScrollCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        
        
        //发送网络请求 获取到图片滚动视图的json数据
        [BMNetworing BMNetworingWithUrlString:@"http://qt.qq.com/static/pages/news/phone/c13_list_1.shtmlf" commpleWithNSDictionary:^(NSDictionary *jsonData) {
          
            
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
    
   return  [super createCellTableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return  screenWidth * 0.5;
    }
    return  [super rowHeight];
}


@end
