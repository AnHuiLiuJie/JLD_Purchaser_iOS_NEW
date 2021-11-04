//
//  GLBStoreModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreModel.h"


@implementation GLBStoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLBStoreInfoModel":@"storeInfoVO",
             @"GLBStoreOtherModel":@"storeQualDeliVO"};
}

@end



@implementation GLBStoreInfoModel

@end


@implementation GLBStoreOtherModel

@end

#pragma mark - 暂时弃用
//@implementation GLBStoreModel
//
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"iD":@"id"};
//}
//
//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"goodslist":@"GLBStoreGoodsModel"};
//}
//
//@end
//
//
//
//@implementation GLBStoreGoodsModel
//
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"iD":@"id"};
//}
//
//@end
