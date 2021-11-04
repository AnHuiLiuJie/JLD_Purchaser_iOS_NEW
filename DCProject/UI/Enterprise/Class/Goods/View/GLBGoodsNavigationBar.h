//
//  GLBGoodsNavigationBar.h
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsNavigationBar : UIView

// 搜索框
@property (nonatomic, strong) DCTextField *searchTF;


@property (nonatomic, copy) dispatch_block_t backBtnBlock;


@property (nonatomic, copy) dispatch_block_t searchTFBlock;

@end

NS_ASSUME_NONNULL_END
