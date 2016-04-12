//
//  BMSingleUrlContentModel.h
//  BMLOL
//
//  Created by donglei on 16/4/12.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMSingleUrlContentModel : NSObject

/**
 *  下一个url 刷新用的
 */

@property(nonatomic,copy) __block NSString *next;
/**
 *  这条URL中的cellModel的数量
 */
@property(nonatomic,assign) __block NSInteger this_page_num;

/**
 *  这条URL的cellModel数组
 */
@property(nonatomic,strong)__block NSMutableArray *listCellModelArray;

/**
 *  初始化
 *
 *  @param urlString url
 *
 *  @return 对象
 */
-(instancetype) initSingleUrlContentModelWithUrlString:(NSString *) urlString;

+(instancetype) singleUrlContentModelWithUrlString:(NSString *) urlString;
@end
