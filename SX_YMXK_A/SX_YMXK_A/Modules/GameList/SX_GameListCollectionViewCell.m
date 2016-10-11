//
//  SX_GameListCollectionViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/23.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_GameListCollectionViewCell.h"
#import "SX_GameListResult.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

@interface SX_GameListCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *myImageView;

@end


@implementation SX_GameListCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        [_label jxl_setDayMode:^(UIView *view) {
            _label.textColor = [UIColor blackColor];
        } nightMode:^(UIView *view) {
            _label.textColor = [UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0];
        }];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 2;
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        
        self.myImageView = [[UIImageView alloc] init];
        _myImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self.contentView addSubview:_myImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _myImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height * 0.8);
    _label.frame = CGRectMake(0, _myImageView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height * 0.2);
    _label.font = [UIFont systemFontOfSize:self.contentView.frame.size.height / 15];
}

- (void)setGameListResult:(SX_GameListResult *)gameListResult {
    _gameListResult = gameListResult;
    _label.text = gameListResult.title;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];
    if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
        _myImageView.image = [UIImage imageNamed:@"common_Logo_174x41"];
    }
    else {
        [_myImageView sd_setImageWithURL:(NSURL *)gameListResult.thumbnailURL];
    }
}


@end
