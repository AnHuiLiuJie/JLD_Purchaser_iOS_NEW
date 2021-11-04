//
//  RefundDetailsListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/23.
//

#import <UIKit/UIKit.h>
#import "GLPDetailReturnModel.h"
#import "GLPOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RefundDetailsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageV;
@property (weak, nonatomic) IBOutlet UILabel *statuLab;

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;

@property (weak, nonatomic) IBOutlet UIView *goodsBgView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *wayLab;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *returnReasonLab;
@property (weak, nonatomic) IBOutlet UILabel *refundTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *returnAmountLab;

@property (nonatomic, strong) GLPDetailReturnModel *model;

@property (nonatomic, strong) GLPOrderDetailModel *detailModel;

@property (nonatomic, copy) dispatch_block_t RefundDetailsListCell_block;


@end

NS_ASSUME_NONNULL_END
