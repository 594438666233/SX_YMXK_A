//
//  SX_Comment.h
//  SX_YMXK_A
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_BaseModel.h"

@interface SX_Comment : SX_BaseModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ip_location;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, assign) NSInteger create_time;
@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, copy) NSString *topic_title;

@end
