//
//  SX_hengtuTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_hengtuTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "SX_NewsResult.h"


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
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:16];
        _label.numberOfLines = 2;
        [self.contentView addSubview:_label];
        
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_myImageView];
        
        self.iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"common_Badge_TuiGuang_31x17_UIMode_Day"];
        [self.contentView addSubview:_iconImageView];
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20);
    _myImageView.frame = CGRectMake(10, 40, self.contentView.frame.size.width - 20, 100);
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@31);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(_myImageView.mas_bottom).offset(10);
        make.height.equalTo(@17);
    }];
}

- (void)setHengtuNewsResult:(SX_NewsResult *)hengtuNewsResult {
    _hengtuNewsResult = hengtuNewsResult;
    _label.text = hengtuNewsResult.title;
    [_myImageView sd_setImageWithURL:(NSURL *)hengtuNewsResult.thumbnailURLs[0]];
}

@end
