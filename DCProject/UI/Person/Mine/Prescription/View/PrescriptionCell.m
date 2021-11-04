//
//  PrescriptionCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PrescriptionCell.h"
#import "PrecriptionGoodsCell.h"
#import "OrderListModel.h"

static NSString *const PrecriptionGoodsCellID = @"PrecriptionGoodsCell";


@implementation PrescriptionCell
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
    PrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:PrecriptionGoodsCellID];
    if (cell == nil) {
        cell = [[PrescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PrecriptionGoodsCellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenW-30, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"PrecriptionGoodsCell" bundle:nil] forCellReuseIdentifier:PrecriptionGoodsCellID];
        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(8, self.frame.size.height-43, kScreenW-130, 17)];
        _timeLab.text = @"提交时间：2019-02-27 03:16:24";
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = RGB_COLOR(153, 153, 153);
        [self.contentView addSubview:_timeLab];
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_lookBtn setTitleColor:RGB_COLOR(0, 183, 171) forState:UIControlStateNormal];
        _lookBtn.frame = CGRectMake(self.frame.size.width-88, self.frame.size.height-50, 81, 30);
        _lookBtn.backgroundColor = [UIColor whiteColor];
        _lookBtn.layer.borderColor = RGB_COLOR(0, 183, 171).CGColor;
        _lookBtn.layer.borderWidth = 1;
        _lookBtn.layer.masksToBounds = YES;
        _lookBtn.layer.cornerRadius = 15;
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lookBtn];
        self.couponArray = [NSMutableArray arrayWithCapacity:0];
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
    return 84;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrecriptionGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrecriptionGoodsCell"];
    if (cell== nil){
        cell = [[PrecriptionGoodsCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OredrGoodsModel *model = self.couponArray[indexPath.section];
    cell.model = model;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)setDataArray:(NSArray *)dataArray
{
    [self.couponArray removeAllObjects];
    for (int i=0; i<dataArray.count; i++)
    {
        NSDictionary *dic = dataArray[i];
        OredrGoodsModel *model = [[OredrGoodsModel alloc]initWithDic:dic];
        [self.couponArray addObject:model];
    }
    _tableView.frame = CGRectMake(0, 0, kScreenW-30, 92*self.couponArray.count);
    _lookBtn.frame = CGRectMake(kScreenW-118, 92*self.couponArray.count+18, 81, 30);
    _timeLab.frame = CGRectMake(8, 92*self.couponArray.count+25, kScreenW-130, 17);
    [_tableView reloadData];
}
@end
