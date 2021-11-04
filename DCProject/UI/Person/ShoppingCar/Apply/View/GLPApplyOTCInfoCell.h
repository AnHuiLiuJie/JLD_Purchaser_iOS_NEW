//
//  GLPApplyOTCInfoCell.h
//  DCProject
//
//  Created by Apple on 2021/3/25.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPApplyOTCInfoCell : UITableViewCell

@property (nonatomic,strong) UIView *noInfo;

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *descLb;
@property (nonatomic,strong) UILabel *rightLb;
@property (nonatomic,strong) UIImageView *iconR;

@property (nonatomic, strong) MedicalPersListModel *model;

@end

NS_ASSUME_NONNULL_END
