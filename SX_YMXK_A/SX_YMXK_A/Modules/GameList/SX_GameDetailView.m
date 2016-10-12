//
//  SX_GameDetailView.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_GameDetailView.h"
#import "Masonry.h"
#import "SX_GameDetailResult.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface SX_GameDetailView ()

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *gameTypeLabel;
@property (nonatomic, strong) UILabel *platformLabel;
@property (nonatomic, strong) UILabel *sellTimeLabel;
@property (nonatomic, strong) UILabel *developerLabel;
@property (nonatomic, strong) UIButton *subscribeButton;


@end

@implementation SX_GameDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        self.bgImageView = [[UIImageView alloc] init];
        _bgImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self addSubview:_bgImageView];
        
        self.myImageView = [[UIImageView alloc] init];
        _myImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self addSubview:_myImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_titleLabel];
        
        self.sellTimeLabel = [[UILabel alloc] init];
        _sellTimeLabel.textColor = [UIColor whiteColor];
        _sellTimeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_sellTimeLabel];
        
        self.platformLabel = [[UILabel alloc] init];
        _platformLabel.textColor = [UIColor whiteColor];
        _platformLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_platformLabel];
        
        self.gameTypeLabel = [[UILabel alloc] init];
        _gameTypeLabel.textColor = [UIColor whiteColor];
        _gameTypeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_gameTypeLabel];
        
        self.developerLabel = [[UILabel alloc] init];
        _developerLabel.textColor = [UIColor whiteColor];
        _developerLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_developerLabel];
        
        self.subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [_subscribeButton jxl_setDayMode:^(UIView *view) {
            _subscribeButton.backgroundColor = [UIColor colorWithRed:0.1668 green:0.5112 blue:1.0 alpha:1.0];
        } nightMode:^(UIView *view) {
            _subscribeButton.backgroundColor = [UIColor colorWithRed:0.1346 green:0.4113 blue:0.9984 alpha:0.86];
        }];
        _subscribeButton.tintColor = [UIColor whiteColor];
        _subscribeButton.layer.cornerRadius = 3.f;
        _subscribeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_subscribeButton setTitle:@"关注" forState:UIControlStateNormal];
        [_subscribeButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_subscribeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_subscribeButton];

    }
    return self;
}

- (void)buttonAction:(UIButton *)button {
    button.selected = !button.selected;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"gameList"]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_gameDetailResult];
    if (button.selected == YES) {
        [mulArray addObject:data];
    } else {
        [mulArray removeObject:data];
        //        [mulArray removeAllObjects];
    }
    NSArray *array = [NSArray arrayWithArray:mulArray];
    [userDefaults setObject:array forKey:@"gameList"];
    [userDefaults synchronize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgImageView.frame = self.frame;
    _myImageView.frame = CGRectMake(WIDTH * 0.1, HEIGHT / 6, HEIGHT * 3 / 6, HEIGHT * 4 / 6);
    _titleLabel.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 5, _myImageView.frame.origin.y, WIDTH - _myImageView.frame.size.width - _myImageView.frame.origin.x, _myImageView.frame.size.height * 1 / 7);
    _sellTimeLabel.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 5, _titleLabel.frame.origin.y + _titleLabel.frame.size.height, WIDTH - _myImageView.frame.size.width - _myImageView.frame.origin.x, _myImageView.frame.size.height * 1 / 7);
    _platformLabel.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 5, _sellTimeLabel.frame.origin.y + _sellTimeLabel.frame.size.height, WIDTH - _myImageView.frame.size.width - _myImageView.frame.origin.x, _myImageView.frame.size.height * 1 / 7);

    _gameTypeLabel.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 5, _platformLabel.frame.origin.y + _platformLabel.frame.size.height, WIDTH - _myImageView.frame.size.width - _myImageView.frame.origin.x, _myImageView.frame.size.height * 1 / 7);
    _developerLabel.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 5, _gameTypeLabel.frame.origin.y + _gameTypeLabel.frame.size.height, WIDTH - _myImageView.frame.size.width - _myImageView.frame.origin.x, _myImageView.frame.size.height * 1 / 7);
    _subscribeButton.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 5, _developerLabel.frame.origin.y + _developerLabel.frame.size.height * 2, _myImageView.frame.size.width * 2, _myImageView.frame.size.height * 1 / 7);
}

- (void)setGameDetailResult:(SX_GameDetailResult *)gameDetailResult {
    _gameDetailResult = gameDetailResult;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];
    if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
        _myImageView.image = [UIImage imageNamed:@"common_Logo_174x41"];
    }
    else {
        [_bgImageView sd_setImageWithURL:(NSURL *)gameDetailResult.backgroundURL];
        
        [_myImageView sd_setImageWithURL:(NSURL *)gameDetailResult.thumbnailURL];
    }
    _titleLabel.text = gameDetailResult.title;
    _sellTimeLabel.text = [NSString stringWithFormat:@"发售:%@", gameDetailResult.sellTime];
    _platformLabel.text = [NSString stringWithFormat:@"平台:%@",gameDetailResult.platform];
    _gameTypeLabel.text = [NSString stringWithFormat:@"类型:%@",gameDetailResult.gameType];
    _developerLabel.text = [NSString stringWithFormat:@"厂商:%@",gameDetailResult.developer];
    
    
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:@"gameList"]];
    for (int i = 0; i < mulArray.count; i++) {
        SX_GameDetailResult *result = [NSKeyedUnarchiver unarchiveObjectWithData:mulArray[i]];
        if ([result.title isEqualToString:_gameDetailResult.title]) {
            _subscribeButton.selected = YES;
            break;
        }
    }
}

@end
