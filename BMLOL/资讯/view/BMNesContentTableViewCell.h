//
//  BMNesContentTableViewCell.h
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMNewsContentCellModel;
@interface BMNesContentTableViewCell : UITableViewCell

//创建cell
-(instancetype) initnewsContentTableViewCellWithContentModel:(BMNewsContentCellModel *) cellModel tableView:(UITableView *)tableView;

//创建cell工厂方法
+(instancetype) newsContentTableViewCellWithContentModel:(BMNewsContentCellModel *) cellModel tableView:(UITableView *)tableView;
@end
