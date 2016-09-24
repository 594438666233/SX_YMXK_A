//
//  SX_DataRequest.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SX_DataRequest : NSObject

+ (void)GETRequestWithString:(NSString *)string block:(void(^)(id result))block;

+ (void)POSTRequestWithString:(NSString *)string body:(NSString *)body block:(void(^)(id result))block;

@end
