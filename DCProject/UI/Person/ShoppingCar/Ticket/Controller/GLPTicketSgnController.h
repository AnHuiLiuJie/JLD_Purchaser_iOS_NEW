//
//  GLPTicketSgnController.h
//  DCProject
//
//  Created by bigbing on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPTicketSgnController : DCBasicViewController

// 商品id
@property (nonatomic, copy) NSString *goodsId;

// 店铺id
@property (nonatomic, copy) NSString *storeId;

// 消失
@property (nonatomic, copy) dispatch_block_t dissmissBlock;

@end

NS_ASSUME_NONNULL_END
