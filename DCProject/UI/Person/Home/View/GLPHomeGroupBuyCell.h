//
//  GLPHomeGroupBuyCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPHomeGroupBuyCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t GLPHomeGroupBuyCell_moreBlock;

@property (nonatomic, strong) NSArray<DCCollageListModel *> *collageList;
@property (nonatomic, copy) void(^GLPHomeGroupBuyCell_clickGoodsBlock)(DCCollageListModel *model);

@end

#pragma mark  itme subView
@interface GLPHomeGroupBuyGoodsView : UIView

// 商品
@property (nonatomic, strong) DCCollageListModel *listModel;

@end

NS_ASSUME_NONNULL_END
