//
//  GLPGoodsQusetionModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/11.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLPGoodsQusetionAnswerModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsQusetionModel : NSObject

@property (nonatomic, strong) NSArray *answerList;
@property (nonatomic, copy) NSString *editTime; // 编辑时间
@property (nonatomic, assign) NSInteger firmId; // 企业ID
@property (nonatomic, copy) NSString *goodsId; // 商品ID
@property (nonatomic, copy) NSString *goodsName; // 商品名称
@property (nonatomic, copy) NSString *questionContent; // 问题内容

@end


#pragma mark - 答案模型
@interface GLPGoodsQusetionAnswerModel : NSObject

@property (nonatomic, copy) NSString *answerContent; // 回答内容
@property (nonatomic, assign) NSInteger answerId; // 唯一ID
@property (nonatomic, assign) NSInteger questionId; // 问题ID
@end

NS_ASSUME_NONNULL_END
