//
//  GLBStoreItemView.h
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBStoreItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *normalImage;
@property (nonatomic, strong) UIImageView *selectedImage;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
