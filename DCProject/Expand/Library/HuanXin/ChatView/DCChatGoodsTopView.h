//
//  DCChatGoodsTopView.h
//  DCProject
//
//  Created by bigbing on 2019/12/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCChatGoodsTopView : UIView

@property (nonatomic, strong) DCChatGoodsModel *goodsModel;

@property (nonatomic, copy) dispatch_block_t sendBtnBlock;
@property (nonatomic, copy) dispatch_block_t cancelBtnBlock;

@end

NS_ASSUME_NONNULL_END
