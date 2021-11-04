//
//  GLBStoreNoticeCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreNoticeCell.h"

@interface GLBStoreNoticeCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation GLBStoreNoticeCell

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
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLabel.text = @"商家公告";
    [self.contentView addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _descLabel.font = PFRFont(13);
    _descLabel.numberOfLines = 0;
    _descLabel.text = @"";
    [self.contentView addSubview:_descLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top).offset(15);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.titleLabel.bottom).offset(20);
        make.bottom.equalTo(self.contentView.bottom).offset(-25);
    }];
}


#pragma mark - setter
- (void)setStoreModel:(GLBStoreModel *)storeModel
{
    _storeModel = storeModel;
    
    if (_storeModel.notice && _storeModel.notice.length > 0) {
        _descLabel.text = [NSString stringWithFormat:@"%@",_storeModel.notice];
    } else {
        _descLabel.text = [NSString stringWithFormat:@"%@",@"无"];
    }
    
}

@end
