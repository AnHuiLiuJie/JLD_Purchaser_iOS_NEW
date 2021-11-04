//
//  GLBApplyStoreCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBApplyStoreCell.h"


@interface GLBApplyStoreCell ()

@property (nonatomic, strong) UIImageView *shopImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIView *goodsView;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) UILabel *totalMoneyLabel;
@property (nonatomic, strong) UIView *discountView;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *discountMoneyLabel;
@property (nonatomic, strong) UIImageView *discountMoreImage;
@property (nonatomic, strong) UIView *yunfeiView;
@property (nonatomic, strong) UILabel *yunfeiLabel;
@property (nonatomic, strong) UIImageView *yunfeiImage;
@property (nonatomic, strong) UILabel *yunfeiMoneyLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UIButton *danbaoBtn;
@property (nonatomic, strong) UIButton *beforeBtn;
@property (nonatomic, strong) UIButton *fenqiBtn;
@property (nonatomic, strong) UIImageView *line2;
@property (nonatomic, strong) UIImageView *line3;
@property (nonatomic, strong) UIImageView *line4;
@property (nonatomic, strong) UIImageView *line5;

@end

@implementation GLBApplyStoreCell

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
    _shopImage.contentMode = UIViewContentModeScaleAspectFill;
    [_shopImage dc_cornerRadius:12];
//    _shopImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_shopImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _shopNameLabel.font = PFRFont(14);
    _shopNameLabel.text = @"";
    [self.contentView addSubview:_shopNameLabel];
    
    _line1 = [[UIImageView alloc] init];
    _line1.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line1];
    
    _goodsView = [[UIView alloc] init];
    _goodsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_goodsView];
    
    _goodsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *goodsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsTapAction:)];
    [_goodsView addGestureRecognizer:goodsTap];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    [_goodsView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _countLabel.font = PFRFont(15);
    _countLabel.text = @"共 0 种";
    [_goodsView addSubview:_countLabel];
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [_goodsView addSubview:_rightImage];
    
    _line2 = [[UIImageView alloc] init];
    _line2.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line2];
    
    _countView = [[UIView alloc] init];
    _countView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_countView];
    
    _totalMoneyLabel = [[UILabel alloc] init];
    _totalMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _totalMoneyLabel.font = PFRFont(15);
    _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    _totalMoneyLabel.text = @"合计：￥0.00";
    [_countView addSubview:_totalMoneyLabel];
    
    _line3 = [[UIImageView alloc] init];
    _line3.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line3];
    
    _discountView = [[UIView alloc] init];
    _discountView.backgroundColor = [UIColor whiteColor];
    _discountView.userInteractionEnabled = YES;
    [self.contentView addSubview:_discountView];
    
    UITapGestureRecognizer *discountTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discountAction:)];
    [_discountView addGestureRecognizer:discountTap];
    
    _discountLabel = [[UILabel alloc] init];
    _discountLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _discountLabel.font = PFRFont(13);
    _discountLabel.text = @"优惠";
    [_discountView addSubview:_discountLabel];
    
    _discountMoneyLabel = [[UILabel alloc] init];
    _discountMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _discountMoneyLabel.font = PFRFont(15);
    _discountMoneyLabel.text = @"-¥0.00";
    _discountMoneyLabel.textAlignment = NSTextAlignmentRight;
    [_discountView addSubview:_discountMoneyLabel];
    
    _discountMoreImage = [[UIImageView alloc] init];
    _discountMoreImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [_discountView addSubview:_discountMoreImage];
    
    _yunfeiView = [[UIView alloc] init];
    _yunfeiView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_yunfeiView];
    
    _yunfeiLabel = [[UILabel alloc] init];
    _yunfeiLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _yunfeiLabel.font = PFRFont(13);
    _yunfeiLabel.text = @"运费";
    [_yunfeiView addSubview:_yunfeiLabel];
    
    _yunfeiMoneyLabel = [[UILabel alloc] init];
    _yunfeiMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _yunfeiMoneyLabel.font = PFRFont(15);
    _yunfeiMoneyLabel.textAlignment = NSTextAlignmentRight;
    _yunfeiMoneyLabel.text = @"￥0.00";
    [_yunfeiView addSubview:_yunfeiMoneyLabel];
    
    _yunfeiImage = [[UIImageView alloc] init];
    _yunfeiImage.image = [UIImage imageNamed:@"gwc_yf"];
    _yunfeiImage.hidden = YES;
    [_yunfeiView addSubview:_yunfeiImage];
    
    
    _yunfeiImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *yunfeiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yunfeiTapAction:)];
    [_yunfeiImage addGestureRecognizer:yunfeiTap];
    
    _line4 = [[UIImageView alloc] init];
    _line4.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line4];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _typeLabel.font = PFRFont(15);
    _typeLabel.text = @"交易方式";
    [self.contentView addSubview:_typeLabel];
    
    _typeImage = [[UIImageView alloc] init];
    _typeImage.image = [UIImage imageNamed:@"gwc_yf"];
    _typeImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_typeImage];
    
    UITapGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeImageAction:)];
    [_typeImage addGestureRecognizer:typeTap];
    
    _danbaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_danbaoBtn setTitle:@"担保支付" forState:0];
    [_danbaoBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_danbaoBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    [_danbaoBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:DC_BGColor] size:CGSizeMake(80, 30)] forState:0];
    [_danbaoBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:@"#00B7AB"] size:CGSizeMake(80, 30)] forState:UIControlStateSelected];
    [_danbaoBtn dc_cornerRadius:5];
    _danbaoBtn.titleLabel.font = PFRFont(14);
    _danbaoBtn.tag = 0;
    [_danbaoBtn addTarget:self action:@selector(danbaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_danbaoBtn];
    
    _beforeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_beforeBtn setTitle:@"预付款支付" forState:0];
    [_beforeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_beforeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    [_beforeBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:DC_BGColor] size:CGSizeMake(80, 30)] forState:0];
    [_beforeBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:@"#00B7AB"] size:CGSizeMake(80, 30)] forState:UIControlStateSelected];
    _beforeBtn.titleLabel.font = PFRFont(14);
    [_beforeBtn dc_cornerRadius:5];
    _beforeBtn.tag = 1;
    [_beforeBtn addTarget:self action:@selector(danbaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_beforeBtn];
    
    _fenqiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fenqiBtn setTitle:@"账期支付" forState:0];
    [_fenqiBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_fenqiBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    [_fenqiBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:DC_BGColor] size:CGSizeMake(80, 30)] forState:0];
    [_fenqiBtn setBackgroundImage:[UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:@"#00B7AB"] size:CGSizeMake(80, 30)] forState:UIControlStateSelected];
    _fenqiBtn.titleLabel.font = PFRFont(14);
    [_fenqiBtn dc_cornerRadius:5];
    _fenqiBtn.tag = 2;
    [_fenqiBtn addTarget:self action:@selector(danbaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _fenqiBtn.hidden = YES;
    [self.contentView addSubview:_fenqiBtn];
    
    _textView = [[DCTextView alloc] init];
    _textView.placeholder = @"买家留言（选填）";
    _textView.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _textView.placeholderColor = [UIColor dc_colorWithHexString:@"#999999"];
    _textView.font = PFRFont(14);
    [self.contentView addSubview:_textView];
    
    _line5 = [[UIImageView alloc] init];
    _line5.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line5];
    
    _danbaoBtn.selected = YES;
    _fenqiBtn.hidden = YES;
    
    [self layoutIfNeeded];
}



#pragma mark - actions
- (void)goodsTapAction:(id)sender
{
    if (_goodsBlock) {
        _goodsBlock();
    }
}


- (void)yunfeiTapAction:(id)sender
{
    if (_yunfeiBlock) {
        _yunfeiBlock();
    }
}

- (void)danbaoBtnClick:(UIButton *)button
{
    if (_typeBtnBlock) {
        _typeBtnBlock(button.tag);
    }
}

- (void)typeImageAction:(id)sender
{
    if (_typeBlock) {
        _typeBlock();
    }
}

- (void)discountAction:(id)sender
{
    if (_discountBlock) {
        _discountBlock();
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top).offset(40);
        make.height.equalTo(1);
    }];
    
    [_shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(18);
        make.top.equalTo(self.contentView.top).offset(8);
        make.size.equalTo(CGSizeMake(24, 24));
    }];
    
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImage.right).offset(10);
        make.centerY.equalTo(self.shopImage.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
    }];
    
    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line1.bottom);
        make.height.equalTo(100);
    }];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsView.left).offset(10);
        make.centerY.equalTo(self.goodsView.centerY);
        make.size.equalTo(CGSizeMake(98, 73));
    }];
    
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsView.right).offset(-10);
        make.centerY.equalTo(self.goodsView.centerY);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.right).offset(10);
        make.right.equalTo(self.rightImage.left).offset(-10);
        make.centerY.equalTo(self.goodsView.centerY);
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line1.right);
        make.top.equalTo(self.goodsView.bottom);
        make.height.equalTo(self.line1.height);
    }];
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line2.bottom);
        make.height.equalTo(36);
    }];
    
    [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countView.right).offset(-12);
        make.centerY.equalTo(self.countView.centerY);
    }];
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line1.right);
        make.top.equalTo(self.countView.bottom);
        make.height.equalTo(self.line1.height);
    }];
    
    [_discountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line3.bottom);
        make.height.equalTo(36);
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountView.left).offset(12);
        make.centerY.equalTo(self.discountView.centerY);
    }];
    
    [_discountMoreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.discountView.centerY);
        make.right.equalTo(self.discountView.right).offset(-5);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_discountMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.discountView.centerY);
        make.right.equalTo(self.discountMoreImage.left).offset(-5);
    }];
    
    [_line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line1.right);
        make.top.equalTo(self.discountView.bottom);
        make.height.equalTo(self.line1.height);
    }];
    
    [_yunfeiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line5.bottom);
        make.height.equalTo(36);
    }];
    
    [_yunfeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yunfeiView.centerY);
        make.left.equalTo(self.yunfeiView.left).offset(12);
    }];
    
    [_yunfeiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yunfeiView.centerY);
        make.left.equalTo(self.yunfeiLabel.right).offset(5);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    [_yunfeiMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.yunfeiView.right).offset(-12);
        make.centerY.equalTo(self.yunfeiView.centerY);
    }];
    
    [_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line1.right);
        make.top.equalTo(self.yunfeiView.bottom);
        make.height.equalTo(self.line1.height);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.line4.bottom);
        make.height.equalTo(36);
    }];
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.centerY.equalTo(self.typeLabel.centerY);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    [_danbaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.typeLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
    
    [_beforeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.danbaoBtn.centerY);
        make.left.equalTo(self.danbaoBtn.right).offset(10);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
    
    [_fenqiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.danbaoBtn.centerY);
        make.left.equalTo(self.beforeBtn.right).offset(10);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(5);
        make.right.equalTo(self.contentView.right).offset(-5);
        make.top.equalTo(self.danbaoBtn.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
        make.height.equalTo(100);
    }];
}


#pragma mark - setter
- (void)setCarModel:(GLBShoppingCarModel *)carModel
{
    _carModel = carModel;
    
    [_shopImage sd_setImageWithURL:[NSURL URLWithString:_carModel.suppierFirmLogo] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _shopNameLabel.text = _carModel.suppierFirmName;
    
    CGFloat totalMoney = 0;
    if (_carModel.cartGoodsList && [_carModel.cartGoodsList count] > 0) {
        GLBShoppingCarGoodsModel *goodsModel = _carModel.cartGoodsList[0];
        [_goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
        _countLabel.text = [NSString stringWithFormat:@"共 %ld 种",(long)_carModel.cartGoodsList.count];
        
        for (int i=0; i<_carModel.cartGoodsList.count; i++) {
            GLBShoppingCarGoodsModel *goodsModel1 = _carModel.cartGoodsList[i];
             totalMoney += (goodsModel1.price *goodsModel1.quantity);
        }
    }
    _totalMoneyLabel.text = [NSString stringWithFormat:@"合计:¥%.2f",totalMoney];
    _totalMoneyLabel = [UILabel setupAttributeLabel:_totalMoneyLabel textColor:_totalMoneyLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    if (_carModel.ticketModel) {
         _discountMoneyLabel.text = [NSString stringWithFormat:@"-¥%.2f",_carModel.ticketModel.discountAmount];
        _discountMoneyLabel = [UILabel setupAttributeLabel:_discountMoneyLabel textColor:_discountMoneyLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    } else {
        _discountMoneyLabel.text = @"-¥0.00";
        _discountMoneyLabel = [UILabel setupAttributeLabel:_discountMoneyLabel textColor:_discountMoneyLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    }
    
    CGFloat freight = 0;
    if (_carModel.freight.freight.length > 0) {
        if (totalMoney < [_carModel.freight.requireAmount floatValue]) {
            freight = [_carModel.freight.freight floatValue];
        } else {
            freight = 0;
        }
    }
    
    _yunfeiMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",freight];
    _yunfeiMoneyLabel = [UILabel setupAttributeLabel:_yunfeiMoneyLabel textColor:_yunfeiMoneyLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    if (_carModel.payType == 0) {
        _danbaoBtn.selected = YES;
        _beforeBtn.selected = NO;
        _fenqiBtn.selected = NO;
    } else if (_carModel.payType == 1) {
        _danbaoBtn.selected = NO;
        _beforeBtn.selected = YES;
        _fenqiBtn.selected = NO;
    } else if (_carModel.payType == 2) {
        _danbaoBtn.selected = NO;
        _beforeBtn.selected = NO;
        _fenqiBtn.selected = YES;
    }
    
    if (_carModel.periodState == 1) { // 已开通账期
        _fenqiBtn.hidden = NO;
    } else { // 未开通账期
        _fenqiBtn.hidden = YES;
    }
    
    _fenqiBtn.hidden = YES;
}


@end
