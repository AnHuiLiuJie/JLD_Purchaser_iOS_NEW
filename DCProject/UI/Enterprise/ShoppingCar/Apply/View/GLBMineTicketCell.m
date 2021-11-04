//
//  GLBMineTicketCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineTicketCell.h"

@interface GLBMineTicketCell ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *ruleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *Label;
//@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, assign) BOOL isCanUsed;

@end

@implementation GLBMineTicketCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"dc_ticket_bg1"];
    _bgImage.clipsToBounds = YES;
    [self.contentView addSubview:_bgImage];
    
    _bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ticketClick:)];
    [_bgImage addGestureRecognizer:tap];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _moneyLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.attributedText = [self dc_attributeStr:50];
    [self.contentView addSubview:_moneyLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _typeLabel.font = [UIFont fontWithName:PFR size:10];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_typeLabel];
    
    _ruleLabel = [[UILabel alloc] init];
    _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _ruleLabel.font = [UIFont fontWithName:PFR size:14];
    //    _ruleLabel.text = @"满1000元可使用";
    [self.contentView addSubview:_ruleLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLabel.font = [UIFont fontWithName:PFR size:10];
    //    _timeLabel.text = @"有效日期：2018.10.15-2018.12.15";
    [self.contentView addSubview:_timeLabel];

//    _tipLabel = [[UILabel alloc] init];
//    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
//    _tipLabel.font = [UIFont fontWithName:PFR size:10];
//    _tipLabel.textAlignment = NSTextAlignmentRight;
//    _tipLabel.text = @"已选中";
//    _tipLabel.hidden = YES;
//    [self.contentView addSubview:_tipLabel];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"dc_gx_no"];
    _iconImage.hidden = YES;
    [self.contentView addSubview:_iconImage];
    
    [self layoutIfNeeded];
}



#pragma mark - action
- (void)ticketClick:(id)sender
{
    if (_ticketBlock) {
        _ticketBlock(_isCanUsed);
    }
}


- (NSMutableAttributedString *)dc_attributeStr:(CGFloat)money
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.0f",money]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} range:NSMakeRange(0, 1)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:23]} range:NSMakeRange(1, attStr.length - 1)];
    return attStr;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.left).offset(0);
        make.bottom.equalTo(self.contentView.centerY).offset(10);
        make.width.equalTo(kScreenW*0.24);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.right.equalTo(self.moneyLabel.right);
        make.top.equalTo(self.moneyLabel.bottom);
    }];
    
    [_ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.right).offset(10);
        make.right.equalTo(self.bgImage.right);
        make.bottom.equalTo(self.contentView.centerY).offset(0);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleLabel.left);
        make.right.equalTo(self.bgImage.right).offset(-10);
        make.top.equalTo(self.ruleLabel.bottom).offset(5);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.right).offset(-10);
        make.centerY.equalTo(self.bgImage.centerY);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
}


#pragma mark - setter
//- (void)setCouponsModel:(GLBMineTicketCouponsModel *)couponsModel
//{
//    _couponsModel = couponsModel;
//
//    if ([_couponsModel.couponType isEqualToString:@"1"]) {
//        _typeLabel.text = @"商品专享券";
//    } else if ([_couponsModel.couponType isEqualToString:@"2"]) {
//        _typeLabel.text = @"店铺优惠券";
//    } else if ([_couponsModel.couponType isEqualToString:@"3"]) {
//        _typeLabel.text = @"平台优惠券";
//    }
//
//    _ruleLabel.text = [NSString stringWithFormat:@"满%.0f元可使用",_couponsModel.requireAmount];
//    _timeLabel.text = [NSString stringWithFormat:@"有效日期：%@-%@",_couponsModel.startTime,_couponsModel.endTime];
//    if (_couponsModel.receive == 1) { // 已领取
//        _bgImage.image = [UIImage imageNamed:@"gwc_yhqy"];
//    } else {
//        _bgImage.image = [UIImage imageNamed:@"gwc_yhq"];
//    }
//}



#pragma mark - 赋值
- (void)setValueWithDataArray:(NSArray *)dataArray seletcedArray:(NSMutableArray *)seletcedArray carModel:(GLBShoppingCarModel *)carModel indexPath:(NSIndexPath *)indexPath
{
    GLBMineTicketCouponsModel *couponsModel = dataArray[indexPath.row];
    
    if (couponsModel.receive == 1) { // 已领取
        _bgImage.image = [UIImage imageNamed:@"dc_ticket_bg1"];
        _isCanUsed = YES;
        
        _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
        _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
        _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    }
    
    _moneyLabel.attributedText = [self dc_attributeStr:couponsModel.discountAmount];
    _ruleLabel.text = [NSString stringWithFormat:@"满%.0f元可使用",couponsModel.requireAmount];
    
    NSString *start = couponsModel.startTime;
       if ([start containsString:@" "]) {
           start = [start componentsSeparatedByString:@" "][0];
       }
       if ([start containsString:@"-"]) {
           start = [start stringByReplacingOccurrencesOfString:@"-" withString:@"."];
       }
       
       NSString *end = couponsModel.endTime;
       if ([end containsString:@" "]) {
           end = [end componentsSeparatedByString:@" "][0];
       }
       if ([end containsString:@"-"]) {
           end = [end stringByReplacingOccurrencesOfString:@"-" withString:@"."];
       }
    _timeLabel.text = [NSString stringWithFormat:@"有效日期：%@-%@",start,end];
    
    if ([couponsModel.couponType isEqualToString:@"1"]) {
        _typeLabel.text = @"商品专享券";
        
        BOOL canuse = NO;
        for (int i=0; i<carModel.cartGoodsList.count; i++) {
            GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[i];
            if ([goodsModel.batchId isEqualToString:couponsModel.batchId]) {
                canuse = YES;
                
                if (goodsModel.price *goodsModel.quantity < couponsModel.requireAmount) { // 该商品小于 用券规则 无法使用
                    _isCanUsed = NO;
                }
            }
        }
        if (canuse == NO) { // 不存在该批次商品，无法使用
            _isCanUsed = NO;
        }
        
    } else if ([couponsModel.couponType isEqualToString:@"2"]) {
        _typeLabel.text = @"店铺优惠券";
        
        if (couponsModel.suppierFirmId != [carModel.suppierFirmId integerValue]) { // id 对不上 无法使用的券
            
            _isCanUsed = NO;
            
        } else { // id 对上了 继续判断
            
            // 商品总计金额
            CGFloat allMoney = 0;
            for (int i=0; i<carModel.cartGoodsList.count; i++) {
                GLBShoppingCarGoodsModel *goodsModel = carModel.cartGoodsList[i];
                allMoney += (goodsModel.price *goodsModel.quantity);
            }
            if (allMoney < couponsModel.requireAmount) { // 总金额小于用券规则 无法使用
                _isCanUsed = NO;
            }
            
        }
        
    } else if ([couponsModel.couponType isEqualToString:@"3"]) {
        _typeLabel.text = @"平台优惠券";
        
    }
    
    if (seletcedArray.count > 0) {
        for (int i=0; i<seletcedArray.count; i++) {
            GLBMineTicketCouponsModel *selectCoupons = seletcedArray[i];
            if (selectCoupons.cashCouponId == couponsModel.cashCouponId) { // 该券已经被使用，无法使用
                
                _isCanUsed = NO;
            }
        }
    }
    
    _iconImage.image = [UIImage imageNamed:@"dc_gx_no"];
    if (carModel.ticketModel.cashCouponId == couponsModel.cashCouponId) {
        _isCanUsed = YES;
        _iconImage.image = [UIImage imageNamed:@"dc_gx_yes"];
    }
    
    _iconImage.hidden = NO;
    if (_isCanUsed == NO) {
        _bgImage.image = [UIImage imageNamed:@"dc_ticket_bg2"];
        
        _iconImage.hidden = YES;
        
        _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
        _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
        _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
        _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
    }
    
}


- (UIImage *)dc_cantUserImage
{
    UIImage *image = [UIImage dc_initImageWithColor:[UIColor dc_colorWithHexString:@"#cccccc"] size:CGSizeMake(kScreenW - 20, 80)];
    return image;
}


#pragma mark - setter
// 赋值 个人版
- (void)setPersonValueWithDataArray:(NSArray *)dataArray seletcedArray:(NSMutableArray *)seletcedArray carModel:(GLPShoppingCarModel *)carModel indexPath:(NSIndexPath *)indexPath
{
    GLPNewTicketModel *couponsModel = dataArray[indexPath.row];
    
    _bgImage.image = [UIImage imageNamed:@"dc_ticket_bg1"];
    _isCanUsed = YES;
    
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    
    _moneyLabel.attributedText = [self dc_attributeStr:couponsModel.discountAmount];
    _ruleLabel.text = [NSString stringWithFormat:@"满%.0f元可使用",couponsModel.requireAmount];
    
    NSString *start = couponsModel.useStartDate;
    if ([start containsString:@" "]) {
        start = [start componentsSeparatedByString:@" "][0];
    }
    if ([start containsString:@"-"]) {
        start = [start stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    
    NSString *end = couponsModel.useEndDate;
    if ([end containsString:@" "]) {
        end = [end componentsSeparatedByString:@" "][0];
    }
    if ([end containsString:@"-"]) {
        end = [end stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"有效日期：%@-%@",start,end];
    
    if (couponsModel.couponsClass == 3) {
        _typeLabel.text = @"商品专享券";
        
        BOOL canuse = NO;
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            for (int i = 0; i<carModel.validActInfoList.count; i++) {
                GLPShoppingCarActivityModel *activityModel = carModel.validActInfoList[i];
                if (activityModel.actCartGoodsList && activityModel.actCartGoodsList.count > 0) {
                    for (int j =0; j<activityModel.actCartGoodsList.count; j++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = activityModel.actCartGoodsList[j];
                        if (goodsModel.isSelected) {
                            // 商品总价
                            CGFloat price = goodsModel.quantity *goodsModel.sellPrice;
                            // 满减条件 未计算进去
                            
                            // 达到券金额要求
                            if (price >= couponsModel.discountAmount ) {
                                canuse = YES;
                            }
                        }
                    }
                }
            }
        }
        
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            for (int i=0; i<carModel.validNoActGoodsList.count; i++) {
                GLPShoppingCarNoActivityModel *noActModel = carModel.validNoActGoodsList[i];
                if (noActModel.isSelected) {
                    // 商品总价
                    CGFloat price = noActModel.quantity *noActModel.sellPrice;

                    // 达到券金额要求
                    if (price >= couponsModel.discountAmount) {
                        canuse = YES;
                    }
                }
            }
        }
        

        if (canuse == NO) { // 不存在该批次商品，无法使用
            _isCanUsed = NO;
        }
        
    } else {
        
        _typeLabel.text = @"店铺优惠券";
        
        // 商品总计金额
        CGFloat allMoney = 0;
        if (carModel.validActInfoList && carModel.validActInfoList.count > 0) {
            for (int i = 0; i<carModel.validActInfoList.count; i++) {
                GLPShoppingCarActivityModel *activityModel = carModel.validActInfoList[i]; //活动
                if (activityModel.actCartGoodsList && activityModel.actCartGoodsList.count > 0) {
                    
                    CGFloat price = 0;// 单个活动商品总价
                    for (int j =0; j<activityModel.actCartGoodsList.count; j++) {
                        GLPShoppingCarActivityGoodsModel *goodsModel = activityModel.actCartGoodsList[j]; //活动商品
                        if (goodsModel.isSelected) {
                            // 累加
                             price += goodsModel.quantity *goodsModel.sellPrice;
                        }
                        
                        // 满减条件
                        if (price > activityModel.requireAmount) {
                            price -= activityModel.discountAmount;
                        }
                        
                        // 累加
                        allMoney += price;
                    }
                }
            }
        }
        
        if (carModel.validNoActGoodsList && carModel.validNoActGoodsList.count > 0) {
            CGFloat price = 0; // 非活动商品总价
            for (int i=0; i<carModel.validNoActGoodsList.count; i++) {
                GLPShoppingCarNoActivityModel *noActModel = carModel.validNoActGoodsList[i];
                if (noActModel.isSelected) {
                    // 商品总价
                    price += noActModel.quantity *noActModel.sellPrice;
                }
            }
            
            // 累加
            allMoney += price;
        }
        if (allMoney < couponsModel.requireAmount) { // 总金额小于用券规则 无法使用
            _isCanUsed = NO;
        }
    }
    
    if (seletcedArray.count > 0) {
        for (int i=0; i<seletcedArray.count; i++) {
            GLPTicketSelectTicketModel *selectCoupons = seletcedArray[i];
            if (selectCoupons.couponsId == couponsModel.couponsId) { // 该券已经被使用，无法使用
                _isCanUsed = NO;
            }
        }
    }
    
    if (carModel.ticketArray && carModel.ticketArray.count > 0) {
        CGFloat discountAmount111 = 0;
        NSInteger type = 0;
        for (int ppp = 0; ppp < carModel.ticketArray.count; ppp++) {
            GLPNewTicketModel *ticketModel666 = carModel.ticketArray[ppp];
            discountAmount111 += ticketModel666.discountAmount;
            if (ticketModel666.discountAmount > 0) {
                type = ticketModel666.couponsClass;
            }
        }
        if (discountAmount111 == 0) { // 初始值
            if (carModel.couponsClass == 2) {// 店铺通用券
                if (couponsModel.couponsClass != 2) {
                    _isCanUsed = NO;
                }
            } else if (carModel.couponsClass == 3) { // 商品券
                if (couponsModel.couponsClass != 3) {
                    _isCanUsed = NO;
                }
            }
        } else { // 非初始值
            if (type == 2) {// 店铺通用券
                if (couponsModel.couponsClass != 2) {
                    _isCanUsed = NO;
                }
            } else if (type == 3) { // 商品券
                if (couponsModel.couponsClass != 3) {
                    _isCanUsed = NO;
                }
            }
        }
    }
//    else { // 初始值
//        if (carModel.couponsClass == 2) {// 店铺通用券
//            if (couponsModel.couponsClass != 2) {
//                _isCanUsed = NO;
//            }
//        } else if (carModel.couponsClass == 3) { // 商品券
//            if (couponsModel.couponsClass != 3) {
//                _isCanUsed = NO;
//            }
//        }
//    }
    
    _iconImage.image = [UIImage imageNamed:@"dc_gx_no"];
    if (carModel.ticketArray.count > 0) {
        for (int ccc = 0; ccc < carModel.ticketArray.count; ccc ++) {
            GLPNewTicketModel *ticketModel = carModel.ticketArray[ccc];
            if (ticketModel.couponsId == couponsModel.couponsId) {
                _isCanUsed = YES;
                _iconImage.image = [UIImage imageNamed:@"dc_gx_yes"];
            }
        }
    }
    
    _iconImage.hidden = NO;
    if (_isCanUsed == NO) {
        _bgImage.image = [UIImage imageNamed:@"dc_ticket_bg2"];
        
        _iconImage.hidden = YES;
        
        _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
        _typeLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
        _ruleLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
        _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
    }
}

@end
