//
//  ChoseModel.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "ChoseModel.h"

@implementation ChoseModel
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
