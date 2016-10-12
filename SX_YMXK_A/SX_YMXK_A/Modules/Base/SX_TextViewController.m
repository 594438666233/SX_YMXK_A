//
//  SX_TextViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/7.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_TextViewController.h"
#import "SX_DataRequest.h"
#import "SX_ArticleResult.h"
#import "SX_LoginViewController.h"

@interface SX_TextViewController ()
<
UITextViewDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIButton *commentButton;

@end

@implementation SX_TextViewController

- (void)createTextView {
    self.commentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    _commentView.backgroundColor = [UIColor colorWithRed:0.8038 green:0.8038 blue:0.8038 alpha:1.0];

    [self.view addSubview:_commentView];
    
    self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 140)];
    _commentTextView.backgroundColor = [UIColor whiteColor];
    _commentTextView.delegate = self;
    [_commentView addSubview:_commentTextView];
    [_commentTextView becomeFirstResponder];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectMake(self.view.frame.size.width - 60, 10, 40, 20);
    [_commentButton setTitle:@"发送" forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commentView addSubview:_commentButton];
    [_commentButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}






-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _commentView.frame = CGRectMake(0, frame.origin.y - 260, self.view.frame.size.width, 200);
}

-(void)keyboardWillHidden:(NSNotification *)notification
{
    _commentView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.view]) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text != nil) {
        _commentButton.userInteractionEnabled = YES;
    }else {
        _commentButton.userInteractionEnabled = NO;
    }
}

- (void)buttonAction {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *loginToken = [userDefaults objectForKey:@"loginToken"];
    if (loginToken != nil) {
        NSDictionary *dic = @{@"loginToken":loginToken, @"topicId":[NSNumber numberWithInteger:_data.Id], @"topicUrl":_data.originURL, @"topicTitle":_data.title, @"content":_commentTextView.text, @"replyID":@""};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *str2 = [NSString stringWithFormat:@"http://cm.gamersky.com/appapi/AddCommnet?jsondata=%@", str];
        NSString *str3 =  [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [SX_DataRequest GETRequestWithString:str3 block:^(id result) {
            NSNumber *errorCode = [result objectForKey:@"errorCode"];
            NSString *message = [result objectForKey:@"errorMessage"];
            if ([errorCode isEqual:@0]) {
                [self.view endEditing:YES];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
