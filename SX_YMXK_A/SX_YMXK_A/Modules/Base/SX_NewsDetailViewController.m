//
//  SX_NewsDetailViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/26.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_NewsDetailViewController.h"
#import "SX_DataRequest.h"
#import "SX_ArticleResult.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SX_NewsDetailViewController ()
<
UIWebViewDelegate
>

@property (nonatomic, strong) SX_ArticleResult *data;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SX_NewsDetailViewController

- (void)getSource {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                              @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                              @"os":@"iOS",
                              @"osVersion":@"9.3.5",
                              @"app":@"GSApp",
                              @"appVersion":@"2.3.3",
                              @"request":@{@"contentId":[NSNumber numberWithInteger:self.contentId],
                                           @"pageIndex":@1}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/TwoArticle" body:str block:^(id result) {
        NSDictionary *dic = [result objectForKey:@"result"];
//        if (pageIndex == 1) {
//            [_dataArray removeAllObjects];
//            }
        self.data = [SX_ArticleResult modelWithDic:dic];
        NSLog(@"%@", _data);
        [self createTitle];
        [self getWebView];
    }];
}


- (void)createTitle {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    titleLabel.text = _data.title;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.numberOfLines = 2;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    subTitleLabel.text = _data.subTitle;
    subTitleLabel.numberOfLines = 2;
    subTitleLabel.font = [UIFont systemFontOfSize:15];
    subTitleLabel.backgroundColor = [UIColor whiteColor];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = [UIColor grayColor];
    [self.view addSubview:subTitleLabel];
    
}

- (void)getWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80)];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_data.originURL]];
//    [_webView loadRequest:request];
//    NSString *str = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>", self.view.frame.size.width - 20]; 
    NSMutableString *tempStr = [NSMutableString stringWithString:_data.mainBody];
//    [tempStr insertString:str atIndex:0];
    [_webView loadHTMLString:tempStr baseURL:nil];
    _webView.scalesPageToFit = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem= leftBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self getSource];
}

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
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
