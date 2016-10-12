//
//  SX_NewsDetailViewController.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/26.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_ViewController.h"
@class SX_NewsResult;

@interface SX_NewsDetailViewController : SX_ViewController

@property (nonatomic, assign) NSInteger contentId;
@property (nonatomic, strong) SX_NewsResult *newsResult;

@end
