//
//  GLBSearchRecordListController.h
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

typedef NS_ENUM(NSInteger , GLBSearchType){
    GLBSearchTypeGoods = 0,
    GLBSearchTypeStore,
};

NS_ASSUME_NONNULL_BEGIN

@interface GLBSearchRecordListController : DCBasicViewController

@property (nonatomic, assign) GLBSearchType searchType;

@end

NS_ASSUME_NONNULL_END
