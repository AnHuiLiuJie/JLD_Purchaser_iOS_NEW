//
//  GLBShoppingCarModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/14.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBShoppingCarModel.h"

@implementation GLBShoppingCarModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cartGoodsList":@"GLBShoppingCarGoodsModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLBShoppingCarFreightModel":@"freight",
             @"GLBMineTicketCouponsModel":@"coupon"
    };
}

@end



@implementation GLBShoppingCarGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLBShoppingCarGoodsInfoModel":@"goodsAttribute"};
}

@end



@implementation GLBShoppingCarFreightModel

@end


#pragma mark - 购物车中的商品特定属性
@implementation GLBShoppingCarGoodsInfoModel

@end
