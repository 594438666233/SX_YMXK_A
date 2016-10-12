//
//  SX_CommentTableViewCell.h
//  SX_YMXK_A
//
//  Created by dllo on 16/10/6.
//  Copyright © 2016年 rain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SX_Comment;

@protocol SX_CommentCellDelegate <NSObject>

- (void)getTopicId:(NSInteger)topicId;

@end


@interface SX_CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) SX_Comment *comment;
@property (nonatomic, assign) id<SX_CommentCellDelegate>topic_delegate;

@end
