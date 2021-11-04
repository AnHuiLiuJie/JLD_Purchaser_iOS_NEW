//
//  EtpServiceFeeSearchView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "PioneerServiceFeeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpServiceFeeSearchView : UIView

@property (nonatomic, copy) dispatch_block_t did_removeView_Block;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *defineBtn;
@property (weak, nonatomic) IBOutlet UITextField *goodsNameTF;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;

@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;

@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;


@property (weak, nonatomic) IBOutlet UIButton *allBtn;
//状态：1-在途，2-成交，3-取消

@property (weak, nonatomic) IBOutlet UIButton *myBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *thridBtn;
@property (weak, nonatomic) IBOutlet UIImageView *startImg;
@property (weak, nonatomic) IBOutlet UIImageView *endImg;


@property (nonatomic, copy) void(^etpServiceFeeSearchViewAction_Block)(PSFSearchConditionModel *model);

@property (nonatomic, strong) PSFSearchConditionModel *model;

@property (weak, nonatomic) IBOutlet UIView *typeBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTypeView_H_LayoutConstraint;

@property (nonatomic,assign) NSInteger showType;// nil 或者0 代表服务费明细里面的。 1 代表我的订单里面的
@end

NS_ASSUME_NONNULL_END
