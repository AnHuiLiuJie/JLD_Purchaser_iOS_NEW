//
//  GLPGoodsDetailsOldStoreCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsOldStoreCell.h"

@interface GLPGoodsDetailsOldStoreCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *careCountLabel;
@property (nonatomic, strong) UILabel *careCountTitleLabel;
@property (nonatomic, strong) UILabel *goodsCountLabel;
@property (nonatomic, strong) UILabel *goodsCountTitleLabel;
@property (nonatomic, strong) UIButton *careBtn;
@property (nonatomic, strong) UIButton *openBtn;

@end

@implementation GLPGoodsDetailsOldStoreCell

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
    [self.contentView  addSubview:_bgView];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:20];
    [_bgView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _nameLabel.text = @"";
    _nameLabel.font = [UIFont fontWithName:PFRMedium size:16];
    [_bgView addSubview:_nameLabel];
    
    _careCountLabel = [[UILabel alloc] init];
    _careCountLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _careCountLabel.text = @"";
    _careCountLabel.font = [UIFont fontWithName:PFRSemibold size:17];
    _careCountLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_careCountLabel];
    
    _goodsCountLabel = [[UILabel alloc] init];
    _goodsCountLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _goodsCountLabel.text = @"0";
    _goodsCountLabel.font = [UIFont fontWithName:PFRSemibold size:17];
    _goodsCountLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_goodsCountLabel];
    
    _careCountTitleLabel = [[UILabel alloc] init];
    _careCountTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#9B9B9B"];
    _careCountTitleLabel.text = @"关注人数";
    _careCountTitleLabel.font = [UIFont fontWithName:PFR size:12];
    _careCountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_careCountTitleLabel];
    
    _goodsCountTitleLabel = [[UILabel alloc] init];
    _goodsCountTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#9B9B9B"];
    _goodsCountTitleLabel.text = @"全部商品";
    _goodsCountTitleLabel.font = [UIFont fontWithName:PFR size:12];
    _goodsCountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_goodsCountTitleLabel];
    
    _careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_careBtn setImage:[UIImage imageNamed:@"guanzhudianpu"] forState:0];
    [_careBtn setImage:[UIImage imageNamed:@"dc_ygz_hong"] forState:UIControlStateSelected];
    [_careBtn setTitle:@" 关注店铺" forState:0];
    [_careBtn setTitle:@" 取消关注" forState:UIControlStateSelected];
    [_careBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_careBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FD4F00"] forState:UIControlStateSelected];
    _careBtn.titleLabel.font = PFRFont(13);
    [_careBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#333333"] radius:18];
    [_careBtn addTarget:self action:@selector(careBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_careBtn];
    
    _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openBtn setImage:[UIImage imageNamed:@"jinrudianpu"] forState:0];
    [_openBtn setTitle:@" 进入店铺" forState:0];
    [_openBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _openBtn.titleLabel.font = PFRFont(13);
    _openBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00BCB1"];
    [_openBtn dc_cornerRadius:18];
    [_openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_openBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)openBtnClick:(UIButton *)button
{
    if (_storeCellBlock) {
        _storeCellBlock(501);
    }
}


- (void)careBtnClick:(UIButton *)button
{
    if (_storeCellBlock) {
        _storeCellBlock(500);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        //make.height.mas_greaterThanOrEqualTo(140).priorityHigh();
        make.height.equalTo(140).priorityHigh();
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top).offset(20);
        make.left.equalTo(self.bgView.left).offset(15);
        make.size.equalTo(CGSizeMake(40, 40));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY);
        make.left.equalTo(self.iconImage.right).offset(10);
    }];
    
    [_goodsCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-15);
        make.top.equalTo(self.iconImage.centerY).offset(3);
        make.width.equalTo(75);
    }];
    
    [_goodsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsCountTitleLabel.left);
        make.right.equalTo(self.goodsCountTitleLabel.right);
        make.bottom.equalTo(self.goodsCountTitleLabel.top).offset(-6);
    }];
    
    [_careCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsCountTitleLabel.left).offset(-20);
        make.left.equalTo(self.nameLabel.right).offset(5);
        make.centerY.equalTo(self.goodsCountTitleLabel.centerY);
        make.width.equalTo(self.goodsCountTitleLabel.width);
    }];
    
    [_careCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.careCountTitleLabel.left);
        make.right.equalTo(self.careCountTitleLabel.right);
        make.centerY.equalTo(self.goodsCountLabel);
    }];
    
    [_careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.bottom).offset(25);
        //make.bottom.equalTo(self.bgView.bottom).offset(-20);
        make.right.equalTo(self.bgView.centerX).offset(-20);
        make.size.equalTo(CGSizeMake(110, 36));
    }];
    
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.careBtn.right).offset(40);
        make.centerY.equalTo(self.careBtn.centerY);
        make.width.equalTo(self.careBtn.width);
        make.height.equalTo(self.careBtn.height);
    }];

}


#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    if (_detailModel && _detailModel.shopInfo) {
        
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:_detailModel.shopInfo.logoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
        _nameLabel.text = _detailModel.shopInfo.shopName;
        _careCountLabel.text = [NSString stringWithFormat:@"%ld",_detailModel.shopInfo.collectionCount];
        _goodsCountLabel.text = [NSString stringWithFormat:@"%ld",_detailModel.shopInfo.goodsCount];
        
        if (_detailModel.shopInfo.isCollection > 0) {
            _careBtn.selected = YES;
        } else {
            _careBtn.selected = NO;
        }
    }
}


@end
