//
//  GLBRepayRecordModel.m
//  DCProject
//
//  Created by bigbing on 2019/8/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayRecordModel.h"

@implementation GLBRepayRecordModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"payments":@"GLBRepayRecordPaymentsModel"};
}

@end



#pragma mark - 还款记录
@implementation GLBRepayRecordPaymentsModel

@end
