//
//  GLBOrderPageController.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "WMPageController.h"

typedef void(^DCOrderSuccessBlock)(DCChatGoodsModel *_Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface GLBOrderPageController : WMPageController

@property (nonatomic, assign) int index;


@property (nonatomic, copy) NSString *sellerFirmName; //


@property (nonatomic, copy) DCOrderSuccessBlock successBlock;

@end

NS_ASSUME_NONNULL_END
