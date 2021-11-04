//
//  GLBSearchPageNaVBar.h
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBSearchPageNaVBar : UIView

@property (nonatomic, strong) DCTextField *textField;


@property (nonatomic, copy) dispatch_block_t cancelBtnClick;

@end

NS_ASSUME_NONNULL_END
