//
//  GLBApplyTotalCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBApplyTotalCell.h"

@interface GLBApplyTotalCell ()

@property (nonatomic, strong) UILabel *freightLabel;
@property (nonatomic, strong) UILabel *freightMoneyLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *totalMoneyLabel;

@end

@implementation GLBApplyTotalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self dc_cornerRadius:5];
    
    _freightLabel = [[UILabel alloc] init];
    _freightLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _freightLabel.font = PFRFont(13);
    _freightLabel.text = @"运费";
    [self.contentView addSubview:_freightLabel];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _totalLabel.font = PFRFont(13);
    _totalLabel.text = @"商品总额";
    [self.contentView addSubview:_totalLabel];
    
    _freightMoneyLabel = [[UILabel alloc] init];
    _freightMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _freightMoneyLabel.font = PFRFont(14);
    _freightMoneyLabel.text = @"￥0.00";
    _freightMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_freightMoneyLabel];
    
    _totalMoneyLabel = [[UILabel alloc] init];
    _totalMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _totalMoneyLabel.font = PFRFont(14);
    _totalMoneyLabel.text = @"￥0.00";
    _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_totalMoneyLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_freightMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(36);
    }];
    
    [_freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freightMoneyLabel.centerY);
        make.right.equalTo(self.freightMoneyLabel.left).offset(-40);
    }];
    
    [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.top.equalTo(self.freightMoneyLabel.bottom);
        make.height.equalTo(36);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalMoneyLabel.centerY);
        make.right.equalTo(self.totalMoneyLabel.left).offset(-18);
    }];
}


#pragma mark - setter
- (void)setDataArray:(NSMutableArray<GLBShoppingCarModel *> *)dataArray
{
    _dataArray = dataArray;
    
    if (!_dataArray || [_dataArray count] == 0) {
        return;
    }
    
    CGFloat allPrice = 0; // 总价格
    CGFloat yunfei = 0; // 总运费
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
            if (price < [carModel.freight.requireAmount floatValue]) {
                yunfei += [carModel.freight.freight floatValue];
            }
        }
    }
    
    _freightMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",yunfei];
    _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
}


@end
