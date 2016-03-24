//
//  BMTabBarBtn.m
//  BMLOL
//
//  Created by donglei on 2/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMTabBarBtn.h"
#define btnWidth self.frame.size.width
#define btnHeight self.frame.size.height

#define titlePadding 2

@interface BMTabBarBtn ()
@property(nonatomic,assign) CGFloat tittleH;

@end

@implementation BMTabBarBtn


+(instancetype)createBtnNormalImage:(NSString *)normalName selectedImageName:(NSString*) selectedName title:(NSString *)titileName{
    BMTabBarBtn *btn = [[self alloc] init]; 
    if (btn) {
        [btn setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
        [btn setTitle:titileName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
       btn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return btn;
}


//更改按钮标题的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
   _tittleH =  12.f;
    CGFloat tittleW = 37;
    if(self.selected){
        _tittleH = 14.f;
    }
    CGFloat titleY = btnHeight - _tittleH -titlePadding;
    CGFloat titleX = (btnWidth- tittleW)/2;
    

    return  CGRectMake(titleX, titleY, tittleW, _tittleH);

}

//更改按钮图片的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imagePadding  = 3;
    
    CGFloat imageH = 41;
    CGFloat imageW = 37;
    
    if (self.selected) {
        imageW = 45;
        imageH = 52;
    }
    CGFloat imageX = (btnWidth - imageW) / 2 ;
    CGFloat imageY = btnHeight-titlePadding-_tittleH-imagePadding-imageH;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}


//禁止高亮
-(BOOL) isHighlighted{
    return  NO;
}






@end
