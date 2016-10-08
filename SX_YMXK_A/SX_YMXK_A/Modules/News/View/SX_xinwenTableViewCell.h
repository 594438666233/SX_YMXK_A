//
//  SX_xinwenTableViewCell.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SX_NewsResult;
@class SX_GameNewsResult;

@interface SX_xinwenTableViewCell : UITableViewCell

@property (nonatomic, strong) SX_NewsResult *xinwenNewsResult;
@property (nonatomic, strong) SX_GameNewsResult *gameNewsResult;
@property (nonatomic, copy) NSString *defaultImg;


@end
