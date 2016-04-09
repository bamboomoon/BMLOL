//
//  NewsTop.m
//  BMLOL
//
//  Created by donglei on 16/4/7.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "NewsTop.h"

@implementation NewsTop

// Insert code here to add functionality to your managed object subclass
-(void)addModelDataWith:(NSDictionary *)dict
{
    self.iD = dict[@"id"];
    self.name = dict[@"name"];
    self.specil = dict[@"specil"];
    self.url = dict[@"url"];
}
@end
