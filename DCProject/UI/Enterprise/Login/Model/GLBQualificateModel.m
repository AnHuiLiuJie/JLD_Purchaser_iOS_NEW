//
//  GLBQualificateModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBQualificateModel.h"

@implementation GLBQualificateModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"qcList":@"GLBQualificateListModel"};
}

@end



@implementation GLBQualificateListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _imgUrlArray = [NSMutableArray array];
    }
    return self;
}

@end
