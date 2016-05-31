//
//  BMVideoTabVc.m
//  BMLOL
//
//  Created by donglei on 16/5/12.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMVideoTabVc.h"
#import "BMVideo.h"

@implementation BMVideoTabVc


-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"videoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.textLabel.text = @"视频1";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BMVideo *video = [[BMVideo alloc] init];
    video.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:video animated:YES];
}
@end
