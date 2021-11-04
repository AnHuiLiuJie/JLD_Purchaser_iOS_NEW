//
//  GLBStoreGoodsModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreGoodsModel : NSObject

@property (nonatomic, copy) NSString *actTitle; // 活动标题
@property (nonatomic, copy) NSString *batchId; // 批次ID
@property (nonatomic, copy) NSString *batchNum; //批号
//@property (nonatomic, copy) NSString *batchProduceTime;//批次生产日期
@property (nonatomic, copy) NSString *isCtrlSale; // 1 控效 2 招标
@property (nonatomic, copy) NSString *batchTotalSale;//销量
@property (nonatomic, copy) NSString *defaultImg; // 默认图片
@property (nonatomic, copy) NSString *goodsId;//产品ID
@property (nonatomic, copy) NSString *goodsImg;//产品图片
@property (nonatomic, copy) NSString *goodsName;//产品名称
@property (nonatomic, copy) NSString *isBasicMedc; // 是否为基药
@property (nonatomic, copy) NSString *isCoupon;//是否有优惠券活动：1.是，2：否
@property (nonatomic, copy) NSString *isPromotion;//是否促销：1.是，2.否
//@property (nonatomic, copy) NSString *isWholeSell;//是否整件销售 1.是；2.否；3.都支持
@property (nonatomic, assign) NSInteger sellType; // 2整 4零 3整+零
@property (nonatomic, copy) NSString *isShowPrice; // 是否开启底价显示,为空或者为1-开启底价显示；2-关闭底价显示
@property (nonatomic, copy) NSString *manufactory;//生产单位
@property (nonatomic, copy) NSString *manufactoryAbbr;//生产单位简称
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *suppierFirmId;//供应商ID
@property (nonatomic, copy) NSString *suppierFirmName;//供应商名称
@property (nonatomic, copy) NSString *wholePrice;//整件价
@property (nonatomic, copy) NSString *zeroPrice;//拆零价



@end

NS_ASSUME_NONNULL_END
