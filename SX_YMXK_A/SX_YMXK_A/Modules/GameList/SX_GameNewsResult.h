//
//  SX_GameNewsResult.h
//  SX_YMXK_A
//
//  Created by dllo on 16/10/3.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_GameNewsResult : SX_BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, assign) NSInteger contentId;


@end
