//
//  GLBStoreDetailHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreDetailHeadView.h"
#import "GLBStoreGradeView.h"

@interface GLBStoreDetailHeadView ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *sellLabel;
@property (nonatomic, strong) UILabel *gardeLabel;
@property (nonatomic, strong) GLBStoreGradeView *gradeView;
@property (nonatomic, strong) UILabel *satisfyLabel;

@end

@implementation GLBStoreDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F7F7"];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [self addSubview:_bgImage];

    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:4];
    [self addSubview:_bgView];
    
    _iconImage = [[UIImageView alloc] init];
    [_iconImage dc_cornerRadius:20];
//    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _nameLabel.font = PFRFont(14);
    _nameLabel.numberOfLines = 2;
    [_bgView addSubview:_nameLabel];
    
    _codeLabel = [[UILabel alloc] init];
    _codeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _codeLabel.font = PFRFont(12);
    [_bgView addSubview:_codeLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _typeLabel.font = PFRFont(13);
    [_bgView addSubview:_typeLabel];
    
    _sellLabel = [[UILabel alloc] init];
    _sellLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _sellLabel.font = PFRFont(13);
    [_bgView addSubview:_sellLabel];
    
    
    _gardeLabel = [[UILabel alloc] init];
    _gardeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _gardeLabel.font = PFRFont(13);
    _gardeLabel.text = @"等级";
    [_bgView addSubview:_gardeLabel];
    
    _gradeView = [[GLBStoreGradeView alloc] init];
    [_bgView addSubview:_gradeView];
    
    _satisfyLabel = [[UILabel alloc] init];
    _satisfyLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _satisfyLabel.font = PFRFont(13);
    [_bgView addSubview:_satisfyLabel];
    
    
    _careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _careBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    [_careBtn setTitle:@"关注" forState:0];
    [_careBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [_careBtn setTitleColor:[UIColor whiteColor] forState:0];
    _careBtn.titleLabel.font = PFRFont(12);
    [_careBtn addTarget:self action:@selector(careBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_careBtn dc_cornerRadius:10];
    [_bgView addSubview:_careBtn];
    
    
    [self layoutSubviews];
}


#pragma mark - action
- (void)careBtnClick:(UIButton *)button
{
    if (_careBtnBlock) {
        _careBtnBlock();
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



#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 46, 0));
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.top.equalTo(self.top).offset(kNavBarHeight + 8);
        make.bottom.equalTo(self.bottom).offset(-8);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(26);
        make.top.equalTo(self.bgView.top).offset(28);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(25);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.iconImage.top).offset(-5);
    }];
    
//    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLabel.right);
//        make.centerY.equalTo(self.nameLabel.centerY);
//    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(20);
    }];
    
    [_sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.right).offset(12);
        make.centerY.equalTo(self.typeLabel.centerY);
    }];
    
    
    [_gardeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.typeLabel.bottom).offset(10);
    }];
    
    [_gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gardeLabel.right).offset(10);
        make.centerY.equalTo(self.gardeLabel.centerY);
        make.size.equalTo(CGSizeMake(90, 10));
    }];
    
    [_satisfyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gradeView.right).offset(20);
        make.centerY.equalTo(self.gradeView.centerY);
    }];
    
    [_careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.centerX);
        make.top.equalTo(self.iconImage.bottom).offset(15);
        make.size.equalTo(CGSizeMake(47, 20));
    }];
}


#pragma mark - setter
- (void)setStoreModel:(GLBStoreModel *)storeModel
{
    _storeModel = storeModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_storeModel.storeInfoVO.logoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _nameLabel.attributedText = [self dc_attributeStr:_storeModel.storeInfoVO.storeName code:_storeModel.storeInfoVO.firmId];
    _satisfyLabel.attributedText = [self attributeStr:@"满意度" afterStr:[NSString stringWithFormat:@"%@",_storeModel.storeInfoVO.storeServiceStar]];
    _sellLabel.attributedText = [self attributeStr:@"发货" afterStr:[NSString stringWithFormat:@"%ld件",_storeModel.storeInfoVO.sendCount]];;
    _typeLabel.attributedText = [self attributeStr:@"上架" afterStr:[NSString stringWithFormat:@"%ld种",_storeModel.storeInfoVO.goodsCount]];
    
    _gradeView.grade = [_storeModel.storeInfoVO.storeStar integerValue];
    
    _careBtn.selected = _storeModel.isCollected;
}


#pragma mark -
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)name code:(NSString *)code
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(编码:%@)",name,code]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"],NSFontAttributeName:[UIFont fontWithName:PFR size:14]} range:NSMakeRange(0, name.length)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:PFR size:12]} range:NSMakeRange(name.length, attrStr.length - name.length)];
    return attrStr;
}

@end
