//
//  SX_SubscribeResult.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/24.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_SubscribeResult : SX_BaseModel

@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, assign) NSInteger sourceId;
@property (nonatomic, assign) NSInteger cnt;

@end
