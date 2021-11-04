//
//  GLBStoreNavigationBar.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBStoreNavBarBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreNavigationBar : UIView


@property (nonatomic, copy) GLBStoreNavBarBlock successBlock;

// 数量
@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
