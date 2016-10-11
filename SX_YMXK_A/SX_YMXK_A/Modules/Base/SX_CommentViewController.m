//
//  SX_CommentViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_CommentViewController.h"
#import "SX_CommentTableViewCell.h"
#import "SX_DataRequest.h"
#import "SX_Comment.h"
#import "MJRefresh.h"
#import "SX_TextViewController.h"
#import "SX_ArticleResult.h"
#import "JXLDayAndNightMode.h"

static NSString *const tableViewIdentifier = @"tableViewCell";



@interface SX_CommentViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation SX_CommentViewController

- (void)getTableViewSourceWithPageIndex:(NSInteger)pageIndex {

    NSDictionary *dic = @{@"topicId":[NSNumber numberWithInteger:_data.Id], @"pageIndex":[NSNumber numberWithInteger:pageIndex], @"pageSize":@20};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *str2 = [NSString stringWithFormat:@"http://cm.gamersky.com/appapi/GetAllComment?jsondata=%@", str];
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

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"评论";
    [self.view jxl_setDayMode:^(UIView *view) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } nightMode:^(UIView *view) {
        self.view.backgroundColor = [UIColor blackColor];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.912 green:0.912 blue:0.912 alpha:1.0]}];
    }];


    
    
    
    self.tableViewDataArray = [NSMutableArray array];
    _pageCount = 1;
    [self getTableViewSourceWithPageIndex:_pageCount];
    [self createView];
    
}




- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView jxl_setDayMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    [_tableView registerClass:[SX_CommentTableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];

    [self.view addSubview:_tableView];
}


- (void)createView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40 - 64, self.view.frame.size.width, 40)];
    [view jxl_setDayMode:^(UIView *view) {
        view.backgroundColor = [UIColor colorWithRed:0.9425 green:0.9425 blue:0.9425 alpha:1.0];
    } nightMode:^(UIView *view) {
        view.backgroundColor = [UIColor colorWithRed:0.6887 green:0.6851 blue:0.6923 alpha:1.0];
    }];
    [self.view addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 5, view.frame.size.width * 3 / 5, 30);
    [button jxl_setDayMode:^(UIView *view) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
    } nightMode:^(UIView *view) {
        [button setTitleColor:[UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:0.7693 green:0.7693 blue:0.7693 alpha:1.0]];
    }];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.clipsToBounds = YES;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"我来说两句..." forState:UIControlStateNormal];
    [view addSubview:button];
}

- (void)buttonAction {
    
    SX_TextViewController *textVC = [[SX_TextViewController alloc] init];
    self.definesPresentationContext = YES;
    textVC.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.38];
    textVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    textVC.data = _data;
    [self presentViewController:textVC animated:NO completion:nil];
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
    [cell jxl_setDayMode:^(UIView *view) {
        cell.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        cell.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_Comment *comment = _tableViewDataArray[indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1000)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16];
    label.text = comment.content;
    [label sizeToFit];
    return label.frame.size.height + 130;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
