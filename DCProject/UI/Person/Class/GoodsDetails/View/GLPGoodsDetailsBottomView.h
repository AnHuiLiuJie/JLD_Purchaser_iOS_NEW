//
//  GLPGoodsDetailsBottomView.h
//  DCProject
//
//  Created by bigbing on 2019/8/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

static CGFloat GoodsDetailsBottomView_HEIGHT = 56;//详情页底部工具条高度


@interface GLPGoodsDetailsBottomView : UIView

@property (nonatomic, copy) void(^GLPNewGoodsDetailsBottomView_block)(NSInteger tag);

@property(nonatomic,strong) GLPGoodsDetailModel *detailModel;
// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;
@property (nonatomic, strong) UILabel *numb;

- (void)reshnum;

@end

NS_ASSUME_NONNULL_END
