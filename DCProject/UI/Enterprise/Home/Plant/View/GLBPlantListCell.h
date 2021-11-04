//
//  GLBPlantListCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBPlantPeopleModel.h"
#import "GLBPlantDrugModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBPlantListCell : UITableViewCell

// 种植户
@property (nonatomic, strong) GLBPlantPeopleModel *peopleModel;


// 原药品种植
@property (nonatomic, strong) GLBPlantDrugModel *drugModel;

@end

NS_ASSUME_NONNULL_END
