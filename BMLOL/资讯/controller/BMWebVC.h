//
//  BMWebVC.h
//  BMLOL
//
//  Created by donglei on 16/4/30.
//  Copyright © 2016年 donglei. All rights reserved.
//  所有的 加载 webview 的 controller

#import <UIKit/UIKit.h>

@interface BMWebVC : UIViewController

/**
 *
 *  创建控制器
 *  @param isViedo 创建的控制器中 webView 中是否包含视频
 *
 *  @return 创建好的对象
 */
-(instancetype) initWebViewControllIsViedo:(BOOL) isViedo WebViewUrlString:(NSString *) urlString;

//工厂方法
+(instancetype) webViewControllIsViedo:(BOOL) isViedo WebViewUrlString:(NSString *) urlString;


@end
