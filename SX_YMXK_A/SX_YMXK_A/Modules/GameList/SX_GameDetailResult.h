//
//  SX_GameDetailResult.h
//  SX_YMXK_A
//
//  Created by dllo on 16/10/2.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_GameDetailResult : SX_BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *backgroundURL;
@property (nonatomic, assign) NSInteger newsNumber;
@property (nonatomic, assign) NSInteger strategyNumber;
@property (nonatomic, copy) NSString *gameType;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *sellTime;
@property (nonatomic, copy) NSString *developer;


@end
