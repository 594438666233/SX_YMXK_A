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
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

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
    NSDictionary *dic = @{@"parentNodeId":@"dingYue",
                                       @"nodeIds":[NSString stringWithFormat:@"%ld", self.subsribeResult.sourceId],
                                       @"type":@"dingyueList",
                                       @"pageIndex":[NSString stringWithFormat:@"%ld", pageIndex],
                                       @"elementsCountPerPage":@"20"};

    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/AllChannelList" body:dic block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (pageIndex == 1) {
            [_tableViewDataArray removeAllObjects];
        }
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL flag = [userDefaults boolForKey:@"imgMode"];

        
        for (NSDictionary *dic in array) {
            SX_NewsResult *newsResult = [SX_NewsResult modelWithDic:dic];
            if ([newsResult.type isEqualToString:@"dingyueTitle"]) {
                UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 200)];
                headerImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
                if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
                    headerImageView.contentMode = UIViewContentModeCenter;
                    headerImageView.image = [UIImage imageNamed:@"common_Logo_174x41"];
                }
                else {
                    [headerImageView sd_setImageWithURL:(NSURL *)newsResult.thumbnailURLs[0]];
                }
                _tableView.tableHeaderView = headerImageView;
            }else {
                [_tableViewDataArray addObject:newsResult];
            }
        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStylePlain];
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
}
- (void)pullLoading {
    _pageCount++;
    [self getTableViewSource:_pageCount];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view jxl_setDayMode:^(UIView *view) {
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
    } nightMode:^(UIView *view) {
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
    }];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
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
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 7;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    SX_NewsResult *result = _tableViewDataArray[indexPath.row];
    newsDetailVC.contentId = result.contentId;
    newsDetailVC.newsResult = result;
    newsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


// 滑动隐藏导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = (scrollView.contentOffset.y - 0) / (200 - 64);
    self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
