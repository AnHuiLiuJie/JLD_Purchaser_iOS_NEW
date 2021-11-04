//
//  GLPMainTicketCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/14.
//

#import "GLPMainTicketCell.h"

@interface GLPMainTicketCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *ruleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *Label;
@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, assign) BOOL isCanUsed;

@end

@implementation GLPMainTicketCell

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
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"dc_yhq_zky"];
    _bgImage.clipsToBounds = YES;
    [_bgView addSubview:_bgImage];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _moneyLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.attributedText = [self dc_attributeStr:50];
    [_bgView addSubview:_moneyLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _typeLabel.font = [UIFont fontWithName:PFR size:12];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_typeLabel];
    
    _ruleLabel = [[UILabel alloc] init];
    _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _ruleLabel.font = [UIFont fontWithName:PFR size:15];
    //    _ruleLabel.text = @"满1000元可使用";
    [_bgView addSubview:_ruleLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _timeLabel.font = [UIFont fontWithName:PFR size:11];
    //_timeLabel.hidden = YES;
    //    _timeLabel.text = @"有效日期：2018.10.15-2018.12.15";
    [_bgView addSubview:_timeLabel];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"dc_gx_no"];
    _iconImage.hidden = NO;
    [_bgView addSubview:_iconImage];
    
    [self layoutIfNeeded];
}

- (NSMutableAttributedString *)dc_attributeStr:(CGFloat)money{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f",money]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} range:NSMakeRange(0, 1)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:24]} range:NSMakeRange(1, attStr.length - 3)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:20]} range:NSMakeRange(attStr.length - 2, 2)];
    return attStr;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
        make.height.equalTo(90).priorityHigh();
    }];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.centerY.equalTo(self.bgView.centerY).offset(-10);//15
        make.width.equalTo(kScreenW*0.27);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.right.equalTo(self.moneyLabel.right);
        make.top.equalTo(self.moneyLabel.bottom).offset(2);
    }];
    
    [_ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.right).offset(15);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.bgView.centerY).offset(-15);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleLabel.left);
        make.right.equalTo(self.bgImage.right).offset(-10);
        make.top.equalTo(self.ruleLabel.bottom).offset(15);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.right).offset(-15);
        make.centerY.equalTo(self.bgImage.centerY);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark - setter
- (void)setCouponsModel:(GLPCouponListModel *)couponsModel{
    _couponsModel = couponsModel;
    
    if ([_couponsModel.couponsClass integerValue] == 1) {
        _typeLabel.text = @"平台优惠券";
    }else if([_couponsModel.couponsClass integerValue] == 2){
        _typeLabel.text = @"店铺优惠券";
    }else if([_couponsModel.couponsClass integerValue] == 3){
        _typeLabel.text = @"商品专享券";
    }
    
//    if (_couponsModel.isSelected) {
//        [_iconImage setImage:[UIImage imageNamed:@"dc_gx_yes"]];
//    }else{
//        [_iconImage setImage:[UIImage imageNamed:@"dc_gx_no"]];
//    }
    
    [self changeCellView:couponsModel.showType];
    
    _moneyLabel.attributedText = [self dc_attributeStr:[_couponsModel.discountAmount floatValue]];
    _ruleLabel.text = [NSString stringWithFormat:@"满%@元可使用",_couponsModel.requireAmount];
    _timeLabel.text = [NSString stringWithFormat:@"有效期：%@至%@",_couponsModel.useStartDate,_couponsModel.useEndDate];

}


#pragma mark - 赋值
- (void)setPersonValueWithDataArray:(NSArray *)dataArray seletcedArray:(NSMutableArray *)seletcedArray firmModel:(GLPFirmListModel *)firmModel indexPath:(NSIndexPath *)indexPath{
    
    [dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [seletcedArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull seletcedModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([seletcedModel.couponsId isEqualToString:couponModel.couponsId]) {
                
            }
        }];
    }];
}

- (void)changeCellView:(NSInteger)type{
    if (type == 1) {//可用已选
        _bgImage.image = [UIImage imageNamed:@"dc_yhq_zky"];
        _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
        _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
        _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
        _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
        [_iconImage setImage:[UIImage imageNamed:@"dc_gx_yes"]];
    }else if(type == 2){//可用没选
        _bgImage.image = [UIImage imageNamed:@"dc_yhq_zky"];
        _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        [_iconImage setImage:[UIImage imageNamed:@"dc_gx_no"]];
    }else if(type == 3){//不可用
        _bgImage.image = [UIImage imageNamed:@"dc_yhq_zbky"];
        _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        [_iconImage setImage:[UIImage imageNamed:@"dc_gx_no"]];
    }
}

//- (UIImage *)dc_cantUserImage{
//    UIImage *image = [UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:@"#cccccc"] size:CGSizeMake(kScreenW - 20, 80)];
//    return image;
//}

@end


