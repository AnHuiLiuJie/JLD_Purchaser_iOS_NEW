//
//  GLBExhibitModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBExhibitModel.h"

@implementation GLBExhibitModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"infoList":@"GLBExhibitInfoModel"};
}

@end



@implementation GLBExhibitInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"expoFirmList":@"GLBExhibitCompanyModel",
             @"goodsList":@"GLBExhibitGoodsModel"};
}

@end



@implementation GLBExhibitCompanyModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":@"GLBExhibitGoodsModel"};
}

@end


@implementation GLBExhibitGoodsModel


@end
