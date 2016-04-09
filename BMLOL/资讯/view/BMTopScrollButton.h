//
//  BMTopScrollButton.h
//  BMLOL
//
//  Created by donglei on 3/31/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsTop;



typedef void(^btnClickedMethod)();
@interface BMTopScrollButton : UIButton



/**
 *  通过静态方法创建对象
 *
 *  @param buttonDict newSPhoneModel
 *
 *  @return 实例对象
 */
+(instancetype) topScrollButtonDict:(NewsTop *) buttonDict;

-(instancetype) initTopScrollButtonWithDict:(NewsTop *) buttonDict;

//按钮被点击之后调用的block
@property(nonatomic,copy)btnClickedMethod btnClicked;

//设置上个被选中的按钮按钮
-(void) setPreviousSelectedBtn:(BMTopScrollButton *) previousBtn;

//按钮被点击之后的回调函数
-(void)buttonClick:(BMTopScrollButton *)btn;


@property(nonatomic,strong) BMTopScrollButton *nextBtn;    //当前被点击的按钮的下一个按钮 用于topscrollview右边那个按钮的处理
@end
