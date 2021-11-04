//
//  EtpBillDetailCell.m
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "EtpBillDetailCell.h"

#import "EtpBillListCell.h"
#import "OrderListModel.h"
#import "TRStorePageVC.h"


static NSString *const EtpBillListCellID = @"EtpBillListCell";

@implementation EtpBillDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];

    
    self.tableview.userInteractionEnabled = YES;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[EtpBillListCell class] forCellReuseIdentifier:EtpBillListCellID];
    self.tableview.scrollEnabled = NO;
}

#pragma mark - set
- (void)setOrderModel:(EtpOrderListModel *)orderModel{
    _orderModel = orderModel;
    
    _orderTimeLab.text = [NSString stringWithFormat:@"%@",_orderModel.settleDate];
    _orderAmountLab.text = [NSString stringWithFormat:@"%@",_orderModel.totalExtendAmount];

    _couponArray = [_orderModel.orderList mutableCopy];
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpBillListCellID];
    if (cell == nil){
        cell = [[EtpBillListCell alloc] init];
    }
//    EtpBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpBillListCellID forIndexPath:indexPath];
    cell.model = _couponArray[indexPath.section];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpOrderPageListModel *model = _couponArray[indexPath.section];
    !_EtpBillDetailCell_Block ?  : _EtpBillDetailCell_Block(model);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // 设置section背景颜色
    view.tintColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
