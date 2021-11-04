//
//  GLPTicketSgnModel.m
//  DCProject
//
//  Created by bigbing on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPTicketSgnModel.h"

@implementation GLPTicketSgnModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"coupGoodsvo":@"GLPTicketSgnTicketModel",
             @"coupfirmvo":@"GLPTicketSgnTicketModel"
             };
}

@end



@implementation GLPTicketSgnTicketModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":@"GLPTicketSgnGoodsModel"};
}

@end



@implementation GLPTicketSgnGoodsModel

@end
