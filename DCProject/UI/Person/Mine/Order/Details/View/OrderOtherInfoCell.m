//
//  OrderOtherInfoCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "OrderOtherInfoCell.h"

@implementation OrderOtherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ui
- (void)setViewUI{
    _jiantouView.layer.masksToBounds = YES;
    _jiantouView.layer.cornerRadius = 1.5;

    
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPressGesture2.minimumPressDuration = 0.8f;//设置长按 时间
    _orderNoLab.userInteractionEnabled = YES;
    [_orderNoLab addGestureRecognizer:longPressGesture2];
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_model.orderNo.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _model.orderNo;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma mark - set
-(void)setModel:(GLPOrderDetailModel *)model{
    _model = model;
    _orderNoLab.text = _model.orderNo;
    
    _orderTimeLab.text = _model.orderTime;
    
    if (_model.payTime.length != 0) {
        _payBgView.hidden = NO;
        _payTimeLab.text = _model.payTime;
        _pay_H_LayoutConstraint.constant = 35;
    }else{
        _payBgView.hidden = YES;
        _pay_H_LayoutConstraint.constant = 0;
    }

    if([self.model.orderState isEqualToString:@"5"]){

        if (_model.oprEtime.length != 0) {
            _logisticsBgView.hidden = NO;
            _logisticsTimeLab.text = _model.oprEtime;
            _logistics_H_LayoutConstraint.constant = 35;
        }else{
            _logisticsBgView.hidden = YES;
            _logistics_H_LayoutConstraint.constant = 0;
        }
    }else{
        _logisticsBgView.hidden = YES;
        _logistics_H_LayoutConstraint.constant = 0;
    }
    
    
    _sellerRemarkLab.text = _model.leaveMsg;

    
}

@end
