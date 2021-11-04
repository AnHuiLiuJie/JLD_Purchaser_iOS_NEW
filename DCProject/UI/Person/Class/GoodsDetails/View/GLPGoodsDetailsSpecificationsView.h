//
//  GLPGoodsDetailsSpecificationsView.h
//  DCProject
//
//  Created by LiuMac on 2021/9/23.
//

#import <UIKit/UIKit.h>

#import "GLPGoodsDetailsSpecModel.h"
#import "GLPEditCountView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsDetailsSpecificationsView : UIView

@property (nonatomic,strong) UIScrollView *ggScrollView;//规格
@property (nonatomic,strong) UIScrollView *lcScrollView;//疗程

@property (nonatomic,strong) UIImageView *goodIcon;
@property (nonatomic,strong) UILabel *goodName;
@property (nonatomic,strong) UILabel *goodPrice;
@property (nonatomic,strong) UILabel *goodOldPrice;
@property (nonatomic,strong) UILabel *goodNum;

@property (nonatomic,strong) UILabel *goodTime;

//@property (nonatomic,strong) UILabel *payCountLB;
@property (nonatomic,strong) GLPEditCountView *countView;

@property (nonatomic,assign) NSInteger payCount;
@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,strong) NSArray *specList;
@property (nonatomic,strong) GLPGoodsDetailsSpecModel *specModel;
@property (nonatomic,assign) NSInteger specIdx;//选中第几个规格的
@property (nonatomic,assign) NSInteger liaoIdx;//选中第几个疗程

@property (nonatomic,copy)  void(^goodsDetailsSpecificationsView_Block)(GLPGoodsDetailsSpecModel *specModel,NSInteger payCount,NSInteger defineType) ;
@property (nonatomic, strong) UILabel *sendTimeLabel;
@property (nonatomic, copy) dispatch_block_t GLPGoodsDetailsSpecificationsView_block;//到货通知

//0 规格 1购物车 2购买
- (void)showType:(NSInteger)showType buyCount:(NSInteger)buyCount;

@end

NS_ASSUME_NONNULL_END
