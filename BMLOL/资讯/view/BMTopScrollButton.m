//
//  BMTopScrollButton.m
//  BMLOL
//
//  Created by donglei on 3/31/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMTopScrollButton.h"
#import "NewsTop.h"


@interface BMTopScrollButton()

@property(nonatomic,copy) NSString *buttonName;


@end

@implementation BMTopScrollButton

static  BMTopScrollButton *previousSelectedBtn;  //上一个被点击的按钮


-(void)setPreviousSelectedBtn:(BMTopScrollButton *)previousBtn{
    previousSelectedBtn = previousBtn;
}

+(instancetype)topScrollButtonDict:(NewsTop *)buttonDict
{
   
    return [[self alloc] initTopScrollButtonWithDict:buttonDict];
    
}

-(instancetype) initTopScrollButtonWithDict:(NewsTop *)buttonDict
{
    if (self = [super init]) {
        
        [self setTitle:buttonDict.name forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:232.0/255 green:184.0/255 blue:114.0/255 alpha:1.0] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
       
    }
    return self;
}

-(BOOL)isHighlighted
{
    return NO;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
         self.titleLabel.font = [UIFont systemFontOfSize:19.f];  //按钮是选中状态就放大
    }else {
         previousSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    }
}
//navigationItem上的scrollView中的btn被点击之后的回调函数
-(void)buttonClick:(BMTopScrollButton *)btn{
   
   
    btn.selected = YES;
   
    if(previousSelectedBtn && previousSelectedBtn != btn){
        previousSelectedBtn.selected = NO; //将上一个按钮选中状态取消
       
    }
        previousSelectedBtn = btn;
     self.btnClicked(); //调用block方法  170 140 88
}

@end
