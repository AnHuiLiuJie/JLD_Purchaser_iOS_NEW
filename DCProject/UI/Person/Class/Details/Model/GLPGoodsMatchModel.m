//
//  GLPGoodsMatchModel.m
//  DCProject
//
//  Created by bigbing on 2019/9/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsMatchModel.h"

@implementation GLPGoodsMatchModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"prodList":@"GLPGoodsMatchProductModel",
             @"goodsList":@"GLPGoodsMatchGoodsModel"};
}

@end




@implementation GLPGoodsMatchGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"iD":@"id"};
}

@end




@implementation GLPGoodsMatchProductModel

@end
