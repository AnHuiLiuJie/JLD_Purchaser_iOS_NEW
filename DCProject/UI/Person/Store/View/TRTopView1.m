//
//  TRReusableView2.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRTopView1.h"
#import "TRActivityTableCell.h"
#import "TRStoreActivityModel.h"
@implementation TRTopView1
{
    UITableView *_tableView;
    UIImageView*tjImageV;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB_COLOR(248, 248, 248);
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"TRActivityTableCell" bundle:nil] forCellReuseIdentifier:@"TRActivityTableCell"];
        self.showArray = [NSMutableArray arrayWithCapacity:0];
        tjImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-55.5, _tableView.frame.size.height+20, 111, 18)];
        tjImageV.image = [UIImage imageNamed:@"tuijian"];
        [self addSubview:tjImageV];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136*kScreenW/375+88;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRActivityTableCell"];
    if (cell==nil)
    {
        cell = [[TRActivityTableCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = RGB_COLOR(248, 248, 248);
    cell.bgView.layer.masksToBounds = YES;
    cell.bgView.layer.cornerRadius = 6;
    cell.joinBtn.layer.masksToBounds = YES;
    cell.joinBtn.layer.cornerRadius = 16;
    cell.joinBtn.tag = indexPath.section;
    [cell.joinBtn addTarget:self action:@selector(jionClick:) forControlEvents:UIControlEventTouchUpInside];
    TRStoreActivityModel *model = self.showArray[indexPath.section];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.actImg] placeholderImage:[UIImage imageNamed:@"ppic"]];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",model.actTitle];
    cell.timeLab.text = [NSString stringWithFormat:@"结束时间：%@",model.actEtime];
    cell.numLab.text = [NSString stringWithFormat:@"%d人已参与",[model.joinNum intValue]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)jionClick:(UIButton*)btn
{
      TRStoreActivityModel *model = self.showArray[btn.tag];
    if (self.activitykblock)
    {
        self.activitykblock([NSString stringWithFormat:@"%@",model.id]);
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    [self.showArray removeAllObjects];
    [self.showArray addObjectsFromArray:dataArray];
    [_tableView reloadData];
    _tableView.frame = CGRectMake(0, 0, kScreenW, (136*kScreenW/375+98)*self.showArray.count);
    tjImageV.frame = CGRectMake(kScreenW/2-55.5, _tableView.frame.size.height+20, 111, 18);
}

@end
