//
//  TRHistoryListCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRHistoryListCell.h"
#import "TRHistoryCell.h"
#import "CouponsModel.h"
@implementation TRHistoryListCell
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
    static NSString *const cellID = @"TRHistoryListCell";
    TRHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TRHistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 12, kScreenW-30, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"TRHistoryCell" bundle:nil] forCellReuseIdentifier:@"TRHistoryCell"];
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
    return 85;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRHistoryCell"];
    if (cell== nil)
    {
        cell = [[TRHistoryCell alloc] init];
    }
    CouponsModel *model = self.couponArray[indexPath.section];
    NSString *isconsume = [NSString stringWithFormat:@"%@",self.currentModel.isConsume];
    if ([isconsume isEqualToString:@"2"])
    {
         cell.statuImageV.image = [UIImage imageNamed:@"icon_ysy"];
        cell.LookBtn.hidden = NO;
    }
    else{
        cell.statuImageV.image = [UIImage imageNamed:@"icon_gq"];
        cell.LookBtn.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.storeImageV sd_setImageWithURL:[NSURL URLWithString:self.currentModel.logo] placeholderImage: [UIImage imageNamed:@"logo"]];
   
    cell.storeNameLab.text=self.currentModel.storeName;
    cell.couponLab.text = [NSString stringWithFormat:@"满%@元可用",model.requireAmount];
    cell.moneyLab.text = [NSString stringWithFormat:@"¥%@",model.discountAmount];
    cell.moneyLab = [UILabel setupAttributeLabel:cell.moneyLab textColor:cell.moneyLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    cell.LookBtn.layer.masksToBounds = YES;
    cell.LookBtn.layer.cornerRadius = 12;
    cell.LookBtn.layer.borderWidth = 1;
    cell.LookBtn.layer.borderColor = RGB_COLOR(243, 144, 79).CGColor;
    cell.LookBtn.tag = indexPath.section;
    [cell.LookBtn addTarget:self action:@selector(lookClick:) forControlEvents:UIControlEventTouchUpInside];
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
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)setListModel:(CouponsListModel *)listModel
{
    self.currentModel=listModel;
    [self.couponArray removeAllObjects];
    NSMutableArray *allArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *couponArr=listModel.coupons;
    NSArray *goodsCuoponArr=listModel.couponsGoods;
    [allArr addObjectsFromArray:couponArr];
    [allArr addObjectsFromArray:goodsCuoponArr];
    for (int i=0; i<allArr.count; i++)
    {
        NSDictionary *dic = allArr[i];
        CouponsModel *model = [[CouponsModel alloc]initWithDic:dic];
        [self.couponArray addObject:model];
    }
    _tableView.frame = CGRectMake(0, 12, kScreenW-30, 95*self.couponArray.count);
    [_tableView reloadData];
}

- (void)lookClick:(UIButton*)btn
{
    if (self.detailblock) {
        self.detailblock(btn.tag);
    }
}
@end
