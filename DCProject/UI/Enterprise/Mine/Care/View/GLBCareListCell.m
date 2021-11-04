//
//  GLBCareListCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCareListCell.h"
#import "GLBStoreRangView.h"

@interface GLBCareListCell ()
{
    CGFloat _spacing;
    CGFloat _btnWidth;
    CGFloat _btnHeight;
}

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *sellLabel;
@property (nonatomic, strong) UILabel *evaluateLabel;
@property (nonatomic, strong) UIView *ticketView;
@property (nonatomic, strong) UIButton *goodsBtn1;
@property (nonatomic, strong) UIButton *goodsBtn2;
@property (nonatomic, strong) UIButton *goodsBtn3;
@property (nonatomic, strong) UILabel *goodslabel1;
@property (nonatomic, strong) UILabel *goodslabel2;
@property (nonatomic, strong) UILabel *goodslabel3;
@property (nonatomic, strong) GLBStoreRangView *tagView;

@end

@implementation GLBCareListCell

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
    
    [self.contentView dc_cornerRadius:5];
    
    _spacing = 28;
    _btnWidth = (kScreenW - 10*2 - 15*2 - _spacing*2)/3;
    _btnHeight = _btnWidth;
    
    _iconImage = [[UIImageView alloc] init];
//    _iconImage.backgroundColor = [UIColor redColor];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:20];
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.numberOfLines = 0;
//    _titleLabel.text = @"源安堂旗舰店";
    [self.contentView addSubview:_titleLabel];
    
//    _codeLabel = [[UILabel alloc] init];
//    _codeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
//    _codeLabel.font = PFRFont(12);
////    _codeLabel.text = @"（编码：2301014574）";
//    [self.contentView addSubview:_codeLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _typeLabel.font = PFRFont(12);
    [self.contentView addSubview:_typeLabel];
    
    _sellLabel = [[UILabel alloc] init];
    _sellLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _sellLabel.font = PFRFont(12);
    [self.contentView addSubview:_sellLabel];
    
    _evaluateLabel = [[UILabel alloc] init];
    _evaluateLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _evaluateLabel.font = PFRFont(12);
    [self.contentView addSubview:_evaluateLabel];
    
    _ticketView = [[UIView alloc] init];
    _ticketView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_ticketView];
    
    _goodsBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsBtn1 setImage:[UIImage imageNamed:@"placher-3"] forState:0];
    _goodsBtn1.contentMode = UIViewContentModeScaleAspectFill;
    _goodsBtn1.clipsToBounds = YES;
    _goodsBtn1.tag = 1;
    [_goodsBtn1 addTarget:self action:@selector(goodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodsBtn1];
    
    _goodsBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsBtn2 setImage:[UIImage imageNamed:@"placher-3"] forState:0];
    _goodsBtn2.contentMode = UIViewContentModeScaleAspectFill;
    _goodsBtn2.clipsToBounds = YES;
    _goodsBtn2.titleLabel.font = PFRFont(14);
    _goodsBtn2.tag = 2;
    [_goodsBtn2 addTarget:self action:@selector(goodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodsBtn2];
    
    _goodsBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsBtn3 setImage:[UIImage imageNamed:@"placher-3"] forState:0];
    _goodsBtn3.contentMode = UIViewContentModeScaleAspectFill;
    _goodsBtn3.clipsToBounds = YES;
    _goodsBtn3.tag = 3;
    [_goodsBtn3 addTarget:self action:@selector(goodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_goodsBtn3];
    
    _goodslabel1 = [[UILabel alloc] init];
    _goodslabel1.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _goodslabel1.font = PFRFont(14);
    _goodslabel1.textAlignment = NSTextAlignmentCenter;
//    _goodslabel1.text = @"￥5.880";
    [self.contentView addSubview:_goodslabel1];
    
    _goodslabel2 = [[UILabel alloc] init];
    _goodslabel2.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _goodslabel2.font = PFRFont(14);
    _goodslabel2.textAlignment = NSTextAlignmentCenter;
//    _goodslabel2.text = @"￥5.880";
    [self.contentView addSubview:_goodslabel2];
    
    _goodslabel3 = [[UILabel alloc] init];
    _goodslabel3.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _goodslabel3.font = PFRFont(14);
    _goodslabel3.textAlignment = NSTextAlignmentCenter;
//    _goodslabel3.text = @"￥5.880";
    [self.contentView addSubview:_goodslabel3];
    
    _tagView = [[GLBStoreRangView alloc] init];
    [self.contentView addSubview:_tagView];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)goodsBtnClick:(UIButton *)button
{
    if (_goodsBlock) {
        _goodsBlock(button.tag);
    }
}


#pragma mark - attributeStr
- (NSMutableAttributedString *)attributeStr:(NSString *)prefixStr afterStr:(NSString *)afterStr
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",prefixStr,afterStr]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(0, prefixStr.length)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(attrStr.length - afterStr.length, afterStr.length)];
    return attrStr;
}


#pragma mark - 适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image = [UIImage imageNamed:@"dc_gx_no"];
                    }
                }
            }
        }
    }
}


#pragma mark -
- (void)layoutSubviews {
    
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image = [UIImage imageNamed:@"dc_gx_yes"];
                    }else
                    {
                        img.image = [UIImage imageNamed:@"dc_gx_no"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
    
    CGFloat spacing = _spacing;
    CGFloat width = _goodsBtn1.hidden ? 0 : _btnWidth;
    CGFloat height = _btnHeight;
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top).offset(18);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(25);
        make.top.equalTo(self.iconImage.top).offset(-3);
        make.right.equalTo(self.contentView.right).offset(-15);
    }];
    
//    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.right);
//        make.centerY.equalTo(self.titleLabel.centerY);
//    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];
    
    [_sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.right).offset(15);
        make.centerY.equalTo(self.typeLabel.centerY);
    }];
    
    [_evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sellLabel.right).offset(15);
        make.centerY.equalTo(self.sellLabel.centerY);
    }];
    
    [_ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.typeLabel.bottom).offset(5);
        make.height.equalTo(16);
    }];
    
    [_goodsBtn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.iconImage.bottom).offset(23);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_goodsBtn2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsBtn1.right).offset(spacing);
        make.centerY.equalTo(self.goodsBtn1.centerY);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_goodsBtn3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsBtn2.right).offset(spacing);
        make.centerY.equalTo(self.goodsBtn2.centerY);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_goodslabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodsBtn1.centerX);
        make.top.equalTo(self.goodsBtn1.bottom);
    }];
    
    [_goodslabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodsBtn2.centerX);
        make.top.equalTo(self.goodsBtn2.bottom);
    }];
    
    [_goodslabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodsBtn3.centerX);
        make.top.equalTo(self.goodsBtn3.bottom);
    }];
    
    [_tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.goodsBtn1.bottom).offset(40);
        make.height.equalTo(18);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
}


- (NSMutableAttributedString *)dc_attributeStr:(NSString *)string1 string2:(NSString *)string2
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(编码：%@)",string1,string2]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#303D55"]} range:NSMakeRange(0, string1.length)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(string1.length, attStr.length - string1.length)];
    return attStr;
}



#pragma mark - setter
- (void)setCareModel:(GLBCareModel *)careModel
{
    _careModel = careModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_careModel.logoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.attributedText = [self dc_attributeStr:_careModel.firmName string2:_careModel.objectId] ;
//    _codeLabel.text = [NSString stringWithFormat:@"(编码：%@)",_careModel.objectId];
    _typeLabel.attributedText = [self attributeStr:@"上架" afterStr:[NSString stringWithFormat:@"%ld种",(long)_careModel.statistics.goodsCount]];
    _sellLabel.attributedText = [self attributeStr:@"发货" afterStr:[NSString stringWithFormat:@"%ld件",(long)_careModel.statistics.sendCount]];
    _evaluateLabel.attributedText = [self attributeStr:@"评价" afterStr:[NSString stringWithFormat:@"%ld条",(long)_careModel.statistics.evalCount]];
    _ticketView.hidden = YES;
    
    _goodsBtn1.hidden = YES;
    _goodsBtn2.hidden = YES;
    _goodsBtn3.hidden = YES;
    _goodslabel1.hidden = YES;
    _goodslabel2.hidden = YES;
    _goodslabel3.hidden = YES;
    
    _tagView.hidden = YES;
    
    for (int i=0; i<_careModel.goods.count; i++) {
        GLBCareGoodsModel *goodsModel = _careModel.goods[i];
        if (i==0) {
            
            _goodsBtn1.hidden = NO;
            _goodslabel1.hidden = NO;
            [_goodsBtn1 sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] forState:0 placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            _goodslabel1.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.price];
            _goodslabel1 = [UILabel setupAttributeLabel:_goodslabel1 textColor:_goodslabel1.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        } else if (i==1) {
            
            _goodsBtn2.hidden = NO;
            _goodslabel2.hidden = NO;
            [_goodsBtn2 sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] forState:0 placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            _goodslabel2.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.price];
            _goodslabel2 = [UILabel setupAttributeLabel:_goodslabel2 textColor:_goodslabel2.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        } else if (i==2) {
            
            _goodsBtn3.hidden = NO;
            _goodslabel3.hidden = NO;
            [_goodsBtn3 sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] forState:0 placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            _goodslabel3.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.price];
            _goodslabel3 = [UILabel setupAttributeLabel:_goodslabel3 textColor:_goodslabel3.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        }
    }
    
    [self layoutSubviews];
}


- (void)setStoreModel:(GLBStoreListModel *)storeModel
{
    _storeModel = storeModel;

    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_storeModel.logoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _storeModel.firmName;
    _codeLabel.text = [NSString stringWithFormat:@"(编码：%@)",_storeModel.statistics.firmId];
    _typeLabel.attributedText = [self attributeStr:@"上架" afterStr:[NSString stringWithFormat:@"%ld种",(long)_storeModel.statistics.goodsCount]];
    _sellLabel.attributedText = [self attributeStr:@"发货" afterStr:[NSString stringWithFormat:@"%ld件",(long)_storeModel.statistics.sendCount]];
    _evaluateLabel.attributedText = [self attributeStr:@"评价" afterStr:[NSString stringWithFormat:@"%ld条",(long)_storeModel.statistics.evalCount]];
    _ticketView.hidden = YES;
    
    _goodsBtn1.hidden = YES;
    _goodsBtn2.hidden = YES;
    _goodsBtn3.hidden = YES;
    _goodslabel1.hidden = YES;
    _goodslabel2.hidden = YES;
    _goodslabel3.hidden = YES;
    
    _tagView.rangArray = _storeModel.scopeList;
    
    for (int i=0; i<_storeModel.goodslist.count; i++) {
        GLBStoreListGoodsModel *goodsModel = _storeModel.goodslist[i];
        if (i==0) {
            
            _goodsBtn1.hidden = NO;
            _goodslabel1.hidden = NO;
            [_goodsBtn1 sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] forState:0 placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            _goodslabel1.text = [NSString stringWithFormat:@"¥%@",goodsModel.zeroNotaxPrice];
            _goodslabel1 = [UILabel setupAttributeLabel:_goodslabel1 textColor:_goodslabel1.textColor minFont:nil maxFont:nil forReplace:@"¥"];

        } else if (i==1) {
            
            _goodsBtn2.hidden = NO;
            _goodslabel2.hidden = NO;
            [_goodsBtn2 sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] forState:0 placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            _goodslabel2.text = [NSString stringWithFormat:@"¥%@",goodsModel.zeroNotaxPrice];
            _goodslabel2 = [UILabel setupAttributeLabel:_goodslabel2 textColor:_goodslabel2.textColor minFont:nil maxFont:nil forReplace:@"¥"];
            
        } else if (i==2) {
            
            _goodsBtn3.hidden = NO;
            _goodslabel3.hidden = NO;
            [_goodsBtn3 sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] forState:0 placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
            _goodslabel3.text = [NSString stringWithFormat:@"¥%@",goodsModel.zeroNotaxPrice];
            _goodslabel3 = [UILabel setupAttributeLabel:_goodslabel3 textColor:_goodslabel3.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        }
    }
    
    [self layoutSubviews];
}

@end
