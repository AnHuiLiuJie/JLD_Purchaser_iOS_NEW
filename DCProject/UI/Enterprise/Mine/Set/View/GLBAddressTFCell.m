//
//  GLBAddressTFCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddressTFCell.h"

@interface GLBAddressTFCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBAddressTFCell


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
    [self.contentView addSubview:_titleLabel];
    
    _textFiled = [[DCTextField alloc] init];
    _textFiled.type = DCTextFieldTypeDefault;
    _textFiled.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _textFiled.font = PFRFont(14);
    [self.contentView addSubview:_textFiled];
    
    [self layoutIfNeeded];
}


#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray *)titles placeholders:(NSArray *)placeholders indexPath:(NSIndexPath *)indexPath
{
    _titleLabel.text = titles[indexPath.section][indexPath.row];
    _textFiled.placeholder = placeholders[indexPath.section][indexPath.row];
    
    self.textFiled.userInteractionEnabled = YES;
    if (indexPath.row == 2) {
        self.textFiled.userInteractionEnabled = NO;
    }
    
    self.textFiled.type = DCTextFieldTypeDefault;
    if (indexPath.row == 1) {
        self.textFiled.type = DCTextFieldTypeTelePhone;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(80);
        make.height.equalTo(50);
    }];
    
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.titleLabel.right).offset(10);
    }];
}

@end
