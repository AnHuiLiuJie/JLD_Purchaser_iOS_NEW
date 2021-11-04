//
//  GLBOtherFiltrateHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBOtherFiltrateHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *openBtn;

@property (nonatomic, copy) dispatch_block_t openBtnBlock;

@end

NS_ASSUME_NONNULL_END
