//
//  TRHomeCell5.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRHomeCell5.h"
#import "TRHomeCollectionCell2.h"
@implementation TRHomeCell5
{
    UICollectionView *  _collectionView;
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
    static NSString *const cellID = @"TRHomeCell5";
    TRHomeCell5 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TRHomeCell5 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView*bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(14, 0, kScreenW-28, 64*kScreenW/375)];
        bgImageV.image = [UIImage imageNamed:@"manbingtiaoyang"];
        [self.contentView addSubview:bgImageV];
        
        self.bgLab = [[UILabel alloc]initWithFrame:CGRectMake(26, 18*kScreenW/375, 140, 28)];
        self.bgLab.textColor = [UIColor whiteColor];
        self.bgLab.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:self.bgLab];
        
        UIButton*moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(kScreenW-93, 22*kScreenW/375, 70, 28);
        moreBtn.backgroundColor = [UIColor whiteColor];
        moreBtn.layer.masksToBounds = YES;
        moreBtn.layer.cornerRadius = 14;
        [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:RGB_COLOR(48, 220, 113) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreBtn];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        //[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 8;// 垂直方向的间距
        layout.minimumLineSpacing = 8; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, 64*kScreenW/375, kScreenW-28, 308) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = NO;
        _collectionView.scrollEnabled = NO;
        [self.contentView addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"TRHomeCollectionCell2" bundle:nil] forCellWithReuseIdentifier:@"TRHomeCollectionCell2"];
        self.showArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return self;
}
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  self.showArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRHomeCollectionCell2*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRHomeCollectionCell2" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[TRHomeCollectionCell2 alloc] init];
    }
    cell.buyBtn.tag = indexPath.item;
    [cell.buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dic = self.showArray[indexPath.item];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"infoImg"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@",dic[@"infoPrice"]];
    cell.priceLab = [UILabel setupAttributeLabel:cell.priceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",dic[@"infoTitle"]];
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-36)/2, 135+172*(kScreenW-36)/2/172);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
    
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    [self.showArray removeAllObjects];
    [self.showArray addObjectsFromArray:dataArray];
    [_collectionView reloadData];
    NSInteger a = self.showArray.count/2;
    CGFloat b=135+172*(kScreenW-36)/2/172;
    _collectionView.frame = CGRectMake(14, 64*kScreenW/375, kScreenW-28, a*(b+8));
}

- (void)setFoolsId:(NSString *)foolsId{
    self.foolId=foolsId;
}

- (void)moreClick
{
    if (self.moreblock) {
        self.moreblock(self.foolId);
    }
}

- (void)buyClick:(UIButton*)btn
{
     NSDictionary *dic = self.showArray[btn.tag];
    NSString *idStr = [NSString stringWithFormat:@"%@",dic[@"infoId"]];
    if (self.foolblock)
    {
        self.foolblock(idStr);
    }
}
@end
