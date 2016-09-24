//
//  SX_NewsResult.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/21.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_NewsResult.h"
#import "SX_NewsChildElements.h"

@implementation SX_NewsResult

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"childElements"]) {
        NSArray *childElementsDicArray = value;
        NSMutableArray *childElements = [NSMutableArray array];
        for (NSDictionary *dic in childElementsDicArray) {
            SX_NewsChildElements *newsChildElements = [SX_NewsChildElements modelWithDic:dic];
            [childElements addObject:newsChildElements];
        }
        self.childElements = childElements;
        return;
    }
    [super setValue:value forKey:key];
}

@end
