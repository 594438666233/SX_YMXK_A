//
//  GameListViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/19.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "GameListViewController.h"
#import "SX_CollectionViewCell.h"
#import "SX_DataRequest.h"
#import "SX_GameListResult.h"
#import "SX_GameListCollectionViewCell.h"
#import <MJRefresh.h>

static NSString * const NCVIdentifier = @"navigationCollectionCell";
static NSString * const collectionViewIdentifier = @"gameListCollectionCell";

@interface GameListViewController ()
<
UIScrollViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *navigationCollectionView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *collectionDataArray;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation GameListViewController

- (void)getCollectionViewSource:(NSInteger)pageIndex {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"nodeIds":@"hot",
                                       @"date":@0,
                                       @"type":@"current",
                                       @"pageIndex":[NSString stringWithFormat:@"%ld", pageIndex],
                                       @"elementsCountPerPage":@"20"}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/twoGameList" body:str block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (_dataArray.count != 0 && pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_GameListResult *gameListResult = [SX_GameListResult modelWithDic:dic];
            [_dataArray addObject:gameListResult];
        }
        [_collectionView reloadData];
    }];
}

// 创建导航栏的collectionView
- (void)createNavigationCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.itemSize = CGSizeMake(70 , 44);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.navigationCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 160, 44) collectionViewLayout:flowLayout];
    _navigationCollectionView.delegate = self;
    _navigationCollectionView.dataSource = self;
    _navigationCollectionView.backgroundColor = [UIColor colorWithRed:0.995 green:0.8961 blue:0.9789 alpha:0.0];
    [_navigationCollectionView registerClass:[SX_CollectionViewCell class] forCellWithReuseIdentifier:NCVIdentifier];
    self.navigationItem.titleView = _navigationCollectionView;
    
}

// 创建collectionView
- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width - 60) / 3, (self.view.frame.size.width - 60) / 9 * 6);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _scrollView.frame.size.height) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:1.0 green:0.9983 blue:0.9951 alpha:1.0];
    [_collectionView registerClass:[SX_GameListCollectionViewCell class] forCellWithReuseIdentifier:collectionViewIdentifier];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
    
    [_scrollView addSubview:_collectionView];
    
    [_collectionView.mj_header beginRefreshing];
}

- (void)pullRefresh {
    _pageCount = 1;
    [self getCollectionViewSource:_pageCount];
    [_collectionView.mj_header endRefreshing];
}

- (void)pullLoading {
    _pageCount++;
    [self getCollectionViewSource:_pageCount];
    [_collectionView.mj_footer endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:0.5788 green:0.7603 blue:1.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    self.collectionDataArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    [_collectionDataArray addObjectsFromArray:@[@"游戏库", @"我的关注"]];
    
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    // 导航栏中间菜单
    [self createNavigationCollectionView];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108)];
    _scrollView.backgroundColor = [UIColor colorWithRed:0.5396 green:0.6387 blue:1.0 alpha:1.0];
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _collectionDataArray.count, _scrollView.frame.size.height);
    [self.view addSubview:_scrollView];
    
    [self createCollectionView];
    [_collectionView reloadData];

}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_navigationCollectionView]) {
        SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.textFont = 17;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_navigationCollectionView]) {
        SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.textFont = 15;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:_navigationCollectionView]) {
        return _collectionDataArray.count;
    }
    NSLog(@"----%ld", _dataArray.count);
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_navigationCollectionView]) {
        SX_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NCVIdentifier forIndexPath:indexPath];
        cell.text = _collectionDataArray[indexPath.item];
        cell.textFont = 15;
        return cell;
    }
    SX_GameListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewIdentifier forIndexPath:indexPath];
    SX_GameListResult *gameListResult = _dataArray[indexPath.item];
    cell.gameListResult = gameListResult;
    return cell;
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
