//
//  SX_NewsChildElements.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/21.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_NewsChildElements : SX_BaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *readingCount;
@property (nonatomic, copy) NSString *conmmentsCount;
@property (nonatomic, assign) NSInteger contentId;
@property (nonatomic, retain) NSArray *childElements;
@property (nonatomic, retain) NSArray *thumbnailURLs;


@end
