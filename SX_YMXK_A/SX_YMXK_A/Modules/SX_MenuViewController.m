//
//  SX_MenuViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/27.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_MenuViewController.h"
#import "SX_MenuTableViewCell.h"
#import "SX_LoginViewController.h"
#import "UIButton+WebCache.h"
#import "SX_DataRequest.h"
#import "SX_ImportantViewController.h"
#import "SX_SearchViewController.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

static NSString *const tableViewIdentifier = @"tableViewCell";

@interface SX_MenuViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *picNameArray;

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *textButton;

@end

@implementation SX_MenuViewController

- (void)getSource {
    self.nameArray = @[@"搜索", @"要闻", @"收藏", @"评论回复", @"夜间模式", @"3G/4G无图", @"清除缓存", @"我要反馈", @"更多设置"];
    self.picNameArray = @[@"Search", @"Message", @"Favority", @"MyCommentReplies", @"NightMode", @"2G3GNullImageMode", @"ClearCache", @"FeedBack", @"Setting"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self getSource];
    [self createButton];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:@"userName"];
    NSString *picName = [userDefaults objectForKey:@"userAvatar"];
    
    if (username == nil) {
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"common_Icon_Login_40x40_UIMode_Day"] forState:UIControlStateNormal];
        [_textButton setTitle:@"点击登录" forState:UIControlStateNormal];
    }
    else {
        [_imageButton sd_setBackgroundImageWithURL:(NSURL *)picName forState:UIControlStateNormal];
        [_textButton setTitle:username forState:UIControlStateNormal];
    }
}


- (void)createButton {
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageButton.frame = CGRectMake((WIDTH - 100 - 80) / 2, 50, 80, 80);
    _imageButton.clipsToBounds = YES;
    _imageButton.layer.cornerRadius = _imageButton.frame.size.width / 2;
    [_imageButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imageButton];
    
    self.textButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _textButton.frame = CGRectMake((WIDTH - 100 - 80) / 2, 140, 80, 20);
    [_textButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_textButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textButton];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, WIDTH, HEIGHT - 170) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SX_MenuTableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
}
// 点击登录和退出事件
- (void)loginAction {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:@"userName"];
    if (username == nil) {
        SX_LoginViewController *loginVC = [[SX_LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定退出登录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                                  @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                                  @"os":@"iOS",
                                  @"osVersion":@"9.3.5",
                                  @"app":@"GSApp",
                                  @"appVersion":@"2.3.3",
                                  @"request":@{@"userId":[NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"userId"]],
                                               @"loginToken":[NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"loginToken"]]}
                                  };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/Logout" body:str block:^(id result) {
                [userDefaults removeObjectForKey:@"userName"];
                [userDefaults removeObjectForKey:@"userId"];
                [userDefaults removeObjectForKey:@"loginToken"];
                [userDefaults removeObjectForKey:@"userAvatar"];
                [userDefaults synchronize];
            }];
            [_imageButton setBackgroundImage:[UIImage imageNamed:@"common_Icon_Login_40x40_UIMode_Day"] forState:UIControlStateNormal];
            [_textButton setTitle:@"点击登录" forState:UIControlStateNormal];

        }];
        [alertController addAction:action];

        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        }

}

// tableView方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SX_MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    cell.name = _nameArray[indexPath.row];
    cell.picName = _picNameArray[indexPath.row];
    NSLog(@"%ld", _nameArray.count);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            SX_SearchViewController *searchVC = [[SX_SearchViewController alloc] init];
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        }
        case 1:
        {
            SX_ImportantViewController *importantVC = [[SX_ImportantViewController alloc] init];
            [self.navigationController pushViewController:importantVC animated:YES];
            break;
        }
        case 2:
        {
            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            break;
        }
        case 5:
        {
            break;
        }
        case 6:
        {
            break;
        }
        case 7:
        {
            break;
        }
        case 8:
        {
            break;
        }
    }
}

// 显示缓存大小

- (float)filePath

{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
}



- (long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}



- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}



- (void)clearCache:(NSString *)path{
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
