//
//  BMNewVC.m
//  BMLOL
//
//  Created by donglei on 3/27/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMNewVC.h"

@implementation BMNewVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat spacint = (screenWidth - 34 - (4*40))/4;
   
    
    CGFloat contentSizeWidth = 6*spacint+40*7+20;
    //创建navigationbar 中的滑动视图
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    topScrollView.backgroundColor = [UIColor redColor];
    topScrollView.alwaysBounceVertical = NO;
    topScrollView.alwaysBounceHorizontal = YES;
    UINavigationItem *scrollItem = [[UINavigationItem alloc] init];
    scrollItem.titleView = topScrollView;
    
    UINavigationBar *newNavigationBar = self.navigationController.navigationBar;
    [self.navigationController.navigationBar setItems:@[scrollItem] animated:YES];
    [topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newNavigationBar.mas_left);
        make.right.equalTo(newNavigationBar.mas_right).with.offset(-34);
        make.top.equalTo(newNavigationBar.mas_top).with.offset(8);
        make.bottom.equalTo(newNavigationBar.mas_bottom).with.offset(-8);
    }];
    

   
    //在 topScrollView 中添加同一个UIView 解决直接添加 UIButton,topScrollView 不能拖动的问题
  
    
    
    UIView *viewInTopScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSizeWidth, 28)];
    viewInTopScrollView.backgroundColor = [UIColor blueColor];
    [topScrollView addSubview:viewInTopScrollView];
    

    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"最新" forState: UIControlStateNormal];
    [viewInTopScrollView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewInTopScrollView.mas_left).offset(20);
        make.top.equalTo(viewInTopScrollView.mas_top);
        make.bottom.equalTo(viewInTopScrollView.mas_bottom);
        make.width.equalTo(@40);
    }];
    
    UIButton *button1 = [[UIButton alloc] init];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"最新" forState: UIControlStateNormal];
    [viewInTopScrollView addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).offset(spacint);
        make.top.equalTo(viewInTopScrollView.mas_top);
        make.bottom.equalTo(viewInTopScrollView.mas_bottom);
        make.width.equalTo(@40);
    }];
    
    UIButton *button2 = [[UIButton alloc] init];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"最新" forState: UIControlStateNormal];
    [viewInTopScrollView addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button1.mas_right).offset(spacint);
        make.top.equalTo(viewInTopScrollView.mas_top);
        make.bottom.equalTo(viewInTopScrollView.mas_bottom);
        make.width.equalTo(@40);
    }];
  
    
    
    UIButton *button3 = [[UIButton alloc] init];
    [button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitle:@"最新" forState: UIControlStateNormal];
    [viewInTopScrollView addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right).offset(spacint);
        make.top.equalTo(viewInTopScrollView.mas_top);
        make.bottom.equalTo(viewInTopScrollView.mas_bottom);
        make.width.equalTo(@40);
    }];

    
    
    
}

-(void)buttonClick:(UIButton *)btn{
    NSLog(@"按钮被点击了");
    btn.titleLabel.font = [UIFont systemFontOfSize:19.f];
}


@end
