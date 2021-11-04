//
//  GLBGoodsInfoCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsInfoCell.h"

@interface GLBGoodsInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UILabel *nameTitleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *packTitleLabel;
@property (nonatomic, strong) UILabel *packLabel;
@property (nonatomic, strong) UILabel *compantTitleLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *numTitleLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *countTitleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *endtimeTitleLabel;
@property (nonatomic, strong) UILabel *endtimeLabel;
@property (nonatomic, strong) UILabel *starttimeTitleLabel;
@property (nonatomic, strong) UILabel *starttimeLabel;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation GLBGoodsInfoCell

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
    _titleLabel.text = @"商品信息";
    [self.contentView addSubview:_titleLabel];
    
    _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailBtn setTitle:@"查看详情" forState:0];
    [_detailBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _detailBtn.titleLabel.font = PFRFont(14);
    [_detailBtn setImage:[UIImage imageNamed:@"dc_arrow_right_cl"] forState:0];
    _detailBtn.adjustsImageWhenHighlighted = NO;
    [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _detailBtn.bounds = CGRectMake(0, 0, 100, 36);
    [_detailBtn dc_buttonIconRightWithSpacing:5];
    [self.contentView addSubview:_detailBtn];
    
    _nameTitleLabel = [[UILabel alloc] init];
    _nameTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _nameTitleLabel.font = PFRFont(13);
    _nameTitleLabel.text = @"商品名称";
    [self.contentView addSubview:_nameTitleLabel];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _nameLabel.font = PFRFont(13);
    _nameLabel.text = @"-";
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    
    _packTitleLabel = [[UILabel alloc] init];
    _packTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _packTitleLabel.font = PFRFont(13);
    _packTitleLabel.text = @"规格包装";
    [self.contentView addSubview:_packTitleLabel];
    
    _packLabel = [[UILabel alloc] init];
    _packLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _packLabel.font = PFRFont(13);
    _packLabel.text = @"-";
    _packLabel.numberOfLines = 0;
    [self.contentView addSubview:_packLabel];
    
    _compantTitleLabel = [[UILabel alloc] init];
    _compantTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _compantTitleLabel.font = PFRFont(13);
    _compantTitleLabel.text = @"生产厂家";
    [self.contentView addSubview:_compantTitleLabel];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _companyLabel.font = PFRFont(13);
    _companyLabel.text = @"-";
    _companyLabel.numberOfLines = 0;
    [self.contentView addSubview:_companyLabel];
    
    _numTitleLabel = [[UILabel alloc] init];
    _numTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _numTitleLabel.font = PFRFont(13);
    _numTitleLabel.text = @"批准文号";
    [self.contentView addSubview:_numTitleLabel];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _numLabel.font = PFRFont(13);
    _numLabel.text = @"-";
    _numLabel.numberOfLines = 0;
    [self.contentView addSubview:_numLabel];
    
    _countTitleLabel = [[UILabel alloc] init];
    _countTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _countTitleLabel.font = PFRFont(13);
    _countTitleLabel.text = @"整件数量";
    [self.contentView addSubview:_countTitleLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _countLabel.font = PFRFont(13);
    _countLabel.text = @"-";
    _countLabel.numberOfLines = 0;
    [self.contentView addSubview:_countLabel];
    
    _endtimeTitleLabel = [[UILabel alloc] init];
    _endtimeTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _endtimeTitleLabel.font = PFRFont(13);
    _endtimeTitleLabel.text = @"有效期至";
    [self.contentView addSubview:_endtimeTitleLabel];
    
    _endtimeLabel = [[UILabel alloc] init];
    _endtimeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _endtimeLabel.font = PFRFont(13);
    _endtimeLabel.text = @"-";
    _endtimeLabel.numberOfLines = 0;
    [self.contentView addSubview:_endtimeLabel];
    
    _starttimeTitleLabel = [[UILabel alloc] init];
    _starttimeTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _starttimeTitleLabel.font = PFRFont(13);
    _starttimeTitleLabel.text = @"生产日期";
    [self.contentView addSubview:_starttimeTitleLabel];
    
    _starttimeLabel = [[UILabel alloc] init];
    _starttimeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _starttimeLabel.font = PFRFont(13);
    _starttimeLabel.text = @"-";
    _starttimeLabel.numberOfLines = 0;
    [self.contentView addSubview:_starttimeLabel];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
    _tipLabel.font = PFRFont(12);
    _tipLabel.text = @"温馨提示：部分商品包装更换频繁，如货品与图片不完全一致，请以收到的商品实物为准。如页面存在有效期信息，为库存韩品最近有效期，实际产品有效期以到货有效期为准。采购到近效期商品，平台支持无条件拒收、退货";
    _tipLabel.numberOfLines = 0;
    [self.contentView addSubview:_tipLabel];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)detailBtnClick:(UIButton *)button
{
    if (_detailBtnClick) {
        _detailBtnClick();
    }
}


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
    
    [_nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.titleLabel.bottom).offset(8);
        make.width.equalTo(80);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTitleLabel.right);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.nameTitleLabel.top);
    }];
    
    [_packTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTitleLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(10);
        make.width.equalTo(self.nameTitleLabel.width);
    }];
    
    [_packLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.top.equalTo(self.packTitleLabel.top);
    }];
    
    [_compantTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTitleLabel.left);
        make.top.equalTo(self.packLabel.bottom).offset(10);
        make.width.equalTo(self.nameTitleLabel.width);
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.top.equalTo(self.compantTitleLabel.top);
    }];
    
    [_numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTitleLabel.left);
        make.top.equalTo(self.companyLabel.bottom).offset(10);
        make.width.equalTo(self.nameTitleLabel.width);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.top.equalTo(self.numTitleLabel.top);
    }];
    
    [_countTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTitleLabel.left);
        make.top.equalTo(self.numLabel.bottom).offset(10);
        make.width.equalTo(self.nameTitleLabel.width);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.top.equalTo(self.countTitleLabel.top);
    }];
    
    [_endtimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTitleLabel.left);
        make.top.equalTo(self.countLabel.bottom).offset(10);
        make.width.equalTo(self.nameTitleLabel.width);
    }];
    
    [_endtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.top.equalTo(self.endtimeTitleLabel.top);
    }];
    
    [_starttimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTitleLabel.left);
        make.top.equalTo(self.endtimeLabel.bottom).offset(10);
        make.width.equalTo(self.nameTitleLabel.width);
    }];
    
    [_starttimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.top.equalTo(self.starttimeTitleLabel.top);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.starttimeLabel.bottom).offset(12);
        make.bottom.equalTo(self.contentView.bottom).offset(-18);
    }];
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    _nameLabel.text = [[DCHelpTool shareClient] dc_setValue:_detailModel.goodsName];
    _packLabel.text = [[DCHelpTool shareClient] dc_setValue:_detailModel.packingSpec];
    _companyLabel.text = [[DCHelpTool shareClient] dc_setValue:_detailModel.manufactory];
    _countLabel.text =  [[DCHelpTool shareClient] dc_setValue:_detailModel.pkgPackingNum];
    _endtimeLabel.text = [[DCHelpTool shareClient] dc_setValue:_detailModel.expireDate];
    _starttimeLabel.text = [[DCHelpTool shareClient] dc_setValue:_detailModel.batchProduceTime];
    _numLabel.text = [[DCHelpTool shareClient] dc_setValue:_detailModel.certifiNum];

}

@end
