//
//  GLBZizhiExchangeItemCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBZizhiExchangeItemCell.h"

@interface GLBZizhiExchangeItemCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *exchangeBtn;
@property (nonatomic, strong) UIImageView *uploadImage;

@end

@implementation GLBZizhiExchangeItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImage.clipsToBounds = YES;
    [self.contentView addSubview:_iconImage];
    
    _uploadImage = [[UIImageView alloc] init];
    _uploadImage.image = [UIImage imageNamed:@"tj"];
    [self.contentView addSubview:_uploadImage];
    _uploadImage.hidden = YES;
    
    _iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageAction:)];
    [_iconImage addGestureRecognizer:tap];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"sc"] forState:0];
    _deleteBtn.adjustsImageWhenHighlighted = NO;
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
    _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exchangeBtn setImage:[UIImage imageNamed:@"gh"] forState:0];
    _exchangeBtn.adjustsImageWhenHighlighted = NO;
    [_exchangeBtn addTarget:self action:@selector(exchangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_exchangeBtn];
    
    [self layoutSubviews];
}


#pragma mark - action
- (void)iconImageAction:(id)sender
{
    if (_iconBlock) {
        _iconBlock();
    }
}

- (void)deleteBtnClick:(id)sender
{
    if (_deleteBlock) {
        _deleteBlock();
    }
}

- (void)exchangeBtnClick:(id)sender
{
    if (_exchangeBlock) {
        _exchangeBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.bottom.equalTo(self.contentView.bottom);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.height.equalTo(self.deleteBtn.width);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.contentView.top);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.deleteBtn.top);
    }];
    
    [_uploadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.centerX);
        make.centerY.equalTo(self.iconImage.centerY);
        make.size.equalTo(CGSizeMake(25, 25));
    }];
}


// 赋值
- (void)setValueWithArray:(NSArray *)imgurlArray indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == imgurlArray.count) { // 上传
        
        self.deleteBtn.hidden = YES;
        self.exchangeBtn.hidden = YES;
        self.uploadImage.hidden = NO;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage dc_initImageWithColor: [UIColor dc_colorWithHexString:@"#F4F4F4"] size:CGSizeMake(kScreenW, kScreenW)]];
        
    } else {
        
        self.deleteBtn.hidden = NO;
        self.exchangeBtn.hidden = NO;
        self.uploadImage.hidden = YES;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:imgurlArray[indexPath.row]] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    }
}

@end
