//
//  SX_GameListResult.h
//  SX_YMXK_A
//
//  Created by dllo on 16/9/23.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_GameListResult : SX_BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, assign) NSInteger contentId;

@end
