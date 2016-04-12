//
//  BMNesContentTableViewCell.m
//  BMLOL
//
//  Created by donglei on 16/4/10.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMNesContentTableViewCell.h"
#import "BMNewsContentCellModel.h"

#import <UIImageView+WebCache.h>

@interface BMNesContentTableViewCell()

@property(nonatomic,weak) UILabel *timeLabel;

@end

@implementation BMNesContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

-(instancetype)initnewsContentTableViewCellWithContentModel:(BMNewsContentCellModel *)cellModel tableView:(UITableView *)tableView
{
    
   BMNesContentTableViewCell *cell =   [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
       
        __weak typeof(cell) replaceCell = cell;  //防止循环引用
        UILabel *timeLabel =  [[UILabel alloc] init];
        _timeLabel = timeLabel;
        [cell.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(replaceCell.contentView.mas_right).offset(-10);
            make.bottom.equalTo(replaceCell.contentView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 10));
        }];
        timeLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    //绑定数据
    cell.textLabel.text       = cellModel.title;
    cell.detailTextLabel.text = cellModel.detailTitle;
    [cell.imageView  sd_setImageWithURL:[NSURL URLWithString:cellModel.image_url_big]];
    _timeLabel.text           = cellModel.time;
    
    return cell;
}


+(instancetype)newsContentTableViewCellWithContentModel:(BMNewsContentCellModel *)cellModel tableView:(UITableView *)tableView
{
    return  [[self alloc] initnewsContentTableViewCellWithContentModel:cellModel  tableView:tableView];
}


@end
