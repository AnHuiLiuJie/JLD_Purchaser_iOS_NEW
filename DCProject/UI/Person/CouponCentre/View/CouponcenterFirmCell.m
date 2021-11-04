//
//  CouponcenterFirmCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "CouponcenterFirmCell.h"
#import "CouponCenterGoodsCell.h"
@implementation CouponcenterFirmCell
{
    UITableView *_tableview;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 58, kScreenW, 0) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor whiteColor];
    [_tableview registerNib:[UINib nibWithNibName:@"CouponCenterGoodsCell" bundle:nil] forCellReuseIdentifier:@"CouponCenterGoodsCell"];
    [self.contentView addSubview:_tableview];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCenterGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCenterGoodsCell"];
    if (cell==nil)
    {
        cell = [[CouponCenterGoodsCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    NSDictionary *dic = self.listArray[indexPath.section];
    NSString *isreceive = [NSString stringWithFormat:@"%@",dic[@"isReceive"]];
    if ([isreceive isEqualToString:@"1"])
    {
        [cell.getBtn setTitle:@"去使用" forState:UIControlStateNormal];
        cell.bgImageV.image = [UIImage imageNamed:@"yilingqu"];
        cell.haveImageV.hidden = NO;
    }
    else{
        [cell.getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        cell.bgImageV.image = [UIImage imageNamed:@"weilingqu"];
        cell.haveImageV.hidden = YES;
    }
    [cell.goodImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"goodsImg1"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.discountLab.text = [NSString stringWithFormat:@"¥%@",dic[@"discountAmount"]];
    cell.discountLab = [UILabel setupAttributeLabel:cell.discountLab textColor:cell.discountLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    cell.requestLab.text = [NSString stringWithFormat:@"满%@元可用",dic[@"requireAmount"]];
    cell.getBtn.tag = indexPath.section;
    [cell.getBtn addTarget:self action:@selector(getClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)setDataArray:(NSArray *)dataArray
{
    [self.listArray removeAllObjects];
    [self.listArray addObjectsFromArray:dataArray];
    [_tableview reloadData];
     _tableview.frame = CGRectMake(0, 58, kScreenW, 95*self.listArray.count);
}

- (void)getClick:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"立即领取"])
    {
        if (self.couponblock) {
            self.couponblock(btn.tag);
        }
    }
    else{
        if (self.couponuserblock) {
            self.couponuserblock(btn.tag);
        }
    }
  
}
@end
