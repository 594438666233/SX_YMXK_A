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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.9468 blue:0.7594 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    self.NCVDataArray = [NSMutableArray array];
    [_NCVDataArray addObjectsFromArray:@[@"订阅内容", @"订阅专题"]];
    
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_OptionButton_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    // 导航栏中间菜单
    [self createNavigationCollectionView];
    // 导航栏右按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_AddButton_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
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
