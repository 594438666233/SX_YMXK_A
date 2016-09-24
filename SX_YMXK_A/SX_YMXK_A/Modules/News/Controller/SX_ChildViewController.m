//
//  SX_ChildViewController.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_ChildViewController.h"
#import "SX_santuTableViewCell.h"
#import "SX_hengtuTableViewCell.h"
#import "SX_huandengTableViewCell.h"
#import "SX_xinwenTableViewCell.h"

@interface SX_ChildViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation SX_ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SX_santuTableViewCell class] forCellReuseIdentifier:@"santu"];
    [_tableView registerClass:[SX_hengtuTableViewCell class] forCellReuseIdentifier:@"hengtu"];
    [_tableView registerClass:[SX_huandengTableViewCell class] forCellReuseIdentifier:@"xinwen"];
    [_tableView registerClass:[SX_xinwenTableViewCell class] forCellReuseIdentifier:@"huandeng"];
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"QAQ";
    return cell;
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
