//
//  GLPMineOrderCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMineOrderCell.h"

@interface GLPMineOrderCell ()
{
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *evaluateBtn;
@property (nonatomic, strong) UIButton *aftersellBtn;
@property(nonatomic,strong) UILabel *payLab;
@property(nonatomic,strong) UILabel *sendLab;
@property(nonatomic,strong) UILabel *acceptLab;
@property(nonatomic,strong) UILabel *evaluateLab;
@property(nonatomic,strong) UILabel *aftersellLab;
@end

@implementation GLPMineOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = RGB_COLOR(248, 248, 248);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _itemW = (kScreenW - 14*2)/5;
    _itemH = _itemW;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:6];
    [self.contentView addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.text = @"我的订单";
    [_bgView addSubview:_titleLabel];
    
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allBtn setTitle:@"全部订单" forState:0];
    [_allBtn setTitleColor:[UIColor dc_colorWithHexString:@"#9EA4B5"] forState:0];
    _allBtn.titleLabel.font = PFRFont(12);
    [_allBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xh"] forState:0];
    _allBtn.adjustsImageWhenHighlighted = NO;
    _allBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _allBtn.tag = 301;
    _allBtn.bounds = CGRectMake(0, 0, 100, 30);
    [_allBtn dc_buttonIconRightWithSpacing:5];
    [_allBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_allBtn];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setImage:[UIImage imageNamed:@"daifuk"] forState:0];
    [_payBtn setTitle:@"待付款" forState:0];
    [_payBtn setTitleColor:[UIColor dc_colorWithHexString:@"#838383"] forState:0];
    _payBtn.titleLabel.font = PFRFont(12);
    _payBtn.adjustsImageWhenHighlighted = NO;
    _payBtn.tag = 302;
    [_payBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _payBtn.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_payBtn dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_payBtn];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setImage:[UIImage imageNamed:@"daifahuo"] forState:0];
    [_sendBtn setTitle:@"待发货" forState:0];
    [_sendBtn setTitleColor:[UIColor dc_colorWithHexString:@"#838383"] forState:0];
    _sendBtn.titleLabel.font = PFRFont(12);
    _sendBtn.adjustsImageWhenHighlighted = NO;
    _sendBtn.tag = 303;
    [_sendBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_sendBtn dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_sendBtn];
    
    _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_acceptBtn setImage:[UIImage imageNamed:@"daishouhuo"] forState:0];
    [_acceptBtn setTitle:@"待收货" forState:0];
    [_acceptBtn setTitleColor:[UIColor dc_colorWithHexString:@"#838383"] forState:0];
    _acceptBtn.titleLabel.font = PFRFont(12);
    _acceptBtn.adjustsImageWhenHighlighted = NO;
    _acceptBtn.tag = 304;
    [_acceptBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _acceptBtn.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_acceptBtn dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_acceptBtn];
    
    _evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_evaluateBtn setImage:[UIImage imageNamed:@"daipingjia"] forState:0];
    [_evaluateBtn setTitle:@"待评价" forState:0];
    [_evaluateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#838383"] forState:0];
    _evaluateBtn.titleLabel.font = PFRFont(12);
    _evaluateBtn.adjustsImageWhenHighlighted = NO;
    _evaluateBtn.tag = 305;
    [_evaluateBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _evaluateBtn.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_evaluateBtn dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_evaluateBtn];
    
    _aftersellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_aftersellBtn setImage:[UIImage imageNamed:@"shouhou"] forState:0];
    [_aftersellBtn setTitle:@"退款/售后" forState:0];
    [_aftersellBtn setTitleColor:[UIColor dc_colorWithHexString:@"#838383"] forState:0];
    _aftersellBtn.titleLabel.font = PFRFont(12);
    _aftersellBtn.adjustsImageWhenHighlighted = NO;
    _aftersellBtn.tag = 306;
    [_aftersellBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _aftersellBtn.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_aftersellBtn dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_aftersellBtn];
    
    _payLab = [[UILabel alloc] init];
    [_payLab dc_cornerRadius:10];
    _payLab.font = [UIFont systemFontOfSize:10];
    _payLab.backgroundColor = [UIColor redColor];
    _payLab.textColor = [UIColor whiteColor];
    _payLab.hidden = YES;
    _payLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_payLab];
    
    _sendLab = [[UILabel alloc] init];
    [_sendLab dc_cornerRadius:10];
    _sendLab.font = [UIFont systemFontOfSize:10];
    _sendLab.backgroundColor = [UIColor redColor];
    _sendLab.textColor = [UIColor whiteColor];
    _sendLab.hidden = YES;
    _sendLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_sendLab];
    
    _acceptLab = [[UILabel alloc] init];
    [_acceptLab dc_cornerRadius:10];
    _acceptLab.textAlignment = NSTextAlignmentCenter;
    _acceptLab.font = [UIFont systemFontOfSize:10];
    _acceptLab.backgroundColor = [UIColor redColor];
    _acceptLab.textColor = [UIColor whiteColor];
    _acceptLab.hidden = YES;
    [_bgView addSubview:_acceptLab];
    
    _evaluateLab = [[UILabel alloc] init];
    [_evaluateLab dc_cornerRadius:10];
    _evaluateLab.textAlignment = NSTextAlignmentCenter;
    _evaluateLab.font = [UIFont systemFontOfSize:10];
    _evaluateLab.backgroundColor = [UIColor redColor];
    _evaluateLab.textColor = [UIColor whiteColor];
    _evaluateLab.hidden = YES;
    [_bgView addSubview:_evaluateLab];
    
    _aftersellLab = [[UILabel alloc] init];
    [_aftersellLab dc_cornerRadius:10];
    _aftersellLab.font = [UIFont systemFontOfSize:10];
    _aftersellLab.textAlignment = NSTextAlignmentCenter;
    _aftersellLab.backgroundColor = [UIColor redColor];
    _aftersellLab.textColor = [UIColor whiteColor];
    _aftersellLab.hidden = YES;
    [_bgView addSubview:_aftersellLab];
    
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
    
    CGFloat itemW = _itemW;
    CGFloat itemH = _itemH;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 14, 5, 14));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.bgView.top).offset(10);
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(100, 30));
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(itemW, itemH));
//        make.bottom.equalTo(self.bgView.bottom).offset(-15);//lj_change_约束
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
    [_payLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payBtn.mas_top);
        make.centerX.equalTo(self.payBtn.centerX).offset(20);
        make.width.height.offset(20);
    }];
    [_sendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendBtn.mas_top);
        make.centerX.equalTo(self.sendBtn.centerX).offset(20);
        make.width.height.offset(20);
    }];
    [_acceptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acceptBtn.mas_top);
        make.centerX.equalTo(self.acceptBtn.centerX).offset(20);
        make.width.height.offset(20);
    }];
    [_evaluateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.evaluateBtn.mas_top);
        make.centerX.equalTo(self.evaluateBtn.centerX).offset(20);
        make.width.height.offset(20);
    }];
    [_aftersellLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aftersellBtn.mas_top);
        make.centerX.equalTo(self.aftersellBtn.centerX).offset(20);
        make.width.height.offset(20);
    }];
}

- (void)setDic:(NSDictionary *)dic
{
    NSString *payStr = [NSString stringWithFormat:@"%@",dic[@"noPayCount"]];
    NSString *sendStr = [NSString stringWithFormat:@"%@",dic[@"noDeliveryCount"]];
    NSString *acentStr = [NSString stringWithFormat:@"%@",dic[@"noReceiptCount"]];
    NSString *eveStr = [NSString stringWithFormat:@"%@",dic[@"noEvalCount"]];
    NSString *afterStr = [NSString stringWithFormat:@"%@",dic[@"refundingCount"]];
    _payLab.text=payStr;
    _sendLab.text=sendStr;
    _acceptLab.text=acentStr;
    _evaluateLab.text=eveStr;
    _aftersellLab.text=afterStr;
    if ([payStr intValue]>0)
    {
        _payLab.hidden = NO;
    }
    else{
         _payLab.hidden = YES;
    }
    if ([sendStr intValue]>0)
    {
        _sendLab.hidden = NO;
    }
    else{
         _sendLab.hidden = YES;
    }
    if ([acentStr intValue]>0)
       {
           _acceptLab.hidden = NO;
       }
       else{
            _acceptLab.hidden = YES;
       }
    if ([eveStr intValue]>0)
    {
        _evaluateLab.hidden = NO;
    }
    else{
         _evaluateLab.hidden = YES;
    }
    if ([afterStr intValue]>0)
       {
           _aftersellLab.hidden = NO;
       }
       else{
            _aftersellLab.hidden = YES;
       }
}
@end
