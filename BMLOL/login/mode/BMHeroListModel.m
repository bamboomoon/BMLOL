//
//  BMHeroListModel.m
//  BMLOL
//
//  Created by donglei on 3/20/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMHeroListModel.h"
#import <MJExtension/MJExtension.h>
@implementation BMHeroListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
            @"heroId":@"id"
             };
}

@end
