//
//  TRStoreChoseView.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRStoreChoseView.h"
#import "TRStoreChoseCell.h"
@implementation TRStoreChoseView
{
    UICollectionView *_collectionView;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 11;// 垂直方向的间距
        layout.minimumLineSpacing = 16; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-92, 10) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = NO;
        _collectionView.scrollEnabled = YES;
        [self addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"TRStoreChoseCell" bundle:nil] forCellWithReuseIdentifier:@"TRStoreChoseCell"];
        self.showArray = [NSMutableArray arrayWithCapacity:0];
        self.seleeArray = [NSMutableArray arrayWithCapacity:0];
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
    TRStoreChoseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRStoreChoseCell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[TRStoreChoseCell alloc] init];
    }
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    cell.backgroundColor = RGB_COLOR(245, 245, 245);
    cell.nameLab.text=self.showArray[indexPath.item];
    if ([self.seleeArray containsObject:self.showArray[indexPath.item]])
    {
        cell.backgroundColor = RGB_COLOR(241, 251, 250);
        cell.nameLab.textColor = RGB_COLOR(0, 190, 179);
    }
    else{
        cell.backgroundColor = RGB_COLOR(245, 245, 245);
        cell.nameLab.textColor = RGB_COLOR(51, 51, 51);
    }
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-156)/3, 34);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 16, 16);//分别为上、左、下、右
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr=self.showArray[indexPath.item];
    if ([self.seleeArray containsObject:titleStr])
    {
        [self.seleeArray removeObject:titleStr];
    }
    else{
        [self.seleeArray addObject:titleStr];
    }
    [_collectionView reloadData];
    if (self.chosebtnblock) {
        self.chosebtnblock(self.seleeArray);
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    [self.showArray removeAllObjects];
    [self.showArray addObjectsFromArray:dataArray];
    if (dataArray.count==0)
    {
       _collectionView.frame = CGRectMake(0, 0, kScreenW-92, 10);
    }
   else if (dataArray.count<=3)
    {
        _collectionView.frame = CGRectMake(0, 0, kScreenW-92, 10+54);
    }
    else
    {
        _collectionView.frame = CGRectMake(0, 0, kScreenW-92, 100);
    }
    [_collectionView reloadData];
}

- (void)setDefaultSelectArr:(NSMutableArray *)defaultSelectArr
{
    [self.seleeArray removeAllObjects];
    [self.seleeArray addObjectsFromArray:defaultSelectArr];
     [_collectionView reloadData];
}
@end
