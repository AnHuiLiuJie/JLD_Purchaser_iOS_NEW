//
//  GLPConfirmOrderBottomView.h
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import <UIKit/UIKit.h>
#import "GLPNewShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPConfirmOrderBottomView : UIView

@property (nonatomic, strong) GLPNewShoppingCarModel *model;

@property (nonatomic, copy) dispatch_block_t GLPConfirmOrderBottomView_block;

@end

NS_ASSUME_NONNULL_END
