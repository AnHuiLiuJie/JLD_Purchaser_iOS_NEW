//
//  GLPGoodsLickModel.m
//  DCProject
//
//  Created by bigbing on 2019/9/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsLickModel.h"

@implementation GLPGoodsLickModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":@"GLPGoodsLickGoodsModel",
             @"facets":@"GLPGoodsLickFacetsModel"};
}

@end




@implementation GLPGoodsLickFacetsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLPGoodsLickFacetsModel":@"valueList"};
}

@end




@implementation GLPGoodsLickGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"iD":@"id"};
}

@end
