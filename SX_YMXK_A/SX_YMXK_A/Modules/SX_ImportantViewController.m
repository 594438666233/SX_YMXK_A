//
//  SX_ImportantViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_ImportantViewController.h"
#import "SX_NewsResult.h"
#import "SX_santuTableViewCell.h"
#import "SX_hengtuTableViewCell.h"
#import "SX_huandengTableViewCell.h"
#import "SX_xinwenTableViewCell.h"
#import "SX_DataRequest.h"
#import "MJRefresh.h"
#import "SX_NewsDetailViewController.h"
#import "JXLDayAndNightMode.h"


static NSString * const santuIdentifier = @"santu";
static NSString * const xinwenIdentifier = @"xinwen";
static NSString * const hengtuIdentifier = @"hengtu";
static NSString * const huandengIdentifier = @"huandeng";

@interface SX_ImportantViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableViewDataArray;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation SX_ImportantViewController



- (void)getTableViewSource:(NSInteger)pageIndex {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"parentNodeId":@"yaowen",
                                       @"nodeIds":@"0",
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
            [_tableViewDataArray addObject:newsResult];
        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}



- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"要闻";
    [self.view jxl_setDayMode:^(UIView *view) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } nightMode:^(UIView *view) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.912 green:0.912 blue:0.912 alpha:1.0]}];
    }];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;


    
    self.tableViewDataArray = [NSMutableArray array];
    self.pageCount = 1;
    
    [self createTableView];
    [self getTableViewSource:_pageCount];
    
}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView jxl_setDayMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    
    [_tableView registerClass:[SX_santuTableViewCell class] forCellReuseIdentifier:santuIdentifier];
    [_tableView registerClass:[SX_hengtuTableViewCell class] forCellReuseIdentifier:hengtuIdentifier];
    [_tableView registerClass:[SX_huandengTableViewCell class] forCellReuseIdentifier:huandengIdentifier];
    [_tableView registerClass:[SX_xinwenTableViewCell class] forCellReuseIdentifier:xinwenIdentifier];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
    [self.view addSubview:_tableView];
}

- (void)pullRefresh {
    _pageCount = 1;
    [self getTableViewSource:_pageCount];
}

- (void)pullLoading {
    _pageCount++;
    [self getTableViewSource:_pageCount];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsResult *newsResult = _tableViewDataArray[indexPath.row];
    if ([newsResult.type isEqualToString:@"huandeng"]) {
        return self.view.frame.size.height / 3;
    } else if ([newsResult.type isEqualToString:@"santu"]) {
        return self.view.frame.size.height / 4;
    } else if ([newsResult.type isEqualToString:@"hengtu"]) {
        return self.view.frame.size.height / 3.5;
    }
    return self.view.frame.size.height / 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsResult *newsResult = _tableViewDataArray[indexPath.row];
    if ([newsResult.type isEqualToString:@"huandeng"]) {
        SX_huandengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:huandengIdentifier];
        cell.huandengNewsResult = newsResult;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    } else if ([newsResult.type isEqualToString:@"santu"]) {
        SX_santuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:santuIdentifier];
        cell.santuNewsResult = newsResult;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    } else if ([newsResult.type isEqualToString:@"hengtu"]) {
        SX_hengtuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hengtuIdentifier];
        cell.hengtuNewsResult = newsResult;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    SX_xinwenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xinwenIdentifier];
    cell.xinwenNewsResult = newsResult;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    SX_NewsResult *result = _tableViewDataArray[indexPath.row];
    newsDetailVC.contentId = result.contentId;
    newsDetailVC.newsResult = result;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
