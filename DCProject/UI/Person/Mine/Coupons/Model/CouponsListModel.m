//
//  CouponsListModel.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "CouponsListModel.h"

@implementation CouponsListModel
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
