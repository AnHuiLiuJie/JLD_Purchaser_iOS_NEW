//
//  GLBAdvModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAdvModel.h"

@implementation GLBAdvModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_adTitle forKey:@"adTitle"];
    [aCoder encodeObject:_adLinkUrl forKey:@"adLinkUrl"];
    [aCoder encodeObject:_adContent forKey:@"adContent"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        _adTitle = [aDecoder decodeObjectForKey:@"adTitle"];
        _adLinkUrl = [aDecoder decodeObjectForKey:@"adLinkUrl"];
        _adContent = [aDecoder decodeObjectForKey:@"adContent"];
    }
    return self;
}


@end
