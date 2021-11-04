//
//  GLBStoreTicketItemCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreTicketItemCell.h"

@interface GLBStoreTicketItemCell ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *ruleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation GLBStoreTicketItemCell

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
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"lqzx_yhq"];
    [self.contentView addSubview:_bgImage];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _moneyLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_moneyLabel];
    
    _ruleLabel = [[UILabel alloc] init];
    _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _ruleLabel.font = [UIFont fontWithName:PFR size:11];
    [self.contentView addSubview:_ruleLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLabel.font = [UIFont fontWithName:PFR size:11];
    [self.contentView addSubview:_timeLabel];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _statusLabel.font = [UIFont fontWithName:PFRMedium size:12];
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
        make.right.equalTo(self.contentView.right).offset(-10);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(50);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.bottom.equalTo(self.contentView.centerY).offset(3);
//        make.width.equalTo(83);
    }];

    
    [_ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.right).offset(10);
//        make.right.equalTo(self.statusLabel.left);
        make.centerY.equalTo(self.moneyLabel.centerY);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.ruleLabel.bottom).offset(10);
    }];
}


#pragma mark - setter
- (void)setTicketModel:(GLBStoreTicketModel *)ticketModel
{
    _ticketModel = ticketModel;
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥%.0f",_ticketModel.discountAmount];
    _moneyLabel = [UILabel setupAttributeLabel:_moneyLabel textColor:_moneyLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _ruleLabel.text = [NSString stringWithFormat:@"满%.0f可用",_ticketModel.requireAmount];
    _timeLabel.text = [NSString stringWithFormat:@"%@-%@",_ticketModel.startTime,_ticketModel.endTime];
    
    if (_ticketModel.receive == 1) {
        _statusLabel.text = @"已领取";
        _bgImage.image = [UIImage imageNamed:@"lqzx_yhqby"];
    } else {
        _statusLabel.text = @"立即领取";
        _bgImage.image = [UIImage imageNamed:@"lqzx_yhq"];
    }
   
}

@end
