//
//  GLPShoppingCarGoodsSectionView.m
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPShoppingCarGoodsSectionView.h"

@interface GLPShoppingCarGoodsSectionView ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *allMoneyLabel;
@property (nonatomic, strong) UILabel *realMoneyLabel;

@property MASConstraint * allMoneyLabel_Y_LayoutConstraint;
@property MASConstraint * realMoneyLabel_Y_LayoutConstraint;

@end

@implementation GLPShoppingCarGoodsSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"dachuxiao"];
    [self.contentView addSubview:_bgImage];
    
    _titleLabel = [[UILabel alloc] init ];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = PFRFont(16);
    _titleLabel.text = @"夏季大促销";
    [self.contentView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] init ];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.font = PFRFont(12);
    _subLabel.text = @"满300减100";
    [self.contentView addSubview:_subLabel];
    
    _allMoneyLabel = [[UILabel alloc] init ];
    _allMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _allMoneyLabel.font = PFRFont(12);
    _allMoneyLabel.attributedText = [NSString dc_strikethroughWithString:@"¥ 0.00"];
    _allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_allMoneyLabel];
    
    _realMoneyLabel = [[UILabel alloc] init ];
    _realMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4400"];
    _realMoneyLabel.font = PFRFont(12);
    _realMoneyLabel.text = @"¥ 0.00";
    _realMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_realMoneyLabel];
    
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.centerY.equalTo(self.contentView.centerY).offset(-8);
    }];

    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).offset(0);
    }];

    [_allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top).offset(10);
        make.width.equalTo(kScreenW *0.33);
    }];
    
    [_realMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right);
        make.width.equalTo(kScreenW *0.33);
        make.centerY.equalTo(self.contentView.centerY).offset(10);
    }];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
}


#pragma mark - setter
- (void)setActInfoList:(NSArray *)actInfoList{
    _actInfoList = actInfoList;
    
    [_acticityModel.actGoodsList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull acticityModel, NSUInteger idx, BOOL * _Nonnull stop) {

    }];
}


- (void)setActicityModel:(ActInfoListModel *)acticityModel
{
    _acticityModel = acticityModel;
    
    _titleLabel.text = _acticityModel.actTitle;
    NSArray *actList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:_acticityModel.actPriceList];
    NSString *tisStr = @"";
    for (GLPCouponListModel *model in actList) {
        tisStr = [NSString stringWithFormat:@"满%@减%@ %@",model.requireAmount,model.discountAmount,tisStr];
    }
    _subLabel.text = tisStr;
    
    __block CGFloat beforeDiscountAmount = 0.00;
    __block CGFloat afterDiscountAmount = 0.00;
    [_acticityModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
        beforeDiscountAmount = [goodsModel.quantity floatValue] * [goodsModel.sellPrice floatValue] + beforeDiscountAmount;
    }];
    
    
    __block GLPCouponListModel *indexModel = nil;
    [actList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(GLPCouponListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (beforeDiscountAmount > [actModel.requireAmount floatValue]) {
            indexModel = actModel;
        }
    }];
    
    if (beforeDiscountAmount >= [indexModel.discountAmount floatValue] && beforeDiscountAmount > [indexModel.requireAmount floatValue]) {
        afterDiscountAmount = beforeDiscountAmount - [indexModel.discountAmount floatValue];
    }else
        afterDiscountAmount = beforeDiscountAmount;
    
    

    if (afterDiscountAmount <= beforeDiscountAmount && beforeDiscountAmount > [indexModel.requireAmount floatValue]){
        _allMoneyLabel.hidden = NO;
        
        [_realMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY).offset(10);
        }];

    }else{
        _allMoneyLabel.hidden = YES;
        
        [_realMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY).offset(0);
        }];
    }
    
    _acticityModel.afterDiscountAmount = [NSString stringWithFormat:@"%.2f",afterDiscountAmount];
    _acticityModel.beforeDiscountAmount = [NSString stringWithFormat:@"%.2f",beforeDiscountAmount];
    
    
    _allMoneyLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"¥%@",_acticityModel.beforeDiscountAmount]];
    
    _realMoneyLabel.text = [NSString stringWithFormat:@"¥%@",_acticityModel.afterDiscountAmount];
    _realMoneyLabel = [UILabel setupAttributeLabel:_realMoneyLabel textColor:_realMoneyLabel.textColor minFont:[UIFont fontWithName:PFR size:10] maxFont:[UIFont fontWithName:PFRMedium size:14] forReplace:@"¥"];
    
    [self layoutIfNeeded];
}

@end
