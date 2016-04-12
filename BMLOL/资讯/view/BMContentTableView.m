//
//  BMContentTableView.m
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMContentTableView.h"
#include "BMSingleUrlContentModel.h"



@interface BMContentTableView()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    BMSingleUrlContentModel *contentModel ;
}
@property(nonatomic,strong) NSMutableArray *modelArray;  //cell的模型数组


@end




@implementation BMContentTableView



-(instancetype) init{
   self =  [super init];
    __weak typeof(self) replaceSelf = self;
    if (self) {
        self.delegate = replaceSelf;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listCellModelOk) name:@"listCellModelArrayOk" object:nil]; //接受一个通知
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listCellModelArrayOk" object:nil];
        NSLog(@"接受一个通知");

   
        contentModel = [BMSingleUrlContentModel singleUrlContentModelWithUrlString:@"http://qt.qq.com/static/pages/news/phone/c12_list_1.shtml"];
        
        
      
    }
    return self;
}


#pragma mark UITableViewDataSource

-(void)listCellModelOk
{
    NSLog(@"ok");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"next:%@--listPagenum%lu",contentModel.next,contentModel.this_page_num);
    });
}


@end
