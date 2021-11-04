//
//  GLBRepayTimeView.h
//  DCProject
//
//  Created by bigbing on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

typedef void(^GLBRepayTimeSuccessBlock)(NSInteger day);

NS_ASSUME_NONNULL_BEGIN

@interface GLBRepayTimeView : UIView

@property (nonatomic, strong) DCTextField *textField;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, copy) GLBRepayTimeSuccessBlock successBlock;

@end

NS_ASSUME_NONNULL_END
