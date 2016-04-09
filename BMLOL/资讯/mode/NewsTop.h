//
//  NewsTop.h
//  BMLOL
//
//  Created by donglei on 16/4/7.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTop : NSManagedObject

-(void) addModelDataWith:(NSDictionary *)dict;  //向数据库中添加数据使用dict

@end

NS_ASSUME_NONNULL_END

#import "NewsTop+CoreDataProperties.h"
