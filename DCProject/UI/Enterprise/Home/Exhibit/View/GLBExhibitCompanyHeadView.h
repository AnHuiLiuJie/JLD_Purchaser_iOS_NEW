//
//  GLBExhibitCompanyHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBExhibitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBExhibitCompanyHeadView : UICollectionReusableView

@property (nonatomic, strong) GLBExhibitCompanyModel *companyModel;


@property (nonatomic, copy) dispatch_block_t companyClickBlock;

@end

NS_ASSUME_NONNULL_END
