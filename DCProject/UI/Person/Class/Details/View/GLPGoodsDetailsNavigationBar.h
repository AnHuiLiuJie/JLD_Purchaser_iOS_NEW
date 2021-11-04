//
//  GLPGoodsDetailsNavigationBar.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLPGoodsDetailNavBarBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsNavigationBar : UIView

@property (nonatomic, assign) BOOL isTop;

// 当前选中的按钮
@property (nonatomic, assign) NSInteger currentIndex;

// 未读消息数量
@property (nonatomic, assign) NSInteger count;
// 点击
@property (nonatomic, copy) GLPGoodsDetailNavBarBlock navbarBlock;

@end

NS_ASSUME_NONNULL_END
