//
//  GLBRepayRecordCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayRecordCell.h"

@interface GLBRepayRecordCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *completeLabel;
@property (nonatomic, strong) UIImageView *topLine;
@property (nonatomic, strong) UIImageView *bottomLine;

@end

@implementation GLBRepayRecordCell

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
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _moneyLabel.font = PFRFont(13);
    _moneyLabel.text = @"还款金额：￥0.00";
    [self.contentView addSubview:_moneyLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _timeLabel.font = PFRFont(13);
    _timeLabel.text = @"还款时间：-";
    [self.contentView addSubview:_timeLabel];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.backgroundColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
    [_iconImage dc_cornerRadius:3];
    [self.contentView addSubview:_iconImage];
    
    _topLine = [[UIImageView alloc] init];
    _topLine.backgroundColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
    [self.contentView addSubview:_topLine];
    
    _bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
    [self.contentView addSubview:_bottomLine];
    
    _completeLabel = [[UILabel alloc] init];
    _completeLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _completeLabel.font = PFRFont(13);
    _completeLabel.text = @"还款完成";
    _completeLabel.textAlignment = NSTextAlignmentRight;
    _completeLabel.hidden = YES;
    [self.contentView addSubview:_completeLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(68);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.right.equalTo(self.moneyLabel.right);
        make.top.equalTo(self.moneyLabel.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-30);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel.left).offset(-24);
        make.centerY.equalTo(self.moneyLabel.bottom).offset(-5);
        make.size.equalTo(CGSizeMake(6, 6));
    }];
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.centerX);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.iconImage.top);
        make.width.equalTo(1);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.centerX);
        make.top.equalTo(self.iconImage.bottom);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(1);
    }];
}


#pragma mark - 赋值
- (void)setValueWithRepayRecordModel:(GLBRepayRecordModel *)recordModel indexPath:(NSIndexPath *)indexPath
{
    NSArray *array = recordModel.payments;
    
    GLBRepayRecordPaymentsModel *payment = array[indexPath.row];
    _moneyLabel.text = [NSString stringWithFormat:@"还款金额：￥%.2f",payment.paymentAmount];
    
    NSString *time = payment.paymentTime;
    if ([time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    _timeLabel.text = [NSString stringWithFormat:@"还款时间：￥%@",time];
    
    if (indexPath.row == 0) {
        self.topLine.hidden = YES;
    } else {
        self.topLine.hidden = NO;
    }
    
    self.completeLabel.hidden = YES;
    if (array.count > 0 && indexPath.row == array.count - 1) {
        self.bottomLine.hidden = YES;
        
        if (recordModel.isEnd && [recordModel.isEnd isEqualToString:@"1"]) { // 已完成还款
            self.completeLabel.hidden = NO;
        }
        
    } else {
        self.bottomLine.hidden = NO;
    }
}

@end
