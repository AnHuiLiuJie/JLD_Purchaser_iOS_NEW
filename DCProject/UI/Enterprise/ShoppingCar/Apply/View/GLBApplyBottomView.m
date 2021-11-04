//
//  GLBApplyBottomView.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBApplyBottomView.h"

@interface GLBApplyBottomView ()

@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) UILabel *payMoneyLabel;
@property (nonatomic, strong) UIButton *commintBtn;

@end

@implementation GLBApplyBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _payLabel = [[UILabel alloc] init];
    _payLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _payLabel.font = PFRFont(14);
    _payLabel.text = @"实付";
    [self addSubview:_payLabel];
    
    _payMoneyLabel = [[UILabel alloc] init];
    _payMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _payMoneyLabel.font = PFRFont(18);
    _payMoneyLabel.text = @"￥0.00";
    [self addSubview:_payMoneyLabel];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commintBtn setTitle:@"确认" forState:0];
    [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
    _commintBtn.titleLabel.font = PFRFont(14);
    _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    [_commintBtn dc_cornerRadius:18];
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commintBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    if (_completeBlock) {
        _completeBlock();
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(23);
        make.centerY.equalTo(self.centerY);
    }];
    
    [_payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.payLabel.right).offset(19);
    }];
    
    [_commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-12);
        make.size.equalTo(CGSizeMake(100, 36));
    }];
}


#pragma mark - setter
- (void)setDataArray:(NSMutableArray<GLBShoppingCarModel *> *)dataArray
{
    _dataArray = dataArray;
    
    CGFloat allPrice = 0; // 总价格
    CGFloat yunfei = 0; // 总运费
    CGFloat discountMoney = 0; // 总优惠
    
    for (int i=0; i<_dataArray.count; i++) {
        GLBShoppingCarModel *carModel = _dataArray[i];
        
        CGFloat price = 0;
        if (carModel.cartGoodsList && carModel.cartGoodsList.count > 0) {
            for (int j=0; j<carModel.cartGoodsList.count; j++) {
                GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[j];
                price += (goodsModel.price *goodsModel.quantity);
            }
        }
        
        allPrice += price;
        
        if (carModel.freight && carModel.freight.freight.length > 0) {
            if (allPrice < [carModel.freight.requireAmount floatValue]) {
                yunfei += [carModel.freight.freight floatValue];
            }
        }
        
        if (carModel.ticketModel) {
            discountMoney += carModel.ticketModel.discountAmount;
        }
    }
    
    CGFloat totalPrice = allPrice + yunfei - discountMoney;
    _payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
}


@end
