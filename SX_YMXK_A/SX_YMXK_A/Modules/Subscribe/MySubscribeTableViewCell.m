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
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        
        self.cntLabel = [[UILabel alloc] init];
        _cntLabel.textColor = [UIColor grayColor];
        _cntLabel.font = [UIFont systemFontOfSize:14];
        _cntLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_cntLabel];
        
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_myImageView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_button];

    }
    return self;
}

- (void)layoutSubviews {
    _myImageView.frame = CGRectMake(10, 10, (self.contentView.frame.size.height - 20) / 3 * 4, self.contentView.frame.size.height - 20);
    _titleLabel.frame = CGRectMake(20 + (self.contentView.frame.size.height - 20) / 3 * 4, 10, (self.contentView.frame.size.width - 30 - _myImageView.frame.size.width) / 2, (self.contentView.frame.size.height - 20) / 2);
    _cntLabel.frame = CGRectMake(_titleLabel.frame.origin.x, self.contentView.frame.size.height - 40, _titleLabel.frame.size.width, 20);
    _button.frame = CGRectMake(self.contentView.frame.size.width - 100, (self.contentView.frame.size.height - 20) / 2, 54, 26);
    [_button setBackgroundImage:[UIImage imageNamed:@"common_Icon_SubscribeButtonNormal_54x26_UIMode_Day"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"common_Icon_SubscribeButtonSelected_54x26_UIMode_Day"] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)button {
    button.selected = !button.selected;
}


- (void)setSubscribeResult:(SX_SubscribeResult *)subscribeResult {
    _subscribeResult = subscribeResult;
    [_myImageView sd_setImageWithURL:(NSURL *)subscribeResult.thumbnailUrl];
    _titleLabel.text = subscribeResult.sourceName;
    _cntLabel.text = [NSString stringWithFormat:@"%ld订阅",subscribeResult.cnt];
}

@end
