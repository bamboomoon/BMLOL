//
//  BMPackageInfo.h
//  BMLOL
//
//  Created by donglei on 3/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//  这是 jsonurl  和 imgurl 的模型

#import <Foundation/Foundation.h>

@interface BMPackageInfo : NSObject
@property(nonatomic,copy) NSString *json_last_modify_time;
@property(nonatomic,copy) NSString *img_size;
@property(nonatomic,copy) NSString *json_size;
@property(nonatomic,copy) NSString *json_md5;
@property(nonatomic,copy) NSString *json_rul;
@property(nonatomic,copy) NSString *img_md5;
@property(nonatomic,copy) NSString *img_url;
@property(nonatomic,copy) NSString *img_last_modify_time;
@end
