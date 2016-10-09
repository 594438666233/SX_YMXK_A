//
//  SX_huandengTableViewCell.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_huandengTableViewCell.h"
#import "SX_NewsResult.h"
#import "SX_NewsChildElements.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

@interface SX_huandengTableViewCell ()
<
UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation SX_huandengTableViewCell

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
        
        self.array = [NSMutableArray array];
        self.scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        self.label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor colorWithRed:0.3703 green:0.3703 blue:0.3703 alpha:0.8];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label];
        
        self.pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor colorWithRed:1.0 green:0.9873 blue:0.9868 alpha:0.0];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [_label addSubview:_pageControl];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.contentView.frame;
    _label.frame = CGRectMake(0, self.contentView.frame.size.height - 40, self.contentView.frame.size.width, 40);
    _pageControl.frame = CGRectMake(self.contentView.frame.size.width - 80, 0, 80, 40);
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger page = scrollView.contentOffset.x / self.contentView.frame.size.width;
//    _pageControl.currentPage = page;
//    _label.text = _array[page];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_scrollView]) {
        NSInteger pageNumber = scrollView.contentOffset.x / scrollView.bounds.size.width;
        if (0 == pageNumber) {
            pageNumber = _array.count - 2;
        } else if (_array.count - 1 == pageNumber) {
            pageNumber = 1;
        }
        _pageControl.currentPage = pageNumber - 1;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width * pageNumber - 1, 0);
        SX_NewsChildElements *newsChildElements = _array[pageNumber];
        _label.text = newsChildElements.title;
    }
}

- (void)setHuandengNewsResult:(SX_NewsResult *)huandengNewsResult {
    _huandengNewsResult = huandengNewsResult;
//    _scrollView.frame = self.contentView.frame;
//    [self layoutSubviews];

    _pageControl.numberOfPages = huandengNewsResult.childElements.count;
    

    
    if (_array.count > 0) {
        [_array removeAllObjects];
    }
    
    SX_NewsChildElements *newsChildElements1 = [huandengNewsResult.childElements lastObject];
    [_array addObject:newsChildElements1];
    for (int i = 0; i < huandengNewsResult.childElements.count; i++) {
        SX_NewsChildElements *newsChildElements = huandengNewsResult.childElements[i];
        [_array addObject:newsChildElements];
    }
    SX_NewsChildElements *newsChildElements2 = [huandengNewsResult.childElements firstObject];
    [_array addObject:newsChildElements2];
    [self loadCarousel];
    

}

- (void)loadCarousel {
    _scrollView.contentSize = CGSizeMake(_array.count * self.contentView.frame.size.width, self.contentView.frame.size.height);
    _pageControl.currentPage = 0;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefaults boolForKey:@"imgMode"];

    
    
    
    for (int i = 0; i < _array.count; i++) {
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        SX_NewsChildElements *newsChildElements = _array[i];
        
        if ((flag == 1) && (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi)) {
            myImageView.contentMode = UIViewContentModeCenter;
            myImageView.backgroundColor = [UIColor colorWithRed:0.8258 green:0.8258 blue:0.8258 alpha:1.0];
            myImageView.image = [UIImage imageNamed:@"common_Logo_174x41"];
        }
        else {
            [myImageView sd_setImageWithURL:(NSURL *)newsChildElements.thumbnailURLs[0]];
        }
        
        [_scrollView addSubview:myImageView];
    }
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);
    SX_NewsChildElements *newsChildElements = _array[1];
    _label.text = newsChildElements.title;
}

@end
