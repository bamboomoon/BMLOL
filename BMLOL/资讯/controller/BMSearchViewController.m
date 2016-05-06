//
//  BMSearchViewController.m
//  BMLOL
//
//  Created by donglei on 16/5/2.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMSearchViewController.h"
#import "BMSearchTv.h"
#import "BMSearchRecordModel.h"

@interface BMSearchViewController ()
<
    UISearchBarDelegate
>


@property (nonatomic,weak) UISearchBar *searchBar;


//搜索记录 tableView
@property (nonatomic,weak) BMSearchTv *searchTableView;

@end

@implementation BMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor redColor];
    //创建 tableView
    BMSearchTv *searchTableView = [BMSearchTv searchTableViewWithHotSearchUrlString:@"http://qt.qq.com/php_cgi/news/varcache_search_hot.php?plat=ios&version=3" frame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
    self.searchTableView = searchTableView;
    [self.view addSubview:searchTableView];
    
    self.navigationItem.hidesBackButton = YES;
    
    //设置搜索 bar
    UISearchBar *searchBar =  [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索您想了解的资讯";
    searchBar.showsCancelButton = YES;
    [searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 
    NSLog(@"searchBarSearchButtonClicked:%@",searchBar.text);
    //保存搜索记录
    BMSearchRecordModel *searchRecordModel = [BMSearchRecordModel getShareInstace];
    [searchRecordModel saveDataName:searchBar.text];
    
    self.searchTableView.searchRecordArray = [searchRecordModel findSearch];
    NSLog(@"增加%lu",self.searchTableView.searchRecordArray.count);
    if (self.searchTableView.searchRecordArray.count > 2) {
        self.searchTableView.isShowAllRecord = YES;
    }
    [self.searchTableView reloadData];
    
    //TODO: 显示搜索结果 tableView
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //pop
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText %@",searchText);
}


@end
