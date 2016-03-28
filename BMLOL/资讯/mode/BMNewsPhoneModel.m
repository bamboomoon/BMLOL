//
//  BMNewsPhoneModel.m
//  BMLOL
//
//  Created by donglei on 3/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//  url:http://qt.qq.com/static/pages/news/phone/index.js

#import "BMNewsPhoneModel.h"
#import <MJExtension/MJExtension.h>
@implementation BMNewsPhoneModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"newsId":@"id" //模型中的 newsId 对应 json 中的 id
             };
}
@end
