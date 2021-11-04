//
//  GLBExhibitGoodsController.m
//  DCProject
//
//  Created by bigbing on 2019/8/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBExhibitGoodsController.h"

#import "GLBExhibitGoodsCell.h"
#import "GLBExhibitGoodsHeadView.h"

#import "GLBGoodsDetailController.h"

static NSString *const listCellID = @"GLBExhibitGoodsCell";
static NSString *const sectionID = @"GLBExhibitGoodsHeadView";

@interface GLBExhibitGoodsController ()

@property (nonatomic, strong) NSMutableArray<GLBExhibitInfoModel *> *dataArray;

@end

@implementation GLBExhibitGoodsController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpCollectionView];
    
    if (self.exhibitModel) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.exhibitModel.infoList];
        
        [self reloadCollectionViewWithDatas:self.dataArray hasNextPage:NO];
    }
}


#pragma mark - UI
- (void)setUpCollectionView
{
    self.collectionView.frame = CGRectMake(0, 0, kScreenW, kScreenH - kNavBarHeight - kScreenW*0.4);
    
    
    [self.collectionView registerClass:NSClassFromString(listCellID) forCellWithReuseIdentifier:listCellID];
    [self.collectionView registerClass:NSClassFromString(sectionID) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID];
}



#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = (kScreenW - 25 *2 - 28*2)/3;
    CGFloat itmeH = itemW + 30;
    return CGSizeMake(itemW, itmeH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 24, 0, 24);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 28;
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataArray[section] goodsList] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLBExhibitGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    cell.goodsModel = [self.dataArray[indexPath.section] goodsList][indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 90);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        GLBExhibitGoodsHeadView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionID forIndexPath:indexPath];
        header.infoModel = self.dataArray[indexPath.section];
        return header;
    }
    return [UICollectionReusableView new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GLBExhibitGoodsModel *goodsModel = [self.dataArray[indexPath.section] goodsList][indexPath.item];
    if ([goodsModel.urlType isEqualToString:@"1"]) { // 产品
        
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.goodsId = goodsModel.infoId;
        [self dc_pushNextController:vc];
        
    } else if ([goodsModel.urlType isEqualToString:@"2"]) { // 资讯
        
        NSString *params = [NSString stringWithFormat:@"id=%@",goodsModel.infoId];
        [self dc_pushWebController:@"/public/infor_detail.html" params:params];
        
    } else if ([goodsModel.urlType isEqualToString:@"3"]) { // 其他
        
        if (DC_CanOpenUrl(goodsModel.url)) {
            DC_OpenUrl(goodsModel.url);
        }
    }
}


#pragma mark - lazy load
- (NSMutableArray<GLBExhibitInfoModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
