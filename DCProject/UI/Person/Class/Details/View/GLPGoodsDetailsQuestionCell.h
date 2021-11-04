//
//  GLPGoodsDetailsQuestionCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsQusetionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsQuestionCell : UITableViewCell


@property (nonatomic, strong) NSMutableArray<GLPGoodsQusetionModel *> *questionArray;

@property (nonatomic, copy) dispatch_block_t questionCellBlock;

@end

NS_ASSUME_NONNULL_END
