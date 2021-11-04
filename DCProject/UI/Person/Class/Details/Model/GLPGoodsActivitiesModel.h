//
//  GLPGoodsActivitiesModel.h
//  DCProject
//
//  Created by LiuMac on 2021/9/15.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsActivitiesModel : DCBaseModel


@property (nonatomic, copy) NSString *actId;//活动Id
@property (nonatomic, assign) CGFloat actSellPrice;//活动单价（seckill-秒杀；collage-拼团；group-团购时存在）
@property (nonatomic, copy) NSString *actTitle;//活动标题
@property (nonatomic, copy) NSString *actType;//活动类型：freePostage-包邮活动；coupon-单品优惠券；fullMinus-满减；seckill-秒杀；collage-拼团；group-团购,可用值:freePostage,coupon,fullMinus,seckill,collage,group
@property (nonatomic, copy) NSString *discountAmount;//优惠金额（coupon-单品优惠券；fullMinus-满减时存在）
@property (nonatomic, copy) NSString *endTime;//活动结束时间（除freePostage-包邮活动 其它都存在）
@property (nonatomic, copy) NSString *priceTips;//活动金额提示（seckill-秒杀；collage-拼团；group-团购时存在）
@property (nonatomic, copy) NSString *requireAmount;//金额要求（coupon-单品优惠券；fullMinus-满减时存在）
@property (nonatomic, copy) NSArray *tips;//活动提示，比如包邮、满30减5、立减3元
@property (nonatomic, copy) NSString *batchId;//

@end

NS_ASSUME_NONNULL_END
