//
//  SX_MySubscribeViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/24.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_MySubscribeViewController.h"
#import "SX_DataRequest.h"
#import "SX_SubscribeResult.h"
#import "SX_CollectionViewCell.h"
#import "MySubscribeTableViewCell.h"
#import "MJRefresh.h"
#import "SX_SubscribeDetailViewController.h"
#import "JXLDayAndNightMode.h"

static NSString * const collectionViewIdentifier = @"collectionCell";
static NSString * const tableViewIdentifier = @"tableViewCell";

@interface SX_MySubscribeViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate
>

@property (nonatomic, strong) NSMutableArray *NCVDataArray;
@property (nonatomic, strong) NSMutableArray *tableViewDataArray;

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *tableViewArray;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation SX_MySubscribeViewController

- (void)getTableViewSource:(NSInteger)pageIndex {
    NSDictionary *dic = @{@"type":[NSNumber numberWithInteger:pageIndex],
                                       };

    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/subscribe" body:dic block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (_tableViewDataArray.count != 0) {
            [_tableViewDataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_SubscribeResult *subscribeResult = [SX_SubscribeResult modelWithDic:dic];
            [_tableViewDataArray addObject:subscribeResult];
        }
        [_currentTableView reloadData];
        [_currentTableView.mj_header endRefreshing];
        [_currentTableView.mj_footer endRefreshing];
    }];
}

// 创建导航栏的collectionView
- (void)createNavigationCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.itemSize = CGSizeMake(70 , 44);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 160, 44) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:0.995 green:0.8961 blue:0.9789 alpha:0.0];
    [_collectionView registerClass:[SX_CollectionViewCell class] forCellWithReuseIdentifier:collectionViewIdentifier];
    self.navigationItem.titleView = _collectionView;
    
}

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108)];
    [_scrollView jxl_setDayMode:^(UIView *view) {
        _scrollView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _scrollView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _NCVDataArray.count, _scrollView.frame.size.height);
    [self.view addSubview:_scrollView];
}

- (void)createTableView {
    for (int i = 0; i < _NCVDataArray.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];

        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
        
        
        [_scrollView addSubview:tableView];
        [_tableViewArray addObject:tableView];
    }
    self.currentTableView = _tableViewArray[0];
    [self getTableViewSource:_pageCount];

}

- (void)pullRefresh {
    [self getTableViewSource:_pageCount];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view jxl_setDayMode:^(UIView *view) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        // 导航栏右按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"common_Icon_Search_20x20_Gray_UIMode_Day"] forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 20, 20);
        [rightButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    } nightMode:^(UIView *view) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        
        // 导航栏右按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"common_Icon_Search_20x20_Gray_UIMode_Night"] forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 20, 20);
        [rightButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    }];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // 导航栏中间菜单
    [self createNavigationCollectionView];
    
    self.tableViewArray = [NSMutableArray array];
    self.tableViewDataArray = [NSMutableArray array];
    self.NCVDataArray = [NSMutableArray array];
    _pageCount = 0;
    [_NCVDataArray addObjectsFromArray:@[@"热门", @"全部"]];
    



    
    // 创建滑动视图
    [self createScrollView];
    // 创建tableView
    [self createTableView];

}

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonItemAction {
    
}

// 翻页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
            _currentTableView = _tableViewArray[currentPage];
            _pageCount = currentPage;
            [_currentTableView.mj_header beginRefreshing];
    
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

// tableView方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MySubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    cell = [[MySubscribeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewIdentifier];

    SX_SubscribeResult *subscribeResult = _tableViewDataArray[indexPath.row];
    cell.subscribeResult = subscribeResult;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_SubscribeDetailViewController *subscribeDetailVC = [[SX_SubscribeDetailViewController alloc] init];
    SX_SubscribeResult *result = _tableViewDataArray[indexPath.row];
    subscribeDetailVC.subsribeResult = result;
    [self.navigationController pushViewController:subscribeDetailVC animated:YES];
}



// collectionView方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _NCVDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewIdentifier forIndexPath:indexPath];
    cell.text = _NCVDataArray[indexPath.item];
    cell.textFont = 15;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textFont = 17;
    
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * indexPath.item, 0);
    if (indexPath.item < 2) {
        _currentTableView = _tableViewArray[indexPath.item];
        _pageCount = indexPath.item;
        [_currentTableView.mj_header beginRefreshing];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textFont = 15;
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
