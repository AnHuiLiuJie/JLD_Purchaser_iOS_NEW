//
//  TRStoreRecomModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRStoreRecomModel : NSObject
@property(nonatomic,copy)NSString *catId;//商品分类
@property(nonatomic,copy)NSString *goodsId;//商品id
@property(nonatomic,copy)NSString *goodsName;//商品名称
@property(nonatomic,copy)NSString *goodsImg1;//商品图片
@property(nonatomic,copy)NSString *isAct;//是否有促销,1：是，2：否
@property(nonatomic,copy)NSString *isGroup;//是否有团购, 1：是，2：否
@property(nonatomic,copy)NSString *isOTC;//是否是OTC,1：是（非处方药），2：否（处方药）3：既不是处方药也不是非处方药
@property(nonatomic,copy)NSString *marketPrice;//市场单价：单位元
@property(nonatomic,copy)NSString *sellPrice;//商城销售单价
@property(nonatomic,copy)NSString *packingSpec;//包装规格
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
