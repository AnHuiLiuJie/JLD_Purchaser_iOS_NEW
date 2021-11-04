//
//  GLBOverdueRecodeCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOverdueRecodeCell.h"
#import "DCTextView.h"

@interface GLBOverdueRecodeCell ()

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) DCTextView *textView;
@property (nonatomic, strong) UILabel *aduioLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation GLBOverdueRecodeCell

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
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#77ACA8"];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = PFRFont(12);
    _numLabel.text = @"1";
    [_numLabel dc_cornerRadius:8];
    [self.contentView addSubview:_numLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _timeLabel.font = PFRFont(14);
    _timeLabel.text = @"延期还款时间：-";
    [self.contentView addSubview:_timeLabel];
    
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _dayLabel.font = PFRFont(14);
    _dayLabel.text = @"延期天数： 0";
    [self.contentView addSubview:_dayLabel];
    
    _textView = [[DCTextView alloc] init];
    _textView.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
    _textView.font = PFRFont(13);
    _textView.content = @"";
    _textView.userInteractionEnabled = NO;
    [_textView dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EDEDED"] radius:2];
    [self.contentView addSubview:_textView];
    
    _aduioLabel = [[UILabel alloc] init];
    _aduioLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _aduioLabel.font = PFRFont(14);
    _aduioLabel.text = @"供应商审核：";
    [self.contentView addSubview:_aduioLabel];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _statusLabel.font = PFRFont(14);
    _statusLabel.text = @"";
    [self.contentView addSubview:_statusLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top).offset(5);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.numLabel.bottom).offset(14);
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.timeLabel.bottom).offset(12);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.dayLabel.bottom).offset(10);
        make.height.equalTo(80);
    }];
    
    [_aduioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.textView.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-25);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aduioLabel.centerY);
        make.left.equalTo(self.aduioLabel.right);
    }];
}


#pragma mark - setter
- (void)setValueWithDelayModel:(GLBRepayListDelayModel *)delayModel indexPath:(NSIndexPath *)indexpath
{
    
    NSString *time = delayModel.paymentEndDate;
    if ([time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%ld",indexpath.row + 1];
    _timeLabel.text = [NSString stringWithFormat:@"延期还款时间：%@",time];
    _dayLabel.text = [NSString stringWithFormat:@"延期天数：%@",delayModel.days];
    _textView.content = delayModel.reason;
    _statusLabel.text = delayModel.auditReason;
}

@end
