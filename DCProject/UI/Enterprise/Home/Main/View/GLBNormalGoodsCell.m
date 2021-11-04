//
//  GLBNormalGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBNormalGoodsCell.h"
#import "GLBGoodsTagView.h"

@interface GLBNormalGoodsCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *shopImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *batchLabel;
@property (nonatomic, strong) UILabel *sellCountLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) GLBGoodsTagView *tagView;
@property (nonatomic, strong) UIImageView *retailImage;
@property (nonatomic, strong) UILabel *retailNowPriceLabel;
@property (nonatomic, strong) UILabel *retailOldPriceLabel;
@property (nonatomic, strong) UIImageView *fullImage;
@property (nonatomic, strong) UILabel *fullNowPriceLabel;
@property (nonatomic, strong) UILabel *fullOldPriceLabel;
@property (nonatomic, strong) UIButton *shoppingCarBtn;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation GLBNormalGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.contentView addSubview:_bgView];
    
    _shopImage = [[UIImageView alloc] init];
    _shopImage.image = [UIImage imageNamed:@"dianpu"];
    [self.contentView addSubview:_shopImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopNameLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _shopNameLabel.text = @"";
    [_bgView addSubview:_shopNameLabel];
    
    _shopNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopNameAction:)];
    [_shopNameLabel addGestureRecognizer:tap];
    
    _sellCountLabel = [[UILabel alloc] init];
    _sellCountLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _sellCountLabel.font = [UIFont fontWithName:PFR size:11];
    _sellCountLabel.text = @"已售0盒";
    _sellCountLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_sellCountLabel];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F7F7"];
    [_bgView addSubview:_line];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    _goodsImage.clipsToBounds = YES;
    [_bgView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"";
    [_bgView addSubview:_titleLabel];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _companyLabel.font = [UIFont fontWithName:PFR size:11];
    _companyLabel.text = @"";
    [_bgView addSubview:_companyLabel];
    
    _batchLabel = [[UILabel alloc] init];
    _batchLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    _batchLabel.font = [UIFont fontWithName:PFR size:11];
    _batchLabel.text = @"";
    [_bgView addSubview:_batchLabel];
    
    _tagView = [[GLBGoodsTagView alloc] init];
    [_bgView addSubview:_tagView];
    
    _retailImage = [[UIImageView alloc] init];
    _retailImage.image = [UIImage imageNamed:@"ling"];
    [_bgView addSubview:_retailImage];
    
    _retailNowPriceLabel = [[UILabel alloc] init];
    _retailNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _retailNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _retailNowPriceLabel.text = @"￥0.00";
    [_bgView addSubview:_retailNowPriceLabel];
    
    _retailOldPriceLabel = [[UILabel alloc] init];
    _retailOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _retailOldPriceLabel.font = PFRFont(12)
    _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥0.00  "];
    [_bgView addSubview:_retailOldPriceLabel];
    
    _fullImage = [[UIImageView alloc] init];
    _fullImage.image = [UIImage imageNamed:@"zheng"];
    [_bgView addSubview:_fullImage];
    
    _fullNowPriceLabel = [[UILabel alloc] init];
    _fullNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _fullNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _fullNowPriceLabel.text = @"￥0.00";
    [_bgView addSubview:_fullNowPriceLabel];
    
    _fullOldPriceLabel = [[UILabel alloc] init];
    _fullOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _fullOldPriceLabel.font = PFRFont(12)
    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥0.00  "];
    [_bgView addSubview:_fullOldPriceLabel];
    
    _shoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shoppingCarBtn setBackgroundImage:[UIImage imageNamed:@"jgwc"] forState:0];
    _shoppingCarBtn.adjustsImageWhenHighlighted = NO;
    [_shoppingCarBtn addTarget:self action:@selector(shoppingCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _shoppingCarBtn.userInteractionEnabled = NO;
    [_bgView addSubview:_shoppingCarBtn];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _tipLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _tipLabel.text = @"登录可见";
    _tipLabel.hidden = YES;
    _tipLabel.userInteractionEnabled = YES;
    [_bgView addSubview:_tipLabel];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipAction:)];
    [_tipLabel addGestureRecognizer:tap1];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)shoppingCarBtnClick:(UIButton *)button
{
    
}


- (void)tipAction:(id)sender
{
    if (_loginBlock) {
        _loginBlock();
    }
}


- (void)shopNameAction:(id)sender
{
    if (_shopNameBlock) {
        _shopNameBlock();
    }
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



#pragma mark - layoutSubviews
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
    
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.height.equalTo(1);
        make.top.equalTo(self.bgView.top).offset(27);
    }];
    
    [_sellCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.bgView.top);
        make.bottom.equalTo(self.line.top);
        make.width.lessThanOrEqualTo(100);
    }];
    
    [_shopImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.centerY.equalTo(self.sellCountLabel.centerY);
        make.width.equalTo(15);
        make.height.equalTo(15);
    }];
    
    [_shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImage.right).offset(5);
        make.right.equalTo(self.sellCountLabel.left).offset(-5);
        make.centerY.equalTo(self.sellCountLabel.centerY);
        make.height.equalTo(35);
    }];
    
    [_goodsImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.line.bottom).offset(10);
        make.width.height.equalTo(90);
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.top);
        make.left.equalTo(self.goodsImage.right).offset(18);
        make.right.equalTo(self.bgView.right).offset(-10);
    }];
    
    [_companyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
    }];
    
    [_batchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyLabel.left);
        make.right.equalTo(self.companyLabel.right);
        make.top.equalTo(self.companyLabel.bottom).offset(5);
    }];
    
//    CGFloat spacing1 = _companyLabel.hidden ? 0 : 10;
    
    [_tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.batchLabel.bottom).offset(10);
        make.right.equalTo(self.titleLabel.right);
        make.height.equalTo(14);
    }];
    
    CGFloat spacing2 = _tagView.hidden ? 0 : 18;
    
    [_retailImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.tagView.bottom).offset(spacing2);
        make.width.height.equalTo(16);
    }];
    
    [_retailNowPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailImage.mas_right).offset(8);
        make.centerY.equalTo(self.retailImage.centerY);
    }];
    
    [_retailOldPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailNowPriceLabel.mas_right).offset(20);
        make.centerY.equalTo(self.retailImage.centerY);
    }];
    
    CGFloat spacing3 = _retailImage.hidden ? 0 : 8;
    [_fullImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.retailImage.bottom).offset(spacing3);
        make.width.height.equalTo(16);
        make.bottom.equalTo(self.bgView.bottom).offset(-17);
    }];
    
    [_fullNowPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullImage.right).offset(8);
        make.centerY.equalTo(self.fullImage.centerY);
    }];
    
    [_fullOldPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullNowPriceLabel.right).offset(20);
        make.centerY.equalTo(self.fullImage.centerY);
    }];

    
    [_shoppingCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.bottom.equalTo(self.bgView.bottom).offset(-19);
        make.width.equalTo(36);
        make.height.equalTo(36);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailImage.left);
        make.top.equalTo(self.retailImage.top);
        make.bottom.equalTo(self.fullImage.bottom);
    }];
}


#pragma mark - setter
- (void)setGoodsModel:(GLBGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    NSString *imgUrl = _goodsModel.imgUrl;
    if (!imgUrl || [imgUrl dc_isNull] || imgUrl.length == 0) {
        imgUrl = _goodsModel.goodsImg;
    }
    
    NSString *title = _goodsModel.infoTitle;
    if (!title || [title dc_isNull] || title.length == 0) {
        title = _goodsModel.goodsName;
    }
    
    _shopNameLabel.text = _goodsModel.suppierFirmName;
    
    if (_goodsModel.batchTotalSale && _goodsModel.batchTotalSale.length > 0 && [_goodsModel.batchTotalSale integerValue] > 0) {
        
        _sellCountLabel.hidden = NO;
        _sellCountLabel.text = [NSString stringWithFormat:@"已售%@盒",_goodsModel.batchTotalSale];
    } else {
        _sellCountLabel.hidden = YES;
    }
    
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",title,_goodsModel.packingSpec];
    _companyLabel.text = _goodsModel.manufactory;
    _batchLabel.text = [NSString stringWithFormat:@"批次：%@",_goodsModel.batchNum];
    
    _retailOldPriceLabel.hidden = YES;
    _fullOldPriceLabel.hidden = YES;
    
    _fullImage.hidden = YES;
    _fullNowPriceLabel.hidden = YES;
    _retailImage.hidden = YES;
    _retailNowPriceLabel.hidden = YES;
    
    if (_goodsModel.sellType == 2) { // 整售
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    } else if (_goodsModel.sellType == 4) { // 零售
        
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    } else if (_goodsModel.sellType == 3) { // 零售 + 整售
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    }
    
    if (_retailNowPriceLabel.hidden == NO && [_goodsModel.zeroPrice floatValue] == 0) {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
    }
    
    if (_fullNowPriceLabel.hidden == NO && [_goodsModel.wholePrice floatValue] == 0) {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
    }
    
    _tagView.goodsModel = _goodsModel;
    
    [self layoutSubviews];
    
}


#pragma mark - 收藏模型
- (void)setCollectModel:(GLBCollectModel *)collectModel
{
    _collectModel = collectModel;
    
    _shopNameLabel.text = _collectModel.suppierFirmName;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_collectModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",_collectModel.goodsName,@"字段缺失"];
    _companyLabel.text = _collectModel.manufactory;
    
    _shoppingCarBtn.hidden = YES;
    _sellCountLabel.hidden = YES;
    _fullOldPriceLabel.hidden = YES;
    _retailOldPriceLabel.hidden = YES;
    _tagView.hidden = YES;
    
    _fullImage.hidden = YES;
    _fullNowPriceLabel.hidden = YES;
    _retailImage.hidden = YES;
    _retailNowPriceLabel.hidden = YES;
    
    if (_collectModel.saleType == 2) { // 整
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_collectModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    } else if (_collectModel.saleType == 4) { // 零
        
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_collectModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        
    } else if (_collectModel.saleType == 3) { // 零 + 整
        
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_collectModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_collectModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    }
    
    if (_retailNowPriceLabel.hidden == NO && [_collectModel.zeroPrice floatValue] == 0) {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
    }
    
    if (_fullNowPriceLabel.hidden == NO && [_collectModel.wholePrice floatValue] == 0) {
        _fullImage.hidden = YES;
        _fullNowPriceLabel.hidden = YES;
    }
   
    [self layoutSubviews];
}


#pragma mark - 分类商品列表模型
- (void)setGoodListModel:(GLBGoodsListModel *)goodListModel
{
    _goodListModel = goodListModel;
    
    _shopNameLabel.text = _goodListModel.suppierFirmName;
    _sellCountLabel.text = [NSString stringWithFormat:@"已售%@盒",_goodListModel.batchTotalSale];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodListModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",_goodListModel.goodsName,_goodListModel.packingSpec];
    _companyLabel.text = _goodListModel.manufactory;
    _batchLabel.text = [NSString stringWithFormat:@"批次：%@",_goodListModel.batchNum];
    
    
    _retailImage.hidden = YES;
    _retailNowPriceLabel.hidden = YES;
    _fullImage.hidden = YES;
    _fullNowPriceLabel.hidden = YES;
    
    if (_goodListModel.sellType == 2) { // 整售
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodListModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    } else if (_goodListModel.sellType == 4) { // 零售
        
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodListModel.zeroPrice ];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    } else if (_goodListModel.sellType == 3) { // 零售 + 整售
        
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodListModel.zeroPrice ];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_goodListModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        
    }
    
    if (_retailNowPriceLabel.hidden == NO && [_goodListModel.zeroPrice floatValue] == 0) {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
    }
    
    if (_fullNowPriceLabel.hidden == NO && [_goodListModel.wholePrice floatValue] == 0) {
        _fullImage.hidden = YES;
        _fullNowPriceLabel.hidden = YES;
    }
    
    _retailOldPriceLabel.hidden = YES;
    _fullOldPriceLabel.hidden = YES;
    
    _tagView.goodsListModel = _goodListModel;
    
    if ([[DCLoginTool shareTool] dc_isLogin]) {
        _tipLabel.hidden = YES;
    } else {
        _tipLabel.hidden = NO;
    }
    
    [self layoutSubviews];
}

@end
