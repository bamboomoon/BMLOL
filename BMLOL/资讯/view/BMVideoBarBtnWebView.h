//
//  BMVideoBarBtnTableView.h
//  BMLOL
//
//  Created by donglei on 16/4/29.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMVideoBarBtnWebView : UIWebView

/**
 *  创建
 *
 *  @param urlString 这个 tableview 中包含的 webView 的 urlstring
 *
 *  @return 创建好的对象
 */
-(instancetype) initViedoBarBtnWebViewUrlString:(NSString *) urlString;

+(instancetype) viedoBarBtnWebViewUrlString:(NSString *) urlString;


@end
