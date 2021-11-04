//
//  TRHomeCell2.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRHomeCell2.h"

@implementation TRHomeCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *const cellID = @"TRHomeCell2";
    TRHomeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TRHomeCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
       
    }
    return self;
}

- (void)btnClick:(UIButton*)btn
{
    if (self.clickblock)
    {
        self.clickblock(btn.tag);
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count==0)
    {
        return;
    }
    else{
        if (self.subviews.count>0)
        {
            for(UIView *view1 in [self subviews]){
                [view1 removeFromSuperview];
            }
        }
    }
    for (int i=0; i<dataArray.count; i++)
    {
        NSDictionary *dic = dataArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i<5) {
            btn.frame = CGRectMake(kScreenW/5*i, 0, kScreenW/5, kScreenW/5);
        }else
        {
            btn.frame = CGRectMake(kScreenW/5*(i-5), kScreenW/5, kScreenW/5, kScreenW/5);
        }
        [self addSubview:btn];
        UIImageView*btnImageV = [[UIImageView alloc] init];
        btnImageV.center = CGPointMake(btn.frame.size.width/2, btn.frame.size.height/2-13);
        btnImageV.bounds = CGRectMake(0, 0, 35, 35);
    [btnImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"catIcon"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
        [btn addSubview:btnImageV];
        UILabel *btnLab = [[UILabel alloc] init];
        btnLab.frame = CGRectMake(0, btnImageV.frame.size.height+btnImageV.frame.origin.y+8, btn.frame.size.width, 17);
        btnLab.textAlignment = NSTextAlignmentCenter;
        btnLab.textColor = RGB_COLOR(51, 51, 51);
       btnLab.text = [NSString stringWithFormat:@"%@",dic[@"catName"]];
        btnLab.font = [UIFont systemFontOfSize:12];
        [btn addSubview:btnLab];
    }
}
@end
