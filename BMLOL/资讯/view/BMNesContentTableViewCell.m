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

@property(nonatomic,weak) UILabel *timeLabel;  //时间label

@property(nonatomic,weak) UIImageView *leftImageView;  //左边图片视图

@property(nonatomic,weak) UILabel *titleLabel;  //标题视图

@property(nonatomic,weak) UITextView *detailTextView; //子标题视图
@end

@implementation BMNesContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

-(instancetype)initnewsContentTableViewCellWithContentModel:(BMNewsContentCellModel *)cellModel tableView:(UITableView *)tableView
{
    
   BMNesContentTableViewCell *cell =   [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
       
        __weak typeof(cell) replaceCell = cell;  //防止循环引用
        
   
      
        //创建图片视图
        UIImageView *leftImageView = [[UIImageView alloc] init];
        _leftImageView = leftImageView;
        leftImageView.userInteractionEnabled = NO;
        leftImageView.tag = 10;
        [cell.contentView addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75.f, 57.f));
            make.left.equalTo(replaceCell.contentView.mas_left).offset(12);
            make.top.equalTo(replaceCell.contentView.mas_top).offset(11);
        }];
        
        //创建标题视图
        UILabel *titleLabel  = [[UILabel alloc] init];
        titleLabel.tag = 11;
        _titleLabel = titleLabel;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.mas_right).offset(8);
            make.top.equalTo(leftImageView.mas_top);
            make.right.equalTo(replaceCell.mas_right);
            make.height.equalTo(@15);
        }];
        
        
        //创建子标题视图
   
        UITextView *detailTextView = [[UITextView alloc] init];
        detailTextView.tag = 12;
        detailTextView.userInteractionEnabled = NO;
        _detailTextView = detailTextView;
        detailTextView.font = [UIFont boldSystemFontOfSize:15.f];
        detailTextView.textColor = [UIColor grayColor];
        detailTextView.editable = NO;
        detailTextView.selectable = NO;
        detailTextView.bounces = NO;
        detailTextView.showsVerticalScrollIndicator = NO;
        detailTextView.showsHorizontalScrollIndicator = NO;
        detailTextView.directionalLockEnabled = YES;
        
        [cell.contentView addSubview:detailTextView];
        [detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.equalTo(titleLabel.mas_left).offset(-5);
            make.right.equalTo(replaceCell.contentView.mas_right).offset(-10);
            make.bottom.equalTo(replaceCell.contentView.mas_bottom);
        }];
        
        
        //创建时间视图
        UILabel *timeLabel =  [[UILabel alloc] init];
        timeLabel.tag = 13;
        _timeLabel = timeLabel;
        [cell.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(replaceCell.contentView.mas_right).offset(-12);
            make.bottom.equalTo(replaceCell.contentView.mas_bottom).offset(-11);
            make.size.mas_equalTo(CGSizeMake(100, 10));
        }];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font  = [UIFont systemFontOfSize:13.f];
        
        
        //绑定数据
            _titleLabel.text      = cellModel.title;
            _detailTextView.text = cellModel.detailTitle;
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.image_url_small]];
        
            _timeLabel.text           = cellModel.time;
        
        
    }
    else {
    for (UIView* cellIncludeView in cell.contentView.subviews) {
        switch (cellIncludeView.tag) {
            case 10:
                NSLog(@"%@",cellIncludeView);
                [(UIImageView*)cellIncludeView sd_setImageWithURL:[NSURL URLWithString:cellModel.image_url_small]];
                NSLog(@"tupian");
                break;
            case 11:
                ((UILabel *)cellIncludeView).text = cellModel.title;
                NSLog(@"biaoti");
                break;
            case 12:
                ((UITextView*)cellIncludeView).text = cellModel.detailTitle;
                NSLog(@"zibaioti");
                break;
            case 13:
                ((UILabel *)cellIncludeView).text =cellModel.time;
                NSLog(@"shijian");
                break;
            default:
                break;
        }
    }
  }

    return cell;
}


+(instancetype)newsContentTableViewCellWithContentModel:(BMNewsContentCellModel *)cellModel tableView:(UITableView *)tableView
{
    return  [[self alloc] initnewsContentTableViewCellWithContentModel:cellModel  tableView:tableView];
}


@end
