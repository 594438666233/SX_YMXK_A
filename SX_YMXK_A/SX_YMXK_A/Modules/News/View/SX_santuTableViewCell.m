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
    _label.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20);
    
    _imageView1.frame = CGRectMake(10, 40, (self.contentView.frame.size.width - 40) / 3, self.contentView.frame.size.height - 80);
    
    _imageView2.frame = CGRectMake(20 + (self.contentView.frame.size.width - 40) / 3, 40, (self.contentView.frame.size.width - 40) / 3, self.contentView.frame.size.height - 80);
    
    _imageView3.frame = CGRectMake(30 + 2 * (self.contentView.frame.size.width - 40) / 3, 40, (self.contentView.frame.size.width - 40) / 3, self.contentView.frame.size.height - 80);
    
    _commentLabel.frame = CGRectMake(self.contentView.frame.size.width - 100, self.contentView.frame.size.height - 40, 90, 20);
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
