//
//  GLBCollectBottomView.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCollectBottomView.h"

@interface GLBCollectBottomView ()

@property (nonatomic, strong) UIButton *removeBtn;

@end

@implementation GLBCollectBottomView

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
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(15, 0, 80, 50);
    [_selectBtn setImage:[UIImage imageNamed:@"dc_gx_no"] forState:0];
    [_selectBtn setImage:[UIImage imageNamed:@"dc_gx_yes"] forState:UIControlStateSelected];
    [_selectBtn setTitle:@"  全选" forState:0];
    [_selectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#000000"] forState:0];
    _selectBtn.titleLabel.font = PFRFont(14);
    _selectBtn.adjustsImageWhenHighlighted = NO;
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_selectBtn];
    
    _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _removeBtn.frame = CGRectMake(kScreenW - 100- 12, 7, 100, 36);
    _removeBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3F3F"];
    [_removeBtn setTitle:@"移出收藏" forState:0];
    [_removeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _removeBtn.titleLabel.font = PFRFont(14);
    _removeBtn.adjustsImageWhenHighlighted = NO;
    [_removeBtn addTarget:self action:@selector(removeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_removeBtn dc_cornerRadius:18];
    [self addSubview:_removeBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)selectBtnClick:(UIButton *)button
{
    button.selected = ! button.selected;
    if (_selectBtnBlock) {
        _selectBtnBlock();
    }
}

- (void)removeBtnClick:(UIButton *)button
{
    if (_removeBtnBlock) {
        _removeBtnBlock();
    }
}

@end
