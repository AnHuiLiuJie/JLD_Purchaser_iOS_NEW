//
//  GLBAreaModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/6.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBProvinceModel.h"

@implementation GLBProvinceModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"son":@"GLBCityModel"};
}

@end


@implementation GLBCityModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"son":@"GLBAreaModel"};
}

@end


@implementation GLBAreaModel



@end
