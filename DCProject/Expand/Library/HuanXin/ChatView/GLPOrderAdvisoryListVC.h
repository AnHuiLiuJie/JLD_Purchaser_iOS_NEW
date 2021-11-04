//
//  GLPOrderAdvisoryListVC.h
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,OrderAdvisoryListType) {
    OrderAdvisoryListTypeOrder = 1,       //
    OrderAdvisoryListType1 = 2,           //
    OrderAdvisoryListType2 = 3,          //
    OrderAdvisoryListType3 = 4,
};


@interface GLPOrderAdvisoryListVC : DCBasicViewController

@property (nonatomic, copy) NSString *sellerFirmName; // 店铺名称

/** 点击已选回调 */
@property (nonatomic , copy) void(^GLPOrderAdvisoryListVCBlock)(NSDictionary *commodityInfo);

@property (nonatomic, assign) OrderAdvisoryListType customerType;
@property (nonatomic, assign) CGRect viewFrame;

@end

NS_ASSUME_NONNULL_END
