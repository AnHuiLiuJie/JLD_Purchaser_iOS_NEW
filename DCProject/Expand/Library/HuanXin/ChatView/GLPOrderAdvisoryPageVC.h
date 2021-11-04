//
//  GLPOrderAdvisoryPageVC.h
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPOrderAdvisoryPageVC : WMPageController

@property (nonatomic, assign) int index;

@property (nonatomic, assign) CGRect viewFrame;

/** 点击已选回调 */
@property (nonatomic , copy) void(^GLPOrderAdvisoryPageVCBlock)(NSDictionary *commodityInfo);

@property (nonatomic, copy) NSString *sellerFirmName; // 店铺名称


@end

NS_ASSUME_NONNULL_END
