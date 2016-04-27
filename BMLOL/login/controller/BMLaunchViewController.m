//
//  BMLaunchViewController.m
//  BMLOL
//
//  Created by donglei on 3/6/16.
//  Copyright © 2016 donglei. All rights reserved.
// 登陆页面


#import "BMLaunchViewController.h"
#import "BMCustomTabBarController.h"
#import "BMOtherLoginVc.h"
#import <Masonry.h>

@interface BMLaunchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *LoginLogIV;

@end

@implementation BMLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1>创建『手机QQ快速登陆』按钮
    UIButton  *qqLoginBtn = ({
    
        UIButton  *qqLoginBtn = [UIButton new];
    [self.view addSubview:qqLoginBtn];
    //1.1>设置按钮的位置
    [qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.height.equalTo(@45);
        make.top.equalTo(self.LoginLogIV.mas_bottom).with.offset(20);
    }];
    
    //1.2>设置背景图片  并且改变图片的拉伸

    [qqLoginBtn setBackgroundImage:[self resizableImageWithImageNmae:@"btn_blue_nor"] forState:UIControlStateNormal];
    [qqLoginBtn setBackgroundImage:[self resizableImageWithImageNmae:@"login_button_pressed"] forState:UIControlStateHighlighted];
   
    
    //1.3>设置文字和颜色
    [qqLoginBtn setTitle:@"手机QQ快速登陆" forState:UIControlStateNormal ];
    [qqLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        
    qqLoginBtn;
        
    });
    
    //2.创建『其它账号登陆』 按钮
    UIButton  *otherLoginBtn = ({
        
        UIButton  *otherLoginBtn = [UIButton new];
        [self.view addSubview:otherLoginBtn];
        //1.1>设置按钮的位置
        [otherLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(20);
            make.right.equalTo(self.view.mas_right).with.offset(-20);
            make.height.equalTo(@45);
            make.top.equalTo(qqLoginBtn.mas_bottom).with.offset(20);
        }];
        
        //1.2>设置背景图片  并且改变图片的拉伸
        
        [otherLoginBtn setBackgroundImage:[self resizableImageWithImageNmae:@"other_login_nor"] forState:UIControlStateNormal];
        [otherLoginBtn setBackgroundImage:[self resizableImageWithImageNmae:@"other_login_pressed"] forState:UIControlStateHighlighted];
        
        
        //1.3>设置文字和颜色
        [otherLoginBtn setTitle:@"其它账号登陆" forState:UIControlStateNormal ];
        [otherLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
        otherLoginBtn.alpha = 0.1;
        otherLoginBtn;
        
    });
        //1.4 绑定点击事件 点击之后进入 其它登陆界面
    [otherLoginBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //3.创建『游客进入』 按钮
    UIButton *visitorBtn   = ({
        UIButton *visitorBtn = [UIButton new];
        [visitorBtn setTitle:@"游客进入" forState:UIControlStateNormal];
        visitorBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [visitorBtn addTarget:self action:@selector(visitorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        visitorBtn.alpha = 0.5;
        [self.view addSubview:visitorBtn];
        [visitorBtn setBackgroundImage:[self resizableImageWithImageNmae:@"other_login_nor"] forState:UIControlStateNormal];
        [visitorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
            make.right.equalTo(self.view.mas_right).with.offset(-20);
            make.width.equalTo(@80);
            make.height.equalTo(@20);
        }];
        visitorBtn;
    });
}



-(void) visitorBtnClick:(UIButton *)btn{
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"customTabBar"] animated:YES];
    
}

/**
 *  对图片进行变形拉伸
 *
 *  @param name 图片的名字
 *
 *  @return 拉伸之后的图片
 */
-(UIImage *) resizableImageWithImageNmae:(NSString *) name {
    UIImage *qqLoginNorImage = [UIImage imageNamed:name];
    UIEdgeInsets insetsNor = UIEdgeInsetsMake(qqLoginNorImage.size.height/2, qqLoginNorImage.size.width/2, qqLoginNorImage.size.height/2,qqLoginNorImage.size.width/2);
    return [qqLoginNorImage resizableImageWithCapInsets:insetsNor resizingMode:UIImageResizingModeStretch];
}

//其他登陆点击 方法
-(void) otherBtnClick:(UIButton *) btn {
    BMOtherLoginVc *otherVc = [[BMOtherLoginVc alloc] init];
    [self.navigationController pushViewController:otherVc animated:YES];
}
@end
