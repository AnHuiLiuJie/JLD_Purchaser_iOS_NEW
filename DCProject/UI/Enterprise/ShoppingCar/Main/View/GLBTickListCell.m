//
//  GLBTickListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTickListCell.h"

@interface GLBTickListCell ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *ruleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation GLBTickListCell

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
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"gwc_yhq"];
    [self.contentView addSubview:_bgImage];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _moneyLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.attributedText = [self dc_attributeStr:0];
    [self.contentView addSubview:_moneyLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _typeLabel.font = [UIFont fontWithName:PFR size:10];
//    _typeLabel.text = @"店铺优惠券";
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_typeLabel];
    
    _ruleLabel = [[UILabel alloc] init];
    _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _ruleLabel.font = [UIFont fontWithName:PFR size:14];
//    _ruleLabel.text = @"满1000元可使用";
    [self.contentView addSubview:_ruleLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLabel.font = [UIFont fontWithName:PFR size:10];
//    _timeLabel.text = @"有效日期：2018.10.15-2018.12.15";
    [self.contentView addSubview:_timeLabel];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _statusLabel.font = [UIFont fontWithName:PFRMedium size:14];
//    _statusLabel.text = @"立即领取";
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statusLabel];
    
    [self layoutIfNeeded];
}


- (NSMutableAttributedString *)dc_attributeStr:(CGFloat)money
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.0f",money]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} range:NSMakeRange(0, 1)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:23]} range:NSMakeRange(1, attStr.length - 1)];
    return attStr;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-20);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(80);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(0);
        make.bottom.equalTo(self.contentView.centerY).offset(10);
        make.width.equalTo(kScreenW *0.23);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.right.equalTo(self.moneyLabel.right);
        make.top.equalTo(self.moneyLabel.bottom);
    }];
    
    [_ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.right).offset(10);
        make.right.equalTo(self.statusLabel.left);
        make.bottom.equalTo(self.contentView.centerY).offset(5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleLabel.left);
        make.right.equalTo(self.bgImage.right).offset(-10);
        make.top.equalTo(self.ruleLabel.bottom).offset(5);
    }];
}


#pragma mark - setter
- (void)setGoodsTicketModel:(GLBGoodsTicketModel *)goodsTicketModel
{
    _goodsTicketModel = goodsTicketModel;
    
    _typeLabel.text = @"商品专享券";
    _ruleLabel.text = [NSString stringWithFormat:@"满%.0f元可使用",_goodsTicketModel.requireAmount];
    _timeLabel.text = [NSString stringWithFormat:@"有效日期：%@-%@",_goodsTicketModel.startTime,_goodsTicketModel.endTime];
    _moneyLabel.attributedText = [self dc_attributeStr:_goodsTicketModel.discountAmount];
    if (_goodsTicketModel.receive == 1) { // 已领取
        _statusLabel.text = @"已领取";
        _bgImage.image = [UIImage imageNamed:@"gwc_yhqy"];
    } else {
        _statusLabel.text = @"立即领取";
        _bgImage.image = [UIImage imageNamed:@"gwc_yhq"];
    }
    
}


- (void)setStoreTicketModel:(GLBStoreTicketModel *)storeTicketModel
{
    _storeTicketModel = storeTicketModel;
    
    _typeLabel.text = @"店铺优惠券";
    _ruleLabel.text = [NSString stringWithFormat:@"满%.0f元可使用",_storeTicketModel.requireAmount];
    _timeLabel.text = [NSString stringWithFormat:@"有效日期：%@-%@",_storeTicketModel.startTime,_storeTicketModel.endTime];
    _moneyLabel.attributedText = [self dc_attributeStr:_storeTicketModel.discountAmount];
    if (_storeTicketModel.receive == 1) { // 已领取
        _statusLabel.text = @"已领取";
        _bgImage.image = [UIImage imageNamed:@"gwc_yhqy"];
    } else {
        _statusLabel.text = @"立即领取";
        _bgImage.image = [UIImage imageNamed:@"gwc_yhq"];
    }
}

@end
