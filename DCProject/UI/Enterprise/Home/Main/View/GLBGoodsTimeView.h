//
//  GLBGoodsTimeView.h
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBPromoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsTimeView : UIView

@property (nonatomic, strong) GLBPromoteModel *goodsModel;

@property (nonatomic, strong) UILabel *spacingLabel;
@property (nonatomic, strong) UILabel *spacingLabel1;
@property (nonatomic, strong) UILabel *spacingLabel2;
@property (nonatomic, strong) UILabel *spacingLabel3;

@end

NS_ASSUME_NONNULL_END
