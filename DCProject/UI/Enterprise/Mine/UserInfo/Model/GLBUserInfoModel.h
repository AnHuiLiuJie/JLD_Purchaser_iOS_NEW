//
//  GLBUserInfoModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/13.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBUserInfoModel : NSObject

@property (nonatomic, copy) NSString  *cellphone; // 手机号
@property (nonatomic, copy) NSString *email; // 电子邮件
@property (nonatomic, copy) NSString *landline; // 座机
@property (nonatomic, copy) NSString *modifyTimeParam; // 修改时间
@property (nonatomic, copy) NSString *qq; // QQ
@property (nonatomic, copy) NSString *userName; // 姓名
@property (nonatomic, copy) NSString *wechat; // 微信号

@end

NS_ASSUME_NONNULL_END
