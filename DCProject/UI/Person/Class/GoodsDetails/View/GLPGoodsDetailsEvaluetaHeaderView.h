//
//  GLPGoodsDetailsEvaluetaHeaderVIew.h
//  DCProject
//
//  Created by bigbing on 2019/8/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsEvaluateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsEvaluetaHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) GLPGoodsEvaluateModel *evaluateModel;


@property (nonatomic, copy) dispatch_block_t allEvaluateBlock;

@end

NS_ASSUME_NONNULL_END
