//
//  GLPToPayHeadView.m
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//

#import "GLPToPayHeadView.h"

@implementation GLPToPayHeadView

#pragma mark - initialize
- (void)awakeFromNib {
    [super awakeFromNib];
    
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
- (void)setModel:(GLPOrderForPayModel *)model{
    _model = model;
    
    _orderNoLab.text = [NSString stringWithFormat:@"订单号：%@",_model.orderNo];
    
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",_model.payAmt];
    self.priceLab = [UILabel setupAttributeLabel:self.priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRMedium size:27] forReplace:@"¥"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
