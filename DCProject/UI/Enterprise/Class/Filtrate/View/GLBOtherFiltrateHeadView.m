//
//  GLBOtherFiltrateHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOtherFiltrateHeadView.h"

@interface GLBOtherFiltrateHeadView ()



@end

@implementation GLBOtherFiltrateHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = PFRFont(14);
    [self.contentView addSubview:_titleLabel];
    
    _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openBtn setTitle:@"展开全部" forState:0];
    [_openBtn setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:0];
    _openBtn.titleLabel.font = PFRFont(13);
    [_openBtn setImage:[UIImage imageNamed:@"dc_arrow_down_hei"] forState:0];
    _openBtn.adjustsImageWhenHighlighted = NO;
    _openBtn.bounds = CGRectMake(0, 0, 80, 40);
    _openBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_openBtn dc_buttonIconRightWithSpacing:5];
    [self.contentView addSubview:_openBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)openBtnClick:(UIButton *)button
{
    if (_openBtnBlock) {
        _openBtnBlock();
    }
}



#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(14);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(150);
    }];
    
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-14);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(80);
    }];
}


@end
