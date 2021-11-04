//
//  CouponListCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/4.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "CouponListCell.h"
#import "CouponStoreCell.h"
#import "CouponGoodsCell.h"
#import "CouponsModel.h"
@implementation CouponListCell
{
    UITableView *  _tableView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *const cellID = @"CouponListCell";
    CouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CouponListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageV = [[UIImageView alloc] init];
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 15;
        [self.contentView addSubview:_imageV];
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = RGB_COLOR(51, 51, 51);
        _nameLab.text = @"";
        _nameLab.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_nameLab];
        UIImageView*rightImageV = [[UIImageView alloc] init];
        rightImageV.image = [UIImage imageNamed:@"dc_arrow_right_xh"];
        [self.contentView addSubview:rightImageV];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 70, kScreenW-60, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"CouponStoreCell" bundle:nil] forCellReuseIdentifier:@"CouponStoreCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CouponGoodsCell" bundle:nil] forCellReuseIdentifier:@"CouponGoodsCell"];
        self.couponArray = [NSMutableArray arrayWithCapacity:0];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(11);
            make.width.height.offset(30);
        }];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.equalTo(self.imageV.mas_right).offset(9);
            make.width.lessThanOrEqualTo(kScreenW-90);
            make.height.offset(20);
        }];
        [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLab.mas_centerY);
            make.left.equalTo(self.nameLab.mas_right).offset(6);
            make.height.offset(15);
            make.width.offset(8);

        }];
    }
    return self;
}
#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.couponArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponsModel *model = self.couponArray[indexPath.section];
    if ([self.classType isEqualToString:@"3"])
    {
        CouponGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponGoodsCell"];
        if (cell== nil)
        {
            cell = [[CouponGoodsCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell.goodsImageV sd_setImageWithURL:[NSURL URLWithString:model.goodsImg1] placeholderImage:[UIImage imageNamed:@"logo"]];
        NSString *discout = [NSString stringWithFormat:@"¥%@",model.discountAmount];
        NSMutableAttributedString*attr = [[NSMutableAttributedString alloc]initWithString:discout];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[discout rangeOfString:@"¥"]];
        cell.goodsNameLab.attributedText=attr;
        cell.goodsCouponLab.text = [NSString stringWithFormat:@"满%@元可用",model.requireAmount];
        cell.goodsUserBtn.tag = indexPath.section;
        if ([model.isconsume isEqualToString:@"4"]) {
            [cell.goodsUserBtn setTitle:@"已过期" forState:UIControlStateNormal];
            cell.goodsUserBtn.userInteractionEnabled = NO;
            [cell.cellBgImageView setImage:[UIImage imageNamed:@"yhq_sy"]];
            cell.goodsNameLab.textColor = [UIColor dc_colorWithHexString:@"#666666"];
            cell.goodsCouponLab.textColor = [UIColor dc_colorWithHexString:@"#999999"];
            [cell.goodsUserBtn setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            
        }else{
            [cell.cellBgImageView setImage:[UIImage imageNamed:@"dc_yhq_ky2"]];
            cell.goodsUserBtn.userInteractionEnabled = YES;
            cell.goodsNameLab.textColor = [UIColor dc_colorWithHexString:@"#EC642B"];
            cell.goodsCouponLab.textColor = [UIColor dc_colorWithHexString:@"#E8612A"];
            [cell.goodsUserBtn setTitleColor:[UIColor dc_colorWithHexString:@"#E8612A"] forState:UIControlStateNormal];
            [cell.goodsUserBtn setTitle:@"去使用" forState:UIControlStateNormal];
        }
        [cell.goodsUserBtn addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    else if([self.classType isEqualToString:@"2"]){//店铺
        CouponStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponStoreCell"];
        if (cell== nil)
        {
            cell = [[CouponStoreCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        NSString *discout = [NSString stringWithFormat:@"¥%@",model.discountAmount];
        NSMutableAttributedString*attr = [[NSMutableAttributedString alloc]initWithString:discout];
        [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[discout rangeOfString:@"¥"]];
        cell.priceLab.attributedText=attr;
        cell.couponLab.text = [NSString stringWithFormat:@"满%@元可用",model.requireAmount];
        cell.userBtn.tag = indexPath.section;
        [cell.userBtn setTitle:@"去使用" forState:UIControlStateNormal];
        [cell.userBtn addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        CouponGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponGoodsCell"];
        if (cell== nil)
        {
            cell = [[CouponGoodsCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.goodsImageV.image = [UIImage imageNamed:@"logo"];
        cell.goodsNameLab.text = [NSString stringWithFormat:@"%@",model.discountAmount];
        cell.goodsCouponLab.text = [NSString stringWithFormat:@"满%@元可用",model.requireAmount];
        cell.goodsUserBtn.tag = indexPath.section;
        [cell.goodsUserBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [cell.goodsUserBtn addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)setDataArray:(NSArray *)dataArray
{
    [self.couponArray removeAllObjects];
    for (int i=0; i<dataArray.count; i++)
    {
        NSDictionary *dic = dataArray[i];
        CouponsModel *model = [[CouponsModel alloc]initWithDic:dic];
        [self.couponArray addObject:model];
    }
    _tableView.frame = CGRectMake(10, 60, kScreenW-50, 95*self.couponArray.count);
    [_tableView reloadData];
}

- (void)userClick:(UIButton*)btn
{
    if (self.userkblock) {
        self.userkblock(btn.tag);
    }
}

- (void)setCouponsClass:(NSString *)couponsClass{
    self.classType=couponsClass;
}
@end
