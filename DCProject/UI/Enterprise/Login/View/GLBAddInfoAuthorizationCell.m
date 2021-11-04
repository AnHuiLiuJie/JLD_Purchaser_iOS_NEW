//
//  GLBAddInfoAuthorizationCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
///product"

#import "GLBAddInfoAuthorizationCell.h"

@interface GLBAddInfoAuthorizationCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *showImageBtn;
@property (nonatomic, strong) UIButton *showTitleBtn;

@end

@implementation GLBAddInfoAuthorizationCell

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
    _titleLabel.text = @"授权委托书上传";
    [self.contentView addSubview:_titleLabel];
    
    _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadBtn setTitle:@"下载模板" forState:0];
    [_downloadBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _downloadBtn.titleLabel.font = PFRFont(14);
    _downloadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_downloadBtn];
    
    _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uploadBtn setImage:[UIImage imageNamed:@"tjzp"] forState:0];
    _uploadBtn.adjustsImageWhenHighlighted = NO;
    _uploadBtn.contentMode = UIViewContentModeScaleAspectFill;
    _uploadBtn.clipsToBounds = YES;
    [_uploadBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_uploadBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"dc_scq_bai"] forState:0];
    _deleteBtn.adjustsImageWhenHighlighted = NO;
    _deleteBtn.hidden = YES;
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];

    _showImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showImageBtn.backgroundColor = [UIColor redColor];
    [_showImageBtn setImage:[UIImage imageNamed:@"dc_placeholder_bg"] forState:0];
    _showImageBtn.adjustsImageWhenHighlighted = NO;
    [_showImageBtn addTarget:self action:@selector(showImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showImageBtn];
    
    _showTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showTitleBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#000000" alpha:0.5];
    [_showTitleBtn setTitle:@"点击查看示例" forState:0];
    [_showTitleBtn setTitleColor:[UIColor whiteColor] forState:0];
    _showTitleBtn.titleLabel.font = PFRFont(12);
    [_showTitleBtn addTarget:self action:@selector(showImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showTitleBtn];
    
    [self layoutIfNeeded];
}



#pragma mark - action
- (void)downloadBtnClick:(UIButton *)button
{
    
}

- (void)uploadBtnClick:(UIButton *)button
{
    
}

- (void)deleteBtnClick:(UIButton *)button
{
    
}

- (void)showImageBtnClick:(UIButton *)button
{
    
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemW = (kScreenW - 15*2 - 24)/2;
    CGFloat itemH = itemW *0.62;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(40);
    }];
    
    [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(100, 40));
    }];
    
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.titleLabel.bottom);
        make.bottom.equalTo(self.contentView.bottom).offset(-25);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadBtn.top);
        make.right.equalTo(self.uploadBtn.right);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_showImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uploadBtn.right).offset(24);
        make.centerY.equalTo(self.uploadBtn.centerY);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_showTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showImageBtn.left);
        make.right.equalTo(self.showImageBtn.right);
        make.bottom.equalTo(self.showImageBtn.bottom);
        make.height.equalTo(30);
    }];
    
}

@end
