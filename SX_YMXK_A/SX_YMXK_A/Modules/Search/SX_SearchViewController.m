//
//  SX_SearchViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/30.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_SearchViewController.h"

@interface SX_SearchViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation SX_SearchViewController

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    // 导航栏左按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem= leftBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"搜索";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

- (void)createTextField {
    self.searchTextField = [[UITextField alloc] init];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
