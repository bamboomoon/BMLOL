//
//  BMSearchRecordCell.h
//  BMLOL
//
//  Created by donglei on 16/5/3.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class BMSearchRecordCell;
//@protocol BMSearchRecordCellDelegate <NSObject>
//
///**
// *  cell 的右边的删除按钮被点击之后的 代理方法
// *
// *  @param recordCell 自己
// *  @param celltouch  被点击在哪里的touch
// */
//-(void) searchRecordCellDeleteRecord:(BMSearchRecordCell *) recordCell celltouch:(UITouch *) celltouch;
//
//@end

@interface BMSearchRecordCell : UITableViewCell

-(instancetype) initsearchRecordCellTitle:(NSString *) title tableView:(UITableView *)tableView;

+(instancetype) searchRecordCellTitle:(NSString *) title tableView:(UITableView *)tableView;

//@property(nonatomic,weak) id<BMSearchRecordCellDelegate> recordCellDegate;
@end
