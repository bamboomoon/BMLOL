//
//  BMContentTableView.h
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMContentTableView : UITableView

/**
 *  创建放在 scrollView 中的 tableView
 *
 *  @param firstUrlString tableView 加载的第一页的 urlString
 *  @param isHasScroll    tablieView 是否带有滚动图片
 *  @param x              tableView 在 scrollView 中的x坐标
 *
 *  @return <#return value description#>
 */
-(instancetype) initContentTableViewFirstUrlString:(NSString *) firstUrlString isHasScroll:(BOOL)isHasScroll inScrollViewX:(CGFloat) x;


/**
 * 该 方法 主要用来 封装 创建cell的代码.方便 BMNewsLasetNewTbliView这个它的子类 来调用
 
 */
-(UITableViewCell *) createCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;



@end
