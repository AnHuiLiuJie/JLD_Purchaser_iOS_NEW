//
//  GLBRegisterModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBRegisterModel : NSObject

@property (nonatomic, copy) NSString *firmAddress; // 详细地址
@property (nonatomic, copy) NSString *firmArea; // 企业所在地 .
@property (nonatomic, assign) NSInteger firmAreaId; // 企业所在地编码
@property (nonatomic, copy) NSString *firmCat1; // 企业一级分类
@property (nonatomic, copy) NSString *firmCat2List; // 企业二级分类

@end

NS_ASSUME_NONNULL_END
