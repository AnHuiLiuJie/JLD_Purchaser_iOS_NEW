//
//  GLPInvalidGoodsCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/15.
//

#import "GLPInvalidGoodsCell.h"

@interface GLPInvalidGoodsCell ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *spacLabel;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation GLPInvalidGoodsCell

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
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"dc_goodsBg_no"];
    //_bgImage.hidden = YES;
    [self.contentView addSubview:_bgImage];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.enabled = NO;
    [_editBtn setTitle:@"失效" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor dc_colorWithHexString:@"#666666" alpha:1] forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _editBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor alpha:1];
    //[_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    _editBtn.layer.masksToBounds = YES;
    _editBtn.layer.cornerRadius = 15;
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    _goodsImage.image = [UIImage imageNamed:@"img1"];
    [self.contentView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666" alpha:0.7];;
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _spacLabel = [[UILabel alloc] init];
    _spacLabel.textColor = [UIColor dc_colorWithHexString:@"#999999" alpha:0.7];;
    _spacLabel.font = [UIFont fontWithName:PFR size:14];
    [self.contentView addSubview:_spacLabel];
    
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4A13" alpha:0.7];
    _promptLabel.font = [UIFont fontWithName:PFR size:13];
    _promptLabel.numberOfLines = 2;
    _promptLabel.text = @"本品为处方药，须凭处方购买。按照规定，100日内限购数量2000盒";
    //_promptLabel.attributedText = [NSString dc_strikethroughWithString:@"市场价￥0.00"];
    _promptLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_promptLabel];
    
    [self layoutIfNeeded];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(13);
        make.left.equalTo(self.contentView.left).offset(60+10+10);
        make.size.equalTo(CGSizeMake(84, 84));
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodsImage.centerY);
        make.left.equalTo(self.contentView.left).offset(10);
        make.size.equalTo(CGSizeMake(60, 30));
    }];
        
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.right).offset(7);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.goodsImage.top).offset(0);
    }];
    
    [_spacLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(3);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.spacLabel.bottom).offset(0);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}



#pragma mark - setter
- (void)setModel:(GLPNewShopCarGoodsModel *)model{
    _model = model;
    
//    _bgImage.hidden = YES;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _model.goodsTitle;
    
    _spacLabel.text = _model.packingSpec;
    
    _promptLabel.text = _model.tips;
}



#pragma mark - 富文本
- (NSMutableAttributedString *)attributeWithMoney:(NSString *)money
{
    NSString *text = [NSString stringWithFormat:@"单品小计：¥%@",money];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSString *floStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(0, 5)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(5, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(6, attrStr.length - 6)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:range2];
    
    return attrStr;
}

@end
