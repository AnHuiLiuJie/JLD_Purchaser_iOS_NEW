//
//  GLBMessageModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBMessageModel : NSObject

@property (nonatomic, copy) NSString *msgContent; // 消息内容
@property (nonatomic, copy) NSString *msgTime; // 发送时间
@property (nonatomic, copy) NSString *msgTitle; // 消息标题

@end

NS_ASSUME_NONNULL_END
