//
//  GLPNewShoppingCarModel.h
//  DCProject
//
//  Created by LiuMac on 2021/7/12.
//

#import "DCBaseModel.h"
#import "GLPGoodsDetailsSpecModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GLPCouponListModel;
@class GLPNewShopCarGoodsModel;
@class ActInfoListModel;

@interface GLPNewShoppingCarModel : DCBaseModel

@property (nonatomic, copy) NSArray *firmList;//卖家列表 ==GLPFirmListModel
@property (nonatomic, copy) NSString *orderCouponsDiscount;//所有店铺优惠券总金额
@property (nonatomic, copy) NSString *orderPrice;//订单金额=订单商品总金额-优惠总金额（客户端需要处理加上运费）
@property (nonatomic, copy) NSString *orderTotalPrice;//订单商品总金额

@end


#pragma mark - ****************************      GLPFirmListModel 卖家列表          ***********************************
@interface GLPFirmListModel : DCBaseModel

//公用的
@property (nonatomic, strong) NSMutableArray *actInfoList;//订单活动列表 ==ActInfoListModel
@property (nonatomic, strong) NSMutableArray *cartGoodsList;//订单商品列表 ==GLPNewShopCarGoodsModel
@property (nonatomic, copy) NSString *mallLogo;//店铺logo
@property (nonatomic, copy) NSString *mallName;//卖家店铺名称
@property (nonatomic, copy) NSString *sellerFirmId;//卖家企业id
@property (nonatomic, copy) NSString *sellerFirmName;//卖家企业名称
//购物车
@property (nonatomic, copy) NSString *existCoupons;//是否有可领取优惠券0-没有优惠券 1-有优惠券
@property (nonatomic, copy) NSArray *invalidGoodsList;//失效商品列表---目前客户端没有显示 == GLPNewShopCarGoodsModel
@property (nonatomic, copy) NSString *isInvalid;//企业是否失效
//订单提交也用到的
@property (nonatomic, copy) NSString *otcGoodsId;//otc产品编码
@property (nonatomic, copy) NSArray *couponList;//优惠券列表 == GLPCouponListModel
@property (nonatomic, copy) NSArray *defaultCoupon;//默认优惠券-订单确认页面显示==GLPCouponListModel
@property (nonatomic, copy) NSString *deliveryTime;//发货时间：文字显示，1.24小时发货，2.2-7天发货
@property (nonatomic, assign) BOOL isPrescription;//是否处方药订单：true-处方订单（非OTC商品）；false-不是处方订单（OTC或者非医药）
@property (nonatomic, copy) NSString *shopTotalPrice;//店铺小计


#pragma mark - 自定义属性
@property (nonatomic, copy) NSString *payType; // 支付方式
@property (nonatomic, copy) NSString *sendType; // 配送方式
@property (nonatomic, assign) CGFloat yufei; // 运费
@property (nonatomic, copy) NSString *remark; // 订单备注

@end

#pragma mark - ****************************      GLPCouponListModel 优惠券列表          ***********************************
@interface GLPCouponListModel : DCBaseModel

@property (nonatomic, copy) NSString *couponsClass;//优惠券类型：1：平台券，2：店铺券3：商品券
@property (nonatomic, copy) NSString *couponsId;//优惠券编码
@property (nonatomic, copy) NSString *discountAmount;//优惠金额
@property (nonatomic, copy) NSString *requireAmount;//优惠券金额要求
@property (nonatomic, copy) NSString *goodsId;//商品
@property (nonatomic, copy) NSString *useStartDate;//使用开始日期
@property (nonatomic, copy) NSString *useEndDate;//使用结束日期

#pragma mark - 自定义属性
@property (nonatomic, assign) BOOL isSelected; // 是否被选中
@property (nonatomic, assign) NSInteger showType; // 1可选 选中 2 可选没选中 3 不可选没选中

@end

#pragma mark - ******************************  ActInfoListModel 活动列表-含活动信息和活动对应的商品   ******************************
@interface ActInfoListModel : DCBaseModel

@property (nonatomic, strong) NSMutableArray *actGoodsList;//活动商品 ==GLPNewShopCarGoodsModel
@property (nonatomic, copy) NSString *actTitle;//活动标题
@property (nonatomic, copy) NSString *afterDiscountAmount;//优惠后商品总金额
@property (nonatomic, copy) NSString *beforeDiscountAmount;//优惠前商品总金额
@property (nonatomic, copy) NSString *isSatisfy;//活动商品，是否满足活动要求
//@property (nonatomic, copy) NSString *requireAmount;//金额要求
//@property (nonatomic, copy) NSString *discountAmount;//优惠金额

@property (nonatomic, copy) NSArray *actPriceList;//满减金额列表 //discountAmount requireAmount

@end


#pragma mark - ******************************  GLPNewShopCarGoodsModel 商品详情商品列表   ******************************
@interface GLPNewShopCarGoodsModel : DCBaseModel

@property (nonatomic, copy) NSString *batchId;//批次ID
@property (nonatomic, copy) NSString *cartId;//购物车ID
@property (nonatomic, copy) NSString *certifiNum;//批准文号
@property (nonatomic, copy) NSString *chargeUnit;//计价单位
@property (nonatomic, copy) NSString *goodsId;//商品id
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsSubtotal;//商品小计
@property (nonatomic, copy) NSString *goodsTitle;//商品标题
@property (nonatomic, copy) NSString *goodsWeight;//商品单位重量（KG）
@property (nonatomic, copy) NSString *groupPrice;//团购价
@property (nonatomic, assign) BOOL isGroup;//是否团购
@property (nonatomic, copy) NSString *isMedical;//是否医药商品
@property (nonatomic, copy) NSString *isOtc;//是否OTC：1-是OTC；2-否（非OTC） isOtc==2时为处方药
@property (nonatomic, copy) NSString *logisticsTplId;//邮费模板:0表示免邮费
@property (nonatomic, copy) NSString *manufactory;//生成厂家
@property (nonatomic, copy) NSString *marketPrice;//市场单价
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *quantity;//购买数量
@property (nonatomic, copy) NSString *sellPrice;//商城销售单价
@property (nonatomic, copy) NSString *sellerFirmId;//卖家企业ID
@property (nonatomic, copy) NSString *stock;//库存
@property (nonatomic, copy) NSString *symptom;//疾病症状
@property (nonatomic, copy) NSString *tips;//商品提示

@property (nonatomic, copy) NSString *mixTip;//组合提示，用于医药商品组合销售时提示
@property (nonatomic, strong) GLPMarketingMixListModel *marketingMix;//组合医疗装信息 GLPMarketingMixListModel
@property (nonatomic, copy) NSString *freeShippingId;//包邮活动的Id，若存在

#pragma mark 自定义属性
@property (nonatomic, assign) BOOL isSelected; // 是否被选中
//@property (nonatomic, assign) BOOL isActGoods;//是否是活动商品


@end




NS_ASSUME_NONNULL_END
