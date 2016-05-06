//
//  BMSearchTv.h
//  BMLOL
//
//  Created by donglei on 16/5/2.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMSearchTv : UITableView

-(instancetype) initSearchTableViewWithHotSearchUrlString:(NSString *) hotSearchUrlString frame:(CGRect ) frame;


+(instancetype) searchTableViewWithHotSearchUrlString:(NSString *) hotSearchUrlString frame:(CGRect ) frame;

//搜索记录数组
@property(nonatomic,strong)  NSArray *searchRecordArray;

//是否显示全部的搜索记录
@property(nonatomic,assign) BOOL isShowAllRecord;

//清空/显示 全部记录 按钮
@property(nonatomic,strong) UIButton *cleanBtn;
@end
