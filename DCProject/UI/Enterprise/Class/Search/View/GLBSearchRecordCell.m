//
//  GLBSearchRecordCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSearchRecordCell.h"

@interface GLBSearchRecordCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation GLBSearchRecordCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = PFRFont(12);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F5F5"];
    [_titleLabel dc_cornerRadius:15];
    [self.contentView addSubview:_titleLabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_scq_bai"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_cancelBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
    if (_deleteBlock) {
        _deleteBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.right.equalTo(self.contentView.right);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(30);
    }];
}


#pragma mark - setter
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    _titleLabel.text = _title;
}

@end
