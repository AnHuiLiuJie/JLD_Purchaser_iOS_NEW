//
//  GLBCollectionViewFlowLayout.m
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBCollectionViewFlowLayout.h"

@interface GLBCollectionViewFlowLayout()

// 布局数组
//@property (nonatomic,strong) NSMutableArray *attrsArray;

@end

@implementation GLBCollectionViewFlowLayout

//#pragma mark - 懒加载
//- (NSMutableArray *)attrsArray{
//    if (!_attrsArray) {
//        _attrsArray = [NSMutableArray array];
//    }
//    return _attrsArray;
//}
//
//#pragma mark - 初始化
//- (void)prepareLayout{
//    [super prepareLayout];
//
//    [self.attrsArray removeAllObjects];
//
//    for (int i=0; i<_count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [self.attrsArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    }
//
//}
//
//#pragma mark - 返回indexPath 位置cell对应的布局属性
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//
//    NSInteger line = indexPath.item / 5;
//    NSInteger list = indexPath.item % 5;
//
//    CGFloat x = _hSpacing + (_itemW + _spacing)*list;
//    CGFloat y = _vSpacing + (_itemH + _spacing)*line;
//
//    attrs.frame = CGRectMake(x, y, _itemW, _itemH);
//    return attrs;
//}
//
//#pragma mark - 决定cell 的排布
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    return self.attrsArray;
//}
//
//#pragma mark - 决定collectionView的可滚动范围
//- (CGSize)collectionViewContentSize{
//    return CGSizeMake(ScreenW, CGRectGetMaxY([self.attrsArray[_count - 1] frame]) + _vSpacing);
//}

@end
