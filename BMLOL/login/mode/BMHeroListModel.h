//
//  BMHeroListModel.h
//  BMLOL
//
//  Created by donglei on 3/20/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMHeroListModel : NSObject
@property(nonatomic,copy) NSString *tag4;
@property(nonatomic,copy) NSString *en_name;
@property(nonatomic,copy) NSString *magic;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *tag2;
@property(nonatomic,copy) NSString *tag3;
@property(nonatomic,copy) NSString *money;
@property(nonatomic,assign) BOOL   *newhero;
@property(nonatomic,copy) NSString *newmoney;
@property(nonatomic,copy) NSString *nick;
@property(nonatomic,copy) NSString *attack;
@property(nonatomic,copy) NSString *defense;
@property(nonatomic,copy) NSString *difficulty;
@property(nonatomic,copy) NSString *coin;
@property(nonatomic,assign) BOOL *discount;
@property(nonatomic,assign) int *heroId;
@property(nonatomic,copy) NSString *tag1;
@end
