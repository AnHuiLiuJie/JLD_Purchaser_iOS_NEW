//
//  HomeRecommListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "HomeRecommListVC.h"
#import "TRHomeCollectionCell2.h"
#import "GLPGoodsDetailsController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface HomeRecommListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,strong)GLPHomeDataModel*Hmode;
@end

@implementation HomeRecommListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160+kStatusBarHeight)];
    [self.view addSubview:headView];
    UIImageView *bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160+kStatusBarHeight)];
    bgImageV.image = [UIImage imageNamed:@"home_bg"];
    bgImageV.contentMode = UIViewContentModeScaleToFill;
    [headView addSubview:bgImageV];
   
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, kStatusBarHeight+14, 20, 20);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(30, kStatusBarHeight+14, kScreenW-60, 20)];
    titLab.textColor = [UIColor whiteColor];
    titLab.text = self.titleStr;
    titLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titLab];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    //[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumInteritemSpacing = 8;// 垂直方向的间距
    layout.minimumLineSpacing = 8; // 水平方向的间距
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, kNavBarHeight, kScreenW-28, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = NO;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"TRHomeCollectionCell2" bundle:nil] forCellWithReuseIdentifier:@"TRHomeCollectionCell2"];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    [_collectionView registerClass:[UICollectionReusableView class
                                    ] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self getdata];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getdata
{
    WEAKSELF;
    [[DCAPIManager shareManager]person_requestHomeRecommendWithZoneCode:@"SEASON_ZONE_INDEX" type:@"2" success:^(id response) {
        weakSelf.Hmode = response;
        NSArray *arr = weakSelf.Hmode.dataList;
        [weakSelf.listArray addObjectsFromArray:arr];
        [weakSelf.collectionView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.listArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRHomeCollectionCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRHomeCollectionCell2" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[TRHomeCollectionCell2 alloc] init];
    }
    cell.buyBtn.tag = indexPath.item;
    [cell.buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.model = self.listArray[indexPath.item];
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenW-36)/2, 135+172*(kScreenW-36)/2/172);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
    GLPHomeDataListModel *model = self.listArray[indexPath.row];
     GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
     vc.goodsId = [NSString stringWithFormat:@"%@",model.infoId];
     [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (_Hmode.spacePic.length < 6) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(kScreenW, 160);
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *resu = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        
        UIImageView *pic = [[UIImageView alloc] init];
        pic.layer.cornerRadius = 6;
        pic.layer.masksToBounds = YES;
        if (_Hmode.spacePic.length >6) {
            [pic sd_setImageWithURL:[NSURL URLWithString:_Hmode.spacePic] placeholderImage:[UIImage imageNamed:@"ppic"]];
        }else{
            pic.hidden = YES;
        }
        pic.contentMode =UIViewContentModeScaleToFill;
        [resu addSubview:pic];
        [pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.width.offset(kScreenW-30);
            make.centerX.offset(0);
            make.height.offset(135);
        }];
        return  resu;
    }
    return nil;
}

- (void)buyClick:(UIButton*)btn
{
   GLPHomeDataListModel *model = self.listArray[btn.tag];
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = [NSString stringWithFormat:@"%@",model.infoId];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
