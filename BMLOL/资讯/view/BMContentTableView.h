//
//  BMContentTableView.h
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMContentTableView : UITableView


-(instancetype) initContentTableViewFirstUrlString:(NSString *) firstUrlString isHasScroll:(BOOL)isHasScroll;


/**
 * 该 方法 主要用来 封装 创建cell的代码.方便 BMNewsLasetNewTbliView这个它的子类 来调用
 
 */
-(UITableViewCell *) createCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


/**
 *
 * 暴露出来给子类来 重写
 *
 */
-(NSInteger) numberofRow;

/**
 *  同样的给子类 
 *
 *  @return <#return value description#>
 */
-(CGFloat) cellHeight;
@end
