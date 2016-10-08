//
//  SX_GameViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/23.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_GameViewController.h"
#import "SX_DataRequest.h"
#import "SX_GameNewsResult.h"
#import "MJRefresh.h"
#import "SX_santuTableViewCell.h"
#import "SX_hengtuTableViewCell.h"
#import "SX_huandengTableViewCell.h"
#import "SX_xinwenTableViewCell.h"
#import "SX_NewsDetailViewController.h"
#import "SX_GameDetailView.h"
#import "SX_GameDetailResult.h"


static NSString * const xinwenIdentifier = @"xinwen";


@interface SX_GameViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *newsButton;
@property (nonatomic, strong) UIButton *strategyButton;

@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) UITableView *currentTableView;

@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, copy) NSString *currentType;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) SX_GameDetailResult *gameDetailResult;


@end

@implementation SX_GameViewController

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDetailSource {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"contentId":[NSString stringWithFormat:@"%ld", _contentId]
                                       }};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/TwoGameDetails" body:str block:^(id result) {
        NSDictionary *dic = [result objectForKey:@"result"];
        self.gameDetailResult = [SX_GameDetailResult modelWithDic:dic];
        [self createHeadView];
        [self createButton];
    }];
}

- (void)getTableViewSource:(NSInteger)pageIndex contentId:(NSInteger)contentId contentType:(NSString *)contentType {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"contentId":[NSNumber numberWithInteger:contentId],
                                       @"contentType":contentType,
                                       @"pageIndex":[NSNumber numberWithInteger:pageIndex],
                                       @"elementsCountPerPage":@20
                                       }};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/TwoCorrelation" body:str block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (_tableViewDataArray.count != 0 && pageIndex == 1) {
            [_tableViewDataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_GameNewsResult *gameNewsResult = [SX_GameNewsResult modelWithDic:dic];
            [_tableViewDataArray addObject:gameNewsResult];
        }
        [_currentTableView reloadData];
        [_currentTableView.mj_header endRefreshing];
        [_currentTableView.mj_footer endRefreshing];
    }];
}


- (void)pullRefresh {
    _pageCount = 1;
    [self getTableViewSource:_pageCount contentId:_contentId contentType:_currentType];
}

- (void)pullLoading {
    _pageCount++;
     [self getTableViewSource:_pageCount contentId:_contentId contentType:_currentType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9354 green:0.9304 blue:0.9403 alpha:1.0];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem= leftBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.currentType = @"news";
    self.pageCount = 1;
    self.currentPage = 0;
    self.tableViewDataArray = [NSMutableArray array];
    self.tableViewArray = [NSMutableArray array];
    [self getDetailSource];
    
    [self createScrollView];
    [self createTableView];

    
}

- (void)createHeadView {
    SX_GameDetailView *gameDetailView = [[SX_GameDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    gameDetailView.gameDetailResult = _gameDetailResult;
    NSLog(@"%@", _gameDetailResult.backgroundURL);
    [self.view addSubview:gameDetailView];
    
}
// 创建button
- (void)createButton {
    self.newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_newsButton setTitle:@"新闻" forState:UIControlStateNormal];
    [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_newsButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_newsButton addTarget:self action:@selector(newsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _newsButton.selected = YES;
    [self.view addSubview:_newsButton];
    _newsButton.frame = CGRectMake((self.view.frame.size.width - 60) / 4, 200, 50, 50);
    
    self.strategyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_strategyButton setTitle:@"攻略" forState:UIControlStateNormal];
    [_strategyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_strategyButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_strategyButton addTarget:self action:@selector(strategyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_strategyButton];
    _strategyButton.frame = CGRectMake((self.view.frame.size.width - 60) / 4 * 3, 200, 50, 50);
}


- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height - 250 - 64 - 40)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize =CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
    [self.view addSubview:_scrollView];
    
}

- (void)createTableView {
    for (int i = 0; i < 2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        //            tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gsAppHTMLTemplate_ImgBoxer_Background"]];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[SX_xinwenTableViewCell class] forCellReuseIdentifier:xinwenIdentifier];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
        tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
        
        [_scrollView addSubview:tableView];
        [_tableViewArray addObject:tableView];
    }
    self.currentTableView = _tableViewArray[0];
    [_currentTableView.mj_header beginRefreshing];
}


- (void)newsButtonAction:(UIButton *)button {
    if (button.selected == NO) {
        _newsButton.selected = YES;
        _strategyButton.selected = NO;
        _currentType = @"news";
        _pageCount = 1;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _currentPage = 0;
        _currentTableView = _tableViewArray[0];
        [_currentTableView.mj_header beginRefreshing];
    }
}
- (void)strategyButtonAction:(UIButton *)button {
    if (button.selected == NO) {
        _newsButton.selected = NO;
        _strategyButton.selected = YES;
        _currentType = @"strategy";
        _pageCount = 1;
        _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        _currentPage = 1;
        _currentTableView = _tableViewArray[1];
        [_currentTableView.mj_header beginRefreshing];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_GameNewsResult *gameNewsResult = _tableViewDataArray[indexPath.row];

    SX_xinwenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xinwenIdentifier];
    cell.gameNewsResult = gameNewsResult;
    cell.defaultImg = _defaultImg;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_GameNewsResult *gameNewsResult = _tableViewDataArray[indexPath.row];
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    newsDetailVC.contentId = gameNewsResult.contentId;
    newsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
        if (currentPage != _currentPage) {
            _currentPage = currentPage;
            _currentTableView = _tableViewArray[currentPage];
            [_currentTableView.mj_header beginRefreshing];
            _newsButton.selected = !_newsButton.selected;
            _strategyButton.selected = !_strategyButton.selected;
            if (_currentPage == 0) {
                _currentType = @"news";
            }
            else {
                _currentType = @"strategy";
            }
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
