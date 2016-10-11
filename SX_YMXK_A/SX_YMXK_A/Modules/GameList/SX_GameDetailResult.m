//
//  SX_GameDetailResult.m
//  SX_YMXK_A
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_GameDetailResult.h"

@implementation SX_GameDetailResult

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.backgroundURL forKey:@"backgroundURL"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.newsNumber forKey:@"newsNumber"];
    [aCoder encodeInteger:self.strategyNumber forKey:@"strategyNumber"];
    [aCoder encodeObject:self.gameType forKey:@"gameType"];
    [aCoder encodeObject:self.platform forKey:@"platform"];
    [aCoder encodeObject:self.sellTime forKey:@"sellTime"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
    [aCoder encodeObject:self.developer forKey:@"developer"];
    [aCoder encodeInteger:self.contentId forKey:@"contentId"];
}
// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.developer = [aDecoder decodeObjectForKey:@"developer"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.sellTime = [aDecoder decodeObjectForKey:@"sellTime"];
        self.platform = [aDecoder decodeObjectForKey:@"platform"];
        self.gameType = [aDecoder decodeObjectForKey:@"gameType"];
        self.newsNumber = [aDecoder decodeIntegerForKey:@"newsNumber"];
        self.strategyNumber = [aDecoder decodeIntegerForKey:@"strategyNumber"];
        self.thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
        self.backgroundURL = [aDecoder decodeObjectForKey:@"backgroundURL"];
        self.contentId = [aDecoder decodeIntegerForKey:@"contentId"];
    }
    return self;
}


@end
