//
//  BMSearchRecordModel.h
//  BMLOL
//
//  Created by donglei on 16/5/3.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMSearchRecordModel : NSObject

//插入数据
- (BOOL) saveDataName:(NSString*)serchWord;
- (NSArray*) findSearch; //搜索出所有的记录
+(instancetype) getShareInstace;

//删除数据 一行
-(BOOL) deleteRecord:(NSString *)recordString;

//清空搜索记录表
-(BOOL) cleanRecordTable;
@end
