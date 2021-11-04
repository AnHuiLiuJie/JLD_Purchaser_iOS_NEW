//
//  GLPDetailTicketSelectCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPDetailTicketSelectCell.h"

@interface GLPDetailTicketSelectCell ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *moneyTitleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *requireLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statuslabel;

@end

@implementation GLPDetailTicketSelectCell

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
    _bgImage.image = [UIImage imageNamed:@"weishiyong"];
    [self.contentView addSubview:_bgImage];
    
    _moneyTitleLabel = [[UILabel alloc] init];
    _moneyTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _moneyTitleLabel.font = PFRFont(14);
    _moneyTitleLabel.text = @"¥";
    [self.contentView addSubview:_moneyTitleLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _moneyLabel.font = [UIFont fontWithName:PFRMedium size:30];
    _moneyLabel.text = @"0";
    [self.contentView addSubview:_moneyLabel];
    
    _requireLabel = [[UILabel alloc] init];
    _requireLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _requireLabel.font = PFRFont(12);
    _requireLabel.text = @"满0元可用";
    [self.contentView addSubview:_requireLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    _timeLabel.font = PFRFont(11);
    _timeLabel.text = @"";
    [self.contentView addSubview:_timeLabel];
    
    _statuslabel = [[UILabel alloc] init];
    _statuslabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _statuslabel.font = PFRFont(13);
    _statuslabel.text = @"领取";
    _statuslabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_statuslabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 25, 0, 25));
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.left).offset(20);
        make.top.equalTo(self.contentView.top).offset(5);
    }];
    
    [_moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel.left);
        make.bottom.equalTo(self.moneyLabel.bottom).offset(-7);
    }];
    
    [_requireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyTitleLabel.left);
        make.top.equalTo(self.moneyTitleLabel.bottom).offset(3);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.requireLabel.left);
        make.top.equalTo(self.requireLabel.bottom).offset(2);
    }];
    
    [_statuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-25);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(0.29*kScreenW);
    }];
}



#pragma mark - lazy load
- (void)setTicketModel:(GLPGoodsTicketModel *)ticketModel
{
    _ticketModel = ticketModel;
    
    _moneyLabel.text = _ticketModel.discountAmount;
    _requireLabel.text = [NSString stringWithFormat:@"满%@元可用",_ticketModel.requireAmount];
    
    NSString *time = _ticketModel.useEndDate;
    if ([time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    if ([time containsString:@"-"]) {
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    _timeLabel.text = [NSString stringWithFormat:@"有限期至%@",time];
    
    if ([_ticketModel.isReceive isEqualToString:@"1"]) { //已领取
        
        _statuslabel.text = @"已领取";
        _statuslabel.textColor = [UIColor dc_colorWithHexString:@"#A1A1A1"];
        
    } else { //未领取
     
        _statuslabel.text = @"领取";
        _statuslabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    }
}

@end
