//
//  DCWifiTool.m
//  DCProject
//
//  Created by bigbing on 2019/7/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCWifiTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation DCWifiTool

+ (DCWifiTool *)shareClient {
    static DCWifiTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


#pragma mark - 获取链接的Wi-Fi信息
- (NSDictionary *)dc_wifiInfomation {
    //    @{
    //        BSSID = "a4:2b:8c:c:7f:bd";
    //        SSID = bdmy06;
    //        SSIDDATA = <73756e65 65653036>;
    //    }
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    return info;
}


#pragma mark - 获取链接的wifi名称
- (NSString *)dc_connectWifiName{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}


#pragma mark - 获取链接的wifi地址
- (NSString *)dc_connectWifiAddress{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    if ([info isKindOfClass:[NSDictionary class]]) {
        //获取BSSID
        return [info objectForKey:@"BSSID"];
    }
    return nil;
}


#pragma mark - 获取链接wifi的数据
- (NSString *)dc_connectWifiData{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    if ([info isKindOfClass:[NSDictionary class]]) {
        //获取SSIDDATA
        return [info objectForKey:@"SSIDDATA"];
    }
    return nil;
}

@end
