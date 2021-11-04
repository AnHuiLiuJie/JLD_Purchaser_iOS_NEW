//
//  GLBGoodsTitleCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsTitleCell.h"
#import "GLBPromotionView.h"
#import "GLBYcjPromotionView.h"
#import "GLBYcjTypeView.h"
#import "GLBGoodsTagView.h"

@interface GLBGoodsTitleCell ()

@property (nonatomic, strong) GLBPromotionView *promotionView;
@property (nonatomic, strong) GLBYcjPromotionView *ycjPromotionView;
@property (nonatomic, strong) GLBYcjTypeView *ycjTypeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GLBGoodsTagView *tagView;
@property (nonatomic, strong) UIImageView *retailImage;
@property (nonatomic, strong) UILabel *retailNowPriceLabel;
@property (nonatomic, strong) UILabel *retailOldPriceLabel;
@property (nonatomic, strong) UIImageView *fullImage;
@property (nonatomic, strong) UILabel *fullNowPriceLabel;
@property (nonatomic, strong) UILabel *fullOldPriceLabel;
@property (nonatomic, strong) UILabel *retailLimitLabel;
@property (nonatomic, strong) UILabel *fullLimitLabel;

@property (nonatomic, strong) UILabel *loginLabel;

@end

@implementation GLBGoodsTitleCell

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
    
    _promotionView = [[GLBPromotionView alloc] init];
    _promotionView.hidden = YES;
    [self.contentView addSubview:_promotionView];
    
    _ycjPromotionView = [[GLBYcjPromotionView alloc] init];
    _ycjPromotionView.hidden = YES;
    [self.contentView addSubview:_ycjPromotionView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 0;
//    _titleLabel.text = @"注射用穿琥宁(80mg*10瓶) -海南通用康力制药";
    [self.contentView addSubview:_titleLabel];
    
    _tagView = [[GLBGoodsTagView alloc] init];
    [self.contentView addSubview:_tagView];
    
    _retailImage = [[UIImageView alloc] init];
    _retailImage.image = [UIImage imageNamed:@"ling"];
    [self.contentView addSubview:_retailImage];
    
    _retailNowPriceLabel = [[UILabel alloc] init];
    _retailNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _retailNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:18];
//    _retailNowPriceLabel.text = @"￥5.880";
    [self.contentView addSubview:_retailNowPriceLabel];
    
    _retailOldPriceLabel = [[UILabel alloc] init];
    _retailOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _retailOldPriceLabel.font = PFRFont(11)
//    _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥7.880  "];
    [self.contentView addSubview:_retailOldPriceLabel];
    
    _fullImage = [[UIImageView alloc] init];
    _fullImage.image = [UIImage imageNamed:@"zheng"];
    [self.contentView addSubview:_fullImage];
    
    _fullNowPriceLabel = [[UILabel alloc] init];
    _fullNowPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _fullNowPriceLabel.font = [UIFont fontWithName:PFRSemibold size:18];
//    _fullNowPriceLabel.text = @"￥15.880";
    [self.contentView addSubview:_fullNowPriceLabel];
    
    _fullOldPriceLabel = [[UILabel alloc] init];
    _fullOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _fullOldPriceLabel.font = PFRFont(11)
//    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥18.880  "];
    [self.contentView addSubview:_fullOldPriceLabel];
    
    _retailLimitLabel = [[UILabel alloc] init];
    _retailLimitLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _retailLimitLabel.font = PFRFont(12)
//    _retailLimitLabel.text = @"200 盒起购";
    _retailLimitLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_retailLimitLabel];
    
    _fullLimitLabel = [[UILabel alloc] init];
    _fullLimitLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _fullLimitLabel.font = PFRFont(12)
//    _fullLimitLabel.text = @"200 盒/件";
    _fullLimitLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_fullLimitLabel];
    
    _ycjTypeView = [[GLBYcjTypeView alloc] init];
    _ycjTypeView.hidden = YES;
    [self.contentView addSubview:_ycjTypeView];
    
    _loginLabel = [[UILabel alloc] init];
    _loginLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _loginLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _loginLabel.text = @"立即登录，进行采购";
    _loginLabel.hidden = YES;
    _loginLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_loginLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginLabelAction:)];
    [_loginLabel addGestureRecognizer:tap];
    
//    [self updateMasonry];
}


#pragma mark - action
- (void)loginLabelAction:(id)sender
{
    if (_loginBlock) {
        _loginBlock();
    }
}


- (NSMutableAttributedString *)dc_attrubuteStr:(NSString *)limit countStr:(NSString *)countStr
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@件起购  %@盒/件",limit,countStr]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF7447"]} range:NSMakeRange(0, limit.length)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF7447"]} range:NSMakeRange(attrStr.length - countStr.length - 3 ,countStr.length)];
    return attrStr;
}


- (NSMutableAttributedString *)dc_countAttrubuteStr:(NSString *)limit
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 盒起购",limit]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF7447"]} range:NSMakeRange(0, limit.length)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(limit.length ,attrStr.length - limit.length)];
    return attrStr;
}



#pragma mark - layoutSubviews
- (void)updateMasonry {
    
    if (self.promotionView.hidden) {
        
        if (self.ycjPromotionView.hidden) {
            
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.left).offset(15);
                make.right.equalTo(self.contentView.right).offset(-15);
                make.top.equalTo(self.contentView.top).offset(20);
            }];
            
        } else {
            
            [_ycjPromotionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.left);
                make.right.equalTo(self.contentView.right);
                make.top.equalTo(self.contentView.top);
                make.height.equalTo(72);
            }];
            
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.left).offset(15);
                make.right.equalTo(self.contentView.right).offset(-15);
                make.top.equalTo(self.ycjPromotionView.bottom).offset(20);
            }];
        }
    
        
    } else {

        [_promotionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.right.equalTo(self.contentView.right);
            make.top.equalTo(self.contentView.top);
            make.height.equalTo(32);
        }];

        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15);
            make.right.equalTo(self.contentView.right).offset(-15);
            make.top.equalTo(self.promotionView.bottom).offset(20);
        }];
    }
    
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.height.equalTo(12);
    }];
    
    if (self.detailType == GLBGoodsDetailTypeYjc) {
        
        NSArray *roles = @[];
        _ycjPromotionView.ycjModel = _ycjModel;
        if (_ycjModel.goods && [_ycjModel.goods count] > 0) {
            
            GLBYcjGoodsModel *goodsModel = _ycjModel.goods[0];
            roles = goodsModel.roles;
            
        }
        CGFloat height = roles.count *32 + 20;
        
        [_ycjTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.right.equalTo(self.contentView.right);
            make.top.equalTo(self.tagView.bottom).offset(10);
            make.bottom.equalTo(self.contentView.bottom).offset(-10);
            make.height.equalTo(height);
        }];
        
    } else {
        
        [_retailImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left);
            make.top.equalTo(self.tagView.bottom).offset(25);
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
        
        [_fullImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left);
            make.top.equalTo(self.retailImage.bottom).offset(20);
            make.width.height.equalTo(16);
            make.bottom.equalTo(self.contentView.bottom).offset(-10);
        }];
        
        [_fullNowPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fullImage.mas_right).offset(8);
            make.centerY.equalTo(self.fullImage.centerY);
        }];
        
        [_fullOldPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fullNowPriceLabel.mas_right).offset(20);
            make.centerY.equalTo(self.fullImage.centerY);
        }];
        
        [_retailLimitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.retailImage.centerY);
            make.right.equalTo(self.contentView.right).offset(-15);
        }];
        
        [_fullLimitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.fullImage.centerY);
            make.right.equalTo(self.contentView.right).offset(-15);
        }];
    }
    
    [_loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.retailLimitLabel.top);
        make.bottom.equalTo(self.fullLimitLabel.bottom);
    }];
}


#pragma mark - setter
- (void)setDetailType:(GLBGoodsDetailType)detailType
{
    _detailType = detailType;
    
    self.promotionView.hidden = YES;
    self.ycjPromotionView.hidden = YES;
    self.ycjTypeView.hidden = YES;
    
    if (_detailType == GLBGoodsDetailTypeYjc){
        self.ycjPromotionView.hidden = NO;
        self.ycjTypeView.hidden = NO;
    } else if (_detailType == GLBGoodsDetailTypePromotione){
        self.promotionView.hidden = NO;
    }
    
    [self updateMasonry];
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)-%@",_detailModel.goodsName,_detailModel.packingSpec,_detailModel.manufactory];

    _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.zeroPrice];
    _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.wholePrice];
    _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _retailOldPriceLabel.hidden = YES;
    _fullOldPriceLabel.hidden = YES;
    
    _fullImage.hidden = NO;
    _fullNowPriceLabel.hidden = NO;
    _retailImage.hidden = YES;
    _retailNowPriceLabel.hidden = YES;
    
    if (_detailModel.sellType == 2) { // 整售
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    } else if (_detailModel.sellType == 4) { // 零售
        
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    } else if (_detailModel.sellType == 3) { // 零售 + 整售
        
        _fullImage.hidden = NO;
        _fullNowPriceLabel.hidden = NO;
        _fullNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.wholePrice];
        _fullNowPriceLabel = [UILabel setupAttributeLabel:_fullNowPriceLabel textColor:_fullNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        _retailImage.hidden = NO;
        _retailNowPriceLabel.hidden = NO;
        _retailNowPriceLabel.text = [NSString stringWithFormat:@"¥%@",_detailModel.zeroPrice];
        _retailNowPriceLabel = [UILabel setupAttributeLabel:_retailNowPriceLabel textColor:_retailNowPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    }
    
    
    if (_retailNowPriceLabel.hidden == NO && [_detailModel.zeroPrice floatValue] == 0) {
        _retailImage.hidden = YES;
        _retailNowPriceLabel.hidden = YES;
    }
    
    if (_fullNowPriceLabel.hidden == NO && [_detailModel.wholePrice floatValue] == 0) {
        _fullImage.hidden = YES;
        _fullNowPriceLabel.hidden = YES;
    }
    
//    _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"  ￥%@  ",_detailModel.zeroTaxPrice]];
//    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"  ￥%@  ",_detailModel.wholeTaxPrice]];
    
    _retailLimitLabel.attributedText = [self dc_countAttrubuteStr:_detailModel.zeroMinBuy];
    _fullLimitLabel.attributedText = [self dc_attrubuteStr:_detailModel.wholeMinBuyNum countStr:_detailModel.pkgPackingNum] ;
    
    _tagView.detailModel = _detailModel;
    
    if ([[DCLoginTool shareTool] dc_isLogin]) {
        _loginLabel.hidden = YES;
    } else {
        _loginLabel.hidden = NO;
    }
}


- (void)setYcjModel:(GLBYcjModel *)ycjModel
{
    _ycjModel = ycjModel;
    
    if (_detailType == GLBGoodsDetailTypeYjc) {
     
        _ycjPromotionView.ycjModel = _ycjModel;
        
        if (_ycjModel.goods && [_ycjModel.goods count] > 0) {
            
            GLBYcjGoodsModel *goodsModel = _ycjModel.goods[0];
            NSArray *roles = goodsModel.roles;
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i =0; i<roles.count; i++) {
                GLBYcjRolesModel *rolesModel = roles[i];
                rolesModel.chargeUnit = goodsModel.chargeUnit;
                [dataArray addObject:rolesModel];
            }
            _ycjTypeView.rolesArray = dataArray;
            
            _titleLabel.text = goodsModel.goodsName;
        }
    }
    
    [self layoutSubviews];
}


- (void)setPromoteModel:(GLBPromoteModel *)promoteModel
{
    _promoteModel = promoteModel;
    
    _promotionView.promoteModel = _promoteModel;
}

@end
