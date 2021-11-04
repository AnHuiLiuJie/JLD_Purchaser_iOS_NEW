//
//  GLBExhibitModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 展会详情
@interface GLBExhibitModel : NSObject

@property (nonatomic, copy) NSString *expoContent; // 展会内容
@property (nonatomic, copy) NSString *expoEndDate; // 结束日期
@property (nonatomic, assign) NSInteger expoId; // 展会ID
@property (nonatomic, copy) NSString *expoImg; // 展会宣传图片
@property (nonatomic, copy) NSString *expoIntroduce; // 展会简介
@property (nonatomic, copy) NSString *expoStartDate; //开始日期
@property (nonatomic, assign) NSInteger expoState; // 状态：1-正常，2-终止
@property (nonatomic, copy) NSString *expoTitle; // 展会标题
@property (nonatomic, copy) NSString *expoType; // 展会类型：1-企业展会，2-商品展会
@property (nonatomic, strong) NSArray *infoList; // 展会企业列表

@end


#pragma mark - 展会列表
@interface GLBExhibitInfoModel : NSObject

@property (nonatomic, copy) NSString *type; // 展会数据类型
@property (nonatomic, copy) NSString *typeName; // 展会数据类型名称
@property (nonatomic, strong) NSArray *goodsList; // 商品列表（展会类型为2-商品展会，不为空）
@property (nonatomic, strong) NSArray *expoFirmList; // 企业列表（展会类型为1-企业展会，不为空）

@end


#pragma mark - 商户
@interface GLBExhibitCompanyModel : NSObject

@property (nonatomic, copy) NSString *firmImg; // 展会企业图片
@property (nonatomic, copy) NSString *firmIntroduce; // 展会企业介绍
@property (nonatomic, copy) NSString *firmName; // 展会企业名称
@property (nonatomic, copy) NSString *infoId; // 企业链接地址类型所需要的ID
@property (nonatomic, copy) NSString *url; // 链接地址
@property (nonatomic, copy) NSString *urlType; // 企业链接地址类型：1-店铺；2-资讯；3-其他
@property (nonatomic, assign) NSInteger firmType; // 展会企业类型，1-工业企业；2-商业企业；3-零售企业
@property (nonatomic, strong) NSArray *goodsList; // 商品列表

@end


#pragma mark - 商品
@interface GLBExhibitGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsImg; // 展会商品图片
@property (nonatomic, copy) NSString *goodsIntroduce; // 展会商品简介
@property (nonatomic, copy) NSString *goodsTitle; // 展会商品标题
@property (nonatomic, copy) NSString *infoId; // 链接地址类型所需要的ID
@property (nonatomic, copy) NSString *url; // 链接地址
@property (nonatomic, copy) NSString *urlType; // 链接地址类型：1-产品；2-资讯；3-其他
@property (nonatomic, copy) NSString *price;// 价格


@end

NS_ASSUME_NONNULL_END
