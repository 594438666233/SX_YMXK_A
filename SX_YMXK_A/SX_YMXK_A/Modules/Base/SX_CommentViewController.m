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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableViewDataArray = [NSMutableArray array];
    _pageCount = 1;
    [self getTableViewSourceWithPageIndex:_pageCount];
    [self createView];
    
}




- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SX_CommentTableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];

    [self.view addSubview:_tableView];
}


- (void)createView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40 - 64, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor colorWithRed:0.9425 green:0.9425 blue:0.9425 alpha:1.0];
    [self.view addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 5, view.frame.size.width * 3 / 5, 30);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
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
