//
//  BMNetworing.h
//  BMLOL
//
//  Created by donglei on 3/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMNetworing : NSObject
/**
 *  传入一个 URL string 获得json 数据 这是一个类方法
 *
 *  @param urlString url 字符串
 *
 *  @return json 数据
 *///- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
+(void)BMNetworingWithUrlString:(NSString *)urlString commpleWithNSArray:(void (^)(NSArray *jsonData))commple;  //返回的数组

+(void)BMNetworingWithUrlString:(NSString *)urlString commpleWithNSDictionary:(void (^)(NSDictionary *jsonData))commple; //返回是字典
@end
