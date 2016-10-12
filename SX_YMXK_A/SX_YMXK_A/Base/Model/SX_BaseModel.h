//
//  SX_BaseModel.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SX_BaseModel : NSObject

+ (instancetype)modelWithDic:(NSDictionary *)dic;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
