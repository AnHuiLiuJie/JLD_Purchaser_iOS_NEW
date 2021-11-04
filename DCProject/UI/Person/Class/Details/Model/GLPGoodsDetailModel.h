//
//  GLPGoodsDetailModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/11.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLPGoodsActivitiesModel.h"
#import "GLPGoodsDetailsSpecModel.h"

@class GLPGoodsDetailTicketModel;
@class GLPGoodsDetailGroupModel;
@class GLPGoodsDetailServerModel;
@class GLPGoodsDetailSpecModel;
@class GLPGoodsDetailShopModel;
@class GLPGoodsDetailActivityModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailModel : NSObject

@property (nonatomic, copy) NSString *goodsWeight;//商品质量kg
@property (nonatomic, copy) NSString *goodsId; // 商品ID
@property (nonatomic, copy) NSString *goodsTitle; // 商品标题
@property (nonatomic, assign) NSInteger sellerFirmId; // 卖家企业ID
@property (nonatomic, assign) NSInteger sellerFirmName; // 卖家企业名称
@property (nonatomic, copy) NSString *goodsDesc; // 商品详情描述
@property (nonatomic, assign) CGFloat marketPrice; // 市场单价：单位元
@property (nonatomic, assign) CGFloat sellPrice; // 商城销售单价：单位元
@property (nonatomic, copy) NSString *chargeUnit; // 计价单位
@property (nonatomic, copy) NSString *manufactoryAddr; // 生产单位地址
@property (nonatomic, copy) NSString *dosageForm; // 剂型
@property (nonatomic, assign) NSInteger isPromotion;//是否促销：1-有促销；2-无促销
@property (nonatomic, assign) NSInteger totalStock; // 总库存量
@property (nonatomic, assign) NSInteger logisticsTplId;//运费模板ID
@property (nonatomic, copy) NSString *prodName; // 目录库中产品名称
@property (nonatomic, copy) NSString *goodsCode; // 商品编码
@property (nonatomic, copy) NSString *goodsImgs; // 商品图片
@property (nonatomic, copy) NSString *goodsName; // 商品名称（通用名）
@property (nonatomic, copy) NSString *brandName; // 商品品牌（bandName）
@property (nonatomic, copy) NSString *useMethod; // 使用方法
@property (nonatomic, copy) NSString *usePerson; // 使用人群
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, copy) NSString *certifiNum; // 批准文号
@property (nonatomic, copy) NSString *manufactory; // 生产单位
@property (nonatomic, assign) NSInteger isOtc; // 是否OTC：1-是OTC；2-否（不是OTC
@property (nonatomic, copy) NSString *isMedical;  //1-医药；2-非医药
@property (nonatomic, copy) NSString *spreadAmount; // 推广收益金额
@property (nonatomic, copy) NSString *frontClassName; //前端品类名称
@property (nonatomic, copy) NSString *frontClassIcon; //前端品类图标
@property (nonatomic, assign) CGFloat spreadRate; // 一级推广分成比例
@property (nonatomic, assign) NSInteger isCollection; // 是否关注：0否，非0即为其关注Id 商品收藏id
@property (nonatomic, strong) GLPGoodsDetailShopModel *shopInfo; // 店铺信息(shopBean)
@property (nonatomic, strong) GLPGoodsDetailActivityModel *activityInfo; // 活动信息(actBean)
@property (nonatomic, strong) GLPGoodsDetailGroupModel *groupInfo; // 团购信息(groupBean)
@property (nonatomic, strong) GLPGoodsDetailTicketModel *goodsCoupons; // 商品优惠券信息(goodsCouponsBean)
@property (nonatomic, strong) GLPGoodsDetailTicketModel *storeCoupons; // 店铺优惠券信息(storeCouponsBean)
@property (nonatomic, strong) GLPGoodsDetailTicketModel *bossCoupons; // 平台优惠券信息 (bossCouponsBean)
@property (nonatomic, strong) NSArray *shopHotGoods;//GLPGoodsLickGoodsModel 猜你喜欢 热销商品(舍弃了)
//@property (nonatomic, strong) GLPGoodsDetailSpecModel *specBean; // 商品规格信息 自己添加
@property (nonatomic, copy) NSString *deliveryTime;//发货时间：文字显示，1.24小时内发货，2.2-7天发货
@property(nonatomic,copy) NSArray *activities;//各个活动信息  GLPGoodsActivitiesModel
@property(nonatomic,copy) NSString *mixTips;//疗程优惠
@property(nonatomic,copy) NSString *couponTips;//单品优惠券提示
@property(nonatomic,copy) NSString *fullMinusTips;//满减活动提示
@property (nonatomic, strong) GLPGoodsDetailsSpecModel *attr; // 非医药商品默认批号，根据batchId查询（如果传入了）GLPGoodsDetailsSpecModel
@property(nonatomic,copy) NSString *goodsTagNameList;//商品标签

//自定义参数 用于存储组合疗程装的价格
@property(nonatomic,copy) NSString *liaoPrice;//疗程单价
@property(nonatomic,copy) NSString *liaoOldPrice;//无疗程单价

@end


#pragma mark - 活动信息
@interface GLPGoodsDetailActivityModel : NSObject

@property (nonatomic, copy) NSString *actBtime;//活动开始时间
@property (nonatomic, copy) NSString *actEtime;//活动结束时间
@property (nonatomic, copy) NSString *actTitle;//活动标题
@property (nonatomic, copy) NSString *discountAmount;//优惠金额
@property (nonatomic, copy) NSString *iD;//活动ID
@property (nonatomic, copy) NSString *joinNum;//活动参与人数
@property (nonatomic, copy) NSString *requireAmount;//金额要求

@end


#pragma mark - 券信息
@interface GLPGoodsDetailTicketModel : NSObject

@property (nonatomic, copy) NSString *couponsId; // 优惠券Id
@property (nonatomic, copy) NSString *discountAmount;//优惠金额/折扣
@property (nonatomic, copy) NSString *requireAmount;//金额要求
@property (nonatomic, copy) NSString *useEndDate;//使用结束日期
@property (nonatomic, copy) NSString *useStartDate;//使用开始日期

@end


#pragma mark - 团购信息
@interface GLPGoodsDetailGroupModel : NSObject

@property (nonatomic, copy) NSString *actBtime;//团购活动开始时间
@property (nonatomic, copy) NSString *actEtime;//团购活动结束时间
@property (nonatomic, copy) NSString *actImg;//团购活动图片
@property (nonatomic, copy) NSString *actPrice;//团购活动价格
@property (nonatomic, copy) NSString *actTitle;//团购活动标题
@property (nonatomic, copy) NSString *iD;//团购活动ID
@property (nonatomic, copy) NSString *joinNum;//参加人数
@end


#pragma mark - 商品服务信息
@interface GLPGoodsDetailServerModel : NSObject

@property (nonatomic, assign) NSInteger isFreightInsurance; // 是否支持退货运费险：1.是。2.否
@property (nonatomic, assign) NSInteger isQuality; // 是否正品：1.是。2.否
@property (nonatomic, assign) NSInteger isQuickRefund;//是否支持极速退款：1.是。2.否
@property (nonatomic, assign) NSInteger isReturn; // 是否支持破损退货：1.是。2.否
@property (nonatomic, assign) NSInteger isReturnByDate; // 是否支持七天无理由退款：1.是。2.否

@end


#pragma mark - 商品规格信息
@interface GLPGoodsDetailSpecModel : NSObject

//@property (nonatomic, copy) NSString *attr; // 规格型号
//@property (nonatomic, copy) NSString *batchId; // 货号ID
//@property (nonatomic, copy) NSString *effectMonths; // 有效期
//@property (nonatomic, copy) NSString *goodsId; // 产品Id
//@property (nonatomic, copy) NSString *goodsTitle; // 规格型号
//@property (nonatomic, copy) NSString *img; // 图片
//@property (nonatomic, assign) CGFloat marketPrice; // 市场单价
//@property (nonatomic, assign) CGFloat sellPrice; // 商城销售单价
//@property (nonatomic, assign) NSInteger stock; // 库存

@property (nonatomic, copy) NSString *goodsName; //商品名称
@property (nonatomic, copy) NSString *bandName;// 商品品牌
@property (nonatomic, copy) NSString *packingSpec; // 商品规格
@property (nonatomic, copy) NSString *certifiNum; // 批准文号
@property (nonatomic, copy) NSString *manufactory; // 生产单位
@property (nonatomic, copy) NSString *manufactoryAddr; // 生产地址
@property (nonatomic, copy) NSString *useMethod;
@property (nonatomic, copy) NSString *usePerson;
@end


#pragma mark - 店铺信息
@interface GLPGoodsDetailShopModel : NSObject

@property (nonatomic, assign) NSInteger collectionCount; // 被关注数量
@property (nonatomic, copy) NSString *firmName; // 企业名称
@property (nonatomic, assign) NSInteger goodsCount; // 全部商品数量
@property (nonatomic, assign) NSInteger isCollection; // 是否关注：0否，非0即为其关注Id
@property (nonatomic, copy) NSString *logoImg; // 企业店铺logo
@property (nonatomic, copy) NSString *shopId; // 店铺Id
@property (nonatomic, copy) NSString *shopName; // 店铺名
@property (nonatomic, copy) NSString *userId; // 用户id

@end

NS_ASSUME_NONNULL_END
