//
//  KFOrderListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import "KFOrderListCell.h"

@implementation KFOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

- (void)setViewUI
{
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    self.contentView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _goodsImg.layer.masksToBounds = YES;
    _goodsImg.layer.cornerRadius = 5;
    self.goodsImg.layer.minificationFilter = kCAFilterTrilinear;

}


#pragma mark - set
- (void)setModel:(OrderListModel *)model{
    _model = model;
    
    _orderNoLab.text = [NSString stringWithFormat:@"订单号:%@",_model.orderNo];
    _orderTimeLab.text = [NSString stringWithFormat:@"%@",_model.orderTime];
    _payableAmountLab.text = _model.payableAmount;
    NSString *state = _model.orderState;//订单状态：1-待付款；3-待发货；4-买家申请退款中 (发货前整笔订单退款)；40-退款已受理；41-退款失败；5-已发货；6-交易成功；7-交易关闭
    _orderStateLab.text = _model.orderStateStr;
    if ([state isEqualToString:@"3"]) {
        _orderStateLab.textColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
    }else if([state isEqualToString:@"6"]){
        _orderStateLab.textColor = [UIColor dc_colorWithHexString:@"#1DA9A2"];
    }else if([state isEqualToString:@"41"]){
        _orderStateLab.textColor = [UIColor dc_colorWithHexString:@"#FF6030"];
    }else if([state isEqualToString:@"7"]){
        _orderStateLab.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    }else{
        _orderStateLab.textColor = [UIColor dc_colorWithHexString:@"#4CB6FF"];
    }
    
    NSArray *arr = [OredrGoodsModel mj_objectArrayWithKeyValuesArray:_model.orderGoodsList];
    OredrGoodsModel *fristModel = arr.count > 0  ?  arr[0] : nil;
    _goodsTitleLab.text = fristModel.goodsTitle;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:fristModel.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
