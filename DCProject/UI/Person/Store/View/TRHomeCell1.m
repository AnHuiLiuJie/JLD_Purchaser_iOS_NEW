//
//  TRHomeCell1.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRHomeCell1.h"
#import "TRHomeCollectionCell1.h"
#import "CouponsModel.h"
@implementation TRHomeCell1
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
    static NSString *const cellID = @"TRHomeCell1";
    TRHomeCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TRHomeCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 0;// 垂直方向的间距
        layout.minimumLineSpacing = 20; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 85) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = NO;
        _collectionView.scrollEnabled = YES;
        [self.contentView addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"TRHomeCollectionCell1" bundle:nil] forCellWithReuseIdentifier:@"TRHomeCollectionCell1"];
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
    TRHomeCollectionCell1*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRHomeCollectionCell1" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[TRHomeCollectionCell1 alloc] init];
    }
    CouponsModel *model = self.showArray[indexPath.item];
    NSString *isReceive = [NSString stringWithFormat:@"%@",model.isReceive];
    if ([isReceive isEqualToString:@"0"])
    {
        cell.bgImageV.image = [UIImage imageNamed:@"dc_yhq_ky"];
        [cell.getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        cell.getBtn.userInteractionEnabled = YES;
        [cell.getBtn setTitleColor:RGB_COLOR(255, 88, 0) forState:UIControlStateNormal];
        cell.priceLab.textColor = RGB_COLOR(255, 88, 0);
         cell.userLab.textColor = RGB_COLOR(255, 88, 0);
    }
    else{
        cell.bgImageV.image = [UIImage imageNamed:@"yhq_sy"];
        [cell.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
        cell.getBtn.userInteractionEnabled = NO;
        [cell.getBtn setTitleColor:RGB_COLOR(174, 174, 174) forState:UIControlStateNormal];
        cell.priceLab.textColor = RGB_COLOR(174, 174, 174);
        cell.userLab.textColor = RGB_COLOR(174, 174, 174);
    }
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@",model.discountAmount];
    cell.priceLab = [UILabel setupAttributeLabel:cell.priceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
    cell.userLab.text = [NSString stringWithFormat:@"满%@元可用",model.requireAmount];
    cell.timeLab.text = [NSString stringWithFormat:@"有效期至%@",model.useEndDate];
    cell.getBtn.tag = indexPath.item;
    [cell.getBtn addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(244, 85);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 12, 0, 0);//分别为上、左、下、右
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    [self.showArray removeAllObjects];
    [self.showArray addObjectsFromArray:dataArray];
    [_collectionView reloadData];
}

- (void)userClick:(UIButton*)btn
{
    if (self.clickblock) {
        self.clickblock(btn.tag);
    }
}
@end
