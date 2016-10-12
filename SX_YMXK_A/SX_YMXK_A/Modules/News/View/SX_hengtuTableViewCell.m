//
//  SX_hengtuTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_hengtuTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SX_NewsResult.h"
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"


@interface SX_hengtuTableViewCell ()

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *myImageView;
@property (nonatomic, retain) UIImageView *iconImageView;

@end

@implementation SX_hengtuTableViewCell

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
        self.label = [[UILabel alloc] init];
        [_label jxl_setDayMode:^(UIView *view) {
            _label.textColor = [UIColor blackColor];
        } nightMode:^(UIView *view) {
            _label.textColor = [UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0];
        }];
        _label.numberOfLines = 2;
        [self.contentView addSubview:_label];
        
        self.myImageView = [[UIImageView alloc] init];
        _myImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self.contentView addSubview:_myImageView];
        
        self.iconImageView = [[UIImageView alloc] init];
        [_iconImageView jxl_setDayMode:^(UIView *view) {
            _iconImageView.image = [UIImage imageNamed:@"common_Badge_TuiGuang_31x17_UIMode_Day"];
        } nightMode:^(UIView *view) {
            _iconImageView.image = [UIImage imageNamed:@"common_Badge_TuiGuang_31x17_UIMode_Night"];
        }];
        [self.contentView addSubview:_iconImageView];
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, self.contentView.frame.size.height / 10);
    _label.font = [UIFont systemFontOfSize:self.contentView.frame.size.height / 10 + 1];
    _myImageView.frame = CGRectMake(10, _label.frame.size.height + 20, self.contentView.frame.size.width - 20, self.contentView.frame.size.height / 2);
    _iconImageView.frame = CGRectMake(self.contentView.frame.size.width - 20 - self.contentView.frame.size.height / 6, _myImageView.frame.size.height + _myImageView.frame.origin.y + 10, self.contentView.frame.size.height / 6, self.contentView.frame.size.height / 10);
}

- (void)setHengtuNewsResult:(SX_NewsResult *)hengtuNewsResult {
    _hengtuNewsResult = hengtuNewsResult;
    _label.text = hengtuNewsResult.title;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];
    if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
        _myImageView.contentMode = UIViewContentModeCenter;
        _myImageView.image = [UIImage imageNamed:@"common_Logo_71x17"];
    }
    else {
        [_myImageView sd_setImageWithURL:(NSURL *)hengtuNewsResult.thumbnailURLs[0]];
    }
}

@end
