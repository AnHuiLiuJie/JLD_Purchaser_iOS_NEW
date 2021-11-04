//
//  GLBTCMHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "DCTextField.h"

typedef void(^GLBTCMHeadViewBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBTCMHeadView : UIView


@property (nonatomic, strong) SDCycleScrollView *scrollView;

@property (nonatomic, strong) DCTextField *textField;

// 点击按钮
@property (nonatomic, copy) GLBTCMHeadViewBlock headViewBlock;


@end

NS_ASSUME_NONNULL_END
