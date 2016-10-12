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
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

@interface SX_CommentTableViewCell ()

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *topicButton;
@property (nonatomic, assign) NSInteger topicId;

@end

@implementation SX_CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myImageView = [[UIImageView alloc] init];
        _myImageView.clipsToBounds = YES;
        [self.contentView addSubview:_myImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        [_nameLabel jxl_setDayMode:^(UIView *view) {
            _nameLabel.textColor = [UIColor colorWithRed:0.2594 green:0.5186 blue:1.0 alpha:1.0];
        } nightMode:^(UIView *view) {
            _nameLabel.textColor = [UIColor colorWithRed:0.1527 green:0.3228 blue:0.7875 alpha:1.0];
        }];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        self.addLabel = [[UILabel alloc] init];
        _addLabel.textColor = [UIColor lightGrayColor];
        _addLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_addLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        [_contentLabel jxl_setDayMode:^(UIView *view) {
            _contentLabel.textColor = [UIColor blackColor];
        } nightMode:^(UIView *view) {
            _contentLabel.textColor = [UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0];
        }];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        self.topicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicButton.clipsToBounds = YES;
        _topicButton.layer.cornerRadius = 7.f;
        _topicButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_topicButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _topicButton.layer.borderWidth = 0.5;
        _topicButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:_topicButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    _myImageView.frame = CGRectMake(10, 20, 40, 40);
    _myImageView.layer.cornerRadius = 20;
    
    _nameLabel.frame = CGRectMake(60, 20, self.contentView.frame.size.width - 80, 20);
    
    _addLabel.frame = CGRectMake(60, 40, self.contentView.frame.size.width - 80, 20);
    
    _contentLabel.frame = CGRectMake(60, 70, self.contentView.frame.size.width - 80, self.contentView.frame.size.height - 110);
    _topicButton.frame = CGRectMake(60, self.contentView.frame.size.height - 30, self.contentView.frame.size.width - 80, 20);
    
}

- (void)setComment:(SX_Comment *)comment {
    _comment = comment;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];
    if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
        _myImageView.image = [UIImage imageNamed:@"common_User_DefaultHeadImage_UIMode_Day"];
    } else {
        [_myImageView sd_setImageWithURL:(NSURL *)comment.img_url];
    }
    
    _nameLabel.text = comment.nickname;
    
    _addLabel.text = [NSString stringWithFormat:@"%@ %@", comment.ip_location, [NSDate intervalSinceNow:comment.create_time]];
    _contentLabel.text = comment.content;
    if (comment.topic_title != nil) {
        [_topicButton setTitle:[NSString stringWithFormat:@"原文:%@", comment.topic_title] forState:UIControlStateNormal];
        [_topicButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        _topicId = comment.topic_id;
    } else {
        _topicButton.hidden = YES;
    }
}

- (void)buttonAction {
    [self.topic_delegate getTopicId:_topicId];
}


@end
