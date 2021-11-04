//
//  OrderGoodsInfoCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "OrderGoodsInfoCell.h"

#import "OrderListModel.h"

static CGFloat Item_H = 100;
static NSString *const OrderGoodsListCellID = @"OrderGoodsListCell";

@implementation OrderGoodsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setViewUI];

}

#pragma mark UI
- (void)setViewUI{
    self.tableview.userInteractionEnabled = YES;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderGoodsListCell" bundle:nil] forCellReuseIdentifier:OrderGoodsListCellID];
    self.tableview.scrollEnabled = NO;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _topBgView.userInteractionEnabled = YES;
    [_topBgView addGestureRecognizer:tapGesture1];
    
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    !_OrderGoodsInfoCell_Block ? : _OrderGoodsInfoCell_Block();
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.orderGoodsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Item_H;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderGoodsListCellID];
    if (cell==nil){
        cell = [[OrderGoodsListCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.model.orderGoodsList.count != 0) {
        GLPOrderGoodsListModel *model = self.model.orderGoodsList[indexPath.section];
        model.orderType = self.model.orderType;
        cell.model = model;
    }
    WEAKSELF;
    cell.OrderGoodsListCell_block = ^(GLPOrderGoodsListModel * _Nonnull model) {
        !weakSelf.OrderGoodsInfoCell_block ? : weakSelf.OrderGoodsInfoCell_block(model);
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLPOrderGoodsListModel *model = self.model.orderGoodsList[indexPath.section];
    !self.OrderGoodsInfoIndexCell_block ? : self.OrderGoodsInfoIndexCell_block(model);
}


#pragma mark - set
- (void)setModel:(GLPOrderDetailModel *)model{
    _model = model;
    
    self.bgView_H_LayoutConstraint.constant = 40 + 30*4+50+self.model.orderGoodsList.count*Item_H;

    [_storeImageV sd_setImageWithURL:[NSURL URLWithString:model.sellerFirmImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    _statuLab.text = [NSString stringWithFormat:@"%@",model.sellerFirmName];
    
    _allGoodsPriceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.goodsTotalAmount floatValue]];
    _allGoodsPriceLab = [UILabel setupAttributeLabel:_allGoodsPriceLab textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFR size:15] forReplace:@"¥"];
    
    _freightLab.text = [NSString stringWithFormat:@"¥%.2f",[model.logisticsAmount floatValue]];
    _freightLab = [UILabel setupAttributeLabel:_freightLab textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFR size:15] forReplace:@"¥"];
    
    _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",[model.deductibleAmount floatValue]+[model.actDiscount floatValue]];
    _discountLab = [UILabel setupAttributeLabel:_discountLab textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFR size:15] forReplace:@"¥"];
    
    _allOrderPriceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.payableAmount floatValue]];
    _allOrderPriceLab = [UILabel setupAttributeLabel:_allOrderPriceLab textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFR size:15] forReplace:@"¥"];
    
    _payPriceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.payableAmount floatValue]];///商品总金额(goodsTotalAmount)+物流金额(logisticsAmount)-活动优惠金额(actDiscount)-商品优惠金额(goodsDiscount)-物流优惠金额(logisticsDiscount)-抵扣金额(deductibleAmount)
    _payPriceLab = [UILabel setupAttributeLabel:_payPriceLab textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFRMedium size:19] forReplace:@"¥"];

    [self.tableview reloadData];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
