//
//  ActivityAreaModel.h
//  DCProject
//
//  Created by LiuMac on 2021/8/10.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityAreaModel : DCBaseModel

@property (nonatomic, copy) NSString *actBtime;//活动开始时间
@property (nonatomic, copy) NSString *actEtime;//活动结束时间
@property (nonatomic, copy) NSString *actImg;//活动图片
@property (nonatomic, copy) NSString *actIntro;//活动简介
@property (nonatomic, copy) NSString *actTitle;//活动标题
@property (nonatomic, copy) NSString *bgColor;//背景颜色
@property (nonatomic, copy) NSString *bgImg;//背景图片
@property (nonatomic, copy) NSString *discountAmount;//优惠金额
@property (nonatomic, copy) NSString *fontColor;//文字颜色
@property (nonatomic, copy) NSString *goodsNum;//参与活动商品数
@property (nonatomic, copy) NSArray *goodsVO;//活动商品 ActivityAreaGoodsVOModel

@property (nonatomic, copy) NSString *iD;//活动ID  变id
@property (nonatomic, copy) NSString *joinNum;//活动参与人数
@property (nonatomic, copy) NSString *mainImg;//主图
@property (nonatomic, copy) NSString *requireAmount;//金额要求

@end


#pragma ####################

@interface ActivityAreaGoodsVOModel : DCBaseModel

@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *goodsName;//商品名称（通用名）
@property (nonatomic, copy) NSString *goodsImg1;//商品图片
@property (nonatomic, copy) NSString *sellPrice;//商城销售单价：单位元


@end

NS_ASSUME_NONNULL_END
