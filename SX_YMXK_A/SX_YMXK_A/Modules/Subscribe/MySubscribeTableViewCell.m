//
//  MySubscribeTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/24.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "MySubscribeTableViewCell.h"
#import "SX_SubscribeResult.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

@interface MySubscribeTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *cntLabel;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIButton *button;

@end


@implementation MySubscribeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel jxl_setDayMode:^(UIView *view) {
            _titleLabel.textColor = [UIColor blackColor];
        } nightMode:^(UIView *view) {
            _titleLabel.textColor = [UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0];
        }];
        [self.contentView addSubview:_titleLabel];
        
        self.cntLabel = [[UILabel alloc] init];
        _cntLabel.textColor = [UIColor grayColor];
        _cntLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_cntLabel];
        
        self.myImageView = [[UIImageView alloc] init];
        _myImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self.contentView addSubview:_myImageView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button jxl_setDayMode:^(UIView *view) {
            _button.backgroundColor = [UIColor colorWithRed:0.9706 green:0.3066 blue:0.3453 alpha:1.0];
        } nightMode:^(UIView *view) {
            _button.backgroundColor = [UIColor colorWithRed:0.897 green:0.1559 blue:0.1816 alpha:1.0];
        }];
        _button.clipsToBounds = YES;
        _button.layer.cornerRadius = 3.f;
        _button.layer.borderWidth = 0.5f;
        _button.layer.borderColor = [UIColor grayColor].CGColor;
        [_button setTitle:@"订阅" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_button setTitle:@"退订" forState:UIControlStateSelected];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];

        
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _myImageView.frame = CGRectMake(10, 10, (self.contentView.frame.size.height - 20) / 3 * 4, self.contentView.frame.size.height - 20);
    _titleLabel.frame = CGRectMake(20 + _myImageView.frame.size.width, 10, self.contentView.frame.size.width / 2, _myImageView.frame.size.height / 4);
    _titleLabel.font = [UIFont systemFontOfSize:_myImageView.frame.size.height / 4 + 1];
    _cntLabel.frame = CGRectMake(_titleLabel.frame.origin.x, self.contentView.frame.size.height - 30, _titleLabel.frame.size.width, _myImageView.frame.size.height / 5);
    _cntLabel.font = [UIFont systemFontOfSize:_myImageView.frame.size.height / 4];
    _button.frame = CGRectMake(self.contentView.frame.size.width * 0.8, self.contentView.frame.size.height / 3, self.contentView.frame.size.height * 0.6, self.contentView.frame.size.height / 3);
    _button.titleLabel.font = [UIFont systemFontOfSize:_myImageView.frame.size.height / 4 + 1];

}

- (void)buttonAction:(UIButton *)button {
    button.selected = !button.selected;
    NSString *str = [NSString stringWithFormat:@"%ld", _subscribeResult.sourceId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"dingyue"]];
    if (button.selected == YES) {
        button.backgroundColor = [UIColor whiteColor];
        [mulArray addObject:str];
        
    }else {
        button.backgroundColor = [UIColor colorWithRed:0.9706 green:0.3066 blue:0.3453 alpha:1.0];
        [mulArray removeObject:str];
    }
    NSArray *array = [NSArray arrayWithArray:mulArray];
    [userDefaults setObject:array forKey:@"dingyue"];
}


- (void)setSubscribeResult:(SX_SubscribeResult *)subscribeResult {
    _subscribeResult = subscribeResult;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];
    if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
        _myImageView.contentMode = UIViewContentModeCenter;
        _myImageView.image = [UIImage imageNamed:@"common_Logo_71x17"];
    }
    else {
        [_myImageView sd_setImageWithURL:(NSURL *)subscribeResult.thumbnailUrl];
    }
    
    _titleLabel.text = subscribeResult.sourceName;
    _cntLabel.text = [NSString stringWithFormat:@"%ld人订阅",subscribeResult.cnt];
    
    NSMutableArray *mulArray= [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"dingyue"]];
    for (int i = 0; i < mulArray.count; i++) {
        if ([mulArray[i] isEqualToString:[NSString stringWithFormat:@"%ld", subscribeResult.sourceId]]) {
            _button.selected = YES;
            _button.backgroundColor = [UIColor whiteColor];
            break;
        }
    }
    
}

@end
