//
//  GLBAddressTVCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddressTVCell.h"

@interface GLBAddressTVCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBAddressTVCell


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
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.text = @"详细地址";
    [self.contentView addSubview:_titleLabel];
    
    _textView = [[DCTextView alloc] init];
    _textView.font = PFRFont(14);
    _textView.placeholder = @"填写详细地址";
    _textView.placeholderColor = [UIColor dc_colorWithHexString:@"#999999"];
    _textView.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    [self.contentView addSubview:_textView];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.width.equalTo(80);
        make.height.equalTo(50);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.titleLabel.top).offset(10);
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.titleLabel.right).offset(5);
        make.height.equalTo(100);
    }];
}
@end
