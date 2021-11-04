//
//  TRHomeCell4.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRHomeCell4.h"
#import "TRHomeTableCell1.h"
@implementation TRHomeCell4
{
    UITableView *_tableView;
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
    static NSString *const cellID = @"TRHomeCell4";
    TRHomeCell4 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TRHomeCell4 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        UIImageView*bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 219*kScreenW/375)];
        bgImageV.image = [UIImage imageNamed:@"xianshimiaosha"];
        [self addSubview: bgImageV];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(14, 131*kScreenW/375, kScreenW-14, 131*kScreenW/375) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"TRHomeTableCell1" bundle:nil] forCellReuseIdentifier:@"TRHomeTableCell1"];
        self.showArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRHomeTableCell1*cell = [tableView dequeueReusableCellWithIdentifier:@"TRHomeTableCell1"];
    if (cell==nil)
    {
        cell = [[TRHomeTableCell1 alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.joinBtn.layer.cornerRadius = 16;
    cell.joinBtn.layer.masksToBounds = YES;
    cell.joinBtn.tag = indexPath.row;
    [cell.joinBtn addTarget:self action:@selector(jionClick:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dic = self.showArray[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",dic[@"subTitle"]];
    cell.timeLab.text = [NSString stringWithFormat:@"结束时间：%@",dic[@"actEndDate"]];
    cell.numLab.text = [NSString stringWithFormat:@"%@人参与",dic[@"joinNum"]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    [self.showArray removeAllObjects];
    [self.showArray addObjectsFromArray:dataArray];
    [_tableView reloadData];
    _tableView.frame = CGRectMake(14, 131*kScreenW/375, kScreenW-28, 140*self.showArray.count);
}

- (void)jionClick:(UIButton*)btn
{
     NSDictionary *dic = self.showArray[btn.tag];
    NSString *idStr = [NSString stringWithFormat:@"%@",dic[@"infoId"]];
    if (self.clickidblock)
    {
        self.clickidblock(idStr);
    }
}
@end
