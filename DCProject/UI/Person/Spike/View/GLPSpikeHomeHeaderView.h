//
//  GLPSpikeHomeHeaderView.h
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN


@class GLPSpikeHomeTimeView;

@interface GLPSpikeHomeHeaderView : UIView


@property (nonatomic, copy) void(^GLPSpikeHomeHeaderView_switchBlock)(int goodsType);
@property (nonatomic, copy) dispatch_block_t GLPSpikeHomeHeaderView_block;


@property (nonatomic, assign) NSInteger goodsType;//类型：1-进行中秒杀，2-未开始秒杀
@property (nonatomic, copy) NSString *timeStr;

@property (nonatomic, strong) GLPSpikeHomeTimeView *timeBgView;


@end


@interface GLPSpikeHomeTimeView : UIView

//- (instancetype)initWithtype:(GLPGoodsDetailType)type;
//字体颜色
@property(strong, nonatomic) UIColor *labelColor;
//框框背景色
@property(strong, nonatomic) UIColor *itemBgColor;

@property (nonatomic, copy) NSString *timeStr;

@property (nonatomic, assign) NSInteger detailType;

@property (nonatomic, copy) dispatch_block_t GLPSpikeHomeTimeView_block;

@end




NS_ASSUME_NONNULL_END
