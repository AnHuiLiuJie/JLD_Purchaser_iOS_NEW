//
//  GLPSpikeHomeListVC.h
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "DCBasicViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPSpikeHomeListVC : DCBasicViewController

@property (nonatomic, assign) NSInteger goodsType;//类型：1-进行中秒杀，2-未开始秒杀

@property (nonatomic, copy) void(^GLPSpikeHomeListVC_switchBlock)(int goodsType);

@end

NS_ASSUME_NONNULL_END
