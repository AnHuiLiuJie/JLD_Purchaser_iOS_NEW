//
//  GLPGoodsDetailsEvaluateCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsEvaluateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsEvaluateCell : UITableViewCell

@property (nonatomic, strong) GLPGoodsEvaluateListModel *listModel;

@end


#pragma mark - 评价的星级
@interface GLPGoodsDetailsEvaluateGradeView : UIView

@property (nonatomic, assign) NSInteger grade;

@end

NS_ASSUME_NONNULL_END
