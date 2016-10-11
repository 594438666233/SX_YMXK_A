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

//- (void)setValue:(id)value forKey:(NSString *)key {
//    if ([key isEqualToString:@"childElements"]) {
//        NSArray *childElementsDicArray = value;
//        NSMutableArray *childElements = [NSMutableArray array];
//        for (NSDictionary *dic in childElementsDicArray) {
//            SX_NewsChildElements *newsChildElements = [SX_NewsChildElements modelWithDic:dic];
//            [childElements addObject:newsChildElements];
//        }
//        self.childElements = childElements;
//        return;
//    }
//    [super setValue:value forKey:key];
//}
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"childElements"]) {
        NSArray *childElementsDicArray = value;
        NSMutableArray *childElements = [NSMutableArray array];
        for (NSDictionary *dic in childElementsDicArray) {
            SX_NewsResult *newsChildElements = [SX_NewsResult modelWithDic:dic];
            [childElements addObject:newsChildElements];
        }
        self.childElements = childElements;
        return;
    }
    [super setValue:value forKey:key];
}

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.authorName forKey:@"authorName"];
    [aCoder encodeObject:self.readingCount forKey:@"readingCount"];
    [aCoder encodeObject:self.commentsCount forKey:@"commentsCount"];
    [aCoder encodeInteger:self.contentId forKey:@"contentId"];
    [aCoder encodeObject:self.childElements forKey:@"childElements"];
    [aCoder encodeObject:self.thumbnailURLs forKey:@"thumbnailURLs"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
}
// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.authorName = [aDecoder decodeObjectForKey:@"authorName"];
        self.readingCount = [aDecoder decodeObjectForKey:@"readingCount"];
        self.commentsCount = [aDecoder decodeObjectForKey:@"commentsCount"];
        self.contentId = [aDecoder decodeIntegerForKey:@"contentId"];
        self.childElements = [aDecoder decodeObjectForKey:@"childElements"];
        self.thumbnailURLs = [aDecoder decodeObjectForKey:@"thumbnailURLs"];
        self.thumbnailUrl = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
    }
    return self;
}


@end
