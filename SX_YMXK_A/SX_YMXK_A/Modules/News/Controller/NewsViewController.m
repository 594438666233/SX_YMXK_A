//
//  NewsViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/19.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "NewsViewController.h"
#import "SX_CollectionViewCell.h"
#import "SX_DataRequest.h"
#import "SX_NewsResult.h"
#import "SX_santuTableViewCell.h"
#import "SX_hengtuTableViewCell.h"
#import "SX_huandengTableViewCell.h"
#import "SX_xinwenTableViewCell.h"
#import "SX_NavigationResult.h"
#import <MJRefresh.h>
#import "SX_NewsDetailViewController.h"
#import "SX_MenuViewController.h"

static NSString * const santuIdentifier = @"santu";
static NSString * const xinwenIdentifier = @"xinwen";
static NSString * const hengtuIdentifier = @"hengtu";
static NSString * const huandengIdentifier = @"huandeng";
static NSString * const collectionViewIdentifier = @"collectionCell";

@interface NewsViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UITableView *currenttableView;
@property (nonatomic, retain) NSMutableArray *tableViewArray;

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentNodeId;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *collectionDataArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL isMenuShow;

@end

@implementation NewsViewController



- (void)getTableViewSource:(NSInteger)pageIndex nodeIds:(NSInteger)nodeIds{
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"parentNodeId":@"news",
                                       @"nodeIds":[NSString stringWithFormat:@"%ld", nodeIds],
                                       @"pageIndex":[NSString stringWithFormat:@"%ld", pageIndex],
                                       @"elementsCountPerPage":@"20"}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/AllChannelList" body:str block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_NewsResult *newsResult = [SX_NewsResult modelWithDic:dic];
            [_dataArray addObject:newsResult];
        }
        [_currenttableView reloadData];
        [_currenttableView.mj_header endRefreshing];
        [_currenttableView.mj_footer endRefreshing];
    }];
}

- (void)getCollectionViewSource {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"type":@0}
                          };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/allchannel" body:str block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        SX_NavigationResult *result1 = [[SX_NavigationResult alloc] init];
        result1.nodeId = 0;
        result1.nodeName = @"头条";
        [_collectionDataArray addObject:result1];
        for (NSDictionary *dic in array) {
            SX_NavigationResult *result = [SX_NavigationResult modelWithDic:dic];
            [_collectionDataArray addObject:result];
        }
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _collectionDataArray.count, _scrollView.frame.size.height);
        [_collectionView reloadData];
        for (int i = 0; i < _collectionDataArray.count; i++) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
//            tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gsAppHTMLTemplate_ImgBoxer_Background"]];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[SX_santuTableViewCell class] forCellReuseIdentifier:santuIdentifier];
            [tableView registerClass:[SX_hengtuTableViewCell class] forCellReuseIdentifier:hengtuIdentifier];
            [tableView registerClass:[SX_huandengTableViewCell class] forCellReuseIdentifier:huandengIdentifier];
            [tableView registerClass:[SX_xinwenTableViewCell class] forCellReuseIdentifier:xinwenIdentifier];
            
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];

            tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
            
            [_scrollView addSubview:tableView];
            [_tableViewArray addObject:tableView];
        }
        self.currenttableView = _tableViewArray[0];
        [_currenttableView.mj_header beginRefreshing];
        [self getTableViewSource:_pageCount nodeIds:_currentNodeId];
    }];
}

- (void)pullRefresh {
    _pageCount = 1;
    [self getTableViewSource:_pageCount nodeIds:_currentNodeId];
}

- (void)pullLoading {
    _pageCount++;
    [self getTableViewSource:_pageCount nodeIds:_currentNodeId];
}


// 创建导航栏的collectionView
- (void)navigationCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 6, 44);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 128, 44) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:0.995 green:0.8961 blue:0.9789 alpha:0.0];
    [_collectionView registerClass:[SX_CollectionViewCell class] forCellWithReuseIdentifier:collectionViewIdentifier];
    self.navigationItem.titleView = _collectionView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _currentPage = 0;
    _isMenuShow = NO;
    _pageCount = 1;
    _currentNodeId = 0;
    self.dataArray = [NSMutableArray array];
    self.collectionDataArray = [NSMutableArray array];
    self.tableViewArray = [NSMutableArray array];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.4953 blue:0.5155 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(menuAction)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // 导航栏右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"common_Icon_ExtensionContentButton_20x20_UIMode_Day"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    

    // 滑动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108)];
    _scrollView.backgroundColor = [UIColor colorWithRed:0.5396 green:0.6387 blue:1.0 alpha:1.0];
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _collectionDataArray.count, _scrollView.frame.size.height);
    [self.view addSubview:_scrollView];
    
    // 导航栏中间菜单
    [self navigationCollectionView];
    [self getCollectionViewSource];
    
}

- (void)menuAction {
    if (_isMenuShow == NO) {
        [UIView animateWithDuration:0.5f animations:^{
            self.tabBarController.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width - 100, 0);
        }];
        _scrollView.userInteractionEnabled = NO;
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            self.tabBarController.view.transform = CGAffineTransformIdentity;
        }];
        _scrollView.userInteractionEnabled = YES;
    }
    _isMenuShow = !_isMenuShow;
}


// 翻页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
        
        if (currentPage != _currentPage) {
            SX_NavigationResult *result = _collectionDataArray[currentPage];
            _currentPage = currentPage;
            _currentNodeId = result.nodeId;
            _currenttableView = _tableViewArray[currentPage];
            [_currenttableView.mj_header beginRefreshing];
        }
        /**
         *  预留实现保存页面位置
         */
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}



// tableView相关方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsResult *newsResult = _dataArray[indexPath.row];
    if ([newsResult.type isEqualToString:@"huandeng"]) {
        return self.view.frame.size.height / 3;
    } else if ([newsResult.type isEqualToString:@"santu"]) {
        return (self.view.frame.size.width - 40) / 3 / 4 * 3 + 80;
    } else if ([newsResult.type isEqualToString:@"hengtu"]) {
        return self.view.frame.size.height / 3.5;
    }
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsResult *newsResult = _dataArray[indexPath.row];
    if ([newsResult.type isEqualToString:@"huandeng"]) {
        SX_huandengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:huandengIdentifier];
        cell.huandengNewsResult = newsResult;

        return cell;
    } else if ([newsResult.type isEqualToString:@"santu"]) {
        SX_santuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:santuIdentifier];
        cell.santuNewsResult = newsResult;

        return cell;
    } else if ([newsResult.type isEqualToString:@"hengtu"]) {
        SX_hengtuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hengtuIdentifier];
        cell.hengtuNewsResult = newsResult;

        return cell;
    }
    SX_xinwenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xinwenIdentifier];
    cell.xinwenNewsResult = newsResult;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    SX_NewsResult *result = _dataArray[indexPath.row];
    if (result.contentId) {
        newsDetailVC.contentId = result.contentId;
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
}

// collectionView相关方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewIdentifier forIndexPath:indexPath];
    SX_NavigationResult *result = [[SX_NavigationResult alloc] init];
    result = _collectionDataArray[indexPath.item];
    cell.text = result.nodeName;
    cell.textFont = 15;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textFont = 17;
    
    SX_NavigationResult *result = _collectionDataArray[indexPath.item];
    _currentNodeId = result.nodeId;
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * indexPath.item, 0);
    _currenttableView = _tableViewArray[indexPath.item];
    [_currenttableView.mj_header beginRefreshing];

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textFont = 15;
}

// 导航栏右按钮事件
- (void)rightBarButtonItemAction:(UIButton *)button {
    button.selected = !button.selected;
    [UIView animateWithDuration:0.3f animations:^{
        if (button.selected) {
            button.transform = CGAffineTransformRotate(button.transform, M_PI);
        }else {
            button.transform = CGAffineTransformRotate(button.transform, 180.1 * M_PI / 180.0);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
