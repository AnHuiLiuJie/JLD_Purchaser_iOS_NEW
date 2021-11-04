//
//  TRRequestGoodsModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRRequestGoodsModel : NSObject
@property(nonatomic,copy)NSString *goodsTitle;//商品名称
@property(nonatomic,copy)NSString *goodsId;//商品id
@property(nonatomic,copy)NSString *goodsImg;//商品图片
@property(nonatomic,copy)NSString *cartId;//购物车ID
@property(nonatomic,copy)NSString *marketPrice;//药店价：单位元
@property(nonatomic,copy)NSString *packingSpec;//包装规格
@property(nonatomic,copy)NSString *quantity;//商品数量
@property(nonatomic,copy)NSString *sellPrice;//商品最新商城销售单价：单位元
@property(nonatomic,copy)NSString *stock;//库存
@property(nonatomic,copy)NSString *totalPrice;//商品小计：单位元; 商品小计= 数量 *商品最新商城销售单价sellPrice
@property(nonatomic,copy)NSString *select;//选中状态0:未选中 1:选中
@property(nonatomic,copy)NSString *section;//哪个区
@property(nonatomic,copy)NSString *row;//哪一行

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
