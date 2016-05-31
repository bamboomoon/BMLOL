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
#import "BMSearchResultTableView.h"

@interface BMSearchViewController ()
<
    UISearchBarDelegate,
    BMSearchResultTableViewDelegate
>


@property (nonatomic,weak) UISearchBar *searchBar;


//搜索记录 tableView
@property (nonatomic,weak) BMSearchTv *searchTableView;

//搜索结果 tableView
@property(nonatomic,weak) BMSearchResultTableView *resultTableView;

@property(nonatomic,assign) BOOL isShowResultTableViwe;

@end

@implementation BMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginSearch:) name:@"beginSearch" object:nil];
    
    //创建搜索结果
    BMSearchResultTableView *resultTableView = [[BMSearchResultTableView alloc] init];
    resultTableView.frame = CGRectMake(0, 64, screenWidth, screenHeight-64);
    self.resultTableView = resultTableView;
    resultTableView.searchResulteDelegate = self;
    [self.view addSubview:resultTableView];
    resultTableView.hidden = YES; //一上来就隐藏
    
    
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


-(void) beginSearch:(NSNotification*) notification{
   NSString *keyWord = notification.userInfo[@"keyWord"];
 [self serchKeyWord:keyWord];
    self.searchBar.text = keyWord;
}


-(void) serchKeyWord:(NSString *) keyWord{
    //保存搜索记录
    BMSearchRecordModel *searchRecordModel = [BMSearchRecordModel getShareInstace];
    [searchRecordModel saveDataName:keyWord];
    
    self.searchTableView.searchRecordArray = [searchRecordModel findSearch];
  
    if (self.searchTableView.searchRecordArray.count > 2) {
        self.searchTableView.isShowAllRecord = YES;
    }
    [self.searchTableView reloadData];
    
    
    self.resultTableView.keyWord  = keyWord;
    self.resultTableView.hidden = NO;
    self.searchTableView.hidden = YES;
    self.isShowResultTableViwe = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchChange" object:self];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 
    [self serchKeyWord:searchBar.text];


}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //pop
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
  
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchBar.text isEqualToString:@""]) {
        //获得第一响应
        [searchBar becomeFirstResponder];
        //数据置空
        [self.resultTableView.dataModelArray removeAllObjects];
        //显示搜索记录 table 隐藏搜索结果
        
        if (self.isShowResultTableViwe) {
            self.resultTableView.hidden = YES;
            self.searchTableView.hidden = NO;
            
            self.isShowResultTableViwe = NO;
        }
    }
}


#pragma mark BMSearchResultTableViewDelegate
-(void) BMSearchResultTableView:(BMSearchResultTableView *)searchResultTableView WebVc:(BMWebVC *)webVc{
    
    [self.navigationController pushViewController:webVc animated:YES];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
