//
//  SX_InputVerifyCodeViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/29.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_InputVerifyCodeViewController.h"
#import "Masonry.h"
#import "SX_DataRequest.h"
#import "SX_RegisterViewController.h"

@interface SX_InputVerifyCodeViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UIButton *verifyCodeButton;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SX_InputVerifyCodeViewController

- (void)leftBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTextField {
    UIImageView *verifyCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_Icon_VerificationCode_16x16_UIMode_Day"]];
    verifyCodeImageView.frame = CGRectMake(0, 0, 40, 40);
    verifyCodeImageView.contentMode = UIViewContentModeCenter;
    
    self.verifyCodeTextField = [[UITextField alloc] init];
    _verifyCodeTextField.delegate = self;
    _verifyCodeTextField.backgroundColor = [UIColor whiteColor];
    _verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeTextField.leftView = verifyCodeImageView;
    _verifyCodeTextField.clipsToBounds = YES;
    _verifyCodeTextField.placeholder = @"请输入验证码";
    _verifyCodeTextField.layer.cornerRadius = 7.f;
    _verifyCodeTextField.layer.borderWidth = 0.5;
    _verifyCodeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_verifyCodeTextField];
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-180);
        make.height.equalTo(@50);
    }];
}

- (void)createButton {
    self.verifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _verifyCodeButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.3223 blue:0.2345 alpha:1.0];
    [_verifyCodeButton addTarget:self action:@selector(getVerifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    _verifyCodeButton.clipsToBounds = YES;
    _verifyCodeButton.layer.cornerRadius = 7.f;
    [self.view addSubview:_verifyCodeButton];
    [_verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(20);
        make.width.equalTo(@150);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@50);
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:1.0 green:0.3223 blue:0.2345 alpha:1.0];
    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 7.f;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verifyCodeButton.mas_bottom).offset(30);
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
    
    self.label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor colorWithRed:1.0 green:0.258 blue:0.2622 alpha:0.0];
    _label.text = @"";
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = [UIColor grayColor];
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self createTextField];
    
    [self createButton];
    
}

- (void)getVerifyCodeAction {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"codetype":@1,
                                       @"phoneNumber":[NSString stringWithFormat:@"%@", _phoneNumber],
                                       @"email":@"" ,
                                       @"username":@""}
                          };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/GetVerificationCode" body:str block:nil];
    
    
    
    
    __block int timeout = 30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _verifyCodeButton.userInteractionEnabled = YES;
                [_verifyCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                [_verifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _verifyCodeButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.3223 blue:0.2345 alpha:1.0];
            });
        }else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击的灰色
                _verifyCodeButton.backgroundColor = [UIColor colorWithRed:0.6926 green:0.6595 blue:0.6921 alpha:1.0];
                [_verifyCodeButton setTitleColor:[UIColor colorWithRed:1.0 green:0.3223 blue:0.2345 alpha:1.0] forState:UIControlStateNormal];
                _verifyCodeButton.userInteractionEnabled = NO;
                _label.text = [NSString stringWithFormat:@"验证码已发送至%@", _phoneNumber];
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_verifyCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (void)nextAction {
    NSDictionary *dic = @{@"deviceType":@"iPhone6,2",
                          @"deviceId":@"E88673B2-DFA0-4D08-A3BD-F7E8CE5F88C1",
                          @"os":@"iOS",
                          @"osVersion":@"9.3.5",
                          @"app":@"GSApp",
                          @"appVersion":@"2.3.3",
                          @"request":@{@"codeType":@1,
                                       @"phone":_phoneNumber,
                                       @"email":@"",
                                       @"veriCode":_verifyCodeTextField.text}
                          };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [SX_DataRequest POSTRequestWithString:@"http://appapi2.gamersky.com/v2/CheckCode" body:str block:^(id result) {
        NSString *message = [result objectForKey:@"errorMessage"];
        NSNumber *errorCode = [result objectForKey:@"errorCode"];
        if ([errorCode isEqual:@0]) {
            NSString *token = [NSString stringWithFormat:@"%@", [[result objectForKey:@"result"] objectForKey:@"VerifyToken"]];
            SX_RegisterViewController *registerVC = [[SX_RegisterViewController alloc] init];
            registerVC.varifyToken = token;
            registerVC.phoneNumber = _phoneNumber;
            [self.navigationController pushViewController:registerVC animated:YES];

        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
