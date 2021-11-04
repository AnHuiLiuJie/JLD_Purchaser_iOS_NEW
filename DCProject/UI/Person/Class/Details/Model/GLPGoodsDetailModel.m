//
//  GLPGoodsDetailModel.m
//  DCProject
//
//  Created by bigbing on 2019/9/11.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailModel.h"

@implementation GLPGoodsDetailModel : NSObject 

//lj_change_未知效果
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"GLPGoodsDetailActivityModel":@"actBean",
//             @"GLPGoodsDetailTicketModel":@"storeCouponsBean",
//             @"GLPGoodsDetailTicketModel":@"bossCouponsBean",
//             @"GLPGoodsDetailTicketModel":@"goodsCouponsBean",
//             @"GLPGoodsDetailGroupModel":@"groupBean",
//             @"GLPGoodsDetailServerModel":@"serverBean",
//             @"GLPGoodsDetailSpecModel":@"specBean",
//             @"GLPGoodsDetailShopModel":@"shopBean"
//             };
//}

@end


#pragma mark - 活动信息
@implementation GLPGoodsDetailActivityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"iD":@"id"};
}

@end



#pragma mark - 券信息
@implementation GLPGoodsDetailTicketModel

@end



#pragma mark - 团购信息
@implementation GLPGoodsDetailGroupModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"iD":@"id"};
}

@end



#pragma mark - 商品服务信息
@implementation GLPGoodsDetailServerModel

@end



#pragma mark - 商品规格信息
@implementation GLPGoodsDetailSpecModel

@end



#pragma mark - 店铺信息
@implementation GLPGoodsDetailShopModel

@end
