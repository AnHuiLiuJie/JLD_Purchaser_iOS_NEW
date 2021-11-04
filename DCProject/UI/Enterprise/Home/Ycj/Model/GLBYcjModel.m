//
//  GLBYcjModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBYcjModel.h"

@implementation GLBYcjModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods":@"GLBYcjGoodsModel"};
}

@end




@implementation GLBYcjGoodsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"roles":@"GLBYcjRolesModel"};
}

@end




@implementation GLBYcjRolesModel



@end
