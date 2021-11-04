//
//  GLPHomeDataModel.m
//  DCProject
//
//  Created by bigbing on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeDataModel.h"

@implementation GLPHomeNewDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"floorData":@"GLPHomeDataModel"};
}
//lj_change_未知效果
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"GLPHomeDataModel":@"midAd",
//             @"GLPHomeDataModel":@"season",
//             @"GLPHomeDataModel":@"hotSales",
//             @"GLPHomeDataModel":@"hotRec"};
//}

@end

@implementation GLPHomeDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dataList":@"GLPHomeDataListModel"};
}

@end



#pragma mark -
@implementation GLPHomeDataListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"GLPHomeDataActivityModel":@"actVo",
             @"GLPHomeDataGoodsModel":@"goodsVo",
             @"GLPHomeDataGroupModel":@"groupVo"};
}

@end


#pragma mark - 活动信息
@implementation GLPHomeDataActivityModel

@end



#pragma mark - 商品信息
@implementation GLPHomeDataGoodsModel

@end


#pragma mark - 团购信息
@implementation GLPHomeDataGroupModel

@end


