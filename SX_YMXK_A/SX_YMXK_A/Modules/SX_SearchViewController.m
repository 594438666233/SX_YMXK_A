//
//  SX_SearchViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_SearchViewController.h"
#import "Masonry.h"
#import "SX_santuTableViewCell.h"
#import "SX_hengtuTableViewCell.h"
#import "SX_huandengTableViewCell.h"
#import "SX_xinwenTableViewCell.h"
#import "MJRefresh.h"
#import "SX_DataRequest.h"
#import "SX_NewsResult.h"
#import "SX_NewsDetailViewController.h"


static NSString * const santuIdentifier = @"santu";
static NSString * const xinwenIdentifier = @"xinwen";
static NSString * const hengtuIdentifier = @"hengtu";
static NSString * const huandengIdentifier = @"huandeng";

@interface SX_SearchViewController ()
<
UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *newsButton;
@property (nonatomic, strong) UIButton *strategyButton;

@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) UITableView *currentTableView;

@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, copy) NSString *currentType;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SX_SearchViewController

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)getTableViewSource:(NSInteger)pageIndex searchKey:(NSString *) searchKey searchType:(NSString *)searchType {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"searchType":searchType,
                                       @"searchKey":searchKey,
                                       @"pageIndex":[NSNumber numberWithInteger:pageIndex],
                                       @"elementsCountPerPage":@20
                                       }};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/TwoSearch" body:str block:^(id result) {
        NSArray *array = [result objectForKey:@"result"];
        if (_tableViewDataArray.count != 0 && pageIndex == 1) {
            [_tableViewDataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            SX_NewsResult *newsResult = [SX_NewsResult modelWithDic:dic];
            [_tableViewDataArray addObject:newsResult];
        }
        [_currentTableView reloadData];
        [_currentTableView.mj_header endRefreshing];
        [_currentTableView.mj_footer endRefreshing];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9354 green:0.9304 blue:0.9403 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem= leftBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"搜索";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.currentType = @"news";
    self.pageCount = 1;
    self.currentPage = 0;
    self.tableViewDataArray = [NSMutableArray array];
    self.tableViewArray = [NSMutableArray array];
    
    [self createTextField];
    [self createButton];
    [self createScrollView];
    [self createTableView];
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
    _newsButton.frame = CGRectMake((self.view.frame.size.width - 60) / 4, 50, 60, 60);
    
    self.strategyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_strategyButton setTitle:@"攻略" forState:UIControlStateNormal];
    [_strategyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_strategyButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_strategyButton addTarget:self action:@selector(strategyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_strategyButton];
    _strategyButton.frame = CGRectMake((self.view.frame.size.width - 60) / 4 * 3, 50, 60, 60);
}

- (void)createTextField {
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_Icon_Search_20x20_UIMode_Day"]];
    searchImageView.frame = CGRectMake(0, 0, 40, 40);
    searchImageView.contentMode = UIViewContentModeCenter;

    self.searchTextField = [[UITextField alloc] init];
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = [UIColor whiteColor];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.leftView = searchImageView;
    _searchTextField.clipsToBounds = YES;
    _searchTextField.placeholder = @"输入搜索内容";
    _searchTextField.layer.cornerRadius = 7.f;
    _searchTextField.layer.borderWidth = 0.5;
    _searchTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    
}

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110 - 64)];
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
        [tableView registerClass:[SX_santuTableViewCell class] forCellReuseIdentifier:santuIdentifier];
        [tableView registerClass:[SX_hengtuTableViewCell class] forCellReuseIdentifier:hengtuIdentifier];
        [tableView registerClass:[SX_huandengTableViewCell class] forCellReuseIdentifier:huandengIdentifier];
        [tableView registerClass:[SX_xinwenTableViewCell class] forCellReuseIdentifier:xinwenIdentifier];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
        tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
        
        [_scrollView addSubview:tableView];
        [_tableViewArray addObject:tableView];
    }
    self.currentTableView = _tableViewArray[0];
}

- (void)pullRefresh {
    _pageCount = 1;
    [self getTableViewSource:_pageCount searchKey:_searchTextField.text searchType:_currentType];
}

- (void)pullLoading {
    _pageCount++;
    [self getTableViewSource:_pageCount searchKey:_searchTextField.text searchType:_currentType];
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
    SX_NewsResult *newsResult = _tableViewDataArray[indexPath.row];
    if ([newsResult.type isEqualToString:@"huandeng"]) {
        return self.view.frame.size.height / 3;
    } else if ([newsResult.type isEqualToString:@"santu"]) {
        return (self.view.frame.size.width - 40) / 3 / 4 * 3 + 80;
    } else if ([newsResult.type isEqualToString:@"hengtu"]) {
        return self.view.frame.size.height / 3.5;
    }
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_NewsResult *newsResult = _tableViewDataArray[indexPath.row];
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
    SX_NewsResult *newsResult = _tableViewDataArray[indexPath.row];
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    newsDetailVC.contentId = newsResult.contentId;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
    _currentTableView.userInteractionEnabled = NO;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    _currentTableView.userInteractionEnabled = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [_currentTableView.mj_header beginRefreshing];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
