//
//  BMScollView.h
//  BMScrollImage
//
//  Created by donglei on 16/4/5.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  BMWebVC;
@protocol BMScrollViewDelegate <NSObject>

@required
-(void) bmScrollViewDelegateScrollBtnClickWithBMWebVc:(BMWebVC *) webVc;

@end


@interface BMScollView : UIScrollView



/**
 *  创建这个轮播试图
 *
 *  @param scrollImageArray 滚动图片数组
 *  @param offets           初始的偏移量
 *
 *
 *  @return 对象
 */
-(instancetype) initBMScrollImages:(NSArray *)scrollImageUrlArray  offest:(CGPoint) offets  scrollViewSize:(CGSize) scrollViewSize;

+(instancetype)BMScrollImages:(NSArray *)scrollImageUrlArray offest:(CGPoint) offets scrollViewSize:(CGSize) scrollViewSize;


@property(nonatomic,unsafe_unretained) id<BMScrollViewDelegate> bmScrollVideDelegate;

@end
