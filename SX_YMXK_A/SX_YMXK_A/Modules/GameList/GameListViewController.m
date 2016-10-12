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
#import "SX_GameViewController.h"
#import "SX_FocusGameViewController.h"
#import "JXLDayAndNightMode.h"

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

@property (nonatomic, strong) SX_FocusGameViewController *FGVC;

//@property (nonatomic, assign) BOOL isMenuShow;

@end

@implementation GameListViewController

- (void)getCollectionViewSource:(NSInteger)pageIndex {
    NSDictionary *dic = @{@"nodeIds":@"hot",
                                       @"date":@0,
                                       @"type":@"current",
                                       @"pageIndex":[NSString stringWithFormat:@"%ld", pageIndex],
                                       @"elementsCountPerPage":@"20"};

    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/twoGameList" body:dic block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_GameListResult *gameListResult = [SX_GameListResult modelWithDic:dic];
            [_dataArray addObject:gameListResult];
        }
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
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
    [_collectionView jxl_setDayMode:^(UIView *view) {
        _collectionView.backgroundColor = [UIColor colorWithRed:1.0 green:0.9983 blue:0.9951 alpha:1.0];
    } nightMode:^(UIView *view) {
        _collectionView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    [_collectionView registerClass:[SX_GameListCollectionViewCell class] forCellWithReuseIdentifier:collectionViewIdentifier];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
    
    [_scrollView addSubview:_collectionView];
    
    [_collectionView.mj_header beginRefreshing];
}

- (void)pullRefresh {
    _pageCount = 1;
    [self getCollectionViewSource:_pageCount];
}

- (void)pullLoading {
    _pageCount++;
    [self getCollectionViewSource:_pageCount];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults arrayForKey:@"gameList"];
    
    if (array.count > 0) {
        
        [self addChildViewController:_FGVC];
        [_scrollView addSubview:_FGVC.view];

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionDataArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    [_collectionDataArray addObjectsFromArray:@[@"游戏库", @"我的关注"]];
    
    
    [self.view jxl_setDayMode:^(UIView *view) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(menuAction)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    } nightMode:^(UIView *view) {
        self.view.backgroundColor = [UIColor blackColor];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(menuAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;

    }];

    
    
    
    // 导航栏中间菜单
    [self createNavigationCollectionView];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108)];
    [_scrollView jxl_setDayMode:^(UIView *view) {
        _scrollView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _scrollView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _collectionDataArray.count, _scrollView.frame.size.height);
    [self.view addSubview:_scrollView];
    
    [self createCollectionView];
    [_collectionView reloadData];
    
    self.FGVC = [[SX_FocusGameViewController alloc] init];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
        [_navigationCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_navigationCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_navigationCollectionView]) {
        SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.textFont = 17;
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * indexPath.item, 0);
    }
    else {
        SX_GameListResult *gameListResult = _dataArray[indexPath.item];
        SX_GameViewController *gameVC = [[SX_GameViewController alloc] init];
        gameVC.contentId = gameListResult.contentId;
        [self.navigationController pushViewController:gameVC animated:YES];
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
    [cell jxl_setDayMode:^(UIView *view) {
        cell.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        cell.backgroundColor = [UIColor clearColor];
    }];
    return cell;
}

// 导航栏左按钮事件
- (void)menuAction {
    if (self.isMenuShow == NO) {
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
    self.isMenuShow = !self.isMenuShow;
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
