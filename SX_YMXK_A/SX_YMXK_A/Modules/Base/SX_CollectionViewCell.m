//
//  SX_CollectionViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_CollectionViewCell.h"

@interface SX_CollectionViewCell ()

@property (nonatomic, retain)UILabel *label;

@end

@implementation SX_CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:_label];
        _label.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:20];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _label.text = text;
}

- (void)setTextFont:(NSInteger)textFont {
    _label.font = [UIFont systemFontOfSize:textFont];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = self.contentView.frame;
}

@end
