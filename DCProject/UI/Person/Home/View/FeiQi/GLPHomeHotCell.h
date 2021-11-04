//
//  GLPHomeHotCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^GLPHomeHotCellBlock)(GLPHomeDataListModel *listModel);
typedef void(^GLPHomeHotSeeBlock)(void);
@interface GLPHomeHotCell : UITableViewCell

// 热销
@property (nonatomic, strong) GLPHomeDataModel *hotModel;

@property (nonatomic, copy) GLPHomeHotCellBlock hotgoodsBlock;
@property (nonatomic, copy) GLPHomeHotSeeBlock hotseeBlock;
@end



@interface GLPHomeHotGoodsView : UIView

// 商品
@property (nonatomic, strong) GLPHomeDataListModel *listModel;

@end

NS_ASSUME_NONNULL_END
