//
//  SX_SubscribeDetailViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/25.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_SubscribeDetailViewController.h"
#import "SX_DataRequest.h"
#import "SX_NewsResult.h"
#import "SX_xinwenTableViewCell.h"
#import "MJRefresh.h"
#import "SX_SubscribeResult.h"
#import "UIImageView+WebCache.h"
#import "SX_NewsDetailViewController.h"

static NSString *const cellIdentifier = @"cellIdentifier";

@interface SX_SubscribeDetailViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableViewDataArray;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, assign) CGFloat contentY;

@end

@implementation SX_SubscribeDetailViewController


- (void)getTableViewSource:(NSInteger)pageIndex {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"parentNodeId":@"dingYue",
                                       @"nodeIds":[NSString stringWithFormat:@"%ld", self.subsribeResult.sourceId],
                                       @"type":@"dingyueList",
                                       @"pageIndex":[NSString stringWithFormat:@"%ld", pageIndex],
                                       @"elementsCountPerPage":@"20"}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/AllChannelList" body:str block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (pageIndex == 1) {
            [_tableViewDataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_NewsResult *newsResult = [SX_NewsResult modelWithDic:dic];
            if ([newsResult.type isEqualToString:@"dingyueTitle"]) {
                UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 200)];
                [headerImageView sd_setImageWithURL:(NSURL *)newsResult.thumbnailURLs[0]];
                _tableView.tableHeaderView = headerImageView;
            }else {
                [_tableViewDataArray addObject:newsResult];
            }
        }
        [_tableView reloadData];
    }];
}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SX_xinwenTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
    [self.view addSubview:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (void)pullRefresh {
    _pageCount = 1;
    [self getTableViewSource:_pageCount];
    [_tableView.mj_header endRefreshing];
}
- (void)pullLoading {
    _pageCount++;
    [self getTableViewSource:_pageCount];
    [_tableView.mj_footer endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem= leftBarButtonItem;

    self.navigationItem.title = self.subsribeResult.sourceName;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    _pageCount = 1;
    
    self.tableViewDataArray = [NSMutableArray array];
    
    [self getTableViewSource:_pageCount];
    
    [self createTableView];
    
}
- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}


// tableview相关方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_xinwenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SX_NewsResult *result = _tableViewDataArray[indexPath.row];
    cell.xinwenNewsResult = result;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    SX_NewsResult *result = _tableViewDataArray[indexPath.row];
    newsDetailVC.contentId = result.contentId;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


// 滑动隐藏导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = (scrollView.contentOffset.y - 0) / (200 - 64);
    self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
//    self.navigationItem.titleView.alpha = alpha;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
