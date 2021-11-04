//
//  DCPayTool.h
//  DCProject
//
//  Created by bigbing on 2019/5/9.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCPayTool : NSObject

+ (DCPayTool *) shareTool;

// 调起支付宝支付
- (void)dc_alipay:(NSString *)orderStr;

// 调起微信支付
- (void)dc_wxpay:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
