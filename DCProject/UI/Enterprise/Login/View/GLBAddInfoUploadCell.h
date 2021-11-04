//
//  GLBAddInfoUploadCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBQualificateModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBImageDeleteBlock)(NSMutableArray *newArray);

@interface GLBAddInfoUploadCell : UITableViewCell

// 模型
@property (nonatomic, strong) GLBQualificateListModel *listModel;

// 点击上传
@property (nonatomic, copy) dispatch_block_t uploadBlock;

// 点击删除
@property (nonatomic, copy) GLBImageDeleteBlock deleteBlock;

@end

NS_ASSUME_NONNULL_END
