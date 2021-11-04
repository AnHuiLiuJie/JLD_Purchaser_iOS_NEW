//
//  GLPShoppingCarModel.m
//  DCProject
//
//  Created by bigbing on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPShoppingCarModel.h"

@implementation GLPShoppingCarModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"validActInfoList":@"GLPShoppingCarActivityModel",
             @"validNoActGoodsList":@"GLPShoppingCarNoActivityModel"};
}

@end


#pragma mark - 活动商品列表
@implementation GLPShoppingCarActivityModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"actCartGoodsList":@"GLPShoppingCarActivityGoodsModel"};
}

@end



#pragma mark - 非活动商品列表
@implementation GLPShoppingCarNoActivityModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderCartList":@"GLPShoppingCarGoodsModel"};
}

@end


#pragma mark - 活动商品列表
@implementation GLPShoppingCarActivityGoodsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderCartList":@"GLPShoppingCarGoodsModel"};
}

@end


#pragma mark - 商品详情
@implementation GLPShoppingCarGoodsModel


@end
