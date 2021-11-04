//
//  GLBCareModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCareModel.h"

@implementation GLBCareModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods":@"GLBCareGoodsModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLBCareInfoModel":@"statistics"};
}

@end


@implementation GLBCareGoodsModel

@end


@implementation GLBCareInfoModel

@end
