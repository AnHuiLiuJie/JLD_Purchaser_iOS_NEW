//
//  GLBSearchRecordListController.m
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSearchRecordListController.h"
#import "WSLWaterFlowLayout.h"
#import "GLBSearchRecordCell.h"

#import "GLBGoodsListController.h"
#import "GLBStoreListController.h"

static NSString *const listCellID = @"GLBSearchRecordCell";

@interface GLBSearchRecordListController ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>

@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cleanBtn;
@property (nonatomic, strong) WSLWaterFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *widthArray;

@end

@implementation GLBSearchRecordListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.dataArray removeAllObjects];
    if (_searchType == GLBSearchTypeGoods) {
        NSArray *goodsRecordArray = [DCObjectManager dc_readUserDataForKey:DC_GoodsSearchRecord_Key];
        if (goodsRecordArray) {
            [self.dataArray addObjectsFromArray:goodsRecordArray];
            
            for (int i=0; i<self.dataArray.count; i++) {
                NSString *name = self.dataArray[i];
                
                CGFloat width = [name boundingRectWithSize:CGSizeMake(kScreenW - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size.width;
                [self.widthArray addObject:@(width + 20)];
            }
        }
    } else {
        NSArray *storeRecordArray = [DCObjectManager dc_readUserDataForKey:DC_StoreSearchRecord_Key];
        if (storeRecordArray) {
            [self.dataArray addObjectsFromArray:storeRecordArray];
            
            for (int i=0; i<self.dataArray.count; i++) {
                NSString *name = self.dataArray[i];
                
                CGFloat width = [name boundingRectWithSize:CGSizeMake(kScreenW - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} context:nil].size.width;
                [self.widthArray addObject:@(width + 20)];
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    GLBSearchRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    cell.deleteBlock = ^{
        [weakSelf dc_deleteRecord:indexPath];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchType == GLBSearchTypeGoods) {
        
        GLBGoodsListController *vc = [GLBGoodsListController new];
        vc.goodsName = self.dataArray[indexPath.row];
        vc.catIds = @"11,12,16,26,14,15,25,24";
        [self dc_pushNextController:vc];
        
    } else {
        
        GLBStoreListController *vc = [GLBStoreListController new];
        vc.firmName = self.dataArray[indexPath.row];
        [self dc_pushNextController:vc];
    }
}


#pragma mark - <WSLWaterFlowLayoutDelegate>
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.widthArray[indexPath.item] floatValue], 45);
}

/** 列间距*/
- (CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return 10.0;
}

/** 行间距*/
- (CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return 10.0f;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - action
- (void)cleanBtnClick:(UIButton *)button
{
    if (_searchType == GLBSearchTypeGoods) {
        NSArray *goodsRecordArray = [DCObjectManager dc_readUserDataForKey:DC_GoodsSearchRecord_Key];
        if (goodsRecordArray) {
            [DCObjectManager dc_saveUserData:@[] forKey:DC_GoodsSearchRecord_Key];
            
            [self.dataArray removeAllObjects];
            [self.widthArray removeAllObjects];
            
        }
    } else {
        NSArray *storeRecordArray = [DCObjectManager dc_readUserDataForKey:DC_StoreSearchRecord_Key];
        if (storeRecordArray) {
            [DCObjectManager dc_saveUserData:@[] forKey:DC_StoreSearchRecord_Key];
            
            [self.dataArray removeAllObjects];
            [self.widthArray removeAllObjects];
        }
    }
    [self.collectionView reloadData];
}


- (void)dc_deleteRecord:(NSIndexPath *)indexPath
{
    if (_searchType == GLBSearchTypeGoods) {
        
        [self.dataArray removeObjectAtIndex:indexPath.item];
        [self.widthArray removeObjectAtIndex:indexPath.item];
        [self.collectionView reloadData];
        [DCObjectManager dc_saveUserData:[self.dataArray copy] forKey:DC_GoodsSearchRecord_Key];
        
    } else {
        
        [self.dataArray removeObjectAtIndex:indexPath.item];
        [self.widthArray removeObjectAtIndex:indexPath.item];
        [self.collectionView reloadData];
        [DCObjectManager dc_saveUserData:[self.dataArray copy] forKey:DC_StoreSearchRecord_Key];
    }
}


#pragma mark - UI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
    _line.backgroundColor = [UIColor dc_colorWithHexString:@"#F2F6F7"];
    [self.view addSubview:_line];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.line.frame) + 20, 100, 20)];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.text = @"历史搜索";
    [self.view addSubview:_titleLabel];
    
    _cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cleanBtn.frame = CGRectMake(kScreenW - 40, CGRectGetMaxY(self.line.frame) + 15, 30, 30);
    [_cleanBtn setImage:[UIImage imageNamed:@"delete"] forState:0];
    _cleanBtn.adjustsImageWhenHighlighted = NO;
    [_cleanBtn addTarget:self action:@selector(cleanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cleanBtn];
    
    _flowLayout = [[WSLWaterFlowLayout alloc] init];
    _flowLayout.delegate = self;
    _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.titleLabel.frame) + 15, kScreenW - 24, kScreenH - CGRectGetMaxY(self.titleLabel.frame) - 15 - kNavBarHeight - 40) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:NSClassFromString(listCellID) forCellWithReuseIdentifier:listCellID];
    [self.view addSubview:_collectionView];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)widthArray{
    if (!_widthArray) {
        _widthArray = [NSMutableArray array];
    }
    return _widthArray;
}


@end
