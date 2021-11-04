//
//  RefundDetailsListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/23.
//

#import "RefundDetailsListCell.h"

@implementation RefundDetailsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewUI];
}

- (void)setViewUI{
    _statusBtn.enabled = NO;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _topBgView.userInteractionEnabled = YES;
    [_topBgView addGestureRecognizer:tapGesture1];
    
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    !_RefundDetailsListCell_block ? : _RefundDetailsListCell_block();
}

#pragma mark - set
-(void)setModel:(GLPDetailReturnModel *)model{
    _model = model;
    
    _titleLab.text = model.goodsTitle;
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    _priceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.sellPrice floatValue]];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFR size:18] forReplace:@"¥"];
    _numLab.text = [NSString stringWithFormat:@"X%@",model.returnNum];
    _wayLab.text = [NSString stringWithFormat:@"%@",model.packingSpec];
    
    if ([model.returnState intValue] == 1) {
        //_statusBtn.hidden = NO;
        [_statusBtn setTitle:[NSString stringWithFormat:@"  %@  ",@"退款成功"] forState:UIControlStateNormal];
        [DCSpeedy dc_changeControlCircularWith:_statusBtn AndSetCornerRadius:_statusBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
        _statusLab.text = @"退款成功";
    }else{
        //_statusBtn.hidden = YES;
        [_statusBtn setTitle:[NSString stringWithFormat:@"  %@  ",@"退款失败"] forState:UIControlStateNormal];
        [DCSpeedy dc_changeControlCircularWith:_statusBtn AndSetCornerRadius:_statusBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#FD4B14"] canMasksToBounds:YES];
        [_statusBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FD4B14"] forState:UIControlStateNormal];
        _statusLab.text = @"退款失败";
    }
    
    _returnReasonLab.text = _model.returnReason;
    
    _refundTimeLab.text = _model.refundTime;
    
    
    _returnAmountLab.text = [NSString stringWithFormat:@"¥%.2f",[model.returnAmount floatValue]];
    _returnAmountLab = [UILabel setupAttributeLabel:_returnAmountLab textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFRMedium size:19] forReplace:@"¥"];
}

-(void)setDetailModel:(GLPOrderDetailModel *)detailModel{
    _detailModel = detailModel;
    
    [_storeImageV sd_setImageWithURL:[NSURL URLWithString:detailModel.sellerFirmImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    _statuLab.text = [NSString stringWithFormat:@"%@",detailModel.sellerFirmName];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
