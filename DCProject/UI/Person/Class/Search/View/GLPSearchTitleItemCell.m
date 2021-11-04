//
//  GLPSearchTitleItemCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPSearchTitleItemCell.h"

@interface GLPSearchTitleItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation GLPSearchTitleItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#6E777E"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F6F7"];
    [_titleLabel dc_cornerRadius:15];
    [self.contentView addSubview:_titleLabel];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"dc_scq_bai"] forState:0];
    _deleteBtn.adjustsImageWhenHighlighted = NO;
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_deleteBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)deleteBtnClick:(UIButton *)button
{
    if (_deleteBlock) {
        _deleteBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
