//
//  GLBTypeGoodsSearchBar.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBTypeGoodsSearchBar : UIView


@property (nonatomic, strong) DCTextField *searchTF;


@property (nonatomic, copy) dispatch_block_t searchTFBlock;


@end

NS_ASSUME_NONNULL_END
