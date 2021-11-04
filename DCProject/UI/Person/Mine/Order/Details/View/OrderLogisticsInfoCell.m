//
//  OrderLogisticsInfoCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "OrderLogisticsInfoCell.h"

@implementation OrderLogisticsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark -set
- (void)setModel:(GLPOrderDeliverModel *)model{
    _model = model;
    if ([_model.isSeparate isEqualToString:@"2"]) {
        _contentLab.text = [NSString stringWithFormat:@"%@ 单号：%@",_model.logisticsFirmName,_model.logisticsNo];
        UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
        longPressGesture2.minimumPressDuration = 0.8f;//设置长按 时间
        _contentLab.userInteractionEnabled = YES;
        [_contentLab addGestureRecognizer:longPressGesture2];
    }else{
        _contentLab.text = [NSString stringWithFormat:@"该订单已分开发货，点击可查看详情"];
    }
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_model.logisticsNo.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _model.logisticsNo;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
