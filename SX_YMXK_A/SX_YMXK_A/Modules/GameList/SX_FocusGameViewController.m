//
//  SX_FocusGameViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/10.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_FocusGameViewController.h"
#import "SX_FocusTableViewCell.h"
#import "SX_GameDetailResult.h"
#import "MJRefresh.h"
#import "SX_GameViewController.h"
#import "JXLDayAndNightMode.h"

static NSString *const cellIdentifier = @"cellIdentifier";

@interface SX_FocusGameViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SX_FocusGameViewController


- (void)getTableViewSource {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.tableViewDataArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"gameList"]];
    if (_tableViewDataArray.count == 0) {
        [self.view removeFromSuperview];
    }else {
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    self.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableViewDataArray = [NSMutableArray array];
    
    
    [self createTableView];
    
}

- (void)pullRefresh {
    [self getTableViewSource];
}

- (void)pullLoading {
    [self getTableViewSource];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 108) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView jxl_setDayMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_GameDetailResult *result = [NSKeyedUnarchiver unarchiveObjectWithData:_tableViewDataArray[indexPath.row]];
    
    SX_FocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[SX_FocusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.gameDetailResult = result;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_GameViewController *gameVC = [[SX_GameViewController alloc] init];
    SX_GameDetailResult *result = [NSKeyedUnarchiver unarchiveObjectWithData:_tableViewDataArray[indexPath.row]];
    gameVC.contentId = result.contentId;
    [self.navigationController pushViewController:gameVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
