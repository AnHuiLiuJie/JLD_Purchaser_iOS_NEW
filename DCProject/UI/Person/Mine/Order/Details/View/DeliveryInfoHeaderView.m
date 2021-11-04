//
//  DeliveryInfoHeaderView.m GLPEtpCenterHeaderView
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import "DeliveryInfoHeaderView.h"

@interface DeliveryInfoHeaderView ()


@end


@implementation DeliveryInfoHeaderView


#pragma mark - initialize
- (void)awakeFromNib {
    [super awakeFromNib];

    [self setViewUI];
}


- (void)setViewUI{
    self.bgView.backgroundColor = [UIColor whiteColor];
    _titleLab.text = @"配送信息";
    [_replicateBtn addTarget:self action:@selector(copyNoAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)copyNoAction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.model.logisticsNo];
    [SVProgressHUD showSuccessWithStatus:@"复制成功！"];
}

#pragma mark - set
- (void)setModel:(DeliveryListModel *)model{
    _model = model;
    
    _logisticsFirmName.text = _model.logisticsFirmName;
    
    _logisticsNo.text = [NSString stringWithFormat:@"单号：%@",_model.logisticsNo];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
