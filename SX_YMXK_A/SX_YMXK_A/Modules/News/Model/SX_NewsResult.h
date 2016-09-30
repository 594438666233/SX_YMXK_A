//
//  SX_NewsResult.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/21.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_NewsResult : SX_BaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *readingCount;
@property (nonatomic, copy) NSString *commentsCount;
@property (nonatomic, assign) NSInteger contentId;

@property (nonatomic, strong) NSArray *childElements;
@property (nonatomic, strong) NSArray *thumbnailURLs;


@end
