//
//  SX_SubscribeTopicViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/10.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_SubscribeTopicViewController.h"
#import "SX_DataRequest.h"
#import "SX_NewsResult.h"
#import "SX_xinwenTableViewCell.h"
#import "MJRefresh.h"
#import "SX_NewsDetailViewController.h"
#import "SX_NewsChildElements.h"
#import "JXLDayAndNightMode.h"

static NSString *const cellIdentifier = @"cellIdentifier";

@interface SX_SubscribeTopicViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>


@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SX_SubscribeTopicViewController


- (void)getTableViewSource:(NSInteger)pageIndex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults arrayForKey:@"dingyue"];
    NSString *nodeIds = [array componentsJoinedByString:@", "];
    // 时间戳
    NSDate *dateNow = [NSDate date];
    NSInteger timeStamp = (NSInteger)[dateNow timeIntervalSince1970];
    
    
    NSDictionary *dic = @{@"parentNodeId":@"dingYue",
                                       @"nodeIds":nodeIds,
                                       @"type":@"dingyueTopic",
                                       @"pageIndex":[NSString stringWithFormat:@"%ld", pageIndex],
                                       @"lastUpdateTime":[NSNumber numberWithInteger:timeStamp],
                                       @"elementsCountPerPage":@"20"};

    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/AllChannelList" body:dic block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (pageIndex == 1) {
            [_tableViewDataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_NewsResult *newsResult = [SX_NewsResult modelWithDic:dic];
            [_tableViewDataArray addObject:newsResult];
        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108) style:UITableViewStylePlain];
    [_tableView jxl_setDayMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
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
//    [_tableView.mj_header endRefreshing];
}
- (void)pullLoading {
    if (_pageCount * 20 < _tableViewDataArray.count * 3) {
        _pageCount++;
        [self getTableViewSource:_pageCount];
        
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _pageCount = 1;
    
    self.tableViewDataArray = [NSMutableArray array];
    
    [self getTableViewSource:_pageCount];
    
    [self createTableView];
    
    
}
// tableview相关方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SX_NewsResult *result = _tableViewDataArray[section];
    return result.childElements.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableViewDataArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SX_NewsResult *result = _tableViewDataArray[section];
    return result.title;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_xinwenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SX_NewsResult *result = _tableViewDataArray[indexPath.section];
    SX_NewsResult *childElements = result.childElements[indexPath.row];
    cell.xinwenNewsResult = childElements;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    SX_NewsResult *result = _tableViewDataArray[indexPath.row];
    newsDetailVC.contentId = result.contentId;
    newsDetailVC.newsResult = result;
    newsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
