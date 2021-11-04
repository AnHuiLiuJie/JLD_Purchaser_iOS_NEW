//
//  GLPHomeNavigationBar.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLPHomeNavBarBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLPHomeNavigationBar : UIView


// 是否被推倒顶部
@property (nonatomic, assign) BOOL isTop;


// 未读消息数量
@property (nonatomic, assign) NSInteger count;


// 导航了跳转
@property (nonatomic, copy) GLPHomeNavBarBlock navBarBlock;


- (void)wr_setBackgroundAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
