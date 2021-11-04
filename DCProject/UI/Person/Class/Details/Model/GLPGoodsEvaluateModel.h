//
//  GLPGoodsEvaluateModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/11.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLPGoodsEvaluateListModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsEvaluateModel : NSObject

@property (nonatomic, assign) NSInteger evalCount; // 评论数
@property (nonatomic, assign) CGFloat praiseRate; // 平均评分
@property (nonatomic, strong) NSArray *evalList; // 评论信息

@end


#pragma mark - 评论信息
@interface GLPGoodsEvaluateListModel : NSObject

@property (nonatomic, assign) NSInteger buyerId; // 买家ID
@property (nonatomic, copy) NSString *buyerLoginName; // 买家登录名称
@property (nonatomic, copy) NSString *buyerNickname; // 买家昵称：匿名评价时，昵称中用*号
@property (nonatomic, copy) NSString *createTime; // 创建时间
@property (nonatomic, copy) NSString *evalContent; // 评论内容
@property (nonatomic, assign) NSInteger evalId; // 评价ID
@property (nonatomic, copy) NSString *evalImgs; // 评论图片
@property (nonatomic, assign) NSInteger star; // 星级：1-1星；2-2星；3-3星；4-4星；5-5星
@property (nonatomic, copy) NSString *userImg; // 买家头像

@end

NS_ASSUME_NONNULL_END
