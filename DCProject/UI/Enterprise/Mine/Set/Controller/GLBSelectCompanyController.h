//
//  GLBSelectCompanyController.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"
#import "GLBCompanyTypeModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBSelectCompanyTypeBlock)(GLBCompanyTypeModel *type,GLBCompanyTypeModel *subType);


@interface GLBSelectCompanyController : DCBasicViewController

+ (GLBSelectCompanyController *)shareInstance;


- (void)dc_getAllCompanyType;


@property (nonatomic, copy) GLBSelectCompanyTypeBlock typeBlock;


@end

NS_ASSUME_NONNULL_END
