//
//  SX_santuTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_santuTableViewCell.h"
#import "SX_NewsResult.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

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
        [_label jxl_setDayMode:^(UIView *view) {
            _label.textColor = [UIColor blackColor];
        } nightMode:^(UIView *view) {
            _label.textColor = [UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0];
        }];
        _label.numberOfLines = 2;
        [self.contentView addSubview:_label];
        
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor grayColor];
        _commentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_commentLabel];
        
        self.imageView1 = [[UIImageView alloc] init];
        _imageView1.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self.contentView addSubview:_imageView1];
        
        self.imageView2 = [[UIImageView alloc] init];
        _imageView2.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self.contentView addSubview:_imageView2];
        
        self.imageView3 = [[UIImageView alloc] init];
        _imageView3.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self.contentView addSubview:_imageView3];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];

    _label.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, self.contentView.frame.size.height / 10);
    _label.font = [UIFont systemFontOfSize:self.contentView.frame.size.height / 10 + 1];
    
    _imageView1.frame = CGRectMake(10, _label.frame.origin.y + _label.frame.size.height + 10, (self.contentView.frame.size.width - 40) / 3, self.contentView.frame.size.height / 2);
    
    _imageView2.frame = CGRectMake(_imageView1.frame.size.width + 20, _label.frame.origin.y + _label.frame.size.height + 10, (self.contentView.frame.size.width - 40) / 3, self.contentView.frame.size.height / 2);
    
    _imageView3.frame = CGRectMake(_imageView2.frame.size.width + _imageView2.frame.origin.x + 10, _label.frame.origin.y + _label.frame.size.height + 10, (self.contentView.frame.size.width - 40) / 3, self.contentView.frame.size.height / 2);
    
    _commentLabel.frame = CGRectMake(self.contentView.frame.size.width - 200 - 10, self.contentView.frame.size.height - 10 - self.contentView.frame.size.height / 10, 200, self.contentView.frame.size.height / 10);
    _commentLabel.font = [UIFont systemFontOfSize:self.contentView.frame.size.height / 12];
}

- (void)setSantuNewsResult:(SX_NewsResult *)santuNewsResult {
    _santuNewsResult = santuNewsResult;
    _label.text = santuNewsResult.title;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];
    if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
        _imageView1.contentMode = UIViewContentModeCenter;
        _imageView1.image = [UIImage imageNamed:@"common_Logo_71x17"];
        _imageView2.contentMode = UIViewContentModeCenter;
        _imageView2.image = [UIImage imageNamed:@"common_Logo_71x17"];
        _imageView3.contentMode = UIViewContentModeCenter;
        _imageView3.image = [UIImage imageNamed:@"common_Logo_71x17"];
    }
    else {
        [_imageView1 sd_setImageWithURL:(NSURL *)santuNewsResult.thumbnailURLs[0]];
        [_imageView2 sd_setImageWithURL:(NSURL *)santuNewsResult.thumbnailURLs[1]];
        [_imageView3 sd_setImageWithURL:(NSURL *)santuNewsResult.thumbnailURLs[2]];
    }
    _commentLabel.text = [NSString stringWithFormat:@"%@评论", santuNewsResult.commentsCount];
}

@end
