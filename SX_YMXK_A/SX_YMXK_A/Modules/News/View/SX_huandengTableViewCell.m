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

@interface SX_huandengTableViewCell ()
<
UIScrollViewDelegate
>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) NSMutableArray *array;

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / self.contentView.frame.size.width;
    _pageControl.currentPage = page;
    _label.text = _array[page];
}

- (void)setHuandengNewsResult:(SX_NewsResult *)huandengNewsResult {
    _huandengNewsResult = huandengNewsResult;
    _scrollView.contentSize = CGSizeMake(huandengNewsResult.childElements.count * self.contentView.frame.size.width, self.contentView.frame.size.height);
    _pageControl.numberOfPages = huandengNewsResult.childElements.count;
    for (int i = 0; i < huandengNewsResult.childElements.count; i++) {
        SX_NewsChildElements *newsChildElements = huandengNewsResult.childElements[i];
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width * i, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [myImageView sd_setImageWithURL:(NSURL *)newsChildElements.thumbnailURLs[0]];
        [_scrollView addSubview:myImageView];
        [_array addObject:newsChildElements.title];
    }
    _label.text = _array[0];
}

@end
