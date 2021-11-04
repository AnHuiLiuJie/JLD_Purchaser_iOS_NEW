//
//  GLBStoreListModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreListModel.h"

@implementation GLBStoreListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLBStoreListInfoModel":@"statistics"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodslist":@"GLBStoreListGoodsModel"};
}

@end



@implementation GLBStoreListGoodsModel

@end



@implementation GLBStoreListInfoModel

@end
