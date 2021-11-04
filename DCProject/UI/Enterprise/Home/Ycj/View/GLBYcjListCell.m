//
//  GLBYcjListCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBYcjListCell.h"
#import "GLBYcjTypeView.h"

@interface GLBYcjListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *fullCountLabel;
@property (nonatomic, strong) UILabel *sellCountLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) GLBYcjTypeView *typeView;

@end

@implementation GLBYcjListCell

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImage.clipsToBounds = YES;
    [_bgView addSubview:_iconImage];
    self.iconImage.layer.minificationFilter = kCAFilterTrilinear;

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
    
    _fullCountLabel = [[UILabel alloc] init];
    _fullCountLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _fullCountLabel.font = [UIFont fontWithName:PFR size:12];
    _fullCountLabel.text = @"件装量：0盒";
    [_bgView addSubview:_fullCountLabel];
    
    _sellCountLabel = [[UILabel alloc] init];
    _sellCountLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _sellCountLabel.font = [UIFont fontWithName:PFR size:12];
    _sellCountLabel.textAlignment = NSTextAlignmentRight;
    _sellCountLabel.text = @"已购量：0盒";
    [_bgView addSubview:_sellCountLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _priceLabel.font = [UIFont fontWithName:PFR size:12];
    _priceLabel.attributedText = [self dc_attributeStr:@"0.00"];
    [_bgView addSubview:_priceLabel];
    
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    [_buyBtn setTitle:@"立即抢购" forState:0];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:0];
    _buyBtn.titleLabel.font = PFRFont(13);
    [_buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBtn dc_cornerRadius:2];
    _buyBtn.userInteractionEnabled = NO;
    [_bgView addSubview:_buyBtn];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_line];
    
    _typeView = [[GLBYcjTypeView alloc] init];
    [_bgView addSubview:_typeView];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)buyBtnClick:(UIButton *)button
{
    
}


#pragma mark -
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)price
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价 ¥%@",price]];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:16],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF9900"]} range:NSMakeRange(2, attrStr.length - 2)];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 2)];
    return attrStr;
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).equalTo(UIEdgeInsetsMake(5, 10, 0, 10));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.bgView.top).offset(10);
        make.size.equalTo(CGSizeMake(90, 90));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.iconImage.top);
    }];
    
    [_fullCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.iconImage.bottom);
        make.width.lessThanOrEqualTo(100);
    }];
    
    [_sellCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fullCountLabel.centerY);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.left.equalTo(self.fullCountLabel.right);
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(6);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.fullCountLabel.bottom).offset(20);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.priceLabel.centerY);
        make.size.equalTo(CGSizeMake(70, 32));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.priceLabel.bottom).offset(20);
        make.height.equalTo(1);
    }];
    
    CGFloat height = _goodsModel.roles.count *32 + 20;
    [_typeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.line.bottom);
        make.bottom.equalTo(self.bgView.bottom);
        make.height.equalTo(height);
    }];
    
}


#pragma mark - setter
- (void)setGoodsModel:(GLBYcjGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",_goodsModel.goodsName,_goodsModel.packingSpec];
    _companyLabel.text = _goodsModel.manufactory;
    _fullCountLabel.text = [NSString stringWithFormat:@"件装量：%ld%@",(long)_goodsModel.pkgPackingNum,_goodsModel.chargeUnit];
    _sellCountLabel.text = [NSString stringWithFormat:@"已购量：%ld%@",(long)_goodsModel.buyAmount,_goodsModel.chargeUnit];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_goodsModel.roles.count; i++) {
        GLBYcjRolesModel *rolesModel = _goodsModel.roles[i];
        rolesModel.chargeUnit = _goodsModel.chargeUnit;
        [array addObject:rolesModel];
    }
    
    _typeView.rolesArray = array;
    _priceLabel.attributedText = [self dc_attributeStr:[NSString stringWithFormat:@"%@",_goodsModel.price]];
    
    [self layoutSubviews];
}

@end
