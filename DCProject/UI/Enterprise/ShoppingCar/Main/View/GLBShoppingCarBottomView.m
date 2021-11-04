//
//  GLBShoppingCarBottomView.m
//  DCProject
//
//  Created by bigbing on 2019/7/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBShoppingCarBottomView.h"

@interface GLBShoppingCarBottomView ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *deleteBtn;


@end

@implementation GLBShoppingCarBottomView

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
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(0, 0, 70, 50);
    [_selectBtn setImage:[UIImage imageNamed:@"dc_gx_no"] forState:0];
    [_selectBtn setImage:[UIImage imageNamed:@"dc_gx_yes"] forState:UIControlStateSelected];
    [_selectBtn setTitle:@" 全选" forState:0];
    [_selectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#000000"] forState:0];
    _selectBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    _selectBtn.adjustsImageWhenHighlighted = NO;
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(kScreenW - 100 - 12, 7, 100, 36);
    _payBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    [_payBtn setTitle:@"结算" forState:0];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:0];
    _payBtn.titleLabel.font = PFRFont(14);
    [_payBtn dc_cornerRadius:18];
    [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_payBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(kScreenW - 100 - 12, 7, 100, 36);
    _deleteBtn.frame = _payBtn.frame;
    _deleteBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3F3F"];
    [_deleteBtn setTitle:@"删除" forState:0];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:0];
    _deleteBtn.titleLabel.font = PFRFont(14);
    [_deleteBtn dc_cornerRadius:18];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    [self addSubview:_deleteBtn];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(CGRectGetMinX(self.deleteBtn.frame) - 15 - 100, 7, 100, 36);
    _collectBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    [_collectBtn setTitle:@"加入收藏" forState:0];
    [_collectBtn setTitleColor:[UIColor whiteColor] forState:0];
    _collectBtn.titleLabel.font = PFRFont(14);
    [_collectBtn dc_cornerRadius:18];
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _collectBtn.hidden = YES;
    [self addSubview:_collectBtn];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBtn.frame), 0, CGRectGetMinX(self.payBtn.frame) - CGRectGetMaxX(self.selectBtn.frame) - 10, 50)];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _priceLabel.font = PFRFont(14);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"合计：￥0";
    [self addSubview:_priceLabel];
}


#pragma mark - 点击事件
- (void)selectBtnClick:(UIButton *)button
{
    button.selected = ! button.selected;
    
    if (_selectBtnClick) {
        _selectBtnClick(button);
    }
}

- (void)payBtnClick:(UIButton *)button
{
    if (_payBtnClick) {
        _payBtnClick();
    }
}

- (void)deleteBtnClick:(UIButton *)button
{
    if (_deleteBtnClick) {
        _deleteBtnClick();
    }
}

- (void)collectBtnClick:(UIButton *)button
{
    if (_collectBtnClick) {
        _collectBtnClick();
    }
}


#pragma mark - setter
- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    if (_isEdit) {
        
        self.priceLabel.hidden = YES;
        self.payBtn.hidden = YES;
        self.deleteBtn.hidden = NO;
        self.collectBtn.hidden = NO;
        
    } else {
        
        self.priceLabel.hidden = NO;
        self.payBtn.hidden = NO;
        self.deleteBtn.hidden = YES;
        self.collectBtn.hidden = YES;
    }
}


#pragma mark -
- (void)setDataArray:(NSMutableArray<GLBShoppingCarModel *> *)dataArray
{
    _dataArray = dataArray;
    
    NSInteger selectCount = 0;
    CGFloat price = 0;
    for (int i=0; i<_dataArray.count; i++) {
        GLBShoppingCarModel *carModel = _dataArray[i];
        if (carModel.isSelected) {
            selectCount ++;
        }
        
        for (int j=0; j<carModel.cartGoodsList.count; j++) {
            GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[j];
            if (goodsModel.isSelected) {
                price += (goodsModel.price *goodsModel.quantity);
            }
        }
    }
    
    if (selectCount == _dataArray.count) {
        self.selectBtn.selected = YES;
    } else {
        self.selectBtn.selected = NO;
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",price];
}

@end
