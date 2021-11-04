//
//  GLBStoreEvaluateHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreEvaluateHeadView.h"

@interface GLBStoreEvaluateHeadView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *goodBtn;
@property (nonatomic, strong) UIButton *generalBtn;
@property (nonatomic, strong) UIButton *badBtn;

@end

@implementation GLBStoreEvaluateHeadView

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
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 40)];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _titleLabel.text = @"满意度";
    [self addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, kScreenW - CGRectGetMaxX(self.titleLabel.frame) - 15, 40)];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _descLabel.font = PFRFont(11);
    _descLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_descLabel];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenW, 5)];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    [self addSubview:_line];
    
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allBtn.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame), kScreenW/4, 60);
    [_allBtn setAttributedTitle:[self dc_normalAttributeStr:@"全部" afterStr:@"0"] forState:0];
    [_allBtn setAttributedTitle:[self dc_selectedAttributeStr:@"全部" afterStr:@"0"] forState:UIControlStateSelected];
    _allBtn.titleLabel.numberOfLines = 0;
    _allBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _allBtn.tag = 800;
    [_allBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _allBtn.selected = YES;
    [self addSubview:_allBtn];
    
    _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goodBtn.frame = CGRectMake(CGRectGetMaxX(self.allBtn.frame), CGRectGetMinY(self.allBtn.frame), kScreenW/4, CGRectGetHeight(self.allBtn.frame));
    [_goodBtn setAttributedTitle:[self dc_normalAttributeStr:@"好评" afterStr:@"0"] forState:0];
    [_goodBtn setAttributedTitle:[self dc_selectedAttributeStr:@"好评" afterStr:@"0"] forState:UIControlStateSelected];
    _goodBtn.titleLabel.numberOfLines = 0;
    _goodBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _goodBtn.tag = 801;
    [_goodBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_goodBtn];
    
    _generalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _generalBtn.frame = CGRectMake(CGRectGetMaxX(self.goodBtn.frame), CGRectGetMinY(self.allBtn.frame), kScreenW/4, CGRectGetHeight(self.allBtn.frame));
    [_generalBtn setAttributedTitle:[self dc_normalAttributeStr:@"一般" afterStr:@"0"] forState:0];
    [_generalBtn setAttributedTitle:[self dc_selectedAttributeStr:@"一般" afterStr:@"0"] forState:UIControlStateSelected];
    _generalBtn.titleLabel.numberOfLines = 0;
    _generalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _generalBtn.tag = 802;
    _generalBtn.adjustsImageWhenHighlighted = NO;
    [_generalBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_generalBtn];
    
    _badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _badBtn.frame = CGRectMake(CGRectGetMaxX(self.generalBtn.frame), CGRectGetMinY(self.allBtn.frame), kScreenW/4, CGRectGetHeight(self.allBtn.frame));
    [_badBtn setAttributedTitle:[self dc_normalAttributeStr:@"不满意" afterStr:@"0"] forState:0];
    [_badBtn setAttributedTitle:[self dc_selectedAttributeStr:@"不满意" afterStr:@"0"] forState:UIControlStateSelected];
    _badBtn.titleLabel.numberOfLines = 0;
    _badBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _badBtn.tag = 803;
    [_badBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_badBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)btnClick:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    self.allBtn.selected = NO;
    self.goodBtn.selected = NO;
    self.generalBtn.selected = NO;
    self.badBtn.selected = NO;
    
    button.selected = YES;
    
    if (_evaluetaBtnBlock) {
        _evaluetaBtnBlock(button.tag);
    }
}


#pragma mark -
- (NSMutableAttributedString *)dc_normalAttributeStr:(NSString *)beforeStr afterStr:(NSString *)afterStr
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",beforeStr,afterStr]];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(0, beforeStr.length)];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(attributeStr.length - afterStr.length, afterStr.length)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    style.alignment = NSTextAlignmentCenter;
    [attributeStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributeStr.length)];
    
    return attributeStr;
}

#pragma mark -
- (NSMutableAttributedString *)dc_selectedAttributeStr:(NSString *)beforeStr afterStr:(NSString *)afterStr
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",beforeStr,afterStr]];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(0, beforeStr.length)];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(attributeStr.length - afterStr.length, afterStr.length)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    style.alignment = NSTextAlignmentCenter;
    [attributeStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributeStr.length)];
    
    return attributeStr;
}


#pragma mark - setter
- (void)setDetailModel:(GLBEvaluateDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    [_allBtn setAttributedTitle:[self dc_normalAttributeStr:@"全部" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.allCount]] forState:0];
    [_allBtn setAttributedTitle:[self dc_selectedAttributeStr:@"全部" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.allCount]] forState:UIControlStateSelected];
     
     
     [_goodBtn setAttributedTitle:[self dc_normalAttributeStr:@"好评" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.favorite]] forState:0];
     [_goodBtn setAttributedTitle:[self dc_selectedAttributeStr:@"好评" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.favorite]] forState:UIControlStateSelected];
    
    [_generalBtn setAttributedTitle:[self dc_normalAttributeStr:@"一般" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.kind]] forState:0];
    [_generalBtn setAttributedTitle:[self dc_selectedAttributeStr:@"一般" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.kind]] forState:UIControlStateSelected];
    
    [_badBtn setAttributedTitle:[self dc_normalAttributeStr:@"不满意" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.bad]] forState:0];
    [_badBtn setAttributedTitle:[self dc_selectedAttributeStr:@"不满意" afterStr:[NSString stringWithFormat:@"%ld",(long)_detailModel.bad]] forState:UIControlStateSelected];
    
    _descLabel.text = [NSString stringWithFormat:@"商品%.0f%@   物流%.0f%@   服务%.0f%@ ",_detailModel.goodsPercent*100,@"%",_detailModel.deliveryPercent*100,@"%",_detailModel.servicePercent*100,@"%"];
}

@end
