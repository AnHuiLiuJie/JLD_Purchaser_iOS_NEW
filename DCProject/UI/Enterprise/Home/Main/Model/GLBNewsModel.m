//
//  GLBNewsModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBNewsModel.h"

@implementation GLBNewsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"iD":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"catId":@"GLBNewsCatIdModel"};
}

@end



@implementation GLBNewsCatIdModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"valuessssss":@"value"};
}

@end
