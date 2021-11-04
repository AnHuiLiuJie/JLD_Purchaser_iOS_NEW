//
//  GLPGoodsDetailsTitleCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsTitleCell.h"

#import "GLPDetailNormalGoodsView.h"

@interface GLPGoodsDetailsTitleCell ()
//<GLPEditCountViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *kucunLabel;
@property (nonatomic, strong) UILabel *limitLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *freightLabel;
@property (nonatomic, strong) UILabel *sendTimeLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) GLPDetailNormalGoodsView *normalGoodsView; // 团购商品

@property (nonatomic, strong) UIView *bgView;
@end

@implementation GLPGoodsDetailsTitleCell

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
    
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];

    _normalGoodsView = [[GLPDetailNormalGoodsView alloc] init];
    _normalGoodsView.hidden = YES;
    [_bgView addSubview:_normalGoodsView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"       ";
    [_bgView addSubview:_titleLabel];
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPressGesture2.minimumPressDuration = 0.8f;//设置长按 时间
    _titleLabel.userInteractionEnabled = YES;
    [_titleLabel addGestureRecognizer:longPressGesture2];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FF5800" alpha:0.1];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5600"];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = @"";
    [_tipLabel dc_cornerRadius:13];
    _tipLabel.font = PFRFont(13);
    [_bgView addSubview:_tipLabel];
    
    _kucunLabel = [[UILabel alloc] init];
    _kucunLabel.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    _kucunLabel.font = [UIFont fontWithName:PFR size:12];
    _kucunLabel.text = @"库存 0";
    [_bgView addSubview:_kucunLabel];
    
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5200"];
    _limitLabel.font = [UIFont fontWithName:PFR size:12];
    _limitLabel.text = @"（限购0件）";
    _limitLabel.hidden = YES;
    [_bgView addSubview:_limitLabel];
    
    _areaLabel = [[UILabel alloc] init];
    _areaLabel.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    _areaLabel.font = PFRFont(12);
    _areaLabel.text = @"送至：-";
    [_bgView addSubview:_areaLabel];
    
    _freightLabel = [[UILabel alloc] init];
    _freightLabel.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    _freightLabel.font = PFRFont(12);
    _freightLabel.text = @"运费0元";
    [_bgView addSubview:_freightLabel];
    
    
    _sendTimeLabel = [[UILabel alloc] init];
    _sendTimeLabel.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    _sendTimeLabel.font = PFRFont(12);
    _sendTimeLabel.text = @"24小时发货";
    [_bgView addSubview:_sendTimeLabel];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setTitle:@"收藏" forState:0];
    [_collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [_collectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_collectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FE4800"] forState:UIControlStateSelected];
    _collectBtn.titleLabel.font = PFRFont(10);
    [_collectBtn setImage:[UIImage imageNamed:@"weishouc"] forState:0];
    [_collectBtn setImage:[UIImage imageNamed:@"yishouc"] forState:UIControlStateSelected];
    _collectBtn.adjustsImageWhenHighlighted = NO;
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _collectBtn.bounds = CGRectMake(0, 0, 50, 50);
    [_collectBtn dc_buttonIconTopWithSpacing:7];
    [_bgView addSubview:_collectBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setTitle:@"分享" forState:0];
    [_shareBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _shareBtn.titleLabel.font = PFRFont(10);
    [_shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:0];
    _shareBtn.adjustsImageWhenHighlighted = NO;
    [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.bounds = CGRectMake(0, 0, 50, 50);
    [_shareBtn dc_buttonIconTopWithSpacing:7];
    [_bgView addSubview:_shareBtn];
    
    _countView = [[GLPEditCountView alloc] init];
    [_bgView addSubview:_countView];

    [self layoutIfNeeded];
}

#pragma mark - action
- (void)collectBtnClick:(UIButton *)button
{
    if (_titleCellBlock) {
        _titleCellBlock(100);
    }
}

- (void)shareBtnClick:(UIButton *)button
{
    if (_titleCellBlock) {
        _titleCellBlock(101);
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat top = 10;
    //CGFloat titleH = [DCSpeedy getLabelHeightWithText:_nameLab.text width:_nameLab.dc_width font:_nameLab.font];
    //75+X+23+8+20+X+23+X
    if (self.normalGoodsView.hidden == NO) {
        
        top = 80;
        [_normalGoodsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bgView.left);
            make.right.equalTo(_bgView.right);
            make.top.equalTo(_bgView.top);
            make.height.equalTo(top-5);
        }];
    }
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView.left).offset(15);
        make.right.equalTo(_bgView.right).offset(-15);
        make.top.equalTo(_bgView.top).offset(top-5);
    }];
    
    [_tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).offset(8);
        make.height.offset(26);
    }];
    
    [_kucunLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).offset(23+8+20);
    }];
    
    [_limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.kucunLabel.right);
        make.centerY.equalTo(self.kucunLabel.centerY);
    }];
    
    [_areaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.kucunLabel.bottom).offset(25);
        make.width.equalTo(kScreenW/2.2);
        make.bottom.equalTo(_bgView.bottom).offset(-10);
    }];
    
    [_freightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.areaLabel.right).offset(20);
        make.centerY.equalTo(self.areaLabel.centerY);
    }];
    
    [_sendTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView.right).offset(-23);
        make.centerY.equalTo(self.areaLabel.centerY);
    }];
    
    [_countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.right);
        make.bottom.equalTo(self.sendTimeLabel.top).offset(-15);
        make.size.equalTo(CGSizeMake(100, 33));
    }];
    
    [_shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgView.right).offset(-10);
        make.bottom.equalTo(self.countView.top).offset(-8);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [_collectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareBtn.centerY);
        make.right.equalTo(self.shareBtn.left).offset(-10);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    CGFloat hight = CGRectGetMaxY(self.areaLabel.frame);
    if (hight < 100) {
        hight = 230;
    }
    
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(hight+5).priorityHigh();
//        make.height.equalTo(hight+5).priorityHigh();
    }];
    
}

#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    _kucunLabel.text = [NSString stringWithFormat:@"库存: %ld%@",(long)_detailModel.totalStock,_detailModel.chargeUnit];
    
    _titleLabel.text = _detailModel.goodsTitle;
    NSDictionary *dic = [_detailModel.activityInfo mj_keyValues];
    if ([dic isEqualToDictionary:@{}]||[dic dc_isNull]) {
        _tipLabel.hidden = YES;
    }
    else{
        _tipLabel.hidden = NO;
        _tipLabel.text = [NSString stringWithFormat:@" %@, 满¥%@减¥%@   ",_detailModel.activityInfo.actTitle,_detailModel.activityInfo.requireAmount,_detailModel.activityInfo.discountAmount];
        //actLabel = [UILabel setupAttributeLabel:actLabel textColor:actLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(templateSingleTapAction:)];
        _tipLabel.userInteractionEnabled = YES;
        [_tipLabel addGestureRecognizer:tap];
    }
   
    if (_detailModel.isCollection > 0) { // 被收藏
        _collectBtn.selected = YES;
    } else {
        _collectBtn.selected = NO;
    }
    _normalGoodsView.detailModel = _detailModel;
    
    if (_detailModel.deliveryTime.length != 0) {
        _sendTimeLabel.text = _detailModel.deliveryTime;
    }
}

- (void)templateSingleTapAction:(id)sender
{
    if (_titleCellBlock) {
        _titleCellBlock(102);
    }
}


- (void)setAddressModel:(GLPGoodsAddressModel *)addressModel{
    _addressModel = addressModel;
    
    NSString *address = _addressModel.areaName;
    if (!address || address.length == 0) {
        address = @"-";
    }
    _areaLabel.text = [NSString stringWithFormat:@"送至：%@",address];
    GLPGoodsAddressExpressModel *model = [_addressModel.expressList firstObject];//详情页只有一个商品
    _freightLabel.text = [NSString stringWithFormat:@"运费%@",model.freight];
}


#pragma mark - setter
- (void)setDetailType:(GLPGoodsDetailType)detailType
{
    _detailType = detailType;
     _normalGoodsView.hidden = NO;
    [self layoutSubviews];
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_detailModel.goodsTitle.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.detailModel.goodsTitle;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

@end
