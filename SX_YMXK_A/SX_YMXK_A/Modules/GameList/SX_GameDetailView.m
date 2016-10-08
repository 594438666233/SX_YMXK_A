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
        [self addSubview:_bgImageView];
        
        self.myImageView = [[UIImageView alloc] init];
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
        _subscribeButton.backgroundColor = [UIColor colorWithRed:0.1668 green:0.5112 blue:1.0 alpha:1.0];
        _subscribeButton.tintColor = [UIColor whiteColor];
        _subscribeButton.layer.cornerRadius = 3.f;
        _subscribeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_subscribeButton setTitle:@"关注" forState:UIControlStateNormal];
        [_subscribeButton setTitle:@"已关注" forState:UIControlStateSelected];
        [self addSubview:_subscribeButton];
    }
    return self;
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
    [_bgImageView sd_setImageWithURL:(NSURL *)gameDetailResult.backgroundURL];
    NSLog(@"%@", gameDetailResult.backgroundURL);
    [_myImageView sd_setImageWithURL:(NSURL *)gameDetailResult.thumbnailURL];
    _titleLabel.text = gameDetailResult.title;
    _sellTimeLabel.text = [NSString stringWithFormat:@"发售:%@", gameDetailResult.sellTime];
    _platformLabel.text = [NSString stringWithFormat:@"平台:%@",gameDetailResult.platform];
    _gameTypeLabel.text = [NSString stringWithFormat:@"类型:%@",gameDetailResult.gameType];
    _developerLabel.text = [NSString stringWithFormat:@"厂商:%@",gameDetailResult.developer];
}

@end
