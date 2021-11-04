
//  TRCouponStoreListCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRCouponStoreListCell.h"
#import "TRCCStoreCCell.h"
#import "GLPGoodsDetailsController.h"
@implementation TRCouponStoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    //[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumInteritemSpacing = 0;// 垂直方向的间距
    layout.minimumLineSpacing = 7; // 水平方向的间距
    self.collectView.collectionViewLayout=layout;
    self.collectView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    self.collectView.pagingEnabled = NO;
    self.collectView.scrollEnabled = NO;
    [self.contentView addSubview:self.collectView];
    [self.collectView registerNib:[UINib nibWithNibName:@"TRCCStoreCCell" bundle:nil] forCellWithReuseIdentifier:@"TRCCStoreCCell"];
    self.showArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  self.showArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRCCStoreCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRCCStoreCCell" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[TRCCStoreCCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = self.showArray[indexPath.item];
    [cell.goodsImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"goodsImg1"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.nameLab.text=dic[@"goodsName"];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@",dic[@"sellPrice"]];
    cell.priceLab = [UILabel setupAttributeLabel:cell.priceLab textColor:cell.priceLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    cell.canuserLab.layer.masksToBounds = YES;
    cell.canuserLab.layer.cornerRadius = 10;
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-46)/3, 158);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary *dic = self.showArray[indexPath.item];
    GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
    vc.goodsId = [NSString stringWithFormat:@"%@",dic[@"goodsId"]];
    [[self jsd_findVisibleViewController].navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)jsd_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

-(UIViewController *)jsd_findVisibleViewController {
    
    UIViewController* currentViewController = [self jsd_getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

- (void)setDataArray:(NSArray *)dataArray
{
    [self.showArray removeAllObjects];
    if (dataArray.count<=3)
    {
         [self.showArray addObjectsFromArray:dataArray];
    }
    else{
         [self.showArray addObject:dataArray[0]];
         [self.showArray addObject:dataArray[1]];
         [self.showArray addObject:dataArray[2]];
    }
    [self.collectView reloadData];
}
@end
