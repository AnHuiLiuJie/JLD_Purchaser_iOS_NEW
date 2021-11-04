//
//  GLBGoodsDetailModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsDetailModel.h"

@implementation GLBGoodsDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderList":@"GLBRecordModel",
             @"recommendGoods":@"GLBGoodsDetailGoodsModel",
             @"similarGoods":@"GLBGoodsDetailGoodsModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLBGoodsDetailStoreModel":@"storeInfo"};
}

@end




@implementation GLBGoodsDetailGoodsModel


@end



@implementation GLBGoodsDetailStoreModel


@end
