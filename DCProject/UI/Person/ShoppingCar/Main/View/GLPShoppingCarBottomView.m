//
//  GLPShoppingCarBottomView.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPShoppingCarBottomView.h"

@interface GLPShoppingCarBottomView ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation GLPShoppingCarBottomView

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
    [_selectBtn setImage:[UIImage imageNamed:@"weixuanz"] forState:0];
    [_selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [_selectBtn setTitle:@" 全选" forState:0];
    [_selectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _selectBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    _selectBtn.adjustsImageWhenHighlighted = NO;
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(kScreenW - 100 - 12, 7, 100, 36);
    _payBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00CAAB"];
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
    //_priceLabel.font = PFRFont(14);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.attributedText = [self dc_attributeString:@"0.00"];
    [self addSubview:_priceLabel];
}


#pragma mark - 富文本
- (NSMutableAttributedString *)dc_attributeString:(NSString *)price
{
    NSString *text = [NSString stringWithFormat:@"合计：￥%@",price];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSString *floStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 3)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF9900"]} range:NSMakeRange(3, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:17],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF9900"]} range:NSMakeRange(4, attrStr.length - 4)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF9900"]} range:range2];
    
    return attrStr;
}


#pragma mark - 点击事件
- (void)selectBtnClick:(UIButton *)button
{
    button.selected = ! button.selected;
    if (_selectBtnClick) {
        _selectBtnClick(button.selected);
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


- (void)setDataArray:(NSMutableArray<GLPFirmListModel *> *)dataArray
{
    _dataArray = dataArray;
    
    __block CGFloat allPrice = 0; // 总金额
    __block BOOL isAllSelected = YES;
    
    for (int i=0; i<_dataArray.count; i++) {
        GLPFirmListModel *carModel = _dataArray[i];

        // 活动
        [carModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
            __block CGFloat beforeDiscountAmount = 0.00; // 每个活动商品金额小记
            CGFloat afterDiscountAmount = 0.00;
            [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (goodsModel.isSelected) { // 选中
                    beforeDiscountAmount += ([goodsModel.quantity floatValue] * [goodsModel.sellPrice floatValue]);
                } else {
                    isAllSelected = NO;
                }
            }];
            
            NSArray *actList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:actModel.actPriceList];
            __block GLPCouponListModel *indexModel = nil;
            [actList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(GLPCouponListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (beforeDiscountAmount > [actModel.requireAmount floatValue]) {
                    indexModel = actModel;
                }
            }];
            
            if (beforeDiscountAmount >= [indexModel.discountAmount floatValue] && beforeDiscountAmount > [indexModel.requireAmount floatValue]) {
                afterDiscountAmount = beforeDiscountAmount - [indexModel.discountAmount floatValue];
            }else
                afterDiscountAmount = beforeDiscountAmount;
            
//            // 达到活动要求，满减
//            if (beforeDiscountAmount >= [actModel.requireAmount floatValue]) {
//                beforeDiscountAmount -= [actModel.discountAmount floatValue];
//            }
            
            // 金额累计
            allPrice += afterDiscountAmount;
        }];

        // 非活动
        __block CGFloat beforeDiscountAmount2 = 0; // 每个活动商品金额小记
        [carModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (goodsModel.isSelected) { // 被选中
                beforeDiscountAmount2 += ([goodsModel.sellPrice floatValue] * [goodsModel.quantity floatValue]);
            } else {
                isAllSelected = NO;
            }
        }];
        
        // 金额累计
        allPrice += beforeDiscountAmount2;
    }
    
    _priceLabel.attributedText = [self dc_attributeString:[NSString stringWithFormat:@"%.2f",allPrice]];
    
    _selectBtn.selected = isAllSelected;
}

@end
