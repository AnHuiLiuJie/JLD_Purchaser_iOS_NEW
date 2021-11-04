//
//  GLPGoodsDetailsSpecModel.h
//  DCProject
//
//  Created by Apple on 2021/3/22.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLPGoodsActivitiesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsSpecModel : NSObject

@property (nonatomic, copy) NSString *attr; // 规格型号
@property (nonatomic, copy) NSString *batchId; // 货号ID
@property (nonatomic, strong) GLPGoodsActivitiesModel *collageAct;//拼团活动
@property (nonatomic, strong) GLPGoodsActivitiesModel *seckillAct;//秒杀活动
@property (nonatomic, strong) GLPGoodsActivitiesModel *group;//团购活动
@property (nonatomic, copy) NSArray *marketingMixList;//如果是医药商品，组合医疗装 GLPMarketingMixListModel
@property (nonatomic, copy) NSString *effectMonths; // 有效期
@property (nonatomic, copy) NSString *goodsId; // 产品Id
@property (nonatomic, copy) NSString *goodsTitle; // 规格型号
@property (nonatomic, copy) NSString *img; // 图片
@property (nonatomic, assign) CGFloat marketPrice; // 市场单价
@property (nonatomic, assign) CGFloat sellPrice; // 商城销售单价
@property (nonatomic, assign) NSInteger stock; // 库存
@property (nonatomic, copy) NSString *serialId; //货号流水ID,非医药商品使用此字段
@property (nonatomic, copy) NSString *deliveryTime;//发货时间：文字显示，1.24小时内发货，2.2-7天发货

//自定义参数
@property (nonatomic, assign) NSInteger liaoIdx;//疗程装 0表示没选  其他值要-1，作为下标


@end


#pragma mark -GLPMarketingMixListModel 组合医疗装信息 MarketingMixVO

@interface GLPMarketingMixListModel : NSObject

@property (nonatomic, copy) NSString *mixId;//组合ID
@property (nonatomic, copy) NSString *mixNum;//组合数量
@property (nonatomic, copy) NSString *price;//商品单价
@property (nonatomic, copy) NSString *totalPrice;//商品总价
@property (nonatomic, copy) NSString *mixTip;

@property (nonatomic, assign) BOOL isSelected;//自定义

@end

NS_ASSUME_NONNULL_END
