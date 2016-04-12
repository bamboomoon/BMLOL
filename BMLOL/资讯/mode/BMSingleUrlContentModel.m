//
//  BMSingleUrlContentModel.m
//  BMLOL
//
//  Created by donglei on 16/4/12.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMSingleUrlContentModel.h"
#import "BMNetworing.h"
#import "BMNewsContentCellModel.h"

@implementation BMSingleUrlContentModel


-(instancetype) initSingleUrlContentModelWithUrlString:(NSString *)urlString
{
    if (self = [super init])
    {
        
        __weak typeof(self) replaceSelf = self;
        
        
     
        
        replaceSelf.listCellModelArray = [NSMutableArray array];
        [BMNetworing BMNetworingWithUrlString:urlString commpleWithNSDictionary:^(NSDictionary *jsonData) {
            NSLog(@"jsondata:%@",jsonData[@"next"]);
            replaceSelf.next =  jsonData[@"next"]  ;
            replaceSelf.this_page_num = [(NSString *)jsonData[@"this_page_num"] integerValue];
            
            NSArray *listArray = [NSArray array];
            listArray =  jsonData[@"list"];
            
            for (NSDictionary *dict in listArray) {
                
                BMNewsContentCellModel *cellModel = [BMNewsContentCellModel newsContentCellModelWithDict:dict];
               [replaceSelf.listCellModelArray addObject:cellModel];
            }
            [self sss];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"%@",[NSThread currentThread]);
//                //数据赋值完成 发一个通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"listCellModelArrayOk" object:nil];
//                NSLog(@"你妹啊你法了吗");
//                
//            });
           
            
        }];
     
       
    }
    return self;
}


-(void) sss {
    NSLog(@"ss");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",[NSThread currentThread]);
        //数据赋值完成 发一个通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listCellModelArrayOk" object:nil];
        NSLog(@"你妹啊你法了吗");
        
    });}


+(instancetype) singleUrlContentModelWithUrlString:(NSString *)urlString
{
    return [[self alloc] initSingleUrlContentModelWithUrlString:urlString];
}


@end
