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
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

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
        _label.numberOfLines = 2;
        [_label jxl_setDayMode:^(UIView *view) {
            _label.textColor = [UIColor blackColor];
        } nightMode:^(UIView *view) {
            _label.textColor = [UIColor colorWithRed:0.4228 green:0.4522 blue:0.5288 alpha:1.0];
        }];
        
        [self.contentView addSubview:_label];
        
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor grayColor];
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
    _myImageView.frame = CGRectMake(10, 10, (self.contentView.frame.size.height - 20) * 1.35, self.contentView.frame.size.height - 20);
    
    _label.frame = CGRectMake(_myImageView.frame.size.width + 20, 10, self.contentView.frame.size.width - 30 - _myImageView.frame.size.width, _myImageView.frame.size.height * 0.7);
    _label.font = [UIFont systemFontOfSize:self.contentView.frame.size.height / 5.5];
    _commentLabel.frame = CGRectMake(self.contentView.frame.size.width - 200 - 10, self.contentView.frame.size.height - _myImageView.frame.size.height * 0.3 - 10, 200, _myImageView.frame.size.height * 0.3);
    _commentLabel.font = [UIFont systemFontOfSize:self.contentView.frame.size.height / 7];
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
        if (xinwenNewsResult.thumbnailURLs.count > 0) {
            [_myImageView sd_setImageWithURL:(NSURL *)xinwenNewsResult.thumbnailURLs[0]];
            _commentLabel.text = [NSString stringWithFormat:@"%@评论", xinwenNewsResult.commentsCount];
        }else if (xinwenNewsResult.thumbnailUrl != nil){
            [_myImageView sd_setImageWithURL:(NSURL *)xinwenNewsResult.thumbnailUrl];
            _commentLabel.hidden = YES;
        } else {
//            _myImageView.contentMode = UIViewContentModeCenter;
            _myImageView.image = [UIImage imageNamed:@"common_Logo_71x17"];
        }
    }
    

    _label.text = xinwenNewsResult.title;

}



@end
