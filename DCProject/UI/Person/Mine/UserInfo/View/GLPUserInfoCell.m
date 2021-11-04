//
//  GLPUserInfoCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPUserInfoCell.h"

@interface GLPUserInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *moreImage;

@end

@implementation GLPUserInfoCell

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
    _titleLabel.font = PFRFont(15);
//    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _moreImage = [[UIImageView alloc] init];
    _moreImage.image = [UIImage imageNamed:@"dc_arrow_right_xh"];
    [self.contentView addSubview:_moreImage];
    
    _textField = [[DCTextField alloc] init];
    _textField.textColor = [UIColor dc_colorWithHexString:@"#939393"];
    _textField.font = PFRFont(15);
    _textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_textField];
    
    _headImage = [[UIImageView alloc] init];
    [_headImage dc_cornerRadius:21];
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_headImage];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(15);
        make.width.equalTo(150);
    }];
    
    [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(6, 12));
    }];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.moreImage.left).offset(-5);
        make.size.equalTo(CGSizeMake(42, 42));
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImage.right);
        make.left.equalTo(self.titleLabel.right);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}



#pragma mark -
- (void)dc_setValueWithTitles:(NSArray *)titles placeholders:(NSArray *)placeholders contents:(NSArray *)contents indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.textField.hidden = YES;
        self.headImage.hidden = NO;
    } else {
        self.textField.hidden = NO;
        self.headImage.hidden = YES;
    }
    
    if (indexPath.row == 0 || indexPath.row == 2||indexPath.row==3) {
        self.textField.userInteractionEnabled = NO;
    } else {
        self.textField.userInteractionEnabled = YES;
    }
    if (indexPath.row==3)
    {
        self.moreImage.hidden = YES;
    }
    self.textField.placeholder = placeholders[indexPath.row];
    self.titleLabel.text = titles[indexPath.row];
    self.textField.text = contents[indexPath.row];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[contents firstObject]] placeholderImage:[UIImage imageNamed:@"logo"]];
    
}

@end
