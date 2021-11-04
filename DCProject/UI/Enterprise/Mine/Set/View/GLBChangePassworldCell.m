//
//  GLBChangePassworldCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBChangePassworldCell.h"


@interface GLBChangePassworldCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBChangePassworldCell


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
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = PFRFont(14);
    [self.contentView addSubview:_titleLabel];
    
    _textFiled = [[DCTextField alloc] init];
    _textFiled.type = DCTextFieldTypePassWord;
    _textFiled.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _textFiled.font = PFRFont(14);
    _textFiled.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_textFiled];
    
    [self layoutIfNeeded];
}


#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray *)titles placeholders:(NSArray *)placeholders indexPath:(NSIndexPath *)indexPath
{
    _titleLabel.text = titles[indexPath.row];
    _textFiled.placeholder = placeholders[indexPath.row];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(20);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(100);
    }];
    
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-20);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.titleLabel.right).offset(10);
    }];
}

@end
