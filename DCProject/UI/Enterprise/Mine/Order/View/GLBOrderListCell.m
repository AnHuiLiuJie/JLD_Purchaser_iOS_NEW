//
//  GLBOrderListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOrderListCell.h"

@interface GLBOrderListCell ()

@property (nonatomic, strong) UIImageView *shopImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *shopRightImage;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *goodsBgView;
@property (nonatomic, strong) UILabel *goodsLabel;
@property (nonatomic, strong) UIImageView *goodsRightImage;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;


@end

@implementation GLBOrderListCell

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
    
    _shopImage = [[UIImageView alloc] init];
    _shopImage.image = [UIImage imageNamed:@"dianpu"];
    [self.contentView addSubview:_shopImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopNameLabel.font = [UIFont fontWithName:PFR size:12];
    _shopNameLabel.text = @"致健旗舰店";
    [self.contentView addSubview:_shopNameLabel];
    
    _shopNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *shopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopTapAction:)];
    [_shopNameLabel addGestureRecognizer:shopTap];
    
    _shopRightImage = [[UIImageView alloc] init];
    _shopRightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [self.contentView addSubview:_shopRightImage];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _statusLabel.font = [UIFont fontWithName:PFR size:12];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.text = @"待审核";
    [self.contentView addSubview:_statusLabel];
    
    _goodsBgView = [[UIView alloc] init];
    _goodsBgView.backgroundColor = [UIColor dc_colorWithHexString:@"#FAFAFA"];
    [_goodsBgView dc_cornerRadius:5];
    [self.contentView addSubview:_goodsBgView];
    
    _goodsBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *goodsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsTapAction:)];
    [_goodsBgView addGestureRecognizer:goodsTap];
    
    _goodsLabel = [[UILabel alloc] init];
    _goodsLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _goodsLabel.font = [UIFont fontWithName:PFR size:13];
    _goodsLabel.text = @"999感冒灵1袋*5g*10袋等12种药品";
    [self.contentView addSubview:_goodsLabel];
    
    _goodsRightImage = [[UIImageView alloc] init];
    _goodsRightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [self.contentView addSubview:_goodsRightImage];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont fontWithName:PFR size:12];
    _timeLabel.text = @"2019-08-03 12:56:32";
    [self.contentView addSubview:_timeLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _priceLabel.font = [UIFont fontWithName:PFR size:11];
    _priceLabel.text = @"合计:￥1207.85";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setTitle:@"取消订单" forState:0];
    [_leftBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _leftBtn.titleLabel.font = PFRFont(12);
    [_leftBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#666666"] radius:12];
    [_leftBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"付款" forState:0];
    [_rightBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _rightBtn.titleLabel.font = PFRFont(12);
    [_rightBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#666666"] radius:12];
    [_rightBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)orderBtnClick:(UIButton *)button
{
    if (_orderBlock) {
        _orderBlock(button.titleLabel.text);
    }
}

- (void)goodsTapAction:(id)sender
{
    if (_orderBlock) {
        _orderBlock(@"");
    }
}

- (void)shopTapAction:(id)sender
{
    if (_orderBlock) {
        _orderBlock(@"");
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top);
        make.size.equalTo(CGSizeMake(100, 27));
    }];
    
    [_shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.statusLabel.centerY);
        make.width.equalTo(10);
        make.height.equalTo(9);
    }];
    
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImage.right).offset(5);
        make.top.equalTo(self.statusLabel.top);
        make.bottom.equalTo(self.statusLabel.bottom);
    }];
    
    [_shopRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopNameLabel.right).offset(5);
        make.centerY.equalTo(self.statusLabel.centerY);
        make.size.equalTo(CGSizeMake(5, 8));
    }];
    
    [_goodsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.statusLabel.bottom);
        make.height.equalTo(50);
    }];
    
    [_goodsRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsBgView.right).offset(-15);
        make.centerY.equalTo(self.goodsBgView.centerY);
        make.size.equalTo(CGSizeMake(5, 8));
    }];
    
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsBgView.left).offset(15);
        make.right.equalTo(self.goodsRightImage.left).offset(-5);
        make.centerY.equalTo(self.goodsBgView.centerY);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.goodsBgView.bottom).offset(13);
        make.width.equalTo(130);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.timeLabel.centerY);
        make.left.equalTo(self.timeLabel.right);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.priceLabel.bottom).offset(19);
        make.bottom.equalTo(self.contentView.bottom).offset(-8);
        make.size.equalTo(CGSizeMake(67, 24));
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBtn.centerY);
        make.right.equalTo(self.rightBtn.left).offset(-10);
        make.width.equalTo(self.rightBtn.width);
        make.height.equalTo(self.rightBtn.height);
    }];
    
}


#pragma mark - setter
- (void)setOrderModel:(GLBOrderModel *)orderModel
{
    _orderModel = orderModel;
    
    _shopNameLabel.text = _orderModel.suppierFirmName;
    _statusLabel.text = _orderModel.orderStateCN;
    _timeLabel.text = _orderModel.orderTime;
    _goodsLabel.text = [NSString stringWithFormat:@"%@等%ld种药品",_orderModel.goods,(long)_orderModel.goodsCount];
    _priceLabel.text = [NSString stringWithFormat:@"合计:¥%.2f",_orderModel.paymentAmount];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:nil minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    if (_orderModel.orderState == 1) { // 待审核
        
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"取消订单" forState:0];
        
    } else if (_orderModel.orderState == 4) { // 待付款
        
        _leftBtn.hidden = NO;
        _rightBtn.hidden = NO;
        [_leftBtn setTitle:@"取消订单" forState:0];
        [_rightBtn setTitle:@"支付" forState:0];
        
    } else if (_orderModel.orderState == 5) { // 待发货
        
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"查看明细" forState:0];
        
    } else if (_orderModel.orderState == 6) { // 部分发货
        
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"查看明细" forState:0];
        
    } else if (_orderModel.orderState == 7) { // 待验收
        
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"验收" forState:0];
        
    } else if (_orderModel.orderState == 8) { // 已验收
        
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"查看异议" forState:0];
        
    } else if (_orderModel.orderState == 9) { // 交易关闭
        
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"查看明细" forState:0];
        
    } else if (_orderModel.orderState == 10) { // 交易完成
        
        if ([_orderModel.evalState isEqualToString:@"1"]) {
            _rightBtn.hidden = NO;
            [_rightBtn setTitle:@"评价" forState:0];
        } else {
            _rightBtn.hidden = NO;
            [_rightBtn setTitle:@"查看明细" forState:0];
        }
    }
    
}

@end
