//
//  SX_MenuTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/27.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_MenuTableViewCell.h"
#import "JXLDayAndNightMode.h"

@interface SX_MenuTableViewCell ()

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SX_MenuTableViewCell

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
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_myImageView];
        self.label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:15];
        [_label jxl_setDayMode:^(UIView *view) {
            _label.textColor = [UIColor blackColor];
        } nightMode:^(UIView *view) {
            _label.textColor = [UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0];
        }];
        _label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _myImageView.frame = CGRectMake(20, (self.contentView.frame.size.height - 25) / 2, 25, 25);
    _label.frame = CGRectMake(55, _myImageView.frame.origin.y, 100, 25);
}

- (void)setName:(NSString *)name {
    _name = name;
    _label.text = name;
}

- (void)setPicName:(NSString *)picName {
    _picName = picName;
    [_myImageView jxl_setDayMode:^(UIView *view) {
        NSString *str = [NSString stringWithFormat:@"common_Icon_%@_38x38_UIMode_Day", picName];
        _myImageView.image = [UIImage imageNamed:str];
    } nightMode:^(UIView *view) {
        NSString *str = [NSString stringWithFormat:@"common_Icon_%@_38x38_UIMode_Night", picName];
        _myImageView.image = [UIImage imageNamed:str];
    }];
    
}




@end
