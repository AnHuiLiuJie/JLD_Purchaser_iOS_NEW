//
//  GLPOldGoodsDetailsSpecificationsView.h
//  DCProject
//
//  Created by Apple on 2021/3/19.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailsSpecModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLPOldGoodsDetailsSpecificationsViewBlock)(GLPGoodsDetailsSpecModel *specModel,NSInteger payCount,NSInteger defineType);

@interface GLPOldGoodsDetailsSpecificationsView : UIView

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UIImageView *goodIcon;
@property (nonatomic,strong) UILabel *goodName;
@property (nonatomic,strong) UILabel *goodPrice;
@property (nonatomic,strong) UILabel *goodPriceOld;
@property (nonatomic,strong) UILabel *goodNum;
@property (nonatomic,strong) UILabel *goodTime;

@property (nonatomic,strong) UILabel *payCountLB;

@property (nonatomic,assign) NSInteger payCount;
@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) NSArray *specModels;
@property (nonatomic,strong) GLPGoodsDetailsSpecModel *specModel;
@property (nonatomic,assign) NSInteger specIdx;//选中第几个规格的

@property (nonatomic,copy) GLPOldGoodsDetailsSpecificationsViewBlock goodsDetailsSpecificationsView_Block;
@property (nonatomic, strong) UILabel *sendTimeLabel;
@property (nonatomic, copy) dispatch_block_t GLPOldGoodsDetailsSpecificationsView_block;

//0 规格 1购物车 2购买
- (void)showType:(NSInteger)showType buyCount:(NSInteger)buyCount;

@end

NS_ASSUME_NONNULL_END
