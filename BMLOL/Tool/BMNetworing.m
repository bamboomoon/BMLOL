;//
//  BMNetworing.m
//  BMLOL
//
//  Created by donglei on 3/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMNetworing.h"

@implementation BMNetworing
//+(NSArray *)BMNetworingWithUrlString:(NSString *)urlString
//{
//    
//    
//    //在这里去加载 herolist  和 heroinfo @"http://ossweb-img.qq.com/upload/qqtalk/lol_hero/hero_list.js"
//    
//    __block NSArray * dict ;
//    
//    __block int i = 2;
//  
//    NSURLSession *getHeroList = [NSURLSession sharedSession];
//    NSURLSessionDataTask *data = [getHeroList dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSArray * d  =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
////         dict = d;
//        dict = [NSArray arrayWithArray:d];
//        NSLog(@"%@--%@  array ::::%@  %d  name:%d",d,response,dict,i,[NSThread currentThread].isMainThread);
//        
//    }];
//    
//   
//    [data resume];
//    
//    return dict;
//}



+(void)BMNetworingWithUrlString:(NSString *)urlString commpleWithNSArray:(void (^)(NSArray *jsonData))commple{
        NSURLSession *getHeroList = [NSURLSession sharedSession];
        NSURLSessionDataTask *data = [getHeroList dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
            
                NSArray * d  =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                commple(d);
            }else {
                NSLog(@"网络请求错误");
            }
            
    
        }];
   
        [data resume];
}


+(void)BMNetworingWithUrlString:(NSString *)urlString commpleWithNSDictionary:(void (^)(NSDictionary *jsonData))commple{
    NSURLSession *getHeroList = [NSURLSession sharedSession];
    NSURLSessionDataTask *data = [getHeroList dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *err;
            NSDictionary * d  =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            
            
            commple(d);
        }else {
            NSLog(@"网络请求错误");
        }
        
        
    }];
    
    [data resume];
}
@end
