//
//  TRRequestGoodsModel.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRRequestGoodsModel.h"

@implementation TRRequestGoodsModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
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
