//
//  CustomerSourceModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/22.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomerSourceModel : DCBaseModel


@end


#pragma mark - 推广用户
@interface CustomerSourceListModel : DCBaseModel

@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *loginName;//登录名
@property (nonatomic, copy) NSString *cellphone;//手机号
@property (nonatomic, copy) NSString *userName;//用户姓名
@property (nonatomic, copy) NSString *totalServiceFee;//累计服务费
@property (nonatomic, copy) NSString *createTime;//获客时间-创建时间

@end


#pragma mark - 赚钱说明
@interface CustomerExplainModel : DCBaseModel

@property (nonatomic, copy) NSString *content;//
@property (nonatomic, copy) NSString *background;

@end

NS_ASSUME_NONNULL_END
