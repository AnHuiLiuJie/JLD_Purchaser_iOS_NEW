//
//  ActivitySharingModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/23.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivitySharingModel : DCBaseModel

@property (nonatomic, copy) NSString *background;//背景图片
@property (nonatomic, copy) NSString *uri;//地址
@property (nonatomic, copy) NSString *qrimg;//二维码图片
@property (nonatomic, copy) NSString *loginName;//登录名
@property (nonatomic, copy) NSString *userImg;//用户图像


@property (nonatomic, copy) NSString *price;//商品价格
@property (nonatomic, copy) NSString *goodsImg;//二维码图片
@property (nonatomic, copy) NSString *goodsName;//商品名


//@property (nonatomic, copy) NSArray *elements;//页面元素


@end



#pragma mark - 元素
@interface ActivityElementsModel : DCBaseModel

@property (nonatomic, copy) NSString *color;//元素颜色
@property (nonatomic, copy) NSString *content;//元素内容
@property (nonatomic, copy) NSString *elementType;//元素类型：1-文字，2-图片
@property (nonatomic, copy) NSString *fontSize;//文字大小
@property (nonatomic, copy) NSString *siteX;//元素位置X坐标
@property (nonatomic, copy) NSString *siteY;//元素位置Y坐标

@end

NS_ASSUME_NONNULL_END
