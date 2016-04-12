//
//  BMNewsContentCellModel.m
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMNewsContentCellModel.h"

@implementation BMNewsContentCellModel

-(instancetype)initNewsContentCellModelWithDict:(NSDictionary *)cellDataDict{
    if (self = [super init]) {
        self.title         = cellDataDict[@"title"];
        self.detailTitle   = cellDataDict[@"summary"];
        self.time          = [self getTimeWith:cellDataDict[@"publication_date"]];
        self.article_url   = cellDataDict[@"article_url"];
        self.image_url_big = cellDataDict[@"image_url_big"];
    }
    return self;
}

+(instancetype)newsContentCellModelWithDict:(NSDictionary *)cellDataDict
{
    return [[self alloc] initNewsContentCellModelWithDict:cellDataDict];
}

/**
 *  计算该消息是多久之前发布的
 *
 *  @param publicationDate 从json中获取
 *
 *  @return 计算之后可用的时间
 */

-(NSString*) getTimeWith:(NSString *)publicationDate
{
 
    NSDate *currentDate        = [[NSDate alloc] initWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone         = [NSTimeZone systemTimeZone];
    NSString *current          = [formatter stringFromDate:currentDate];

    
    
    //月
    NSInteger pubMouth   = [[publicationDate substringWithRange:NSMakeRange(5, 2)] integerValue];

    //日
    NSInteger pubDay     = [[publicationDate substringWithRange:NSMakeRange(8, 2)] integerValue];
    NSInteger currDay    = [[current substringWithRange:NSMakeRange(8, 2)] integerValue];


    //hour
    NSInteger pubHour    = [[publicationDate substringWithRange:NSMakeRange(11, 2)] integerValue];
    NSInteger currHour   = [[current substringWithRange:NSMakeRange(11, 2)] integerValue];

    //分钟
    NSInteger pubMinute  = [[publicationDate substringWithRange:NSMakeRange(14, 2)] integerValue];
    NSInteger currMinute = [[current substringWithRange:NSMakeRange(14, 2)] integerValue];
    
    
    if(pubDay != currDay){
        return  [NSString stringWithFormat:@"%02ld-%02ld",pubMouth,pubDay];
    }else if(pubHour != currHour){
        return  [NSString stringWithFormat:@"%ld小时前",currHour-pubHour];
    }else {
        return  [NSString stringWithFormat:@"%ld分钟前",currMinute-pubMinute];
    }
    
    
    
    return  nil;
}
@end
