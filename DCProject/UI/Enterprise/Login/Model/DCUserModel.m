//
//  DCUserModel.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCUserModel.h"

@implementation DCUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:_code forKey:@"code"];
    [aCoder encodeObject:_msg forKey:@"msg"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        _code = [aDecoder decodeIntegerForKey:@"code"];
        _msg = [aDecoder decodeObjectForKey:@"msg"];
    }
    return self;
}

@end
