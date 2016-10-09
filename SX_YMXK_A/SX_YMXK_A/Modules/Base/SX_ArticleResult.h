//
//  SX_ArticleResult.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/26.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_ArticleResult : SX_BaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, copy) NSString *mainBody;
@property (nonatomic, copy) NSString *originURL;
@property (nonatomic, copy) NSString *thumbnailUrl;

@end
