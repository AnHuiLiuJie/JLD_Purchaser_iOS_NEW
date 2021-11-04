//
//  GLBMineToolCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineToolCell.h"

@interface GLBMineToolCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *ticketBtn;
@property (nonatomic, strong) UIButton *evaluateBtn;
@property (nonatomic, strong) UIButton *intentionBtn;
@property (nonatomic, strong) UIButton *tellBtn;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *abousBtn;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIImageView *line;

@end

@implementation GLBMineToolCell

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
    _titleLabel.text = @"常用工具";
    [self.contentView addSubview:_titleLabel];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    _ticketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ticketBtn setImage:[UIImage imageNamed:@"wode_yhq"] forState:0];
    [_ticketBtn setTitle:@"优惠券" forState:0];
    [_ticketBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _ticketBtn.titleLabel.font = PFRFont(11);
    _ticketBtn.adjustsImageWhenHighlighted = NO;
    _ticketBtn.tag = 100;
    [_ticketBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _ticketBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
    [_ticketBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_ticketBtn];
    
    _evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_evaluateBtn setImage:[UIImage imageNamed:@"pjgl"] forState:0];
    [_evaluateBtn setTitle:@"评价管理" forState:0];
    [_evaluateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _evaluateBtn.titleLabel.font = PFRFont(11);
    _evaluateBtn.adjustsImageWhenHighlighted = NO;
    _evaluateBtn.tag = 101;
    [_evaluateBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _evaluateBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
    [_evaluateBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_evaluateBtn];
    
    _intentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_intentionBtn setImage:[UIImage imageNamed:@"wode_dgyx"] forState:0];
    [_intentionBtn setTitle:@"订购意向" forState:0];
    [_intentionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _intentionBtn.titleLabel.font = PFRFont(11);
    _intentionBtn.adjustsImageWhenHighlighted = NO;
    _intentionBtn.tag = 102;
    [_intentionBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _intentionBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
    [_intentionBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_intentionBtn];
    
    _tellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tellBtn setImage:[UIImage imageNamed:@"wode_lxkf"] forState:0];
    [_tellBtn setTitle:@"联系客服" forState:0];
    [_tellBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _tellBtn.titleLabel.font = PFRFont(11);
    _tellBtn.adjustsImageWhenHighlighted = NO;
    _tellBtn.tag = 103;
    [_tellBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _tellBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
    [_tellBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_tellBtn];
    
//    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_payBtn setImage:[UIImage imageNamed:@"zqff"] forState:0];
//    [_payBtn setTitle:@"账期付费" forState:0];
//    [_payBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
//    _payBtn.titleLabel.font = PFRFont(11);
//    _payBtn.adjustsImageWhenHighlighted = NO;
//    _payBtn.tag = 104;
//    [_payBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _payBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
//    [_payBtn dc_buttonIconTopWithSpacing:20];
//    [self.contentView addSubview:_payBtn];
    
    _abousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_abousBtn setImage:[UIImage imageNamed:@"wode_gywm"] forState:0];
    [_abousBtn setTitle:@"关于我们" forState:0];
    [_abousBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _abousBtn.titleLabel.font = PFRFont(11);
    _abousBtn.adjustsImageWhenHighlighted = NO;
    _abousBtn.tag = 105;
    [_abousBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _abousBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
    [_abousBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_abousBtn];
    
    _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_helpBtn setImage:[UIImage imageNamed:@"wode_bzfk"] forState:0];
    [_helpBtn setTitle:@"帮助反馈" forState:0];
    [_helpBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _helpBtn.titleLabel.font = PFRFont(11);
    _helpBtn.adjustsImageWhenHighlighted = NO;
    _helpBtn.tag = 106;
    [_helpBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _helpBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
    [_helpBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_helpBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setBtn setImage:[UIImage imageNamed:@"wode_sz"] forState:0];
    [_setBtn setTitle:@"设置" forState:0];
    [_setBtn setTitleColor:[UIColor dc_colorWithHexString:@"#8F93A3"] forState:0];
    _setBtn.titleLabel.font = PFRFont(11);
    _setBtn.adjustsImageWhenHighlighted = NO;
    _setBtn.tag = 107;
    [_setBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _setBtn.bounds = CGRectMake(0, 0, kScreenW/4, kScreenW/4);
    [_setBtn dc_buttonIconTopWithSpacing:20];
    [self.contentView addSubview:_setBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - 点击事件
- (void)toolBtnClick:(UIButton *)button
{
    if (_toolCellBlock) {
        _toolCellBlock(button.tag);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(14);
        make.top.equalTo(self.contentView.top).offset(10);
        make.right.equalTo(self.contentView.right).offset(-14);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.titleLabel.bottom).offset(9);
        make.height.equalTo(1);
    }];
    
    [_ticketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(kScreenW/4, kScreenW/4));
    }];
    
    [_evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ticketBtn.centerY);
        make.left.equalTo(self.ticketBtn.right);
        make.width.equalTo(self.ticketBtn.width);
        make.height.equalTo(self.ticketBtn.height);
    }];
    
    [_intentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ticketBtn.centerY);
        make.left.equalTo(self.evaluateBtn.right);
        make.width.equalTo(self.ticketBtn.width);
        make.height.equalTo(self.ticketBtn.height);
    }];
    
    [_tellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ticketBtn.centerY);
        make.left.equalTo(self.intentionBtn.right);
        make.width.equalTo(self.ticketBtn.width);
        make.height.equalTo(self.ticketBtn.height);
    }];
    
    [_abousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ticketBtn.left);
        make.top.equalTo(self.ticketBtn.bottom);
        make.width.equalTo(self.ticketBtn.width);
        make.height.equalTo(self.ticketBtn.height);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
//    [_abousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.payBtn.centerY);
//        make.left.equalTo(self.payBtn.right);
//        make.width.equalTo(self.ticketBtn.width);
//        make.height.equalTo(self.ticketBtn.height);
//    }];
    
    [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.abousBtn.centerY);
        make.left.equalTo(self.abousBtn.right);
        make.width.equalTo(self.ticketBtn.width);
        make.height.equalTo(self.ticketBtn.height);
    }];
    
    [_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.abousBtn.centerY);
        make.left.equalTo(self.helpBtn.right);
        make.width.equalTo(self.ticketBtn.width);
        make.height.equalTo(self.ticketBtn.height);
    }];
}

@end
