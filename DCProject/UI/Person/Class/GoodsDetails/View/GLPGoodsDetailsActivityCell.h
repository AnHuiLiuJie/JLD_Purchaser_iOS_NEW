//
//  GLPGoodsDetailsActivityCell.h
//  DCProject
//
//  Created by LiuMac on 2021/7/23.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark *******************************   限时优惠 **************************************
@interface GLPGoodsDetailsActivityCell : UITableViewCell

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;

@end

#pragma mark *******************************   拼团活动 **************************************
@interface GLPGoodsDetailsActivityGroupCell : UITableViewCell

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;

@end


#pragma mark *******************************   预售活动 **************************************
@interface GLPGoodsDetailsActivityPreSaleCell : UITableViewCell

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;

@end

#pragma mark *******************************   时间倒计时View **************************************
@interface GLPGCountdownTimeView : UIView

//- (instancetype)initWithtype:(GLPGoodsDetailType)type;
//字体颜色
@property(strong, nonatomic) UIColor *labelColor;
//框框背景色
@property(strong, nonatomic) UIColor *itemBgColor;
// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;

@property (nonatomic, strong) GLPGoodsDetailGroupModel *model;

@end



#pragma mark *******************************  预支付购买流程View **************************************
@interface GLPPurchaseProcessView : UIView

@end

NS_ASSUME_NONNULL_END
