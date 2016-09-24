//
//  SX_xinwenTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_xinwenTableViewCell.h"
#import "SX_NewsResult.h"
#import "UIImageView+WebCache.h"

@interface SX_xinwenTableViewCell ()

@property (nonatomic, retain) UIImageView *myImageView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *commentLabel;

@end

@implementation SX_xinwenTableViewCell

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
        _label.font = [UIFont systemFontOfSize:16];
        _label.numberOfLines = 2;
        _label.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label];
        
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor grayColor];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_commentLabel];
        
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_myImageView];
    }
    return self;
}



- (void)layoutSubviews {
    _myImageView.frame = CGRectMake(10, 10, (self.contentView.frame.size.height - 20) / 3 * 4, self.contentView.frame.size.height - 20);
    _label.frame = CGRectMake(20 + (self.contentView.frame.size.height - 20) / 3 * 4, 10, self.contentView.frame.size.width - 30 - (self.contentView.frame.size.height - 20) / 3 * 4, (self.contentView.frame.size.height - 20) / 2);
    _commentLabel.frame = CGRectMake(self.contentView.frame.size.width - 100, self.contentView.frame.size.height - 40, 90, 20);
}

- (void)setXinwenNewsResult:(SX_NewsResult *)xinwenNewsResult {
    _xinwenNewsResult = xinwenNewsResult;
    [_myImageView sd_setImageWithURL:(NSURL *)xinwenNewsResult.thumbnailURLs[0]];
    _label.text = xinwenNewsResult.title;
    _commentLabel.text = [NSString stringWithFormat:@"%@评论", xinwenNewsResult.commentsCount];
}



@end
