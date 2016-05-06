//
//  BMSearchRecordCell.m
//  BMLOL
//
//  Created by donglei on 16/5/3.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMSearchRecordCell.h"

@implementation BMSearchRecordCell




-(instancetype) initsearchRecordCellTitle:(NSString *)title tableView:(UITableView *)tableView
{
    NSString *identifier = @"searchRecordCell";
    BMSearchRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BMSearchRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        cell.imageView.image = [UIImage imageNamed:@"add_friend_search_clock"];
        cell.userInteractionEnabled = YES;
        
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_friend_remove"]];
        accessoryImageView.userInteractionEnabled = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 15,15);
        [btn setBackgroundImage:[UIImage imageNamed:@"add_friend_remove"] forState:UIControlStateNormal];
        [btn addTarget:tableView action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        btn.userInteractionEnabled = YES;
        cell.accessoryView = btn;
        

        
    }
    cell.textLabel.text = title;
    return cell;
}


+(instancetype) searchRecordCellTitle:(NSString *)title tableView:(UITableView *)tableView
{
    return  [[self alloc]initsearchRecordCellTitle:title tableView:tableView];
}


@end
