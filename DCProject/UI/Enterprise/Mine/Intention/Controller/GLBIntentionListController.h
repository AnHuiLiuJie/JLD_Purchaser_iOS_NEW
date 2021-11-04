//
//  GLBIntentionListController.h
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"

typedef NS_ENUM(NSInteger ,GLBIntenTionType) {
    GLBIntenTionTypeAll = 0,       // 全部
    GLBIntenTionTypeWait,          // 待确认
    GLBIntenTionTypeConfirm,       // 已确认
    GLBIntenTionTypeUnpass,        // 未通过
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBIntentionListController : DCTabViewController


@property (nonatomic, assign) GLBIntenTionType intentionType;


@end

NS_ASSUME_NONNULL_END
