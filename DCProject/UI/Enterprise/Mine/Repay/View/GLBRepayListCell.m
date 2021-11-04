//
//  GLBRepayListCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayListCell.h"

@interface GLBRepayListCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *completeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *repayLabel;
@property (nonatomic, strong) UILabel *nopayLabel;
@property (nonatomic, strong) UIButton *overdueBtn;

@end

@implementation GLBRepayListCell

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"dianpu"];
    [self.contentView addSubview:_iconImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopNameLabel.font = PFRFont(12);
    _shopNameLabel.text = @"";
    [self.contentView addSubview:_shopNameLabel];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _statusLabel.font = PFRFont(12);
    _statusLabel.text = @"";
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statusLabel];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _numLabel.font = PFRFont(13);
    _numLabel.text = @"订单号：-";
    [self.contentView addSubview:_numLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _moneyLabel.font = PFRFont(13);
    _moneyLabel.attributedText = [self dc_attributeStr:@"账期金额: " moneyStr:@"0.00"];
    [self.contentView addSubview:_moneyLabel];
    
    _completeLabel = [[UILabel alloc] init];
    _completeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _completeLabel.font = PFRFont(13);
    _completeLabel.text = @"订单完成日期: -";
    [self.contentView addSubview:_completeLabel];
    
    _endTimeLabel = [[UILabel alloc] init];
    _endTimeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _endTimeLabel.font = PFRFont(13);
    _endTimeLabel.text = @"还款截止日期: -";
    [self.contentView addSubview:_endTimeLabel];
    
    _repayLabel = [[UILabel alloc] init];
    _repayLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _repayLabel.font = PFRFont(13);
    _repayLabel.attributedText = [self dc_attributeStr:@"已还款:  " moneyStr:@"0.00"];
    [self.contentView addSubview:_repayLabel];
    
    _nopayLabel = [[UILabel alloc] init];
    _nopayLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _nopayLabel.font = PFRFont(13);
    _nopayLabel.attributedText = [self dc_attributeStr:@"待还款:  " moneyStr:@"9461.83"];
    _nopayLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_nopayLabel];
    
    _overdueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_overdueBtn setTitle:@"逾期申请历史" forState:0];
    [_overdueBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FF9900"] forState:0];
    _overdueBtn.titleLabel.font = PFRFont(10);
    [_overdueBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#FF9900"] radius:10];
    [_overdueBtn addTarget:self action:@selector(overdueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_overdueBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)overdueBtnClick:(UIButton *)button
{
    if (_btnClickBlock) {
        _btnClickBlock();
    }
}


#pragma mark - attributeStr
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)beforeStr moneyStr:(NSString *)moneyStr
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@¥%@",beforeStr,moneyStr]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:13]} range:NSMakeRange(0, beforeStr.length)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:15]} range:NSMakeRange(beforeStr.length, attStr.length - beforeStr.length)];
    return attStr;
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top).offset(36);
        make.height.equalTo(1);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.line.top);
        make.width.lessThanOrEqualTo(120);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLabel.centerY);
        make.left.equalTo(self.contentView.left).offset(15);
        make.size.equalTo(CGSizeMake(10, 10));
    }];
    
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY);
        make.left.equalTo(self.iconImage.right).offset(10);
        make.right.equalTo(self.statusLabel.left).offset(-5);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.line.bottom).offset(15);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLabel.left);
        make.right.equalTo(self.numLabel.right);
        make.top.equalTo(self.numLabel.bottom).offset(10);
    }];
    
    [_completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLabel.left);
        make.right.offset(-15);
        make.top.equalTo(self.moneyLabel.bottom).offset(10);
    }];
    
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLabel.left);
        make.right.offset(-15);
        make.top.equalTo(self.completeLabel.bottom).offset(10);
    }];
    
    [_repayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLabel.left);
        make.width.equalTo(kScreenW/2);
        make.top.equalTo(self.endTimeLabel.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-15);
    }];
    
    [_nopayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repayLabel.right);
        make.centerY.equalTo(self.repayLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
    }];
    
    [_overdueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endTimeLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.size.equalTo(CGSizeMake(80, 20));
    }];
}



#pragma mark - setter
- (void)setRepayListModel:(GLBRepayListModel *)repayListModel
{
    _repayListModel = repayListModel;
    
    _shopNameLabel.text = _repayListModel.suppierFirmName;
    _numLabel.text = [NSString stringWithFormat:@"订单号：%ld",_repayListModel.orderNo];
    _moneyLabel.attributedText = [self dc_attributeStr:@"账期金额: " moneyStr:[NSString stringWithFormat:@"%.2f",_repayListModel.accountPeriodAmount]];
    _completeLabel.text = [NSString stringWithFormat:@"订单完成日期: %@",_repayListModel.orderFinishTime];
    _endTimeLabel.text = [NSString stringWithFormat:@"还款截止日期: %@",_repayListModel.repaymentEndDate];
    _repayLabel.attributedText = [self dc_attributeStr:@"已还款:  " moneyStr:[NSString stringWithFormat:@"%.2f",_repayListModel.hasPaymentAmount]];
    _nopayLabel.attributedText = [self dc_attributeStr:@"待还款:  " moneyStr:[NSString stringWithFormat:@"%.2f",_repayListModel.paymentAmount]];
    
//    账期状态：1-在途；2-待还款；3-还款中；4-已还款；5-逾期还款结束
    
    NSString *status = @"";
    if (_repayListModel.periodState == 1) {
        status = @"在途";
    } else if (_repayListModel.periodState == 2) {
        status = @"待还款";
    } else if (_repayListModel.periodState == 3) {
        status = @"还款中";
    } else if (_repayListModel.periodState == 4) {
        status = @"已还款";
    } else if (_repayListModel.periodState == 5) {
        status = @"逾期还款结束";
    }
    
    _statusLabel.text = status;
    
    if (_repayListModel.delays && _repayListModel.delays.count > 0) {
        _overdueBtn.hidden = NO;
    } else {
        _overdueBtn.hidden = YES;
    }

}


@end
