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
#import "Masonry.h"
#import "AFNetworking.h"

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
        _myImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
        [self.contentView addSubview:_myImageView];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [_myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@(70 / 3 * 4) );
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(_myImageView.mas_right).offset(10);
        make.height.equalTo(@40);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
}

- (void)setXinwenNewsResult:(SX_NewsResult *)xinwenNewsResult {
    _xinwenNewsResult = xinwenNewsResult;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];
    if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
        _myImageView.contentMode = UIViewContentModeCenter;
        _myImageView.image = [UIImage imageNamed:@"common_Logo_71x17"];
    }
    else {
        if (xinwenNewsResult.thumbnailURLs) {
            [_myImageView sd_setImageWithURL:(NSURL *)xinwenNewsResult.thumbnailURLs[0]];
            _commentLabel.text = [NSString stringWithFormat:@"%@评论", xinwenNewsResult.commentsCount];
        }else {
            [_myImageView sd_setImageWithURL:(NSURL *)xinwenNewsResult.thumbnailUrl];
            _commentLabel.frame = CGRectZero;
        }
    }
    

    _label.text = xinwenNewsResult.title;

}



@end
