//
//  GLBMineOrderCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineOrderCell.h"

@interface GLBMineOrderCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *evaluateBtn;
@property (nonatomic, strong) UIButton *aftersellBtn;
@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) UILabel *allCountLabel;
@property (nonatomic, strong) UILabel *payCountLabel;
@property (nonatomic, strong) UILabel *sendCountLabel;
@property (nonatomic, strong) UILabel *acceptCountLabel;
@property (nonatomic, strong) UILabel *evaluateCountLabel;
@property (nonatomic, strong) UILabel *sellAfterCountLabel;

@end

@implementation GLBMineOrderCell

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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _titleLabel.text = @"我的订单";
    [self.contentView addSubview:_titleLabel];
    
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allBtn setTitle:@"全部订单" forState:0];
    [_allBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _allBtn.titleLabel.font = PFRFont(13);
    _allBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _allBtn.tag = 301;
    [_allBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_allBtn];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setImage:[UIImage imageNamed:@"wode_dfk"] forState:0];
    [_payBtn setTitle:@"待付款" forState:0];
    [_payBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _payBtn.titleLabel.font = PFRFont(11);
    _payBtn.adjustsImageWhenHighlighted = NO;
    _payBtn.tag = 302;
    [_payBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _payBtn.bounds = CGRectMake(0, 0, kScreenW/5, kScreenW/5);
    [_payBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_payBtn];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setImage:[UIImage imageNamed:@"wode_dfh"] forState:0];
    [_sendBtn setTitle:@"待发货" forState:0];
    [_sendBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _sendBtn.titleLabel.font = PFRFont(11);
    _sendBtn.adjustsImageWhenHighlighted = NO;
    _sendBtn.tag = 303;
    [_sendBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.bounds = CGRectMake(0, 0, kScreenW/5, kScreenW/5);
    [_sendBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_sendBtn];
    
    _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_acceptBtn setImage:[UIImage imageNamed:@"wode_dsh"] forState:0];
    [_acceptBtn setTitle:@"待收货" forState:0];
    [_acceptBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _acceptBtn.titleLabel.font = PFRFont(11);
    _acceptBtn.adjustsImageWhenHighlighted = NO;
    _acceptBtn.tag = 304;
    [_acceptBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _acceptBtn.bounds = CGRectMake(0, 0, kScreenW/5, kScreenW/5);
    [_acceptBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_acceptBtn];
    
    _evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_evaluateBtn setImage:[UIImage imageNamed:@"wode_dpj"] forState:0];
    [_evaluateBtn setTitle:@"待评价" forState:0];
    [_evaluateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _evaluateBtn.titleLabel.font = PFRFont(11);
    _evaluateBtn.adjustsImageWhenHighlighted = NO;
    _evaluateBtn.tag = 305;
    [_evaluateBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _evaluateBtn.bounds = CGRectMake(0, 0, kScreenW/5, kScreenW/5);
    [_evaluateBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_evaluateBtn];
    
    _aftersellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_aftersellBtn setImage:[UIImage imageNamed:@"wode_sh"] forState:0];
    [_aftersellBtn setTitle:@"售后" forState:0];
    [_aftersellBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _aftersellBtn.titleLabel.font = PFRFont(11);
    _aftersellBtn.adjustsImageWhenHighlighted = NO;
    _aftersellBtn.tag = 306;
    [_aftersellBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _aftersellBtn.bounds = CGRectMake(0, 0, kScreenW/5, kScreenW/5);
    [_aftersellBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_aftersellBtn];
    
    _allCountLabel = [[UILabel alloc] init];
    _allCountLabel.textColor = [UIColor whiteColor];
    _allCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _allCountLabel.textAlignment = NSTextAlignmentCenter;
    _allCountLabel.font = PFRFont(8);
    [_allCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _allCountLabel.text = @"0";
    _allCountLabel.hidden = YES;
    [self.contentView addSubview:_allCountLabel];
    
    _allCountLabel = [[UILabel alloc] init];
    _allCountLabel.textColor = [UIColor whiteColor];
    _allCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _allCountLabel.textAlignment = NSTextAlignmentCenter;
    _allCountLabel.font = PFRFont(8);
    [_allCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _allCountLabel.text = @"0";
    _allCountLabel.hidden = YES;
    [self.contentView addSubview:_allCountLabel];
    
    _payCountLabel = [[UILabel alloc] init];
    _payCountLabel.textColor = [UIColor whiteColor];
    _payCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _payCountLabel.textAlignment = NSTextAlignmentCenter;
    _payCountLabel.font = PFRFont(8);
    [_payCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _payCountLabel.text = @"0";
    _payCountLabel.hidden = YES;
    [self.contentView addSubview:_payCountLabel];
    
    _sendCountLabel = [[UILabel alloc] init];
    _sendCountLabel.textColor = [UIColor whiteColor];
    _sendCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _sendCountLabel.textAlignment = NSTextAlignmentCenter;
    _sendCountLabel.font = PFRFont(8);
    [_sendCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _sendCountLabel.text = @"0";
    _sendCountLabel.hidden = YES;
    [self.contentView addSubview:_sendCountLabel];
    
    _acceptCountLabel = [[UILabel alloc] init];
    _acceptCountLabel.textColor = [UIColor whiteColor];
    _acceptCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _acceptCountLabel.textAlignment = NSTextAlignmentCenter;
    _acceptCountLabel.font = PFRFont(8);
    [_acceptCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _acceptCountLabel.text = @"0";
    _acceptCountLabel.hidden = YES;
    [self.contentView addSubview:_acceptCountLabel];
    
    _evaluateCountLabel = [[UILabel alloc] init];
    _evaluateCountLabel.textColor = [UIColor whiteColor];
    _evaluateCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _evaluateCountLabel.textAlignment = NSTextAlignmentCenter;
    _evaluateCountLabel.font = PFRFont(8);
    [_evaluateCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _evaluateCountLabel.text = @"0";
    _evaluateCountLabel.hidden = YES;
    [self.contentView addSubview:_evaluateCountLabel];
    
    _sellAfterCountLabel = [[UILabel alloc] init];
    _sellAfterCountLabel.textColor = [UIColor whiteColor];
    _sellAfterCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#EF393B"];
    _sellAfterCountLabel.textAlignment = NSTextAlignmentCenter;
    _sellAfterCountLabel.font = PFRFont(8);
    [_sellAfterCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:8];
    _sellAfterCountLabel.text = @"0";
    _sellAfterCountLabel.hidden = YES;
    [self.contentView addSubview:_sellAfterCountLabel];
    
//    _allCountLabel.hidden = NO;
//    _payCountLabel.hidden = NO;
//    _acceptCountLabel.hidden = NO;
//    _sendCountLabel.hidden = NO;
//    _evaluateCountLabel.hidden = NO;
//    _sellAfterCountLabel.hidden = NO;
    
    [self layoutIfNeeded];
}


#pragma mark - 点击事件
- (void)orderBtnClick:(UIButton *)button
{
    if (_orderCellBlock) {
        _orderCellBlock(button.tag);
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(14);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-14);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(60, 30));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.allBtn.bottom).offset(9);
        make.height.equalTo(1);
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(kScreenW/5, kScreenW/5));
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payBtn.right);
        make.centerY.equalTo(self.payBtn.centerY);
        make.width.equalTo(self.payBtn.width);
        make.height.equalTo(self.payBtn.height);
    }];
    
    [_acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendBtn.right);
        make.centerY.equalTo(self.payBtn.centerY);
        make.width.equalTo(self.payBtn.width);
        make.height.equalTo(self.payBtn.height);
    }];
    
    [_evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acceptBtn.right);
        make.centerY.equalTo(self.payBtn.centerY);
        make.width.equalTo(self.payBtn.width);
        make.height.equalTo(self.payBtn.height);
    }];
    
    [_aftersellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.evaluateBtn.right);
        make.centerY.equalTo(self.payBtn.centerY);
        make.width.equalTo(self.payBtn.width);
        make.height.equalTo(self.payBtn.height);
    }];
    
    [_allCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allBtn.top);
        make.left.equalTo(self.allBtn.right);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_payCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payBtn.centerX).offset(10);
        make.top.equalTo(self.payBtn.top).offset(10);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_sendCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendBtn.centerX).offset(10);
        make.top.equalTo(self.sendBtn.top).offset(10);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_acceptCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acceptBtn.centerX).offset(10);
        make.top.equalTo(self.acceptBtn.top).offset(10);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_evaluateCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.evaluateBtn.centerX).offset(10);
        make.top.equalTo(self.evaluateBtn.top).offset(10);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_sellAfterCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aftersellBtn.centerX).offset(10);
        make.top.equalTo(self.aftersellBtn.top).offset(10);;
        make.size.equalTo(CGSizeMake(16, 16));
    }];
}


#pragma mark - setter
- (void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    if (!_infoDict) {
        return;
    }
    
    if (_infoDict[@"allOrderCount"] && ![_infoDict[@"allOrderCount"] dc_isNull] && [_infoDict[@"allOrderCount"] length] > 0) {
        if ([_infoDict[@"allOrderCount"] integerValue] > 0) {
            _acceptCountLabel.hidden = NO;
            _acceptCountLabel.text = _infoDict[@"allOrderCount"];
        } else {
            _acceptCountLabel.hidden = YES;
        }
    }
    
    if (_infoDict[@"noPayCount"] && ![_infoDict[@"noPayCount"] dc_isNull] && [_infoDict[@"noPayCount"] length] > 0) {
        if ([_infoDict[@"noPayCount"] integerValue] > 0) {
            _payCountLabel.hidden = NO;
            _payCountLabel.text = _infoDict[@"noPayCount"];
        } else {
            _payCountLabel.hidden = YES;
        }
    }
    
    if (_infoDict[@"noDeliveryCount"] && ![_infoDict[@"noDeliveryCount"] dc_isNull] && [_infoDict[@"noDeliveryCount"] length] > 0) {
        if ([_infoDict[@"noDeliveryCount"] integerValue] > 0) {
            _sendCountLabel.hidden = NO;
            _sendCountLabel.text = _infoDict[@"noDeliveryCount"];
        } else {
            _sendCountLabel.hidden = YES;
        }
    }
    
    if (_infoDict[@"noAcceptanceCount"] && ![_infoDict[@"noAcceptanceCount"] dc_isNull] && [_infoDict[@"noAcceptanceCount"] length] > 0) {
        if ([_infoDict[@"noAcceptanceCount"] integerValue] > 0) {
            _acceptCountLabel.hidden = NO;
            _acceptCountLabel.text = _infoDict[@"noAcceptanceCount"];
        } else {
            _acceptCountLabel.hidden = YES;
        }
    }
    
    if (_infoDict[@"noEvalCount"] && ![_infoDict[@"noEvalCount"] dc_isNull] && [_infoDict[@"noEvalCount"] length] > 0) {
        if ([_infoDict[@"noEvalCount"] integerValue] > 0) {
            _evaluateCountLabel.hidden = NO;
            _evaluateCountLabel.text = _infoDict[@"noEvalCount"];
        } else {
            _evaluateCountLabel.hidden = YES;
        }
    }
    
    if (_infoDict[@"objectionCount"] && ![_infoDict[@"objectionCount"] dc_isNull] && [_infoDict[@"objectionCount"] length] > 0) {
        if ([_infoDict[@"objectionCount"] integerValue] > 0) {
            _sellAfterCountLabel.hidden = NO;
            _sellAfterCountLabel.text = _infoDict[@"objectionCount"];
        } else {
            _sellAfterCountLabel.hidden = YES;
        }
    }
    
}

@end
