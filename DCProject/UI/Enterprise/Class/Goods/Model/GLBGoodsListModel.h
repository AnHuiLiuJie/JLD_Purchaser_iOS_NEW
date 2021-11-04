//
//  GLBGoodsListModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/13.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsListModel : NSObject

@property (nonatomic, copy) NSString *batchId; // 批次ID
@property (nonatomic, copy) NSString *batchNum; // 批号
@property (nonatomic, copy) NSString *batchTotalSale; // 批次销量
@property (nonatomic, copy) NSString *defaultImg; // 默认图片
@property (nonatomic, copy) NSString *goodsId; // 产品ID
@property (nonatomic, copy) NSString *goodsImg; // 产品图片
@property (nonatomic, copy) NSString *goodsName; // 产品名称
@property (nonatomic, copy) NSString *isBasicMedc; // 是否为基药 1是
@property (nonatomic, copy) NSString *isCoupon; // 是否有优惠券活动：1.是，2：否
@property (nonatomic, copy) NSString *isCtrlSale; // 是否控销:1：控销，2：非控销 <这里修改过，原先为：1：非控销，2：控销，如果出现控销问题，请定位到GoodsListVO进行修改>
@property (nonatomic, copy) NSString *isPromotion; // 是否促销：1.是，2.否
@property (nonatomic, copy) NSString *isShowPrice; // 是否开启底价显示,为空或者为1-开启底价显示；2-关闭低价显示
//@property (nonatomic, copy) NSString *isWholeSell; // 是否整件销售：1.是；2.否
@property (nonatomic, assign) NSInteger sellType; // 2整 4零 3整+零
@property (nonatomic, copy) NSString *manufactory; // 生产单位
@property (nonatomic, copy) NSString *manufactoryAbbr; // 生产单位简称
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, copy) NSString *suppierFirmId; // 供应商ID
@property (nonatomic, copy) NSString *suppierFirmName; // 供应商名称
@property (nonatomic, copy) NSString *wholePrice; // 整件价
@property (nonatomic, copy) NSString *zeroPrice; // 拆零价
@property (nonatomic, copy) NSString *actTitle; // // 满多少减多少券

@end

NS_ASSUME_NONNULL_END
