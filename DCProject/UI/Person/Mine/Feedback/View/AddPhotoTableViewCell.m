//
//  AddPhotoTableViewCell.m
//  MSIApp
//
//  Created by ZhihanCui on 2018/6/20.
//  Copyright © 2018年 ZhihanCui. All rights reserved.
//

#import "AddPhotoTableViewCell.h"
#import "PhotoCollectionViewCell.h"
@implementation AddPhotoTableViewCell
{
    UICollectionView *  _collectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *const cellID = @"AddPhotoTableViewCell";
    AddPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AddPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
//        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
         layout.minimumInteritemSpacing = 5;// 垂直方向的间距
        layout.minimumLineSpacing = 5; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 10, kScreenW-30, (kScreenW-50)/3) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = NO;
        [self.contentView addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
        self.photoArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    return self;
}
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.photoArray.count<9)
    {
         return self.photoArray.count+1;
    }
    else{
        return 9;
    }
   
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.photoArray.count<9)
    {
        if (indexPath.item==self.photoArray.count)
        {
            PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
            if (cell==nil)
            {
                cell = [[PhotoCollectionViewCell alloc] init];
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.photoImageV.hidden = YES;
            [cell.addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.addBtn.tag = indexPath.item;
            [cell.addBtn setImage:[UIImage imageNamed:@"tjtuwen"] forState:UIControlStateNormal];
            cell.photoBtn.hidden = YES;
            cell.addBtn.hidden = NO;
            return cell;
        }
        else{
            PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
            if (cell==nil)
            {
                cell = [[PhotoCollectionViewCell alloc] init];
            }
            cell.addBtn.hidden = YES;
            cell.photoImageV.hidden = NO;
            cell.photoBtn.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"%@",self.photoArray[indexPath.item]];
            [cell.photoImageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"dc_placeholder_bg"]];
//            cell.photoImageV.image=self.photoArray[indexPath.item];
            [cell.photoBtn addTarget:self action:@selector(deleClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.photoBtn.tag = indexPath.item;
            return cell;
        }
    }
    else{
        PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
        if (cell==nil)
        {
            cell = [[PhotoCollectionViewCell alloc] init];
        }
        cell.addBtn.hidden = YES;
        cell.photoImageV.hidden = NO;
        cell.photoBtn.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%@",self.photoArray[indexPath.item]];
        [cell.photoImageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"dc_placeholder_bg"]];
//        cell.photoImageV.image=self.photoArray[indexPath.item];
        [cell.photoBtn addTarget:self action:@selector(deleClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.photoBtn.tag = indexPath.item;
        return cell;
    }
   
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-50)/3, (kScreenW-50)/3);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
   
}

- (void)deleClick:(UIButton*)btn
{
    if (self.deleblock)
    {
        self.deleblock(btn.tag);
    }
    
}

- (void)addClick:(UIButton*)btn
{
    if (self.addblock) {
        self.addblock(btn.tag);
    }
}

- (void)setClickPhotoArray:(NSArray *)clickPhotoArray
{
    [self.photoArray  removeAllObjects];
    [self.photoArray addObjectsFromArray:clickPhotoArray];
    if (self.photoArray.count<3)
    {
        _collectionView.frame = CGRectMake(15, 10, kScreenW-30, (kScreenW-50)/3+10);
    }
    else if(self.photoArray.count>=3&&self.photoArray.count<6)
    {
        _collectionView.frame = CGRectMake(15, 10, kScreenW-30, (kScreenW-50)/3*2+20);
    }
    else
    {
       _collectionView.frame = CGRectMake(15, 10, kScreenW-30, (kScreenW-50)/3*3+30);
    }
   
     [_collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
