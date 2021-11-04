//
//  GLPHomeSpikeCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPHomeSpikeCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t GLPHomeSpikeCell_moreBlock;

@property (nonatomic, strong) NSArray<DCSeckillListModel *> *spikeList;
@property (nonatomic, copy) void(^GLPHomeSpikeCell_clickGoodsBlock)(DCSeckillListModel *model);
@end


#pragma mark  itme subView
@interface GLPHomeSpikeGoodsView : UIView

// 商品
@property (nonatomic, strong) DCSeckillListModel *listModel;

@end
NS_ASSUME_NONNULL_END
