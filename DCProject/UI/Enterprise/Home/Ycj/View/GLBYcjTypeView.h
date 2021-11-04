//
//  GLBYcjTypeView.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBYcjModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBYcjTypeView : UIView


@property (nonatomic, strong) UILabel *titleLabel;

// 
@property (nonatomic, strong) NSArray<GLBYcjRolesModel *> *rolesArray;


@end

NS_ASSUME_NONNULL_END
