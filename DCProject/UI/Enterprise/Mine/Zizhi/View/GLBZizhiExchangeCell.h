//
//  GLBZizhiExchangeCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBQualificateModel.h"

typedef void(^GLBZizhiChangeBlock)(GLBQualificateListModel *_Nullable listModel);

NS_ASSUME_NONNULL_BEGIN

@interface GLBZizhiExchangeCell : UITableViewCell

// 模型
@property (nonatomic, strong) GLBQualificateListModel *listModel;


// 变更
@property (nonatomic, copy) GLBZizhiChangeBlock changeBlock;

@end

NS_ASSUME_NONNULL_END
