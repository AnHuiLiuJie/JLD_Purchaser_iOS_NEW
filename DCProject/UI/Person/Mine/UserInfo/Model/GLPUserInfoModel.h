//
//  GLPUserInfoModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/10/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPUserInfoModel : NSObject
@property (nonatomic, copy) NSString  *cellphone; // 手机号
@property (nonatomic, copy) NSString *email; // 电子邮件
@property (nonatomic, copy) NSString *landline; // 座机
@property (nonatomic, copy) NSString *modifyTime; // 修改时间
@property (nonatomic, copy) NSString *qq; // QQ
@property (nonatomic, copy) NSString *userName; // 姓名
@property (nonatomic, copy) NSString *wechat; // 微信号
@property (nonatomic, copy) NSString *userImg; // 头像
@property (nonatomic, copy) NSString *nickName; //昵称
@property (nonatomic, copy) NSString *extendType; //用户推广类型：0-普通用户【进入申请界面】，1-创业者【正常推广】，2-创业者【待审核】，3-创业者【审核不通过】，4-创业者【禁用】，5-服务商员工【不可推广】
@property (nonatomic, copy) NSString *idCard; //身份证
@property (nonatomic, copy) NSString *idState; //实名认证状态:1-未提交认证资料；2-已提交认证资料；3-认证通过；4-认证不通过
@property (nonatomic, copy) NSString *idStateDesc; //实名认证说明
@property (nonatomic, copy) NSString *sex; //性别


@property (nonatomic, copy) NSString *modifyTimeParam; // 修改时间

@end

NS_ASSUME_NONNULL_END
