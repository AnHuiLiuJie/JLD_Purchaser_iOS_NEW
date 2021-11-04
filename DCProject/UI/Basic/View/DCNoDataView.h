//
//  DCNoDataView.h
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCNoDataView : UIView

// init
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image button:(NSString *__nullable)button tip:(NSString *)tip;

// 点击回调
@property (nonatomic , copy) dispatch_block_t noDataBlock;

@end

NS_ASSUME_NONNULL_END
