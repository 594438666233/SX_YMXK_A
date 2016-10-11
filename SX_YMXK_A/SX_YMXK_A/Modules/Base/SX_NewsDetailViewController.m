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
#import "SX_CommentViewController.h"
#import "SX_NewsResult.h"
#import "JXLDayAndNightMode.h"

@interface SX_NewsDetailViewController ()
<
UIWebViewDelegate
>

@property (nonatomic, strong) SX_ArticleResult *data;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SX_NewsDetailViewController

- (void)dealloc {
    _webView.delegate = nil;
}

- (void)getSource {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                              @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                              @"os":@"iOS",
                              @"osVersion":@"9.3.5",
                              @"app":@"GSApp",
                              @"appVersion":@"2.3.3",
                              @"request":@{@"contentId":[NSNumber numberWithInteger:_contentId],
                                           @"pageIndex":@1}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/TwoArticle" body:str block:^(id result) {
        NSDictionary *dic = [result objectForKey:@"result"];
//        if (pageIndex == 1) {
//            [_dataArray removeAllObjects];
//            }
        self.data = [SX_ArticleResult modelWithDic:dic];
        [self getWebView];
    }];
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
    button.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.width / 25];
    button.clipsToBounds = YES;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"评论/查看评论" forState:UIControlStateNormal];
    [view addSubview:button];
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton jxl_setDayMode:^(UIView *view) {
        [collectButton setImage:[UIImage imageNamed:@"common_Icon_Favorite_26x26_UIMode_Day"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"common_Icon_FavoriteSelected_26x26_UIMode_Day"] forState:UIControlStateSelected];
    } nightMode:^(UIView *view) {
        [collectButton setImage:[UIImage imageNamed:@"common_Icon_Favorite_26x26_UIMode_Night"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"common_Icon_FavoriteSelected_26x26_UIMode_Night"] forState:UIControlStateSelected];
    }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"collection"]];
    for (int i = 0; i < mulArray.count; i++) {
        SX_NewsResult *result = [NSKeyedUnarchiver unarchiveObjectWithData:mulArray[i]];
        if (result.contentId == _newsResult.contentId) {
            collectButton.selected = YES;
            break;
        }
    }


    collectButton.frame = CGRectMake(button.frame.origin.x + button.frame.size.width + 30, 7, 26, 26);
    [collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectButton];
    
}

- (void)collectAction:(UIButton *)button {
    button.selected = !button.selected;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"collection"]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_newsResult];
    if (button.selected == YES) {
        [mulArray addObject:data];
    } else {
        [mulArray removeObject:data];
//        [mulArray removeAllObjects];
    }
    NSArray *array = [NSArray arrayWithArray:mulArray];
    [userDefaults setObject:array forKey:@"collection"];
    [userDefaults synchronize];

}

- (void)buttonAction {
    SX_CommentViewController *commentVC = [[SX_CommentViewController alloc] init];
    commentVC.data = _data;
    [self.navigationController pushViewController:commentVC animated:YES];
}


- (void)getWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40)];
    [_webView jxl_setDayMode:^(UIView *view) {
        _webView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        _webView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    }];
    
    NSString *html = [[NSBundle mainBundle] pathForResource:@"gsAppHTMLTemplate_News" ofType:@"html"];
    NSMutableString *htmlCont = [NSMutableString stringWithContentsOfFile:html encoding:NSUTF8StringEncoding error:nil];
    if (_data.mainBody != nil) {
        [htmlCont replaceOccurrencesOfString:@"#文章正文#" withString:_data.mainBody options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlCont.length)];
    }
    if (_data.title != nil) {
        [htmlCont replaceOccurrencesOfString:@"#文章标题#" withString:_data.title options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlCont.length)];
    }
    if (_data.subTitle != nil) {
        [htmlCont replaceOccurrencesOfString:@"#文章副标题#" withString:_data.subTitle options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlCont.length)];
    }
#pragma mark - WQNMLGB
    [_webView loadHTMLString:htmlCont baseURL:[NSURL URLWithString:html]];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.delegate = self;
    _webView.allowsInlineMediaPlayback = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
    
    [self.view addSubview:_webView];
}


//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSURL *requestURL = [request URL];
//    if (([[requestURL scheme] isEqualToString:@"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString:@"mailto"]) && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
//        return  ![[UIApplication sharedApplication] openURL:requestURL];
//    }
//    return YES;
//}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self getSource];
    [self createView];
}

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
