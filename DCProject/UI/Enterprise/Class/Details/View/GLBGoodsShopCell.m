//
//  GLBGoodsShopCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsShopCell.h"
#import "GLBStoreGradeView.h"

@interface GLBGoodsShopCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *sellLabel;
@property (nonatomic, strong) UILabel *evaluateLabel;
@property (nonatomic, strong) UILabel *gardeLabel;
@property (nonatomic, strong) GLBStoreGradeView *gradeView;
@property (nonatomic, strong) UILabel *satisfyLabel;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation GLBGoodsShopCell

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
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLabel.text = @"店铺信息";
    [self.contentView addSubview:_titleLabel];
    
    _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailBtn setTitle:@"进入店铺" forState:0];
    [_detailBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _detailBtn.titleLabel.font = PFRFont(14);
    [_detailBtn setImage:[UIImage imageNamed:@"dc_arrow_right_cl"] forState:0];
    _detailBtn.adjustsImageWhenHighlighted = NO;
    [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _detailBtn.bounds = CGRectMake(0, 0, 100, 36);
    [_detailBtn dc_buttonIconRightWithSpacing:5];
    [self.contentView addSubview:_detailBtn];
    
    _iconImage = [[UIImageView alloc] init];
//    _iconImage.backgroundColor = [UIColor redColor];
    [_iconImage dc_cornerRadius:20];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _nameLabel.font = PFRFont(14);
//    _nameLabel.text = @"源安堂旗舰店";
    [self.contentView addSubview:_nameLabel];
    
//    _codeLabel = [[UILabel alloc] init];
//    _codeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
//    _codeLabel.font = PFRFont(12);
//    _codeLabel.text = @"（编码：2301014574）";
//    [self.contentView addSubview:_codeLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _typeLabel.font = PFRFont(12);
//    _typeLabel.attributedText = [self attributeStr:@"上架" afterStr:@"2203种"];
    [self.contentView addSubview:_typeLabel];
    
    _sellLabel = [[UILabel alloc] init];
    _sellLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _sellLabel.font = PFRFont(12);
//    _sellLabel.attributedText = [self attributeStr:@"发货" afterStr:@"124.5万件"];;
    [self.contentView addSubview:_sellLabel];
    
    _evaluateLabel = [[UILabel alloc] init];
    _evaluateLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _evaluateLabel.font = PFRFont(12);
//    _evaluateLabel.attributedText = [self attributeStr:@"评价" afterStr:@"2.5万条"];;
    [self.contentView addSubview:_evaluateLabel];
    
    _gardeLabel = [[UILabel alloc] init];
    _gardeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _gardeLabel.font = PFRFont(12);
    _gardeLabel.text = @"等级";
    [self.contentView addSubview:_gardeLabel];
    
    _gradeView = [[GLBStoreGradeView alloc] init];
    [self.contentView addSubview:_gradeView];
    
    _satisfyLabel = [[UILabel alloc] init];
    _satisfyLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _satisfyLabel.font = PFRFont(12);
//    _satisfyLabel.attributedText = [self attributeStr:@"满意度" afterStr:@"5.0"];;
    [self.contentView addSubview:_satisfyLabel];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FFECD0"];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _tipLabel.font = PFRFont(11);
    _tipLabel.text = @" 订单满1000.00元免运费，不满收取20.00元运费 ";
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.hidden = YES;
    [_tipLabel dc_cornerRadius:2];
    [self.contentView addSubview:_tipLabel];
    
    [self layoutSubviews];
}


#pragma mark - action
- (void)detailBtnClick:(UIButton *)button
{
    if (_openStoreBlock) {
        _openStoreBlock();
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
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.size.equalTo(CGSizeMake(100, 36));
    }];
    
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(100, 36));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.titleLabel.bottom).offset(8);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(25);
        make.top.equalTo(self.iconImage.top).offset(-3);
    }];
    
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right);
        make.centerY.equalTo(self.nameLabel.centerY);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(10);
    }];
    
    [_sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.right).offset(15);
        make.centerY.equalTo(self.typeLabel.centerY);
    }];
    
    [_evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sellLabel.right).offset(15);
        make.centerY.equalTo(self.sellLabel.centerY);
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
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.gardeLabel.bottom).offset(12);
        make.height.equalTo(16);
        make.bottom.equalTo(self.contentView.bottom).offset(-15);
    }];
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    GLBGoodsDetailStoreModel *storeModel = detailModel.storeInfo;
    
    // 字段缺失
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:storeModel.logoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _nameLabel.text = storeModel.storeName;
//    _codeLabel.text = [NSString stringWithFormat:@"(编码：%@)",_detailModel.suppierFirmId];
    
    _typeLabel.attributedText = [self attributeStr:@"上架" afterStr:[NSString stringWithFormat:@"%ld种",(long)storeModel.goodsCount]];
    _sellLabel.attributedText = [self attributeStr:@"发货" afterStr:[NSString stringWithFormat:@"%ld件",(long)storeModel.sendCount]];
    _evaluateLabel.attributedText = [self attributeStr:@"评价" afterStr:[NSString stringWithFormat:@"%ld条",(long)storeModel.evalCount]];
     _satisfyLabel.attributedText = [self attributeStr:@"满意度" afterStr:storeModel.storeServiceStar];
    
    _gradeView.grade = [storeModel.storeStar integerValue];
    if (storeModel.freight && storeModel.freight.length > 0) {
        _tipLabel.text = [NSString stringWithFormat:@" %@ ",storeModel.freight];
        _tipLabel.hidden = NO;
    } else {
        _tipLabel.hidden = YES;
    }
    
    [self layoutSubviews];
}

@end
