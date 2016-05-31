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
    NSURLSessionDataTask *data = [getHeroList dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
		NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		
		
        if (!error) {
			NSError *ee;
            NSDictionary * d  =   [NSJSONSerialization JSONObjectWithData:[[self stringByRemovingControlCharacters:s] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&ee];
			NSLog(@"eerr:%@",ee);
            commple(d);
        }else {
            NSLog(@"网络请求错误");
        }
        
        
    }];
    [data resume];
}

//去除字符串中未转义的字符
+(NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
	NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
	NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
	if (range.location != NSNotFound) {
		NSMutableString *mutable = [NSMutableString stringWithString:inputString];
		while (range.location != NSNotFound) {
			[mutable deleteCharactersInRange:range];
			range = [mutable rangeOfCharacterFromSet:controlChars];
		}
		return mutable;
	}
	return inputString;
}
@end
