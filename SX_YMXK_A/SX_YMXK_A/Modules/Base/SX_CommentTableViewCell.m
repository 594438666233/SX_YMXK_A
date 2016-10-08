//
//  SX_CommentTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_CommentTableViewCell.h"
#import "SX_Comment.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Categories.h"

@interface SX_CommentTableViewCell ()

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SX_CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myImageView = [[UIImageView alloc] init];
        _myImageView.clipsToBounds = YES;
        [self.contentView addSubview:_myImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithRed:0.2594 green:0.5186 blue:1.0 alpha:1.0];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        self.addLabel = [[UILabel alloc] init];
        _addLabel.textColor = [UIColor lightGrayColor];
        _addLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_addLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    _myImageView.frame = CGRectMake(10, 20, 40, 40);
    _myImageView.layer.cornerRadius = 20;
    
    _nameLabel.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 10, 20, 150, _myImageView.frame.size.height / 2);
    
    _addLabel.frame = CGRectMake(_myImageView.frame.origin.x + _myImageView.frame.size.width + 10, 20 + _nameLabel.frame.size.height, 250, _myImageView.frame.size.height / 2);
    
    _contentLabel.frame = CGRectMake(70, 70, self.contentView.frame.size.width - 90, self.contentView.frame.size.height - 70);
    
}

- (void)setComment:(SX_Comment *)comment {
    _comment = comment;
    [_myImageView sd_setImageWithURL:(NSURL *)comment.img_url];
    _nameLabel.text = comment.nickname;
    
    _addLabel.text = [NSString stringWithFormat:@"%@ %@", comment.ip_location, [NSDate intervalSinceNow:comment.create_time]];
    _contentLabel.text = comment.content;
}


@end
