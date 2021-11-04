//
//  GLBStoreDetailHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreDetailHeadView : UIView


@property (nonatomic, strong) UIButton *careBtn;


@property (nonatomic, strong) GLBStoreModel *storeModel;


@property (nonatomic, copy) dispatch_block_t careBtnBlock;

@end

NS_ASSUME_NONNULL_END
