//
//  OrderGoodsInfoCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "OrderGoodsListCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderGoodsInfoCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageV;
@property (weak, nonatomic) IBOutlet UILabel *statuLab;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *allGoodsPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *freightLab;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *allOrderPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView_H_LayoutConstraint;

@property (nonatomic, strong) NSMutableArray *couponArray;

@property (nonatomic, strong) GLPOrderDetailModel *model;

@property (nonatomic, strong) void(^OrderGoodsInfoCell_block)(GLPOrderGoodsListModel *model);
@property (nonatomic, strong) void(^OrderGoodsInfoIndexCell_block)(GLPOrderGoodsListModel *model);

@property (nonatomic, copy) dispatch_block_t OrderGoodsInfoCell_Block;
@end

NS_ASSUME_NONNULL_END
