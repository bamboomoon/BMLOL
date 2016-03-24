//
//  BMOtherLoginVc.m
//  BMLOL
//
//  Created by donglei on 3/8/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "BMOtherLoginVc.h"
#import "BMCustomTextField.h"

@interface BMOtherLoginVc() <UITextFieldDelegate>

@property(nonatomic,weak) UITextField *nameTextField;
@property(nonatomic,weak) UITextField *passTextField;


@property(nonatomic,weak) UIButton *nameRightCloseBtn;
@property(nonatomic,weak) UIButton *passRightCloseBtn;
@end

@implementation BMOtherLoginVc


-(void) viewDidLoad{
    [super viewDidLoad];
  
    //1.设置改页面的背景
    UIImageView *backageIV = ({
        UIImageView *backageIV  = [UIImageView new];
        backageIV.image = [UIImage imageNamed:@"login_bkg"];
        [self.view addSubview:backageIV];
        [backageIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        backageIV;
    });
    //2.设置 navigation 标题
    UILabel *middleLabel = ({
        UILabel *middleLabel = [[UILabel alloc] init];
        middleLabel.textAlignment = NSTextAlignmentCenter;
        middleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        middleLabel.text = @"其它方式登录";
        middleLabel.textColor = [UIColor colorWithRed:206/255.0 green:161/255.0 blue:97/255.0 alpha:1.0f];
        [self.view addSubview:middleLabel];
       
        [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(screenHeight/20);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@(screenWidth/2));
            make.height.equalTo(@32);
        }];
        middleLabel;
    });
    //3.返回按钮
    UIButton *backBtn = ({
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_normal"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_pressed"] forState:UIControlStateHighlighted];
        [self.view addSubview:backBtn];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchDown];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(middleLabel.mas_centerY);
            make.left.equalTo(@20);
            make.width.equalTo(@50);
            make.height.equalTo(@32);
        }];
        backBtn;
    });
    
    //4.设置账号密码 输入框
    UIView *namePassView = ({
        UIView *namePassView = [[UIView alloc] init];
        [self.view addSubview:namePassView];
        [namePassView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).with.offset(-80);
//            make.width.equalTo(@267);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.equalTo(@90);
        }];

        namePassView;
    });
    UIImageView *nameAndPassIv = ({
        UIImageView *nameAndPassIv = [[UIImageView alloc] init];
        nameAndPassIv.image = [UIImage imageNamed:@"login_input"];
        [namePassView addSubview:nameAndPassIv];
        [nameAndPassIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(namePassView);
        }];
        nameAndPassIv;
    });
    
    BMCustomTextField *nameTextField = ({
        BMCustomTextField *nameTextField = [BMCustomTextField customTextField:namePassView];
        nameTextField.placeholder = @"QQ账号";
        _nameTextField = nameTextField;
        nameTextField.delegate = self;
       
        nameTextField.keyboardType = UIKeyboardTypeNumberPad;
        [namePassView addSubview:nameTextField];
        [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(namePassView.mas_top);
            make.right.equalTo(namePassView.mas_right);
            make.left.equalTo(namePassView.mas_left);
            make.height.equalTo(@45);
        }];
        nameTextField;
    });
    
    
    BMCustomTextField *passTextField = ({
        BMCustomTextField *passTextField = [BMCustomTextField customTextField:namePassView];
        _passTextField = passTextField;
        passTextField.delegate = self;
        [namePassView addSubview:passTextField];
        passTextField.placeholder = @"密码";
        passTextField.keyboardType = UIKeyboardTypeASCIICapable;
        passTextField.secureTextEntry = YES;
        
        //rightview
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 17)];
        passTextField.rightViewMode = UITextFieldViewModeAlways;
        passTextField.rightView = rightView;
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setBackgroundImage: [UIImage imageNamed:@"subscribe_match_filter_delete_hover"] forState:UIControlStateNormal];
        _passRightCloseBtn = rightBtn;
        [rightBtn addTarget:self action:@selector(passCloseBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.hidden = YES;
        [rightView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@17);
            make.height.equalTo(@17);
            make.centerY.equalTo(rightView.mas_centerY);
            make.right.equalTo(rightView.mas_right).offset(-20);
        }];
        
        
        
        [passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(namePassView.mas_right);
            make.left.equalTo(namePassView.mas_left);
            make.height.equalTo(@45);
            make.bottom.equalTo(namePassView.mas_bottom);
        }];
        passTextField;
    });
    //创建 账号输入框的 rigthview
    UIView *nameRightView = ({
        UIView *nameRightView = [[UIView alloc] init];
        nameRightView.bounds = CGRectMake(0, 0, 100, 34);
        nameTextField.rightView = nameRightView;
        nameTextField.rightViewMode = UITextFieldViewModeAlways;
        
        UIButton *closeBtn = ({
            UIButton *closeBtn = [[UIButton alloc] init];
            closeBtn.hidden = YES;
            [closeBtn setBackgroundImage:[UIImage imageNamed:@"subscribe_match_filter_delete_hover"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(nameClostBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            _nameRightCloseBtn = closeBtn;
            [nameRightView addSubview:closeBtn];
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(nameRightView.mas_centerY);
                make.left.equalTo(nameRightView.mas_left).offset(20);
                make.height.equalTo(@17);
                make.width.equalTo(@17);
            }];
           
            closeBtn;
        });
        
        nameRightView;
    });
    
    
    UIButton *chooseBtn = ({
        UIButton *chooseBtn = [[UIButton alloc] init];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"current_martch_scroll_arrow_down_view"] forState:UIControlStateNormal];
        [nameRightView addSubview:chooseBtn];
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@10);
            make.height.equalTo(@6);
            make.right.equalTo(nameRightView.mas_right).offset(-20);
            make.centerY.equalTo(nameRightView.mas_centerY);
        }];
        chooseBtn;
    });
    //5.设置登陆按钮
    
    
    UIButton *loginBtn = ({
        UIButton *loginBtn = [[UIButton alloc] init];
        [self.view addSubview:loginBtn];
        UIImage *backImage = [UIImage imageNamed:@"btn_blue_nor"] ;
        [loginBtn setBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(backImage.size.height/2, backImage.size.width/2, backImage.size.height/2, backImage.size.width/2) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState: UIControlStateNormal];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(namePassView.mas_left);
            make.right.equalTo(namePassView.mas_right);
            make.top.equalTo(namePassView.mas_bottom).offset(15);
            make.height.equalTo(@40);
        }];
        loginBtn;
    });
    
    //6.对两个输入框 进行监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameTf) name:UITextFieldTextDidChangeNotification object:nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passTf) name:UITextFieldTextDidChangeNotification object:passTextField];
}

-(void) backBtnClick:(UIButton *)backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

//登录按钮点击事件
-(void) loginBtnClick:(UIButton *)btn{
    
}


//UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_passTextField] && range.location > 15 ) return NO;
    if ([textField isEqual:_nameTextField] && range.location > 11) return NO;
    return YES;
}

// 账号输入框通知响应方法
-(void) nameTf{

    _nameRightCloseBtn.hidden = !(_nameTextField.text.length > 0);
    
    
}
// 密码输入框通知响应方法
-(void) passTf{
    _passRightCloseBtn.hidden = !(_passTextField.text.length > 0 );
}
 //账号 和 密码 点击事件
-(void) nameClostBtnOnClick:(UIButton *) btn{
    _nameTextField.text = nil;
    _nameRightCloseBtn.hidden = YES;
}
-(void) passCloseBtnOnClick:(UIButton *) btn{
    _passTextField.text = nil;
    _passRightCloseBtn.hidden = YES;
}
@end
