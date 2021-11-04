//
//  GLPConfirmOrderHeaderView.m
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import "GLPConfirmOrderHeaderView.h"

@interface GLPConfirmOrderHeaderView ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *allMoneyLabel;
@property (nonatomic, strong) UILabel *realMoneyLabel;

@end

@implementation GLPConfirmOrderHeaderView

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
    _allMoneyLabel.font = PFRFont(13);
    _allMoneyLabel.attributedText = [NSString dc_strikethroughWithString:@"¥ 0.00"];
    _allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_allMoneyLabel];
    
    _realMoneyLabel = [[UILabel alloc] init ];
    _realMoneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4400"];
    _realMoneyLabel.font = PFRFont(14);
    _realMoneyLabel.text = @"¥ 0.00";
    _realMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_realMoneyLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top).offset(8);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.contentView.bottom).offset(-5);
    }];
    
    [_allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.width.equalTo(kScreenW *0.33);
    }];
    
    [_realMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allMoneyLabel.left);
        make.right.equalTo(self.allMoneyLabel.right);
        make.bottom.equalTo(self.contentView.bottom).offset(-5);
    }];
}


#pragma mark - setter
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
    
    if ([_acticityModel.afterDiscountAmount floatValue] < [_acticityModel.beforeDiscountAmount floatValue]) {
        _allMoneyLabel.hidden = NO;
        
        [_realMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subLabel.centerY);
        }];
    }else{
        _allMoneyLabel.hidden = YES;

        [_realMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
        }];
    }
    
    _allMoneyLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"¥%@",_acticityModel.beforeDiscountAmount]];
    
    _realMoneyLabel.text = [NSString stringWithFormat:@"¥%@",_acticityModel.afterDiscountAmount];
    _realMoneyLabel = [UILabel setupAttributeLabel:_realMoneyLabel textColor:_realMoneyLabel.textColor minFont:[UIFont fontWithName:PFR size:10] maxFont:[UIFont fontWithName:PFRMedium size:14] forReplace:@"¥"];
}

@end
