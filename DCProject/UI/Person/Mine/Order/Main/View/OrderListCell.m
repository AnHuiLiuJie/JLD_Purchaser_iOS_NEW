//
//  OrderListCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "OrderListCell.h"
#import "PrecriptionGoodsCell.h"
#import "OrderListModel.h"
#import "TRStorePageVC.h"

static CGFloat kBtnHight = 32;
static NSInteger kBtnNum = 4;

static NSString *const PrecriptionGoodsCellID = @"PrecriptionGoodsCell";


@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
    self.backgroundColor = [UIColor whiteColor];
    
    self.tableview.userInteractionEnabled = NO;
    self.priceLab.font = [UIFont fontWithName:PFR size:14];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"PrecriptionGoodsCell" bundle:nil] forCellReuseIdentifier:PrecriptionGoodsCellID];
    self.tableview.scrollEnabled = NO;
    self.tableview.estimatedRowHeight = 84.f;
    self.tableview.tableFooterView = [UIView new];
    
    self.couponArray = [NSMutableArray arrayWithCapacity:0];
    self.orderBtn1.layer.masksToBounds = YES;
    self.orderBtn1.layer.cornerRadius = 15;
    self.orderBtn1.layer.borderWidth = 1;
    self.orderBtn1.layer.borderColor = RGB_COLOR(0, 183, 171).CGColor;
    self.orderBtn2.layer.masksToBounds = YES;
    self.orderBtn2.layer.cornerRadius = 15;
    self.orderBtn2.layer.borderWidth = 1;
    self.orderBtn2.layer.borderColor = RGB_COLOR(198, 198, 198).CGColor;
    self.orderBtn3.layer.masksToBounds = YES;
    self.orderBtn3.layer.cornerRadius = 15;
    self.orderBtn3.layer.borderWidth = 1;
    self.orderBtn3.layer.borderColor = RGB_COLOR(198, 198, 198).CGColor;
    
    //    _storeNmaeLab.userInteractionEnabled = YES;
    //          UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(store)];
    //          [_storeNmaeLab addGestureRecognizer:tap];
    UIButton *bt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(40);
    }];
    [bt addTarget:self action:@selector(store) forControlEvents:(UIControlEventTouchUpInside)];
    
//    CGFloat spacing = 10.0f;
//    CGFloat itemW = (kScreenW-45-spacing*5)/4;
//    //NSInteger num = self.bottomArr.count;
//    //CGFloat leftX = kScreenW -(num+1)*spacing-num*itemW;
//    CGFloat itemH = kBtnHight;
//    CGFloat index = 0;
//    NSArray *allTitle = @[@"客服1",@"客服2",@"客服3",@"客服4"];
//    for (NSString *str in allTitle) {
//        NSString *title = [NSString stringWithFormat:@"%@",str];
//        UIFont *font = [UIFont fontWithName:PFR size:14];
//        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        subBtn.backgroundColor = [UIColor whiteColor];
//        subBtn.titleLabel.font = font;
//        [subBtn setTitle:title forState:UIControlStateNormal];
//        [subBtn setTitleColor:[UIColor dc_colorWithHexString:@"#666666"] forState:UIControlStateNormal];
//        [subBtn setTitleColor:[UIColor dc_colorWithHexString:@"#14D7C7"] forState:UIControlStateSelected];
//        subBtn.tag = index;
//
//        [subBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:subBtn];
//
//        [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_bottomView).offset(spacing+(spacing+itemW)*index);
//            make.centerY.equalTo(_bottomView).offset(0);
//            make.size.equalTo(CGSizeMake(itemW, itemH));
//        }];
//        subBtn.selected = NO;
//        subBtn.hidden = YES;
//        [DCSpeedy dc_changeControlCircularWith:subBtn AndSetCornerRadius:itemH/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#666666"] canMasksToBounds:YES];
//        index++;
//    }
}

#pragma mark -set
-(void)setIsRefund:(BOOL)isRefund{
    _isRefund = isRefund;
}

-(void)setModel:(OrderListModel *)model{
    _model = model;
    
    _rpStateImg.hidden = model.rpState == 0;

    [self.couponArray removeAllObjects];
    self.couponArray = [model.orderGoodsList mutableCopy];

    [self.storeImageV sd_setImageWithURL:[NSURL URLWithString:model.sellerFirmImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.storeNmaeLab.text = [NSString stringWithFormat:@"%@",model.sellerFirmName];
    self.sellerFirmId = model.sellerFirmId;
    self.priceLab.text = [NSString stringWithFormat:@"共%@件商品  合计:¥%@",model.goodsCount,model.payableAmount];
    NSString *payableAmount = model.payableAmount.length > 0 ? model.payableAmount : @"0";
    self.priceLab.attributedText = [self dc_attStrWithCount:model.goodsCount price:payableAmount];

    self.tableview.frame = CGRectMake(0, 48, kScreenW-30, (84+8)*self.couponArray.count);
    
    if (_isRefund == YES) {
        NSString *orderStateStr = model.orderStateStr;
        [self.bottomArr removeAllObjects];
        [self.bottomArr addObjectsFromArray:@[@"客服"]];
        NSString *buyerReturnState = [NSString stringWithFormat:@"%@",model.buyerReturnState];
        if([buyerReturnState isEqualToString:@"1"]){
            orderStateStr = @"已全部退款";
        }else if([buyerReturnState isEqualToString:@"2"]){
            orderStateStr = @"已部分退款";
        }else if([buyerReturnState isEqualToString:@"3"]){
            orderStateStr = @"已申请";
        }else if([buyerReturnState isEqualToString:@"4"]){
            orderStateStr = @"已拒绝";
        }
        self.statuLab.text = orderStateStr;
    }else{
        [self getDifferentOrderStatesData:model];
    }

    
    if (self.bottomArr.count != 0) {
        [self changeBottomView:self.bottomArr];
    }
    [self.tableview reloadData];
}

-(void)setReturnModel:(ReturnOrderListModel *)returnModel{
    _returnModel = returnModel;
    
    _rpStateImg.hidden = YES;
    [self.storeImageV sd_setImageWithURL:[NSURL URLWithString:_returnModel.sellerFirmImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.storeNmaeLab.text = [NSString stringWithFormat:@"%@",_returnModel.sellerFirmName];
    self.sellerFirmId = _returnModel.sellerFirmId;
    self.priceLab.text = [NSString stringWithFormat:@"共%ld件商品  合计:¥%@",_returnModel.retrunGoodsVO.count,_returnModel.returnTotalAmount];
    NSString *payableAmount = _returnModel.returnTotalAmount.length > 0 ? _returnModel.returnTotalAmount : @"0.00";
    self.priceLab.attributedText = [self dc_attStrWithCount:[NSString stringWithFormat:@"%ld",_returnModel.retrunGoodsVO.count] price:payableAmount];

    [self.couponArray removeAllObjects];
    self.couponArray = [_returnModel.retrunGoodsVO mutableCopy];


    self.tableview.frame = CGRectMake(0, 48, kScreenW-30, (84+8)*self.couponArray.count);
    
    NSString *orderStateStr = _returnModel.reasonText;
    [self.bottomArr removeAllObjects];
    NSString *refundState = [NSString stringWithFormat:@"%@",_returnModel.refundState];//1-退款成功，2-退款失败，3-退款中，4-已拒绝
    if([refundState isEqualToString:@"1"]){
        orderStateStr = @"退款成功";
        [self.bottomArr addObjectsFromArray:@[@"客服"]];
    }else if([refundState isEqualToString:@"2"]){
        orderStateStr = @"退款失败";
        [self.bottomArr addObjectsFromArray:@[@"客服"]];
    }else if([refundState isEqualToString:@"3"]){
        orderStateStr = @"退款中";
        [self.bottomArr addObjectsFromArray:@[@"客服",@"取消退款"]];
    }else if([refundState isEqualToString:@"4"]){
        orderStateStr = @"已拒绝";
        [self.bottomArr addObjectsFromArray:@[@"客服"]];
    }

    self.statuLab.text = orderStateStr;

    if (self.bottomArr.count != 0) {
        [self changeBottomView:self.bottomArr];
    }
    [self.tableview reloadData];
}

- (void)changeBottomView:(NSArray *)array{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenW-45, self.bottomView.dc_height);
//    view.layer.borderColor = [UIColor redColor].CGColor;
//    view.layer.borderWidth = 1;
    [[self.bottomView viewWithTag:1001] removeFromSuperview];
    view.tag = 1001;
    CGFloat spacing = 10.0f;
    CGFloat itemW = (kScreenW-45-spacing*5)/kBtnNum;
    NSInteger num = self.bottomArr.count;
    CGFloat leftX = kScreenW-45-num*spacing-num*itemW;
    CGFloat itemH = kBtnHight;
    CGFloat index = 0;
    NSArray *allTitle = self.bottomArr;
    for (NSString *str in allTitle) {
        NSString *title = [NSString stringWithFormat:@"%@",str];
        UIFont *font = [UIFont fontWithName:PFR size:14];
        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subBtn.backgroundColor = [UIColor whiteColor];
        subBtn.titleLabel.font = font;
        [subBtn setTitle:title forState:UIControlStateNormal];
        [subBtn setTitleColor:[UIColor dc_colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [subBtn setTitleColor:[UIColor dc_colorWithHexString:@"#14D7C7"] forState:UIControlStateSelected];
        subBtn.tag = index;

        [subBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:subBtn];
        [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(leftX+(spacing+itemW)*index);
            make.centerY.equalTo(view).offset(0);
            make.size.equalTo(CGSizeMake(itemW, itemH));
        }];
        if ([title isEqualToString:@"删除订单"] || [title isEqualToString:@"付款"] || [title isEqualToString:@"确认收货"] || [title isEqualToString:@"评价"] || [title isEqualToString:@"取消退款"] ) {
            subBtn.selected = YES;
            [DCSpeedy dc_changeControlCircularWith:subBtn AndSetCornerRadius:kBtnHight/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#14D7C7"] canMasksToBounds:YES];
        }else{
            subBtn.selected = NO;
            [DCSpeedy dc_changeControlCircularWith:subBtn AndSetCornerRadius:itemH/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#666666"] canMasksToBounds:YES];
        }

        index++;
    }
    [self.bottomView addSubview:view];
}

- (void)confirmBtnAction:(UIButton *)button{
    if (self.isRefund) {
        !_OrderListCell_Block ? : _OrderListCell_Block(button.titleLabel.text,self.returnModel);
    }else
        !_OrderListCell_block ? : _OrderListCell_block(button.titleLabel.text,self.model);

}

- (void)getDifferentOrderStatesData:(OrderListModel *)model{
    //订单状态：订单状态：1-待付款；2-待接单，3-已接单；5-已发货；6-待评价；7-交易关闭；8-有退款
    NSString *orderState = [NSString stringWithFormat:@"%@",model.orderState];
    //退款状态：0-全部有退款订单，1-退款成功，2-退款失败，3-退款中,4-已拒绝
    //NSString *refundState = [NSString stringWithFormat:@"%@",listmodel.refundState];
    //用户退款状态：0-默认状态，1-已全部退款，2-已部分退款，3-已申请，4-已拒绝
    NSString *buyerReturnState = [NSString stringWithFormat:@"%@",model.buyerReturnState];
    NSString *orderStateStr = model.orderStateStr;

    [self.bottomArr removeAllObjects];
    if ([orderState isEqualToString:@"1"]) {
        [self.bottomArr addObjectsFromArray:@[@"客服",@"取消订单",@"付款"]];
    }else if([orderState isEqualToString:@"2"] || [orderState isEqualToString:@"3"]){
        if([buyerReturnState isEqualToString:@"2"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else if([buyerReturnState isEqualToString:@"3"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单",@"取消退款"]];
        }else if([buyerReturnState isEqualToString:@"4"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单"]];
        }else{
            [self.bottomArr addObjectsFromArray:@[@"客服",@"催单",@"退款"]];
        }
    }else if([orderState isEqualToString:@"5"]){
        if([buyerReturnState isEqualToString:@"2"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"确认收货"]];
        }else if([buyerReturnState isEqualToString:@"3"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"取消退款"]];//@"确认收货"
        }else if([buyerReturnState isEqualToString:@"4"]){
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"确认收货"]];
        }else{
            [self.bottomArr addObjectsFromArray:@[@"客服",@"延期收货",@"退款",@"确认收货"]];
        }
        if ([model.oprState isEqualToString:@"10"]) {
            [self.bottomArr removeObject:@"延期收货"];
        }
    }else if([orderState isEqualToString:@"6"]){
        [self.bottomArr addObjectsFromArray:@[@"客服",@"评价"]];
        NSString *evalState = [NSString stringWithFormat:@"%@",model.evalState];
        if ([evalState isEqualToString:@"21"] || [evalState isEqualToString:@"22"]){
            orderStateStr = @"已评价";
            [self.bottomArr removeObject:@"评价"];
        }else{
            orderStateStr = @"待评价";
        }
    }else if([orderState isEqualToString:@"7"]){
        [self.bottomArr addObjectsFromArray:@[@"客服",@"删除订单"]];
    }else if([orderState isEqualToString:@"8"]){
        [self.bottomArr addObjectsFromArray:@[@"客服"]];
    }else{////这里要注意

    }
    
    //拼团商品不可以退款
    if ([model.orderType isEqualToString:@"4"] && ![model.joinState isEqualToString:@"1"]) {
        [self.bottomArr removeObject:@"退款"];
    }
    
    self.statuLab.text = orderStateStr;

//    if ([buyerReturnState isEqualToString:@"0"]) {
//
//    }else {
//        [self.bottomArr removeAllObjects];
//        if([buyerReturnState isEqualToString:@"1"]){
//            [self.bottomArr addObjectsFromArray:@[@"客服"]];
//        }else if([buyerReturnState isEqualToString:@"2"]){
//            [self.bottomArr addObjectsFromArray:@[@"客服"]];
//        }else if([buyerReturnState isEqualToString:@"3"]){
//            [self.bottomArr addObjectsFromArray:@[@"客服",@"取消退款"]];
//        }else if([buyerReturnState isEqualToString:@"4"]){
//            [self.bottomArr addObjectsFromArray:@[@"客服"]];
//        }
//    }
    


}

#pragma mark - 富文本
- (NSMutableAttributedString *)dc_attStrWithCount:(NSString *)count price:(NSString *)price
{
    NSString *text = [NSString stringWithFormat:@"共计%@件商品 合计：¥%@",count,price];
    NSString *floStr;
    NSString *intStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        intStr = [text substringToIndex:range.location];//前
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange range1 = [text rangeOfString:intStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:range1];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#E71313"]} range:NSMakeRange(2, count.length)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(count.length+9, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:16],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(count.length+10, attrStr.length - count.length-10)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:range2];
    
    return attrStr;
}


- (void)store{
    TRStorePageVC *vc = [[TRStorePageVC alloc] init];
    vc.firmId = _sellerFirmId;
    [[self jsd_findVisibleViewController].navigationController pushViewController:vc animated:YES];
    
}

- (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

- (UIViewController *)jsd_findVisibleViewController {
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.couponArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrecriptionGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:PrecriptionGoodsCellID];
    if (cell==nil){
        cell = [[PrecriptionGoodsCell alloc] init];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    OredrGoodsModel *model = self.couponArray[indexPath.section];
    model.orderType = self.model.orderType;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.00f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (NSMutableArray *)bottomArr{
    if (!_bottomArr) {
        _bottomArr = [[NSMutableArray alloc] init];
    }
    return _bottomArr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
