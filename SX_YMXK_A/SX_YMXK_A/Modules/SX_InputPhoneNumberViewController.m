//
//  SX_InputPhoneNumberViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/29.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_InputPhoneNumberViewController.h"
#import "Masonry.h"
#import "SX_DataRequest.h"
#import "SX_InputVerifyCodeViewController.h"
#import "JXLDayAndNightMode.h"


@interface SX_InputPhoneNumberViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *phoneNumberTextField;

@end

@implementation SX_InputPhoneNumberViewController

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTextField {
    UIImageView *phoneNumberImageView = [[UIImageView alloc] init];
    phoneNumberImageView.frame = CGRectMake(0, 0, 40, 40);
    phoneNumberImageView.contentMode = UIViewContentModeCenter;
    self.phoneNumberTextField = [[UITextField alloc] init];
    _phoneNumberTextField.delegate = self;
    _phoneNumberTextField.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    [_phoneNumberTextField jxl_setDayMode:^(UIView *view) {
        phoneNumberImageView.image = [UIImage imageNamed:@"common_Icon_Phone_13x18_UIMode_Day"];
    } nightMode:^(UIView *view) {
        phoneNumberImageView.image = [UIImage imageNamed:@"common_Icon_Phone_13x18_UIMode_Night"];
    }];
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumberTextField.leftView = phoneNumberImageView;
    _phoneNumberTextField.clipsToBounds = YES;
    _phoneNumberTextField.placeholder = @"请输入手机号";
    _phoneNumberTextField.layer.cornerRadius = 7.f;
    _phoneNumberTextField.layer.borderWidth = 0.5;
    _phoneNumberTextField.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:_phoneNumberTextField];
    [_phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(50);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(self.view.frame.size.height / 15));
    }];

}

- (void)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button jxl_setDayMode:^(UIView *view) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
    } nightMode:^(UIView *view) {
        [button setTitleColor:[UIColor colorWithRed:0.912 green:0.912 blue:0.912 alpha:1.0] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
    }];
    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 7.f;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneNumberTextField.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(self.view.frame.size.height / 15));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"注册";
    [self.view jxl_setDayMode:^(UIView *view) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.9873 green:0.1906 blue:0.2123 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } nightMode:^(UIView *view) {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
        // 导航栏左按钮
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"common_Icon_Back_20x20_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem= leftBarButtonItem;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.912 green:0.912 blue:0.912 alpha:1.0]}];
    }];

    
    [self createTextField];
    [self createButton];

}

- (void)nextAction {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"userInfo":[NSString stringWithFormat:@"%@", _phoneNumberTextField.text]}
                          };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/IsEmailAndPhone" body:str block:^(id result) {
        NSNumber *errorCode = [result objectForKey:@"errorCode"];
        if ([errorCode isEqual:@1]) {
            SX_InputVerifyCodeViewController *iVVC =[[SX_InputVerifyCodeViewController alloc] init];
            iVVC.phoneNumber = _phoneNumberTextField.text;
            [self.navigationController pushViewController:iVVC animated:YES];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该手机号已经注册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
    }];
}





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
