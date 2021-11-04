//
//  GLPHomeRecommendCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HomeRecommBlock)(GLPHomeDataListModel *recommendModel);
@interface GLPHomeRecommendCell : UITableViewCell

// 热点推荐
@property (nonatomic, strong) GLPHomeDataModel *recommendModel;

@property(nonatomic,copy) HomeRecommBlock recomblock;

@end

NS_ASSUME_NONNULL_END
