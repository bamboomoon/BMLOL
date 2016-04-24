//
//  BMNewsContentCellModel.h
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

/**
 *
 *cell的数据模型
 */

#import <Foundation/Foundation.h>

@interface BMNewsContentCellModel : NSObject

@property(nonatomic,copy) NSString *title; //cell的标题

@property(nonatomic,copy) NSString *detailTitle; //cell的子标题

@property(nonatomic,copy) NSString *time;//cell中 多少分钟之前...

@property(nonatomic,copy) NSString *article_url;//文章链接

@property(nonatomic,copy) NSString *image_url_small; //图片链接 只适配 屏幕宽度320的所以 只获取这个图片链接


@property(nonatomic,copy) NSString *image_url_big;  //大图片

+(instancetype) newsContentCellModelWithDict:(NSDictionary *)cellDataDict; //工程方法

-(instancetype) initNewsContentCellModelWithDict:(NSDictionary *)cellDataDict;

@end
