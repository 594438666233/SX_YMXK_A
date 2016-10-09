//
//  SX_CommentMeViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_CommentMeViewController.h"
#import "SX_DataRequest.h"
#import "SX_Comment.h"
#import "MJRefresh.h"
#import "SX_CommentTableViewCell.h"
#import "SX_NewsDetailViewController.h"

static NSString *const tableViewIdentifier = @"tableViewCell";

@interface SX_CommentMeViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
SX_CommentCellDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation SX_CommentMeViewController

- (void)getTableViewSourceWithPageIndex:(NSInteger)pageIndex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [userDefaults objectForKey:@"userId"];
    if (userId != nil) {
        NSDictionary *dic = @{@"userId":userId, @"pageIndex":[NSNumber numberWithInteger:pageIndex], @"pageSize":@20};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *str2 = [NSString stringWithFormat:@"http://cm.gamersky.com/appapi/GetUserComment?jsondata=%@", str];
        NSString *str3 =  [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [SX_DataRequest GETRequestWithString:str3 block:^(id result) {
            NSArray *array =  [[result objectForKey:@"result"] objectForKey:@"comments"];
            if (pageIndex == 1 && _tableViewDataArray.count > 0) {
                [_tableViewDataArray removeAllObjects];
            }
            if (array.count > 0) {
                for (NSDictionary *dic in array) {
                    SX_Comment *comment = [SX_Comment modelWithDic:dic];
                    [_tableViewDataArray addObject:comment];
                }
                [self createTableView];
                [_tableView reloadData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
            }
        }];

    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }

    
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SX_CommentTableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
    
    [self.view addSubview:_tableView];
}

- (void)pullRefresh {
    _pageCount = 1;
    [self getTableViewSourceWithPageIndex:_pageCount];
}

- (void)pullLoading {
    _pageCount++;
    [self getTableViewSourceWithPageIndex:_pageCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    SX_Comment *comment = _tableViewDataArray[indexPath.row];
    cell.comment = comment;
    cell.topic_delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_Comment *comment = _tableViewDataArray[indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1000)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16];
    label.text = comment.content;
    [label sizeToFit];
    NSLog(@"%f", label.frame.size.height + 100);
    return label.frame.size.height + 130;
}



- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem= leftBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"回复我的";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    self.tableViewDataArray = [NSMutableArray array];
    _pageCount = 1;
    [self getTableViewSourceWithPageIndex:_pageCount];
}

// 协议方法
- (void)getTopicId:(NSInteger)topicId {
    SX_NewsDetailViewController *newsDetailVC = [[SX_NewsDetailViewController alloc] init];
    newsDetailVC.contentId = topicId;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
