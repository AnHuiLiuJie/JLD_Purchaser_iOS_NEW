//
//  GLBHomeCompanyCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBCompanyModel.h"

typedef void(^GLBHomeCompanyCellBlock)(GLBCompanyModel *_Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface GLBHomeCompanyCell : UITableViewCell


// 模型
@property (nonatomic, strong) NSMutableArray<GLBCompanyModel *> *companyArray;


// 点击item回调
@property (nonatomic, copy) GLBHomeCompanyCellBlock companyItemBlock;

@end

NS_ASSUME_NONNULL_END
