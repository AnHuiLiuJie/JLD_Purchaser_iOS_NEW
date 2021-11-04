//
//  GLBPlantListController.h
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"

typedef NS_ENUM(NSInteger ,GLBPlantType){
    GLBPlantTypeZzh = 0,
    GLBPlantTypeZzyp,
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBPlantListController : DCTabViewController

// 搜索字段
@property (nonatomic, copy) NSString *searchText;

// 类型
@property (nonatomic, assign) GLBPlantType plantType;

@end

NS_ASSUME_NONNULL_END
