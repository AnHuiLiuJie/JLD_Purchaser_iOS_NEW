//
//  GLPActivityAreaCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/11.
//

#import <UIKit/UIKit.h>
#import "GLPActivityAreaListCell.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat AreaListCell_H = 120;
static CGFloat AreaListHeader_H = 130;

@interface GLPActivityAreaCell : UITableViewCell


@property (nonatomic, strong) ActivityAreaModel *model;

@property (nonatomic, copy) void(^GLPActivityAreaCell_block)(NSString *goodsId);


@end

NS_ASSUME_NONNULL_END
