//
//  GLBRecordListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRecordListCell.h"


@interface GLBRecordListCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *countlabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GLBRecordListCell

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
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _nameLabel.font = PFRFont(13);
    _nameLabel.text = @"新***房";
    [self.contentView addSubview:_nameLabel];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _phoneLabel.font = PFRFont(13);
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.text = @"138****5672";
    [self.contentView addSubview:_phoneLabel];
    
    _countlabel = [[UILabel alloc] init];
    _countlabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _countlabel.font = PFRFont(13);
    _countlabel.textAlignment = NSTextAlignmentCenter;
    _countlabel.text = @"50000盒";
    [self.contentView addSubview:_countlabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLabel.font = PFRFont(13);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = @"2019-05-30";
    [self.contentView addSubview:_timeLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(70);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(80);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(100);
    }];
    
    [_countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel.right);
        make.right.equalTo(self.timeLabel.left);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}


#pragma mark - setter
- (void)setRecordModel:(GLBRecordModel *)recordModel
{
    _recordModel = recordModel;
    
    _nameLabel.text = _recordModel.purchaserFirmName;
    _phoneLabel.text = _recordModel.purchaserFirmPhone;
    _countlabel.text = [NSString stringWithFormat:@"%ld盒",(long)_recordModel.quantity];
    
    NSString *time = _recordModel.orderTime;
    if ([time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    _timeLabel.text = time;
}

@end
