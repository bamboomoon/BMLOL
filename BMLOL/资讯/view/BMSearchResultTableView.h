//
//  BMSearchResultTableView.h
//  BMLOL
//
//  Created by donglei on 16/5/7.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMSearchResultTableView;
@class BMWebVC;

@protocol BMSearchResultTableViewDelegate <NSObject>

-(void) BMSearchResultTableView:( BMSearchResultTableView *) searchResultTableView WebVc:(BMWebVC*) webVc;

@end

@interface BMSearchResultTableView : UITableView

//这是一个2维数组 [第几页的数据][每一页的数据]  每一页10个cell 数据对象
@property(nonatomic,strong) __block NSMutableArray *dataModelArray;
//加载的 url
@property(nonatomic,copy) NSString *keyWord;

@property(nonatomic,weak) id<BMSearchResultTableViewDelegate> searchResulteDelegate;

@end
