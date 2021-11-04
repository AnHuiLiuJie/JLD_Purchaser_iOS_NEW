//
//  DH_EncryptAndDecrypt.h
//  zhinengyibiao
//
//  Created by 刘健 on 2017/12/29.
//  Copyright © 2017年 杜欢. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface DH_EncryptAndDecrypt : NSObject

#pragma mark - 加密
+(NSString *)encryptWithContent:(NSString *)content key:(NSString *)aKey;
#pragma mark - 解密
+(NSString *)decryptWithContent:(NSString *)content key:(NSString *)aKey;

@end
NS_ASSUME_NONNULL_END
