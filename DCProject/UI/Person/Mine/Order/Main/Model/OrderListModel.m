//
//  OrderListModel.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

// 重写setValue:forUndefinedKey:方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end




#pragma mark **************************************** ReturnOrderListModel ****************************

@implementation ReturnOrderListModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

// 重写setValue:forUndefinedKey:方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end


#pragma mark **************************************** OredrGoodsModel ****************************
@implementation OredrGoodsModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

// 重写setValue:forUndefinedKey:方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
