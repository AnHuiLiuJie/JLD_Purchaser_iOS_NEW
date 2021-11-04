//
//  DCWifiTool.h
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCWifiTool : NSObject

+ (DCWifiTool *)shareClient;

#pragma mark - iOS12需要额外在证书里配置信息

#pragma mark - 获取链接的Wi-Fi信息
- (NSDictionary *)dc_wifiInfomation;

#pragma mark - 获取链接的wifi名称
- (NSString *)dc_connectWifiName;

#pragma mark - 获取链接的wifi地址
- (NSString *)dc_connectWifiAddress;

#pragma mark - 获取链接wifi的数据
- (NSString *)dc_connectWifiData;

@end

NS_ASSUME_NONNULL_END
