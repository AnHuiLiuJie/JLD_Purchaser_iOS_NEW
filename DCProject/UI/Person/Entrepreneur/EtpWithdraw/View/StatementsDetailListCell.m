//
//  StatementsDetailListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import "StatementsDetailListCell.h"
#import "EtpCommodityListCell.h"


static NSString *const EtpCommodityListCellID = @"EtpCommodityListCell";

@implementation StatementsDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];

    
    self.tableview.userInteractionEnabled = NO;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"EtpCommodityListCell" bundle:nil] forCellReuseIdentifier:EtpCommodityListCellID];
    self.tableview.scrollEnabled = NO;
    
    [DCSpeedy dc_changeControlCircularWith:_statusLab AndSetCornerRadius:3 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    [DCSpeedy dc_changeControlCircularWith:_customerTypeLab AndSetCornerRadius:3 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPressGesture2.minimumPressDuration = 0.8f;//设置长按 时间
    _orderLab.userInteractionEnabled = YES;
    [_orderLab addGestureRecognizer:longPressGesture2];
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_orderModel.orderNo.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _orderModel.orderNo;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma mark - set
- (void)setOrderModel:(EtpOrderPageListModel *)orderModel{
    _orderModel = orderModel;
    _orderLab.text = _orderModel.orderNo;
    _timeLab.text = _orderModel.orderTime;
    if ([_orderModel.extendLevel isEqual:@"1"]) {
        //_customerTypeLab.textColor = [UIColor dc_colorWithHexString:@""];
        //_customerTypeLab.backgroundColor = [UIColor dc_colorWithHexString:@""];
    }else if ([_orderModel.extendLevel isEqual:@"2"]){
    
    }else if ([_orderModel.extendLevel isEqual:@"3"]){
        
    }
    _customerTypeLab.text = [NSString stringWithFormat:@" %@ ",_orderModel.custType];
    
    _settleStateLab.text = _orderModel.orderStateStr;
    if ([_orderModel.orderState isEqualToString:@"6"]) {//成功
        [_starusImg setImage:[UIImage imageNamed:@"etp_ddxq_cggb"]];
        _settleStateLab.textColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
    }else if([_orderModel.orderState isEqualToString:@"7"]){//失败
        [_starusImg setImage:[UIImage imageNamed:@"etp_ddxq_sbgb"]];
        _settleStateLab.textColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];
    }else{
        [_starusImg setImage:[UIImage imageNamed:@"etp_ddxq_cggb"]];
        _settleStateLab.textColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
    }

    if ([_orderModel.settleState isEqual:@"2"]){//已结算
        _statusLab.textColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        _statusLab.backgroundColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor alpha:0.3];
    }else if ([_orderModel.settleState isEqual:@"3"]){//结算失败
        _statusLab.textColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];//FF6030
        _statusLab.backgroundColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor alpha:0.3];
    }else {//未结算
        _statusLab.textColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor];
        _statusLab.backgroundColor = [UIColor dc_colorWithHexString:DC_OtherStatusColor alpha:0.3];
    }
    _statusLab.text = [NSString stringWithFormat:@" %@ ",_orderModel.settleStateStr];
    

    _numberLab.text = [NSString stringWithFormat:@"共%@件商品",_orderModel.goodsCount];
    _orderAmountLab.text = [NSString stringWithFormat:@"%@",_orderModel.orderAmount];
    _receiveLab.text = [NSString stringWithFormat:@"%@",_orderModel.extendAmount];

    self.couponArray = [_orderModel.goodsList mutableCopy];
    [self.tableview reloadData];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.couponArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpCommodityListCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpCommodityListCellID];
    if (cell == nil){
        cell = [[EtpCommodityListCell alloc] init];
    }
    cell.goodsModel = _couponArray[indexPath.section];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // 设置section背景颜色
    view.tintColor = [UIColor clearColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
