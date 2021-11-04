//
//  GLBApplySuccessCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBApplySuccessCell.h"

@interface GLBApplySuccessCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *orderNameLabel;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UILabel *typeNameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *moneyNameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GLBApplySuccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.contentView addSubview:_bgView];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_bgView addSubview:_bgImage];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"tjcg"];
    [_bgView addSubview:_iconImage];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.text = @"订单提交成功！";
    _statusLabel.font = PFRFont(14);
    [_bgView addSubview:_statusLabel];
    
    _orderNameLabel = [[UILabel alloc] init];
    _orderNameLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _orderNameLabel.text = @"订单编号";
    _orderNameLabel.font = PFRFont(14);
    [_bgView addSubview:_orderNameLabel];
    
    _orderLabel = [[UILabel alloc] init];
    _orderLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _orderLabel.text = @"";
    _orderLabel.font = PFRFont(14);
    _orderLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_orderLabel];
    
    _typeNameLabel = [[UILabel alloc] init];
    _typeNameLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _typeNameLabel.text = @"支付方式";
    _typeNameLabel.font = PFRFont(14);
    [_bgView addSubview:_typeNameLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _typeLabel.text = @"";
    _typeLabel.font = PFRFont(14);
    _typeLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLabel.text = @"";
    _timeLabel.font = PFRFont(14);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_timeLabel];
    _timeLabel.hidden = YES;
    
    _moneyNameLabel = [[UILabel alloc] init];
    _moneyNameLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _moneyNameLabel.text = @"支付金额";
    _moneyNameLabel.font = PFRFont(14);
    [_bgView addSubview:_moneyNameLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _moneyLabel.text = @"";
    _moneyLabel.font = PFRFont(14);
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_moneyLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [_bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.bgView.top);
        make.height.equalTo(80);
    }];
    
    [_iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImage.centerY);
        make.left.equalTo(self.bgView.left).offset(20);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY);
        make.left.equalTo(self.iconImage.right).offset(20);
    }];
    
    [_orderNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.bgImage.bottom);
        make.size.equalTo(CGSizeMake(100, 35));
    }];
    
    [_orderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNameLabel.right);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.orderNameLabel.centerY);
    }];
    
    [_typeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNameLabel.left);
        make.top.equalTo(self.orderNameLabel.bottom);
        make.width.equalTo(self.orderNameLabel.width);
        make.height.equalTo(self.orderNameLabel.height);
    }];
    
    [_typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLabel.left);
        make.right.equalTo(self.orderLabel.right);
        make.centerY.equalTo(self.typeNameLabel.centerY);
    }];
    
    if (_timeLabel.hidden == YES) {
        
        [_moneyNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNameLabel.left);
            make.top.equalTo(self.typeNameLabel.bottom);
            make.width.equalTo(self.orderNameLabel.width);
            make.height.equalTo(self.orderNameLabel.height);
            make.bottom.equalTo(self.bgView.bottom);
        }];
        
        [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderLabel.left);
            make.right.equalTo(self.orderLabel.right);
            make.centerY.equalTo(self.moneyNameLabel.centerY);
        }];
        
    } else {
        
        [_moneyNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNameLabel.left);
            make.top.equalTo(self.typeNameLabel.bottom);
            make.width.equalTo(self.orderNameLabel.width);
            make.height.equalTo(self.orderNameLabel.height);
//            make.bottom.equalTo(self.bgView.bottom);
        }];
        
        [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderLabel.left);
            make.right.equalTo(self.orderLabel.right);
            make.centerY.equalTo(self.moneyNameLabel.centerY);
        }];
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNameLabel.left);
            make.right.equalTo(self.orderLabel.right);
            make.top.equalTo(self.moneyNameLabel.bottom);
            make.height.equalTo(self.moneyNameLabel.height);
            make.bottom.equalTo(self.bgView.bottom);
        }];
    }

}



#pragma mark - setter
- (void)setSuccessModel:(GLBOrderSuccessModel *)successModel
{
    _successModel = successModel;
    
    _orderLabel.text = [NSString stringWithFormat:@"%ld",(long)_successModel.orderNo];
    _typeLabel.text = _successModel.tradeType;
    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",_successModel.paymentAmount];
    _moneyLabel = [UILabel setupAttributeLabel:_moneyLabel textColor:_moneyLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    if (_successModel.repayment && _successModel.repayment.length > 0) {
        _timeLabel.hidden = NO;
        _timeLabel.text = _successModel.repayment;
    } else {
        _timeLabel.hidden = YES;
    }
    
    [self layoutSubviews];
}

@end
