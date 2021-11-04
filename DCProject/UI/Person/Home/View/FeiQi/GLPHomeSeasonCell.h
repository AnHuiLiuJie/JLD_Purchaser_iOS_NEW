//
//  GLPHomeSeasonCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLPSeasonCellBlock)(GLPHomeDataListModel *listModel);
typedef void(^GLPSeasonMoreBlock)(void);

@interface GLPHomeSeasonCell : UITableViewCell

// 季节
@property (nonatomic, strong) GLPHomeDataModel *seasonModel;


@property (nonatomic, copy) GLPSeasonCellBlock goodsItemBlock;

@property (nonatomic, copy) GLPSeasonMoreBlock moreBlock;

@end



@interface GLPHomeSeasonGoodsView : UIView

// 商品
@property (nonatomic, strong) GLPHomeDataListModel *listModel;

@end

NS_ASSUME_NONNULL_END
