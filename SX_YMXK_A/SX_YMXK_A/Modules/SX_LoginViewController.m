//
//  SX_LoginViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/28.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_LoginViewController.h"
#import "Masonry.h"
#import "SX_DataRequest.h"
#import "SX_InputPhoneNumberViewController.h"

@interface SX_LoginViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation SX_LoginViewController


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}
- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTextField {
    UIImageView *usernameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_Icon_Account_16x16_UIMode_Day"]];
    usernameImageView.frame = CGRectMake(0, 0, 40, 40);
    usernameImageView.contentMode = UIViewContentModeCenter;
    self.usernameTextField = [[UITextField alloc] init];
    _usernameTextField.delegate = self;
    _usernameTextField.backgroundColor = [UIColor whiteColor];
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    _usernameTextField.leftView = usernameImageView;
    _usernameTextField.clipsToBounds = YES;
    _usernameTextField.placeholder = @"请输入用户名";
    _usernameTextField.layer.cornerRadius = 7.f;
    _usernameTextField.layer.borderWidth = 0.5;
    _usernameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_usernameTextField];
    [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@50);
    }];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_Icon_PasswordUnlock_16x16_UIMode_Day"]];
    passwordImageView.frame = CGRectMake(0, 0, 50, 50);
    passwordImageView.contentMode = UIViewContentModeCenter;
    self.passwordTextField = [[UITextField alloc] init];
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.leftView = passwordImageView;
    _passwordTextField.clipsToBounds = YES;
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.layer.cornerRadius = 7.f;
    _passwordTextField.layer.borderWidth = 0.5;
    _passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usernameTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@50);
    }];

}

- (void)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:1.0 green:0.3223 blue:0.2345 alpha:1.0];
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 7.f;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@50);
    }];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerButton setTitleColor:[UIColor colorWithRed:1.0 green:0.3058 blue:0.3499 alpha:1.0] forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor colorWithRed:0.9872 green:0.2242 blue:0.182 alpha:0.0];
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(10);
        make.width.equalTo(@100);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@20);
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
    self.navigationItem.title = @"用户登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self createTextField];
    
    [self createButton];

}
- (void)registerAction {
    SX_InputPhoneNumberViewController *iPNVC = [[SX_InputPhoneNumberViewController alloc] init];
    [self.navigationController pushViewController:iPNVC animated:YES];
}

- (void)loginAction {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"userInfo":[NSString stringWithFormat:@"%@", _usernameTextField.text],
                                       @"passWord":[NSString stringWithFormat:@"%@", _passwordTextField.text],
                                       @"veriCode":@""}
                          };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/TwoLogin" body:str block:^(id result) {
        NSString *str = [NSString stringWithFormat:@"%@", [result objectForKey:@"errorCode"]];
        if ([str isEqualToString:@"0"]) {
            
            NSString *loginToken = [[result objectForKey:@"result"] objectForKey:@"loginToken"];
            NSString *userName = [[result objectForKey:@"result"] objectForKey:@"userName"];
            NSString *userId = [[result objectForKey:@"result"] objectForKey:@"userId"];
            NSString *userAvatar = [[result objectForKey:@"result"] objectForKey:@"userAvatar"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:loginToken forKey:@"loginToken"];
            [userDefaults setObject:userId forKey:@"userId"];
            [userDefaults setObject:userAvatar forKey:@"userAvatar"];
            [userDefaults setObject:userName forKey:@"userName"];
            [userDefaults synchronize];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[result objectForKey:@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[result objectForKey:@"errorMessage"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
