//
//  GLBHomeNavigationBar.h
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBHomeNavBarBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBHomeNavigationBar : UIView


// 是否被推倒顶部
@property (nonatomic, assign) BOOL isTop;


@property (nonatomic, assign) NSInteger count;


// 导航了跳转
@property (nonatomic, copy) GLBHomeNavBarBlock navBarBlock;

@end

NS_ASSUME_NONNULL_END
