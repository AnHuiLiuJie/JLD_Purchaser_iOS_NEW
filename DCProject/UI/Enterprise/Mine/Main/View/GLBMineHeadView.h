//
//  GLBMineHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLBMineHeadViewBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface GLBMineHeadView : UIView


// 数量显示
@property (nonatomic, strong) NSDictionary *countDic;

// 企业信息
@property (nonatomic, strong) NSDictionary *infoDict;


@property (nonatomic, assign) NSInteger count;

// 点击回调
@property (nonatomic, copy) GLBMineHeadViewBlock buttonClickBlock;


@end

NS_ASSUME_NONNULL_END
