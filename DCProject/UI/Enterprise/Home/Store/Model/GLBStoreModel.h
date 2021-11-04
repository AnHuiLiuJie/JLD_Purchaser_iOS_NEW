//
//  GLBStoreModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GLBStoreInfoModel;
@class GLBStoreOtherModel;

NS_ASSUME_NONNULL_BEGIN


@interface GLBStoreModel : NSObject

@property (nonatomic, copy) NSString *notice; // 商家公告
@property (nonatomic, strong) GLBStoreInfoModel *storeInfoVO; // 店铺详情
@property (nonatomic, strong) GLBStoreOtherModel *storeQualDeliVO; // 资质/配送

#pragma mark - 自定义参数
@property (nonatomic, assign) BOOL isCollected;// 是否被收藏

@end


@interface GLBStoreInfoModel : NSObject

@property (nonatomic, assign) NSInteger evalCount; // 评论数量
@property (nonatomic, copy) NSString *firmId; // 企业ID
@property (nonatomic, copy) NSString *firmName; // 企业名称
@property (nonatomic, copy) NSString *freight; // 运费说明
@property (nonatomic, assign) NSInteger goodsCount; // 产品上架数量
@property (nonatomic, copy) NSString *logoImg; // logo(没有时放一个默认的图片)
@property (nonatomic, assign) NSInteger sendCount; // 发货数量
@property (nonatomic, copy) NSString *storeDeliveryStar; // 发货速度
@property (nonatomic, copy) NSString *storeName; // 店铺名称
@property (nonatomic, copy) NSString *storeServiceStar; // 服务评价/满意度
@property (nonatomic, copy) NSString *storeStar; // 店铺等级
@property (nonatomic, copy) NSString *suppierUserId; // 环信id

@end


@interface GLBStoreOtherModel : NSObject

@property (nonatomic, copy) NSString *afterSaleExplain; // 售后说明
@property (nonatomic, assign) NSInteger auditState; // 商家认证，1-待审核；2-审核通过
@property (nonatomic, copy) NSString *deliveryExplain; // 配送说明
@property (nonatomic, strong) NSArray *qual; // 产品资质图片地址
@property (nonatomic, copy) NSString *supplierScope; // 经营范围

@end


#pragma mark - 暂时弃用
//@interface GLBStoreModel : NSObject
//
//@property (nonatomic, copy) NSString *arrivalEate; //到货速度
//@property (nonatomic, copy) NSString *createTime; // 注册时间
//@property (nonatomic, assign) NSInteger deliveryMoney;//最小起定量
//@property (nonatomic, copy) NSString *domainName;//店铺域名
//@property (nonatomic, assign) NSInteger evalCount;//评价数
//@property (nonatomic, copy) NSString *firmAddress;//详细地址
//@property (nonatomic, copy) NSString *firmArea;//企业所在地
//@property (nonatomic, copy) NSString *firmAreaId;//企业所在地ID
//@property (nonatomic, copy) NSString *firmContactPhone;//企业联系人手机
//@property (nonatomic, copy) NSString *firmCorp;//企业法人
//@property (nonatomic, copy) NSString *firmEmail;//企业邮箱
//@property (nonatomic, copy) NSString *firmName;//企业名称
//@property (nonatomic, copy) NSString *firmPhone;//企业联系电话
//@property (nonatomic, copy) NSString *firmState;//企业状态1-正常；2-禁用；3-待提交审核资料；4-审核中
//@property (nonatomic, copy) NSString *firmType;//企业类型
//@property (nonatomic, copy) NSString *firmTypeName;//企业类型名称
//@property (nonatomic, copy) NSString *firstFirmCat;//企业一级分类
//@property (nonatomic, copy) NSString *freight;//运费
//@property (nonatomic, strong) NSArray *goodslist; //企业所属产品
//@property (nonatomic, copy) NSString *iD;//企业ID
//@property (nonatomic, copy) NSString *isCoupon;//是否有优惠券
//@property (nonatomic, copy) NSString *isPromotion;//是否有促销商品
//@property (nonatomic, copy) NSString *isSign;
//@property (nonatomic, copy) NSString *logoImg;
//@property (nonatomic, copy) NSString *produceArea;//生产/经营范围名称
//@property (nonatomic, assign) NSInteger sales;//销量
//@property (nonatomic, strong) NSArray *scopeList;//经营范围列表，key为经营范围ID，value为经营范围名称
//@property (nonatomic, copy) NSString *secondFirmCat;//企业二级分类
//@property (nonatomic, copy) NSString *serviceAttitude;//服务态度
//@property (nonatomic, copy) NSString *shopName;//店铺名称
//@property (nonatomic, copy) NSString *supplierLevel;//供应商级别
//@property (nonatomic, copy) NSString *supplierScopeList;//供应商经营范围
//@property (nonatomic, copy) NSString *transScore;//交易评分
//
//@property (nonatomic, copy) NSString *notice; // 商家公告
//
//
//#pragma mark - 自定义参数
//@property (nonatomic, assign) BOOL isCollected;// 是否被收藏
//
//@end
//
//
//#pragma mark - 店铺商品
//@interface GLBStoreGoodsModel : NSObject
//
//@property (nonatomic, copy) NSString *actTitle; // 活动标题
//@property (nonatomic, copy) NSString *batchNum; //批号
//@property (nonatomic, copy) NSString *batchProduceTime;//批次生产日期
//@property (nonatomic, copy) NSString *batchTotalSale;//销量
//@property (nonatomic, copy) NSString *brandName;//品牌名称
//@property (nonatomic, copy) NSString *catId;//产品分类ID
//@property (nonatomic, copy) NSString *catName;//产品分类名称
//@property (nonatomic, copy) NSString *centerPackNum;//中包装数量
//@property (nonatomic, copy) NSString *certifiNum;//批准文号
//@property (nonatomic, copy) NSString *effectTime;//有效期
//@property (nonatomic, copy) NSString *goodsCode;//商品编码
//@property (nonatomic, copy) NSString *goodsId;//产品ID
//@property (nonatomic, copy) NSString *goodsImg;//产品图片
//@property (nonatomic, copy) NSString *goodsName;//产品名称
//@property (nonatomic, copy) NSString *iD;//批次ID
//@property (nonatomic, copy) NSString *isCoupon;//是否有优惠券活动：1.是，2：否
//@property (nonatomic, copy) NSString *isPromotion;//是否促销：1.是，2.否
//@property (nonatomic, copy) NSString *isWholeSell;//是否整件销售
//@property (nonatomic, copy) NSString *manufactory;//生产单位
//@property (nonatomic, copy) NSString *manufactoryAbbr;//生产单位简称
//@property (nonatomic, copy) NSString *packingSpec;//包装规格
//@property (nonatomic, copy) NSString *sellType;//1.拆零中包；2.拆零小包 .
//@property (nonatomic, copy) NSString *stock;//库存
//@property (nonatomic, copy) NSString *suppierFirmId;//供应商ID
//@property (nonatomic, copy) NSString *suppierFirmName;//供应商名称
//@property (nonatomic, copy) NSString *wholeNotaxPrice;//整件价
//@property (nonatomic, copy) NSString *zeroNotaxPrice;//拆零价
//
//
//@end


NS_ASSUME_NONNULL_END
