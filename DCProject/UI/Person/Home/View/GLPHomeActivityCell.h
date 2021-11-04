//
//  GLPHomeActivityCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HomeActivityBlock)(GLPHomeDataListModel*listmodel);
@interface GLPHomeActivityCell : UITableViewCell

@property (nonatomic, strong) GLPHomeDataModel *activityModel;
@property(nonatomic,copy)HomeActivityBlock activityblock;
@end

NS_ASSUME_NONNULL_END
