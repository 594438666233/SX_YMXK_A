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

@property (nonatomic, assign) CGFloat currentY;

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
        if (_dataArray.count != 0 && pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_NewsResult *newsResult = [SX_NewsResult modelWithDic:dic];
            [_dataArray addObject:newsResult];
        }
        [_currenttableView reloadData];
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
    [_currenttableView.mj_header endRefreshing];
}

- (void)pullLoading {
    _pageCount++;
    [self getTableViewSource:_pageCount nodeIds:_currentNodeId];
    [_currenttableView.mj_footer endRefreshing];
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
    
    _pageCount = 1;
    _currentNodeId = 0;
    self.dataArray = [NSMutableArray array];
    self.collectionDataArray = [NSMutableArray array];
    self.tableViewArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.4953 blue:0.5155 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
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




// 翻页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
        NSLog(@"%f", scrollView.contentOffset.x);
        NSLog(@"%f", _scrollView.frame.size.width);
        SX_NavigationResult *result = _collectionDataArray[currentPage];
        _currentNodeId = result.nodeId;
        NSLog(@"----------%ld", _currentNodeId);
        NSLog(@"-------%ld", currentPage);
        _currenttableView = _tableViewArray[currentPage];
        [_currenttableView.mj_header beginRefreshing];
        /**
         *  预留实现保存页面位置
         */
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

// 加载刷新
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if ([scrollView isEqual:_currenttableView]) {
//        NSLog(@"%f", scrollView.contentOffset.y);
//        NSLog(@"%f", _currenttableView.contentSize.height);
//        NSLog(@"%f", _scrollView.frame.size.height);
//        if (_currenttableView.contentOffset.y > _currenttableView.contentSize.height - _scrollView.frame.size.height + 10) {
//            _pageCount++;
//            [self getTableViewSource:_pageCount nodeIds:_currentNodeId];
//        }
//        if (_currenttableView.contentOffset.y < -30) {
//            _pageCount = 1;
//            [self getTableViewSource:_pageCount nodeIds:_currentNodeId];
//        }
//    }
//}

// tableView相关方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsResult *newsResult = _dataArray[indexPath.row];
    if ([newsResult.type isEqualToString:@"huandeng"]) {
        return 250;
    } else if ([newsResult.type isEqualToString:@"santu"]) {
        return 180;
    } else if ([newsResult.type isEqualToString:@"hengtu"]) {
        return 180;
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", _dataArray.count);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
