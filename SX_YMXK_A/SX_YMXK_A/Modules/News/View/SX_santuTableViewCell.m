//
//  SX_santuTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_santuTableViewCell.h"
#import "Masonry.h"
#import "SX_NewsResult.h"
#import "UIImageView+WebCache.h"

@interface SX_santuTableViewCell ()

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView1;
@property (nonatomic, retain) UIImageView *imageView2;
@property (nonatomic, retain) UIImageView *imageView3;
@property (nonatomic, retain) UILabel *commentLabel;

@end

@implementation SX_santuTableViewCell

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
        
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor grayColor];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_commentLabel];
        
        self.imageView1 = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView1];
        
        self.imageView2 = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView2];
        
        self.imageView3 = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView3];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];

    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@20);
    }];
    
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@((self.contentView.frame.size.width - 40) / 3));
    }];
    
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        make.left.equalTo(_imageView1.mas_right).offset(10);
        make.width.equalTo(@((self.contentView.frame.size.width - 40) / 3));
    }];
    
    [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        make.left.equalTo(_imageView2.mas_right).offset(10);
        make.width.equalTo(@((self.contentView.frame.size.width - 40) / 3));
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView1.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(@100);
    }];
}

- (void)setSantuNewsResult:(SX_NewsResult *)santuNewsResult {
    _santuNewsResult = santuNewsResult;
    _label.text = santuNewsResult.title;
    [_imageView1 sd_setImageWithURL:(NSURL *)santuNewsResult.thumbnailURLs[0]];
    [_imageView2 sd_setImageWithURL:(NSURL *)santuNewsResult.thumbnailURLs[1]];
    [_imageView3 sd_setImageWithURL:(NSURL *)santuNewsResult.thumbnailURLs[2]];
    _commentLabel.text = [NSString stringWithFormat:@"%@评论", santuNewsResult.commentsCount];
}

@end
