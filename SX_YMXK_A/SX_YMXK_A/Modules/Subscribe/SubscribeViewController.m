//
//  SubscribeViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/19.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SX_CollectionViewCell.h"
#import "SX_MySubscribeViewController.h"
#import "SX_SubscribeNewsViewController.h"
#import "SX_SubscribeTopicViewController.h"
#import "JXLDayAndNightMode.h"


static NSString * const NCVIdentifier = @"navigationCollectionCell";

@interface SubscribeViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *navigationCollectionView;

@property (nonatomic, strong) NSMutableArray *NCVDataArray;

@property (nonatomic, strong) SX_SubscribeNewsViewController *SNVC;
@property (nonatomic, strong) SX_SubscribeTopicViewController *STVC;

@property (nonatomic, assign) NSInteger appearCount;

//@property (nonatomic, assign) BOOL isMenuShow;

@end

@implementation SubscribeViewController

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

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults arrayForKey:@"dingyue"];
    
    if (array.count > 0) {
        [self addChildViewController:_STVC];
        [self addChildViewController:_SNVC];
        [_scrollView addSubview:_SNVC.view];
        [_scrollView addSubview:_STVC.view];
        _appearCount = 1;
    }
    else {
        if (_appearCount == 1) {
            [_SNVC.view removeFromSuperview];
            [_STVC.view removeFromSuperview];
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.NCVDataArray = [NSMutableArray array];
    [_NCVDataArray addObjectsFromArray:@[@"订阅内容", @"订阅专题"]];
    self.appearCount = 0;
    
    [self.view jxl_setDayMode:^(UIView *view) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(menuAction)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
        
        // 导航栏右按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"common_Icon_AddButton_20x20_UIMode_Day"] forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 20, 20);
        [rightButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    } nightMode:^(UIView *view) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(menuAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        
        // 导航栏右按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"common_Icon_AddButton_20x20_UIMode_Night"] forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 20, 20);
        [rightButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    }];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // 导航栏中间菜单
    [self createNavigationCollectionView];

    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108)];
    [_scrollView jxl_setDayMode:^(UIView *view) {
        _scrollView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _scrollView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    
    _scrollView.pagingEnabled = YES;

    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _NCVDataArray.count, _scrollView.frame.size.height);
    
    for (int i = 0; i < _NCVDataArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((_scrollView.frame.size.width - 182) / 2 + _scrollView.frame.size.width * i, (_scrollView.frame.size.height - 75) / 2, 182, 75);
            UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_Icon_Subscribe_40x40_UIMode_Day"]];
            imageView1.frame = CGRectMake(0, 0, 40, 40);
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_CaptionImage_NewSubscribe_142x35_UIMode_Day"]];
            imageView2.frame = CGRectMake(40, 5, 142, 35);
            [button addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:imageView1];
            [button addSubview:imageView2];
            [_scrollView addSubview:button];

    }
    [self.view addSubview:_scrollView];


    self.SNVC = [[SX_SubscribeNewsViewController alloc] init];
    self.STVC = [[SX_SubscribeTopicViewController alloc] init];

    
}

- (void)rightBarButtonItemAction {
    SX_MySubscribeViewController *mySubscribeViewController = [[SX_MySubscribeViewController alloc] init];
    [self.navigationController pushViewController:mySubscribeViewController animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _NCVDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NCVIdentifier forIndexPath:indexPath];
    cell.text = _NCVDataArray[indexPath.item];
    cell.textFont = 15;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textFont = 17;
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * indexPath.item, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SX_CollectionViewCell *cell = (SX_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.textFont = 15;
}

// 翻页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
        [_navigationCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [_navigationCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
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


@end
