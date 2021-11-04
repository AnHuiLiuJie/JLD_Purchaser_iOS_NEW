//
//  GLPMineSeeModel.m
//  DCProject
//
//  Created by bigbing on 2019/9/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMineSeeModel.h"

@implementation GLPMineSeeModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"accessList":@"GLPMineSeeGoodsModel"};
}

@end


@implementation GLPMineSeeGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLPMineSeeTicketModel":@"goodsCouponsBean"};
}

@end


@implementation GLPMineSeeTicketModel

@end
