//
//  GLBHomeCompanyCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBHomeCompanyCell.h"

#import "GLBCompanyItemCell.h"

static NSString *const listCellID = @"GLBCompanyItemCell";

@interface GLBHomeCompanyCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLBHomeCompanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _spacing = 1.0f;
    _itemW = (kScreenW - 10*2 - _spacing)/2;
    _itemH = _itemW *0.5;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(_itemW, _itemH);
    flowLayout.minimumLineSpacing = _spacing;
    flowLayout.minimumInteritemSpacing = _spacing;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView dc_cornerRadius:5];
    [_collectionView registerClass:NSClassFromString(listCellID) forCellWithReuseIdentifier:listCellID];
    [self.contentView addSubview:_collectionView];
}


- (void)updateMasonry
{
    NSInteger line = 0;
    if (self.dataArray.count > 0) {
        line = (self.dataArray.count - 1)/2 + 1;
    }
    CGFloat height = 0;
    if (line > 0) {
        height = _itemH *line + _spacing *(line - 1);
    }
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        make.height.equalTo(height);
    }];
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLBCompanyItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    cell.companyModel = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_companyItemBlock) {
        _companyItemBlock(self.dataArray[indexPath.item]);
    }
}


#pragma mark - setter
- (void)setCompanyArray:(NSMutableArray<GLBCompanyModel *> *)companyArray
{
    _companyArray = companyArray;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_companyArray];
    
    [self updateMasonry];
    [self.collectionView reloadData];
}


#pragma mark - lazy laod
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
