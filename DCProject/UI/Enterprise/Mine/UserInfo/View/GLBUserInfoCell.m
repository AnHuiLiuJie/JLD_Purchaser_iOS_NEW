//
//  GLBUserInfoCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBUserInfoCell.h"

@interface GLBUserInfoCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImage;

@end

@implementation GLBUserInfoCell

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
    _titleLabel.font = PFRFont(14);
    [self.contentView addSubview:_titleLabel];
    
    _textField = [[DCTextField alloc] init];
    _textField.type = DCTextFieldTypeDefault;
    _textField.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _textField.font = PFRFont(14);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.delegate = self;
    [self.contentView addSubview:_textField];
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [self.contentView addSubview:_rightImage];
    
    [self layoutIfNeeded];
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(80);
    }];
    
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right);
        make.right.equalTo(self.rightImage.left).offset(-10);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}



#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray *)titles placeholders:(NSArray *)placeholders contents:(NSArray *)contents indexPath:(NSIndexPath *)indexPath
{
    self.titleLabel.text = titles[indexPath.row];
    self.textField.placeholder = placeholders[indexPath.row];
    self.textField.text = contents[indexPath.row];
}

@end
