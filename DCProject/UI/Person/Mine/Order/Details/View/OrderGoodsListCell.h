//
//  OrderGoodsListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import <UIKit/UIKit.h>
#import "GLPOrderDetailModel.h"
#import "GLPNewShoppingCarModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderGoodsListCell : UITableViewCell

@property (nonatomic, strong) GLPNewShopCarGoodsModel *carModel;

@property (nonatomic, strong) GLPOrderGoodsListModel *model;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *wayLab;
@property (weak, nonatomic) IBOutlet UILabel *returnInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *mixTipLab;

@property (nonatomic, strong) void(^OrderGoodsListCell_block)(GLPOrderGoodsListModel *model);

@end

NS_ASSUME_NONNULL_END

