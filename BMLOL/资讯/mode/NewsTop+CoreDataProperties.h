//
//  NewsTop+CoreDataProperties.h
//  BMLOL
//
//  Created by donglei on 16/4/7.
//  Copyright © 2016年 donglei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NewsTop.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsTop (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iD;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *specil;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
