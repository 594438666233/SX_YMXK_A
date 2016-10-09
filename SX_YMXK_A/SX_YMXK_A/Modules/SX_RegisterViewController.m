//
//  SX_RegisterViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/29.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_RegisterViewController.h"
#import "Masonry.h"
#import "SX_DataRequest.h"

@interface SX_RegisterViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmTextField;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SX_RegisterViewController

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUsername {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{}
                          };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/GetRandomUserName" body:str block:^(id result) {
        _usernameTextField.text = [[result objectForKey:@"result"] objectForKey:@"userName"];
    }];
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
    [self getUsername];
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
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_Icon_PasswordLock_16x16_UIMode_Day"]];
    passwordImageView.frame = CGRectMake(0, 0, 40, 40);
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
    
    UIImageView *confirmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_Icon_PasswordLock_16x16_UIMode_Day"]];
    confirmImageView.frame = CGRectMake(0, 0, 40, 40);
    confirmImageView.contentMode = UIViewContentModeCenter;
    
    self.confirmTextField = [[UITextField alloc] init];
    _confirmTextField.delegate = self;
    _confirmTextField.secureTextEntry = YES;
    _confirmTextField.backgroundColor = [UIColor whiteColor];
    _confirmTextField.leftViewMode = UITextFieldViewModeAlways;
    _confirmTextField.leftView = confirmImageView;
    _confirmTextField.clipsToBounds = YES;
    _confirmTextField.placeholder = @"请再次输入密码";
    _confirmTextField.layer.cornerRadius = 7.f;
    _confirmTextField.layer.borderWidth = 0.5;
    _confirmTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_confirmTextField];
    [_confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@50);
    }];

}

- (void)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:1.0 green:0.3223 blue:0.2345 alpha:1.0];
    [button addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 7.f;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@50);
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
    self.navigationItem.title = @"注册";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self createTextField];
    
    self.label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor colorWithRed:1.0 green:0.258 blue:0.2622 alpha:0.0];
    _label.text = @"";
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = [UIColor grayColor];
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@20);
    }];
    
    
    [self createButton];


}

- (void)finishAction {
    if (![_confirmTextField.text isEqualToString:_passwordTextField.text]) {
        _label.text = @"两次输入密码不相同!";
    }
    else {
        NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                              @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                              @"os":@"iOS",
                              @"osVersion":@"9.3.5",
                              @"app":@"GSApp",
                              @"appVersion":@"2.3.3",
                              @"request":@{@"phoneNumber":_phoneNumber,
                                           @"userName":_usernameTextField.text,
                                           @"password":_passwordTextField.text,
                                           @"varifyToken":_varifyToken}
                              };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/Register" body:str block:^(id result) {
            NSNumber *errorCode = [result objectForKey:@"errorCode"];
            if ([errorCode isEqual:@0]) {
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
                    [self.navigationController popToRootViewControllerAnimated:YES];
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
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
