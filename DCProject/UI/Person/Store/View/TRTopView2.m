//
//  TRReusableView2.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRTopView2.h"
#import "TRHomeCell3.h"
#import "TRstoreActivityModel.h"
@implementation TRTopView2
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
        [_tableView registerNib:[UINib nibWithNibName:@"TRHomeCell3" bundle:nil] forCellReuseIdentifier:@"TRHomeCell3"];
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
    return 197*kScreenW/375;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRHomeCell3*cell = [tableView dequeueReusableCellWithIdentifier:@"TRHomeCell3"];
    if (cell==nil)
    {
        cell = [[TRHomeCell3 alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    TRStoreActivityModel *model = self.showArray[indexPath.section];
    [cell.bgImageV sd_setImageWithURL:[NSURL URLWithString:model.actImg] placeholderImage:[UIImage imageNamed:@"ppic"]];
    NSString *endtime = [NSString stringWithFormat:@"%@ 00:00:00",model.actEtime];
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curTime = [formatter stringFromDate:date];
    NSDate *endDate = [NSDate dateFromString:endtime];
    NSDate *currentDate = [NSDate dateFromString:curTime];
    NSTimeInterval vale = [endDate timeIntervalSinceDate:currentDate];
    int timenum=vale;
    if (vale>0)
    {
        int day=timenum/(3600*24);
        int a=timenum%(3600*24);
        int hou=a/3600;
        int b=a%3600;
        int m=b/60;
        if (day<10)
        {
            cell.dayLab.text = [NSString stringWithFormat:@"0%d",day];
        }
        else{
            cell.dayLab.text = [NSString stringWithFormat:@"%d",day];
        }
        if (hou<10)
        {
            cell.hLab.text = [NSString stringWithFormat:@"0%d",hou];
        }
        else{
            cell.hLab.text = [NSString stringWithFormat:@"%d",hou];
        }
        if (m<10)
        {
            cell.mLab.text = [NSString stringWithFormat:@"0%d",m];
        }
        else{
            cell.mLab.text = [NSString stringWithFormat:@"%d",m];
        }
        
    }
    else{
        cell.dayLab.text = @"00";
        cell.hLab.text = @"00";
        cell.mLab.text = @"00";
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TRStoreActivityModel *model = self.showArray[indexPath.section];
    if (self.clickblock)
    {
        self.clickblock([NSString stringWithFormat:@"%@",model.goodsId]);
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    [self.showArray removeAllObjects];
    [self.showArray addObjectsFromArray:dataArray];
    [_tableView reloadData];
    _tableView.frame = CGRectMake(0, 0, kScreenW, (197*kScreenW/375+9)*self.showArray.count);
    tjImageV.frame = CGRectMake(kScreenW/2-55.5, _tableView.frame.size.height+20, 111, 18);
}

@end
