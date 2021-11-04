//
//  GLPVerifyPayPwdModel.h
//  DCProject
//
//  Created by LiuMac on 2021/8/18.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPVerifyPayPwdModel : DCBaseModel

@property (nonatomic, copy) NSString *errorCount;//错误次数
@property (nonatomic, copy) NSString *errorTime;//最后一次错误时间
@property (nonatomic, copy) NSString *isRight;//密码是否正确：0-错误，1-正确
@property (nonatomic, copy) NSString *ts;//提示信息
@property (nonatomic, copy) NSString *limitErrorCount;//限制错误次数



@end

NS_ASSUME_NONNULL_END
