//
//  GLBStoreGradeView.h
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreGradeView : UIView

/*
 11 - 一星供应商，12 - 二星供应商，13 - 三星供应商，14 - 四星供应商，15 - 五星供应商
 21 - 一钻供应商，22 - 二钻供应商，23 - 三钻供应商，24 - 四钻供应商，25 - 五钻供应商
 31 - 一冠供应商，32 - 二冠供应商，33 - 三冠供应商，34 - 四冠供应商，35 - 五冠供应商
 */
@property (nonatomic, assign) NSInteger grade;

@end

NS_ASSUME_NONNULL_END
